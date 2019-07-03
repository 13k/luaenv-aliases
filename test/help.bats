#!/usr/bin/env bats

load test_helper

@test "help for alias is available" {
  run luaenv-help 'alias'
  assert_success
  assert_line "Usage: luaenv alias <name> [<version> | --auto | --remove]"
  assert_line "Symlink a short name to an exact version.  Passing a second argument of"
}


@test "help for unalias is available" {
  run luaenv-help 'unalias'
  assert_success
  assert_line 'Usage: luaenv unalias <alias> [<alias> ...]'
  assert_line 'Remove one or more symlinks in the versions directory'
}

