-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
-- Created By Brody Jeanes - 10568619

-- This section of code imports the required libraries
local composer = require("composer")

display.setDefault("background", 0.3, 0.3, 0.3)
display.setStatusBar(display.HiddenStatusBar)

-- This section of code opens the mainMenu scene when the program is ran
composer.gotoScene("mainMenu")