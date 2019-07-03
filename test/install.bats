#!/usr/bin/env bats

load test_helper

@test "running luaenv-install auto installs an alias" {
  run luaenv-install 5.3.3
  assert_success
  assert_line 'Installed fake version 5.3.3'
  assert_line '5.3 => 5.3.3'
  assert_alias_version 5.3 5.3.3

  run luaenv-install 5.3.4
  assert_success
  assert_line 'Installed fake version 5.3.4'
  assert_line '5.3 => 5.3.4'
  assert_alias_version 5.3 5.3.4

  run luaenv-install 5.3.5
  assert_success
  assert_line 'Installed fake version 5.3.5'
  assert_line '5.3 => 5.3.5'
  assert_alias_version 5.3 5.3.5
}
