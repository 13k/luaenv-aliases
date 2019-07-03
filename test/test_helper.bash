unset LUAENV_VERSION
unset LUAENV_DIR

LUAENV_TEST_DIR="${BATS_TMPDIR}/luaenv"
PLUGIN="${LUAENV_TEST_DIR}/root/plugins/luaenv-aliases"

# guard against executing this block twice due to bats internals
if [ "$LUAENV_ROOT" != "${LUAENV_TEST_DIR}/root" ]; then
  export LUAENV_ROOT="${LUAENV_TEST_DIR}/root"
  export HOME="${LUAENV_TEST_DIR}/home"
  local parent

  export INSTALL_HOOK="${BATS_TEST_DIRNAME}/../etc/luaenv.d/install/autoalias.bash"
  export UNINSTALL_HOOK="${BATS_TEST_DIRNAME}/../etc/luaenv.d/uninstall/autoalias.bash"

  PATH=/usr/bin:/bin:/usr/sbin:/sbin
  PATH="${LUAENV_TEST_DIR}/bin:$PATH"
  PATH="${BATS_TEST_DIRNAME}/bin:$PATH"
  PATH="${BATS_TEST_DIRNAME}/../bin:$PATH"
  PATH="${BATS_TEST_DIRNAME}/../luaenv/libexec:$PATH"
  PATH="${BATS_TEST_DIRNAME}/../luaenv/test/libexec:$PATH"
  PATH="${LUAENV_ROOT}/shims:$PATH"
  export PATH
fi

teardown() {
  rm -rf "$LUAENV_TEST_DIR"
}

flunk() {
  {
    if [ "$#" -eq 0 ]; then
      cat -
    else
      echo "$@"
    fi
  } | sed "s:${LUAENV_TEST_DIR}:TEST_DIR:g" >&2
  return 1
}

# Creates fake version directories
create_versions() {
  for v in $*; do
    #echo "Created version: $d"
    d="$LUAENV_TEST_DIR/root/versions/$v"
    mkdir -p "$d/bin"
    echo $v >"$d/RELEASE.txt"
    ln -nfs /bin/echo "$d/bin/lua"
  done
}

# Creates test aliases
create_alias() {
  local alias="$1"
  local version="$2"

  mkdir -p "$LUAENV_ROOT/versions"
  ln -nfs "$LUAENV_ROOT/versions/$version" "$LUAENV_ROOT/versions/$alias"
}

# assert_alias_version alias version

assert_alias_version() {
  if [ ! -f $LUAENV_ROOT/versions/$1/RELEASE.txt ]; then
    echo "Versions:"
    (
      cd $LUAENV_ROOT/versions
      ls -l
    )
  fi
  assert_equal "$2" "$(cat "$LUAENV_ROOT/versions/$1/RELEASE.txt" 2>&1)"
}

assert_alias_missing() {
  if [ -f $LUAENV_ROOT/versions/$1/RELEASE.txt ]; then
    assert_equal "no-version" "$(cat "$LUAENV_ROOT/versions/$1/RELEASE.txt" 2>&1)"
  fi
}

assert_success() {
  if [ "$status" -ne 0 ]; then
    flunk "command failed with exit status $status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_failure() {
  if [ "$status" -eq 0 ]; then
    flunk "expected failed exit status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_equal() {
  if [ "$1" != "$2" ]; then
    {
      echo "expected: $1"
      echo "actual:   $2"
    } | flunk
  fi
}

assert_output() {
  local expected
  if [ $# -eq 0 ]; then
    expected="$(cat -)"
  else
    expected="$1"
  fi
  assert_equal "$expected" "$output"
}

assert_line() {
  if [ "$1" -ge 0 ] 2>/dev/null; then
    assert_equal "$2" "${lines[$1]}"
  else
    local line
    for line in "${lines[@]}"; do
      if [ "$line" = "$1" ]; then return 0; fi
    done
    flunk "expected line \`$1'"
  fi
}

assert_line_starts_with() {
  if [ "$1" -ge 0 ] 2>/dev/null; then
    assert_equal "$2" "${lines[$1]}"
  else
    local line
    for line in "${lines[@]}"; do
      if [ -n "${line#${1}}" ]; then return 0; fi
    done
    flunk "expected line \`$1'"
  fi
}

refute_line() {
  if [ "$1" -ge 0 ] 2>/dev/null; then
    local num_lines="${#lines[@]}"
    if [ "$1" -lt "$num_lines" ]; then
      flunk "output has $num_lines lines"
    fi
  else
    local line
    for line in "${lines[@]}"; do
      if [ "$line" = "$1" ]; then
        flunk "expected to not find line \`$line'"
      fi
    done
  fi
}

assert() {
  if ! "$@"; then
    flunk "failed: $@"
  fi
}
