# Aliases for luaenv Lua versions

Invoke `luaenv alias <name> <version>` to make a symbolic link from `<name>` to
`<version>` in the [luaenv][] versions directory, effectively creating an
alias.  The cool part is that if you pass in a point release as the name, you
can give `--auto` to link to the latest installed patch level.  For example,
`luaenv alias 5.3.5 --auto` will automatically create an alias from `5.3` to
`5.3.5` (or whatever the most recent version you have installed is).

Plus, if you're using [lua-build][], `luaenv install A.B.C-pXXX` automatically
invokes `luaenv alias A.B.C --auto`, so you'll always have up to date aliases
for point releases.

Whether it's a good idea to use these aliases in a `.lua-version` file is up
to the user to decide.

## Installation

    mkdir -p "$(luaenv root)/plugins"
    git clone https://github.com/13k/luaenv-aliases.git \
      "$(luaenv root)/plugins/luaenv-aliases"
    luaenv alias --auto

[luaenv]: https://github.com/cehoffman/luaenv
[lua-build]: https://github.com/cehoffman/lua-build
