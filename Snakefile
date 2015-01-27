# dmc-corona-boot

try:
	if not gSTARTED: print( gSTARTED )
except:
	MODULE = "dmc-corona-boot"
	include: "../DMC-Corona-Library/snakemake/Snakefile"

module_config = {
	"name": "dmc-corona-boot",
	"module": {
		"dir": ".",
		"files": [
			"dmc_corona_boot.lua"
		],
		"requires": []
	},
	"examples": {
		"dir": "examples",
		"apps": []
	},
	"tests": {
		"files": [],
		"requires": []
	}
}

register( "dmc-corona-boot", module_config )

