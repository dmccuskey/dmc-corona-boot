--====================================================================--
-- Corona Boot Unit Tests
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--

module(..., package.seeall)



--====================================================================--
--== Test: dmc-corona-boot
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local function isError_notFound()
-- "The module '' not found in archive:"
end

local function isError_loading()
--- "error loading module"
end

local function isError_notFound()

end



--====================================================================--
--== Testing Setup
--====================================================================--


function suite_setup()
	require 'dmc_corona_boot'
end

-- 1> require level-1 file
function test_L1F1()
	local file = require 'tests.mod_F1'
	assert_equal( file.name, 'module-found', "names should be equal" )
end

-- 1> require level-1 file
--    2> require level-1 file
function test_L1R1()
	local file = require 'tests.mod_L1R1'
	assert_equal( file.name, 'module-request', "names should be equal" )
	assert_equal( file.file.name, 'module-found', "names should be equal" )
end

-- 1> require level-2 file
function test_L2F1()
	local file = require 'tests.level2.mod_F1'
	assert_equal( file.name, 'module-found', "names should be equal" )
end

-- 1> require level-3 file
function test_L3F1()
	local file = require 'tests.level2.level3.mod_F1'
	assert_equal( file.name, 'module-found', "names should be equal" )
end

-- 1> require level-1 missing file
function test_L1M1()
	local path = 'tests.mod_M1'
	-- require(path)
	assert_error( function() local file = require(path) end, "should be error" )
end

-- 1> require level-2 missing file
function test_L2M1()
	local path = 'tests.level2.mod_M1'
	-- require(path)
	assert_error( function() local file = require(path) end, "should be error" )
end

-- 1> require level-1 error file
function test_L1E1()
	local path = 'tests.mod_E1'
	-- require(path)
	assert_error( function() local file = require(path) end, "should be error" )
end

-- 1> require level-2 error file
function test_L2E1()
	local path = 'tests.level2.mod_E1'
	-- require(path)
	assert_error( function() local file = require(path) end, "should be error" )
end

-- 1> require level-1 file
--   2> require level-2 error file
function test_L1R1_L2E2()
	local path = 'tests.mod_L1R1_L2E2'
	-- require(path)
	assert_error( function() local file = require(path) end, "should be error" )
end

-- 1> require level-1 file
--   2> require lib file
function test_L1R1_LBF1()
	local file = require 'tests.mod_L1R1_LBF1'
	assert_equal( file.name, 'module-request', "names should be equal" )
	assert_equal( file.lib.name, 'lib-module-found', "names should be equal" )
end

