#!/usr/bin/env bats

load test_helper

@test "running luaenv-uninstall auto removes the alias" {
  create_versions 5.3.5
  create_alias 5.3 5.3.5

  run luaenv-uninstall 5.3.5

  assert_success
  assert_line 'Uninstalled fake version 5.3.5'
  assert_line_starts_with 'Removing invalid link from 5.3'
  assert [ ! -L "$LUAENV_ROOT/versions/5.3" ]
}

@test "running luaenv-uninstall auto updates the alias to highest remaining semver version" {
  create_versions 5.3.2 5.3.3 5.3.5
  create_alias 5.3 5.3.5

  run luaenv-uninstall 5.3.5

  assert_success
  assert_line 'Uninstalled fake version 5.3.5'
  assert_line_starts_with 'Removing invalid link from 5.3'
  assert_line '5.3 => 5.3.3'
  assert_alias_version 5.3 5.3.3
}
