[![Luarocks](https://img.shields.io/luarocks/v/gvvaughan/lpeg?label=Luarocks&logo=Lua)](https://luarocks.org/modules/gvvaughan/lpeg)
[![](https://img.shields.io/badge/HTML-documentation-green?logo=html5)](http://www.inf.puc-rio.br/~roberto/lpeg/lpeg.html)

# Definitions for the LPeg library

Type definitions for the [LPeg](https://www.inf.puc-rio.br/~roberto/lpeg) library.

## Patterns vs. Captures

Functions and operators in *LPeg* can be split into two main groups. One that
creates patterns and one that creates captures. The corresponding types are
called `Pattern` and `Capture`. For example `lpeg.P('a')` returns a `Pattern`
while `lpeg.Cc('a')` returns a `Capture`. Technically however, each capture is
also a pattern. In other words `Capture` is an **alias** of `Pattern`.

### Tooltips

Whether the tooltips of your editor display a capture type as `Capture` or
`Pattern` depends on the
[`hover.expandAlias`](https://github.com/LuaLS/lua-language-server/wiki/Settings#hoverexpandalias)
setting in the configuration file of
[lua-language-server](https://github.com/LuaLS/lua-language-server).

Here are two screenshots showing the different behavior. If `hover.expandAlias` is `false`,
the tooltip for a function like `lpeg.Cc()` displays the return type as `Capture`:

![hover.expandAlias equals false](https://raw.githubusercontent.com/Josef-Friedrich/LuaTeX_Lua-API/main/resources/images/LPeg_alias-01.png)

If `hover.expandAlias` is `true`, the tooltip displays the return type as `Pattern`:

![hover.expandAlias equals true](https://raw.githubusercontent.com/Josef-Friedrich/LuaTeX_Lua-API/main/resources/images/LPeg_alias-02.png)

### Configuration

[Lua-language-server](https://github.com/LuaLS/lua-language-server) provides several
configuration file for defining settings like `hover.expandAlias`, and they are all
explained in the documentation of lua-language-server.

One way to configure it is the following: Create a JSON file
[`.luarc.json`](https://github.com/LuaLS/lua-language-server/wiki/Configuration-File#luarcjson)
in the top-level directory of your workspace with the following content. If this
configuration file already exists, just add the `expandAlias` key.


```json
{
   "Lua" : {
      "hover" : {
         "expandAlias" : false,
      },
   },
}

```
