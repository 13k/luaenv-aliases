#!/usr/bin/env bats

load test_helper

@test "luaenv-alias luajit-2.0 --auto with luajit" {
  create_versions luajit-2.0.3 luajit-2.0.5

  run luaenv-alias luajit-2.0 --auto
  assert_success
  assert_alias_version luajit-2.0 luajit-2.0.5
}

@test "luaenv-alias 5.2 --auto with semver" {
  create_versions 5.2.1 5.2.2

  run luaenv-alias 5.2 --auto
  assert_success
  assert_alias_version 5.2 5.2.2
}

@test "luaenv-alias name 5.2.1" {
  create_versions 5.2.1 5.2.2

  run luaenv-alias name 5.2.1
  assert_success
  assert_alias_version name 5.2.1
}

@test "luaenv-alias --auto" {
  create_versions luajit-2.1.0-beta3 luajit-2.1.0-beta2
  create_versions luajit-2.0.3 luajit-2.0.5
  create_versions 5.3.4 5.3.5

  run luaenv-alias --auto
  assert_success
  assert_alias_version luajit-2.1.0 luajit-2.1.0-beta3
  assert_alias_version luajit-2.0 luajit-2.0.5
  assert_alias_version 5.3 5.3.5
}

@test "luaenv-alias 1.8.7-p371 --auto removes dangling alias" {
  # alias to non-existant version
  create_alias 5.0.0 5.0.0

  run luaenv-alias 5.0.0 --auto

  assert_success
  assert [ ! -L "$LUAENV_ROOT/versions/5.0.0" ]
}

@test "luaenv-alias 5.3 --auto redirects alias to highest remaining version" {
  create_versions 5.3.2
  # alias to non-existant version
  create_alias 5.3 5.3.5

  run luaenv-alias 5.3 --auto

  assert_success
  assert_alias_version 5.3 5.3.2
}
