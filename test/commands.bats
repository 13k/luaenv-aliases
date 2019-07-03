#!/usr/bin/env bats

load test_helper

@test "alias is listed in luaenv commands" {
  run luaenv-commands
  assert_success
  assert_line "alias"
}

@test "commands --sh should not list alias" {
  run luaenv-commands --sh
  assert_success
  refute_line "alias"
}

@test "commands --no-sh should list alias" {
  run luaenv-commands --no-sh
  assert_success
  assert_line "alias"
}

@test "unalias is listed in luaenv commands" {
  run luaenv-commands
  assert_success
  assert_line "unalias"
}

@test "commands --sh should not list unalias" {
  run luaenv-commands --sh
  assert_success
  refute_line "unalias"
}

@test "commands --no-sh should list unalias" {
  run luaenv-commands --no-sh
  assert_success
  assert_line "unalias"
}
