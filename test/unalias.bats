#!/usr/bin/env bats

load test_helper

@test "running unalias removes an alias" {
  create_versions 5.3.5
  run luaenv-alias 5.3 --auto
  assert_success

  run luaenv-unalias 5.3
  assert_success
  assert_alias_missing 5.3
}
