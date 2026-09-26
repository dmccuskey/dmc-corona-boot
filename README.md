# dmc-corona-boot

The loader behind the DMC libraries for Solar2D (formerly Corona SDK): it reads `dmc_corona.cfg` and lets the libraries find each other wherever you keep them in your project.

You don't call it yourself. Every DMC library loads it on its first `require`, and it replaces `require` with a version that also searches the folders listed in `dmc_corona.cfg`:

```ini
[DMC_CORONA]
LUA_PATH:JSON = [ "./dmc_corona" ]

[DMC_WEBSOCKETS]
DEBUG_ACTIVE:BOOL = true
```

## Features

- One file, `dmc_corona_boot.lua`, shipped with every DMC library
- Keep the DMC libraries in any folder (`dmc_corona/`, `lib/dmc_corona/`, ...) by naming it in one config line
- Libraries load each other by short names, whatever folder they are in
- One config file for all DMC libraries, with a section per library
- Typed settings: boolean, integer, JSON, path and string values
- Clear errors: a missing module is reported with the name that was asked for and a traceback
- Pure Lua, no plugins; MIT licensed

## Quick Start

This sets up the DMC library layout in a Solar2D project and loads a library from it, in about 5 minutes, in the Solar2D Simulator on macOS or Windows. It uses [dmc-websockets](https://github.com/dmccuskey/dmc-websockets) as the example library; any DMC library works the same way.

Prerequisites: the [Solar2D](https://solar2d.com/) Simulator and a copy of a DMC library (`git clone https://github.com/dmccuskey/dmc-websockets.git`, or download the ZIP from GitHub). Each DMC library already includes `dmc_corona_boot.lua`; you don't need this repository to use one.

### 1. Copy Three Items into Your Project

Copy these from the library into the root of your project folder:

```text
dmc_corona_boot.lua     this loader
dmc_corona.cfg          the configuration
dmc_corona/             the library and the libraries it uses
```

`dmc_corona_boot.lua` and `dmc_corona.cfg` must stay at the root of the project folder.

**Going further:** to use more than one DMC library, merge their `dmc_corona/` folders ([Configuration](docs/configuration.md#several-dmc-libraries)).

### 2. Load the Library

Create `main.lua` in the project folder with:

```lua
local WebSockets = require 'dmc_corona.dmc_websockets'

print( 'loaded dmc-websockets', WebSockets.VERSION )
```

Open the project in the Simulator. The console shows:

```text
loaded dmc-websockets	1.4.0
```

A warning that `plugin.bit is not configured in build.settings`, and `Lua Patch::` lines, may come first; they are harmless here.

If it shows `The module 'lib.dmc_lua.lua_bytearray' not found in archive:` instead, `dmc_corona.cfg` is missing from the root of the project folder, or its `LUA_PATH` doesn't name the folder the libraries are in.

**Going further:** keep the libraries in a subfolder such as `lib/` ([Configuration](docs/configuration.md#lua_path)), or change a library's settings ([Configuration](docs/configuration.md#library-sections)).

To update, copy `dmc_corona_boot.lua` and `dmc_corona/` again from the newer version of the library. Keep your own `dmc_corona.cfg` if you have changed it.

## Documentation

- [Configuration](docs/configuration.md): the `dmc_corona.cfg` format, `LUA_PATH`, how modules are found
- [Development](docs/development.md): tests, how the libraries get their copy of this file

Everything else is listed on the [documentation home](docs/README.md).

## License

dmc-corona-boot is released under the [MIT License](LICENSE).
