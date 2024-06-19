-----------------------------------------------------------------------------------------
--
-- mainMenu.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
-- Created By Brody Jeanes - 10568619

-- This section of code imports the required libraries and creates the new scene 
local composer = require("composer")
local mainMenu = composer.newScene()

-- This section initialises button display variables
local buttonWidth = 275
local buttonHeight = 60
local cornerRadius = 10

-- This section of code will load randomStartState scene when the Start Random Game button is pressed
function onRandomGameButtonTap()
    composer.gotoScene("randomStartState", { effect = "fade", time = 250 })
end

-- This section of code will load customStartState scene when the Start Custom Game button is pressed
function onCustomGameButtonTap()
    composer.gotoScene("customStartState", { effect = "fade", time = 250 })
end

-- This section of code creates all of the elements that will be seen on the screen
function mainMenu:create(event)
    local mainMenuGroup = self.view

    local titleText = display.newText(mainMenuGroup, "  Game Of Life\n UNIT TESTING", display.contentCenterX, 50, native.systemFontBold, 36)
    titleText:setFillColor(1, 1, 1) 

    
    local randomGameButtonBg = display.newRoundedRect(mainMenuGroup, display.contentCenterX, 200, buttonWidth, buttonHeight, cornerRadius)
    randomGameButtonBg:setFillColor(1, 1, 1)

    local randomGameButton = display.newText(mainMenuGroup, "Start Random Game", display.contentCenterX, 200, native.systemFont, 24)
    randomGameButton:setFillColor(0, 0, 0)


    local customGameButtonBg = display.newRoundedRect(mainMenuGroup, display.contentCenterX, 300, buttonWidth, buttonHeight, cornerRadius)
    customGameButtonBg:setFillColor(1, 1, 1)

    local customGameButton = display.newText(mainMenuGroup, "Start Custom Game", display.contentCenterX, 300, native.systemFont, 24)
    customGameButton:setFillColor(0, 0, 0)

    randomGameButtonBg:addEventListener("tap", onRandomGameButtonTap)
    customGameButtonBg:addEventListener("tap", onCustomGameButtonTap)
end

mainMenu:addEventListener("create", mainMenu)

return mainMenu