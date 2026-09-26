#!/bin/sh
#
# Run the lunatest unit specs with plain Lua 5.1.
#
# usage: tests/run_unit.sh
#   override the interpreter with LUA=

set -e

HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/.." && pwd)
LUA=${LUA:-$ROOT/../tools/lua51/bin/lua}

cd "$ROOT"
LUA_PATH="$ROOT/?.lua;$($LUA -e 'io.write(package.path)')"
LUA_CPATH="$($LUA -e 'io.write(package.cpath)')"
export LUA_PATH LUA_CPATH

# stand-ins for the Solar2D globals the loader touches: json, and
# system.pathForFile, pointed at the test config
"$LUA" -e "
package.preload.json = package.preload.json or function() return require 'dkjson' end
system = { ResourceDirectory='.', pathForFile=function() return 'tests/dmc_corona.cfg' end }
require 'tests.lunatest'
lunatest.suite( 'tests.dmc_corona_boot_spec' )
lunatest.run()
"
