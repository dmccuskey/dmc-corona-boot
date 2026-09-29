# Changelog

## Unreleased

### Fixed

- A config section with a digit in its name, such as `[DMC_E4X]`, stopped the app at boot. The config parser is now lua-files 0.3.0's: names may have digits, `KEY : TYPE` may have spaces, and a line that isn't a setting gives a clear error.
- The loader set the global `_extend` in every DMC app (its copy of `Utils.extend`); it is now local, as in lua-utils 0.3.0.

### Changed

- Stricter config values: `BOOL` must be `true` or `false` (any case; anything else used to read as `false`), `INT` a whole number, and an unknown type is an error instead of a string. Version 1.6.0.

### Added

- Documentation: README with a Quick Start, and `docs/` with the `dmc_corona.cfg` reference, recovered from the old docs site and checked against the code.
- `tests/run_unit.sh` runs the unit tests in plain Lua 5.1, with a test config (`tests/dmc_corona.cfg`) so all of them pass.

## 1.5.2 (2015-04-25)

The last release before this changelog was started; see the Git history for earlier changes.
