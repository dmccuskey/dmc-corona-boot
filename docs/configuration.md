# Configuration

How `dmc_corona.cfg` is written, how `LUA_PATH` tells the loader where the DMC libraries are, and how modules are found. The [Quick Start](../README.md#quick-start) covers the default setup, which needs no changes.

## Quick Reference

| Topic | In short |
|---|---|
| [The config file](#the-config-file) | `dmc_corona.cfg` at the root of the project folder, read once, on the first `require` of a DMC library |
| [File format](#file-format) | `[SECTION]` lines, then `NAME:TYPE = value` lines; everything else is ignored |
| [Value types](#value-types) | `BOOL`, `INT`, `JSON`, `PATH`, `FILE`, `STR` (the default); a bad value or an unknown type stops the app with an error |
| [`LUA_PATH`](#lua_path) | the folders that hold DMC libraries, relative to the project root |
| [How modules are found](#how-modules-are-found) | the project root first, then each `LUA_PATH` folder, then its `lib/dmc_lua/` |
| [Library sections](#library-sections) | one section per library, for its own settings |
| [Several DMC libraries](#several-dmc-libraries) | merge the `dmc_corona/` folders and the config files |

## The Config File

`dmc_corona_boot.lua` and `dmc_corona.cfg` go at the root of the project folder, next to `main.lua`. The loader looks for the config file only there (in `system.ResourceDirectory`).

Your code doesn't load the loader: each DMC library does, on its first `require`. The loader then reads `dmc_corona.cfg` once and replaces the global `require` for the whole app with its own version (see [How Modules Are Found](#how-modules-are-found)). Changes to the file take effect the next time the app starts.

When the libraries are in a folder such as `dmc_corona/`, the config file is required: without it the loader knows only the project root, and the first library that loads another one fails with `The module '...' not found in archive:`. Every DMC library includes a `dmc_corona.cfg` for its default layout.

## File Format

```ini
[DMC_CORONA]

-- where the DMC libraries are
LUA_PATH:JSON = [ "./dmc_corona" ]

[DMC_WEBSOCKETS]

DEBUG_ACTIVE:BOOL = true
```

The loader looks at the first character of each line:

- A line starting with `[` and a capital letter starts a **section**: `[DMC_WEBSOCKETS]`. Section names start with a capital letter, then letters, digits and underscores: `[DMC_E4X]`.
- A line starting with a capital letter is a **setting**: `NAME:TYPE = value`.
- Every other line is ignored: blank lines, comments (by convention `--`, as in Lua), and **indented lines**. An indented setting is skipped without a warning, so start settings at the first column.

Settings before the first section belong to `[DMC_CORONA]`.

In a setting:

- The name starts with a capital letter, then letters, digits and underscores. The type follows after a colon, spaces optional: `TIMER_MIN:INT` or `TIMER_MIN : INT`. Without a type the value is a string.
- A line that starts with a capital letter but isn't a setting (no `=`, for example) stops the app with an error naming the line.
- Spaces around `=` are optional.
- The value runs to the end of the line, so a setting line can't have a comment after the value. Quotes around the value are removed; they must match (`'hello'` or `"hello"`).
- A section or setting that appears twice keeps the last value.

Inside Lua, section and setting names are lowercase: `[DMC_WEBSOCKETS]` `DEBUG_ACTIVE` is `_G.__dmc_corona.dmc_websockets.debug_active`. The libraries read their own section; your code doesn't need to.

## Value Types

The type is not case-sensitive (`:BOOL` or `:bool`). An unknown type, or a value that doesn't fit its type, stops the app with an error naming the line or value.

| Type | Value | Example | In Lua |
|---|---|---|---|
| `BOOL`, `BOOLEAN` | `true` or `false`, any case; anything else is an error | `DEBUG_ACTIVE:BOOL = true` | `true` |
| `INT`, `INTEGER` | a whole number; anything else is an error | `TIMER_MIN:INT = 2000` | `2000` |
| `JSON` | JSON, decoded with Solar2D's `json` library | `LUA_PATH:JSON = [ "./dmc_corona" ]` | `{ "./dmc_corona" }` |
| `PATH` | a folder path; `/` and `\` become `.` | `LOCATION:PATH = lib/dmc_corona` | `"lib.dmc_corona"` |
| `FILE` | a file name, kept as a string | `NAMED_COLOR_FILE:FILE = colors.json` | `"colors.json"` |
| `STR`, `STRING`, none | a string | `DATA_FILENAME = gamedata` | `"gamedata"` |

Before 1.6.0 the checks were looser: a section name with a digit (`[DMC_E4X]`) stopped the app, `BOOL` read anything but `true` as `false`, `INT` took decimals, and an unknown type was read as a string.

## `LUA_PATH`

`LUA_PATH` in `[DMC_CORONA]` lists the folders that hold DMC libraries, relative to the project root, as a JSON array. The default:

```ini
[DMC_CORONA]
LUA_PATH:JSON = [ "./dmc_corona" ]
```

To keep third-party code in a subfolder, for example `lib/`:

```text
main.lua
dmc_corona_boot.lua
dmc_corona.cfg
lib/
└── dmc_corona/
```

name that folder instead:

```ini
[DMC_CORONA]
LUA_PATH:JSON = [ "./lib/dmc_corona" ]
```

and require the libraries by their path from the project root:

```lua
local WebSockets = require 'lib.dmc_corona.dmc_websockets'
```

`dmc_corona_boot.lua` and `dmc_corona.cfg` stay at the root.

## How Modules Are Found

The loader's `require` tries each of these in order and uses the first module it finds:

1. the name as given, from the project root (like Solar2D's own `require`);
2. the name inside each `LUA_PATH` folder, in the order listed;
3. the name inside each `LUA_PATH` folder's `lib/dmc_lua/` (the DMC Lua library that each DMC library includes).

That is how the libraries load each other by short names, wherever they are: dmc-websockets asks for `dmc_sockets` and `lib.dmc_lua.lua_objects`, and with the default `LUA_PATH` it gets `dmc_corona.dmc_sockets` and `dmc_corona.lib.dmc_lua.lua_objects`.

Some things follow from this:

- **Short and full names load the same module.** `require 'dmc_websockets'` and `require 'dmc_corona.dmc_websockets'` return the same table; Lua caches it under the full name.
- **The project root comes first.** A file of yours with the same name as a library module (for example `dmc_sockets.lua` at the root) is loaded instead of the library's.
- **Your own modules load as before,** because the root is searched first.
- **Errors keep their meaning.** A module that isn't found anywhere gives `The module '<name>' not found in archive:` with a traceback. A module that is found but fails to load (a syntax error, a runtime error) reports that error, not "not found".

Don't add a `LUA_PATH` folder to Lua's `package.path` as well. Modules would then load under two names, as two separate copies, and objects from one copy aren't recognized by the other.

## Library Sections

Each library reads its own section, named after the library in capitals: `[DMC_WEBSOCKETS]` for dmc-websockets, `[DMC_AUTOSTORE]` for dmc-autostore. Sections can come in any order after `[DMC_CORONA]`. A library uses its defaults for anything its section leaves out, and a missing section is fine.

The settings are listed in each library's documentation, and in the `dmc_corona.cfg` it ships with. For example, dmc-autostore's save timing:

```ini
[DMC_AUTOSTORE]
TIMER_MIN:INT = 2000
TIMER_MAX:INT = 6000
```

## Several DMC Libraries

To use more than one DMC library in a project:

- **Merge the `dmc_corona/` folders.** Files with the same name are the same library, shared by both; keep the newer copy.
- **Keep one `dmc_corona_boot.lua`,** the newer one.
- **Merge the config files:** one `[DMC_CORONA]` section, plus each library's own section.
