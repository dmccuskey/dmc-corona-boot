# dmc-corona-boot Documentation

New here? The [Quick Start](../README.md#quick-start) sets up the DMC library layout and loads a library in about 5 minutes.

## Start

- [Quick Start](../README.md#quick-start): copy three items into a project, load a library

## Use

- [Configuration](configuration.md): the `dmc_corona.cfg` format, value types, `LUA_PATH`, using several DMC libraries

## Internals

- [How modules are found](configuration.md#how-modules-are-found): the loader's search order and what follows from it

## Contribute

- [Development](development.md): tests, how the libraries get their copy, possible future changes
- [Changelog](../CHANGELOG.md)
- [Issues](https://github.com/dmccuskey/dmc-corona-boot/issues)

## Project Structure

```text
README.md                   landing page and Quick Start
CHANGELOG.md
LICENSE
docs/                       this documentation
dmc_corona_boot.lua         the loader (source, and what the libraries copy)
main.lua                    runs the tests in the Solar2D Simulator
Snakefile                   registers this repository with the shared build rules
tests/
├── run_unit.sh             runs the tests in plain Lua 5.1
├── dmc_corona.cfg          config used by the tests
├── dmc_corona_boot_spec.lua
├── lunatest.lua            test framework (Scott Vokes, MIT)
└── ...                     modules for the tests to load
```
