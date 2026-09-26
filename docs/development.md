# Development

How dmc-corona-boot is tested, how the DMC libraries get their copy of it, and where it could go next.

## Testing

The unit tests load modules through the loader: at the root, in `LUA_PATH` folders, in subfolders, and in `lib/dmc_lua/`, including modules that load other modules, and modules that are missing or fail to load. They run in plain Lua 5.1, without Solar2D, and need `dkjson`:

```sh
tests/run_unit.sh
```

The script uses `../tools/lua51/bin/lua`; set `LUA=` to use another Lua 5.1 interpreter. The tests read `tests/dmc_corona.cfg`. Expected output ends with:

```text
  10 passed, 0 failed, 0 error(s), 0 skipped.
```

`main.lua` runs the same tests in the Solar2D Simulator. There the loader reads a `dmc_corona.cfg` at the repository root, which doesn't exist, so `test_L1R1_LBF1` fails unless you copy `tests/dmc_corona.cfg` there.

## How the Libraries Get Their Copy

Every DMC library includes `dmc_corona_boot.lua` at its root, copied from this repository with [Snakemake](https://snakemake.readthedocs.io/) (version 7) using DMC-Corona-Library's shared rules. After a change here, rebuild the libraries that bundle it (all of them).

In this repository the source file is also the build output, so don't run a Snakemake build here with `--forceall`: Snakemake deletes outputs before it rebuilds them.

## Branches

Changes go on a short-lived branch (`fix/...`, `feat/...`, `docs/...`) and reach `master` once tested.

## Possible Future Changes

These are ideas, not plans. Each needs discussion and a concrete use case before it is worked on; decided work goes in [GitHub issues](https://github.com/dmccuskey/dmc-corona-boot/issues).

- **Warn about ignored lines** in `dmc_corona.cfg`, such as indented settings, instead of skipping them silently.
- **Allow comments after a value** on a setting line.
