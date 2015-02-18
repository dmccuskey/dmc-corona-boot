--====================================================================--
-- Corona Boot Main
--
-- Run Unit Tests for dmc-corona-boot
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--


print( '\n\n##############################################\n\n' )


require 'tests.lunatest'

lunatest.suite( 'tests.dmc_corona_boot_spec' )

lunatest.run()
