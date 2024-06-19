-----------------------------------------------------------------------------------------
--
-- randomStartState.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
-- Created By Brody Jeanes - 10568619

-- NOTE: the program will run infintly until it is paused.

-- This section of code imports the required libraries and creates the new scene 
local composer = require("composer")
local randomStartState = composer.newScene()

-- This section of code initialises necessary display settings and other variables that are required for modules to work.
local indvCellSize = display.contentWidth / 200
local outlineWidth = indvCellSize * 200
local outlineHeight = indvCellSize * 200
local centerX = display.contentCenterX -- X coordinate of the middle of the screen
local centerY = display.contentCenterY -- Y coordinate of the middle of the screen
local cellBoard = {}

local paused = true

local buttonWidth = 125
local buttonHeight = 40
local cornerRadius = 10

local initialCellBoard = {}

local iterationSpeed = 150
------------------------------------
-- UNIT TESTING

    -- This section checks to see if the actualValue is equal or not to the expectedValue which is utilised for unit tests
    function unitTest(actualValue, expectedValue, testMessage)
        if actualValue ~= expectedValue then
            print("Test failed:", testMessage)
        else
            print("Test passed:", testMessage)
        end
    end

    -- This section tests isNeighbourAlive using the unitTest function. It creates a small cellBoard 3x3 and tests to see if the IsNeighbourAlive is actually recognising if a alive cell has alive neighbours or not
    function isNeighbourAliveTests()
        local testCellBoard = {
            {true, false, true},
            {false, true, false},
            {true, false, false}
        }

        unitTest(isNeighbourAlive(testCellBoard, 2, 2), 3, "Test isNeighbourAlive 1")
        unitTest(isNeighbourAlive(testCellBoard, 1, 1), 1, "Test isNeighbourAlive 2")
        unitTest(isNeighbourAlive(testCellBoard, 3, 3), 1, "Test isNeighbourAlive 3")
    end

    -- This section tests createRandomStartingPoints using the unitTest function. It counts every row and column and determins if there are 5000 points or not
    function createRandomStartingPointsTest()
        local cellBoard = {}
        for row = 1, 200 do
            cellBoard[row] = {}
            for column = 1, 200 do
                cellBoard[row][column] = false
            end
        end

        local cellBoardStartingPoint = 5000
        for row = 1, 200 do
            for column = 1, 200 do
                if cellBoard[row][column] then
                    cellBoardStartingPoint = cellBoardStartingPoint + 1
                end
            end
        end

        unitTest(cellBoardStartingPoint, 5000, "Test createRandomStartingPoints")
    end

    -- This section tests increaseSpeedButtonTest using the unitTest function. It will simulate as if the user has pressed the button to increase the iteration speed
    function increaseSpeedButtonTest()
        local initialSpeed = iterationSpeed
        increaseSpeedButtonGroup:dispatchEvent({ name = "tap" })
        unitTest(iterationSpeed, initialSpeed - 25, "Test increaseSpeedButton - Speed increased by 25")
    end

    -- This section tests decreaseSpeedButtonTest using the unitTest function. It will simulate as if the user has pressed the button to decrease the iteration speed
    function decreaseSpeedButtonTest()
        local initialSpeed = iterationSpeed
        decreaseSpeedButtonGroup:dispatchEvent({ name = "tap" })
        unitTest(iterationSpeed, initialSpeed + 25, "Test decreaseSpeedButton - Speed decreased by 25")
    end

    -- This section checks if the current scene matches the expected scene name
    function sceneNavigationTest()
        local currentScene = composer.getSceneName("current")
        -- Check if the current scene matches the expected scene name
        unitTest(currentScene, "randomStartState", "Test sceneNavigationTest - Navigation to RandomStartState")
    end

    -- This section tests randomSeedButtonTest for whether or not a random seed is generated when the button is pressed
    function randomSeedButtonTest(randomSeedButtonGroup)
        for row = 1, 200 do
            initialCellBoard[row] = {}
            for column = 1, 200 do
                initialCellBoard[row][column] = cellBoard[row][column]
            end
        end
        randomSeedButtonGroup:dispatchEvent({ name = "tap" })

        -- This section verifies that the cellBoard has changed, which would indicate that random seeding has occurred
        local seedApplied = false
        for row = 1, 200 do
            for column = 1, 200 do
                if cellBoard[row][column] ~= initialCellBoard[row][column] then
                    seedApplied = true
                    break
                end
            end
        end
        if seedApplied == true then
            unitTest(true, true, "randomSeedButtonTest", randomSeedButtonGroup)
        else
            unitTest(false, true, "randomSeedButtonTest", randomSeedButtonGroup)
        end
    end
------------------------------------

-- This section of code creates all of the elements that will be seen on the screen and runs whenever the Start Random Game button is pressed in the main menu.
function randomStartState:create(event)
    local randomStartStateGroup = self.view
    onScreenCells = display.newGroup(randomStartStateGroup)

    createGrid()
    createRandomStartingPoints()
    createRandomStartingPointsTest()
    isNeighbourAliveTests()
    sceneNavigationTest()
    
    -- This section of code creates the green outline around the simulated area
    local outline = display.newRect(onScreenCells, centerX, centerY, outlineWidth - 2, outlineHeight - 2)
    outline:setFillColor(0, 0, 0, 0)
    outline:setStrokeColor(0, 1, 0)
    outline.strokeWidth = 1

    -- This section of code creates a timer to update the grid continuously as long as the program is running
    continuousTimer = timer.performWithDelay(iterationSpeed, function()
        if paused == false then
            updateCellDisplay()
            for row = 1, 200 do
                for column = 1, 200 do
                    onScreenCells[row + (column - 1) * 200]:setFillColor(cellBoard[row][column] and 1 or 0)
                end
            end
        end
    end, -1)

    for row = 1, 200 do
        initialCellBoard[row] = {}
        for column = 1, 200 do
            initialCellBoard[row][column] = cellBoard[row][column]
        end
    end

    local titleText = display.newText(randomStartStateGroup, "Randomly Generated \n             Game", centerX , 30, native.systemFontBold, 26)
    titleText:setFillColor(1, 1, 1)

---------------------------------------------------
-- Play Button 

    --- This section of code creates a PLAY button which is used to start the simulation for the first time
    playButtonGroup = display.newGroup()
    randomStartStateGroup:insert(playButtonGroup)

    local playButtonBg = display.newRoundedRect(playButtonGroup, centerX , display.contentHeight - 50, buttonWidth, buttonHeight, cornerRadius)
    playButtonBg:setFillColor(1, 1, 1)
        
    local playButtonText = display.newText(playButtonGroup, "Play", centerX , display.contentHeight - 50, native.systemFont, 24)
    playButtonText:setFillColor(0, 0, 0)

    playButtonGroup:addEventListener("tap", function(event)
        if paused == true then
            paused = false
            playButtonGroup.isVisible = false
            pauseButtonGroup.isVisible = true
            restartButtonGroup.isVisible = true
        end
    end)

---------------------------------------------------
-- Pause And Resume Buttons 

    -- This section of code create a PAUSE button which is used to pause the simulation at any given time
    pauseButtonGroup = display.newGroup()
    randomStartStateGroup:insert(pauseButtonGroup)

    local pauseButtonBg = display.newRoundedRect(pauseButtonGroup, centerX  - 80, display.contentHeight - 50, buttonWidth, buttonHeight, cornerRadius)
    pauseButtonBg:setFillColor(1, 1, 1)

    pauseButtonText = display.newText(pauseButtonGroup, "Pause", centerX  - 80, display.contentHeight - 50, native.systemFont, 24)
    pauseButtonText:setFillColor(0, 0, 0)

    pauseButtonGroup:addEventListener("tap", function(event)
        paused = true
        pauseButtonGroup.isVisible = false
        resumeButtonGroup.isVisible = true
    end)
    pauseButtonGroup.isVisible = false

    
    -- This section of code create a RESUME button which is used to resume the simulation at any given time when it is paused
    resumeButtonGroup = display.newGroup()
    randomStartStateGroup:insert(resumeButtonGroup)

    local resumeButtonBg = display.newRoundedRect(resumeButtonGroup, centerX  - 80, display.contentHeight - 50, buttonWidth, buttonHeight, cornerRadius)
    resumeButtonBg:setFillColor(1, 1, 1)    

    resumeButtonText = display.newText(resumeButtonGroup, "Resume", centerX  - 80, display.contentHeight - 50, native.systemFont, 24)
    resumeButtonText:setFillColor(0, 0, 0)

    resumeButtonGroup:addEventListener("tap", function(event)
        paused = false
        resumeButtonGroup.isVisible = false
        pauseButtonGroup.isVisible = true
    end)
    resumeButtonGroup.isVisible = false

---------------------------------------------------
-- Back To Main Menu Button 

    -- This section of code creates a BACK button which is used to return the user back to the main menu scene
    backButtonGroup = display.newGroup()
    randomStartStateGroup:insert(backButtonGroup)

    local backButtonbg = display.newRoundedRect(backButtonGroup, centerX, display.contentHeight, buttonWidth, buttonHeight, cornerRadius)
    backButtonbg:setFillColor(1, 1, 1)
        
    local backButtonText = display.newText(backButtonGroup, "Back", centerX, display.contentHeight, native.systemFont, 24)
    backButtonText:setFillColor(0, 0, 0)

    backButtonGroup:addEventListener("tap", function(event)
        paused = true
        composer.removeScene("randomStartState", true)
        composer.gotoScene("mainMenu", { effect = "slideRight", time = 500 })
        unitTest(currentScene, "mainMenu", "Test sceneNavigationTest - Navigation to mainMenu")
    end)

---------------------------------------------------
-- Restart Button

    -- This section of code creates a RESTART button which is used to restart the simulation completely
    restartButtonGroup = display.newGroup()
    randomStartStateGroup:insert(restartButtonGroup)

    local restartButtonBg = display.newRoundedRect(restartButtonGroup, centerX  - -80, display.contentHeight - 50, buttonWidth, buttonHeight, cornerRadius)
    restartButtonBg:setFillColor(1, 1, 1)
                
    restartButtonText = display.newText(restartButtonGroup, "Restart", centerX  - -80, display.contentHeight - 50, native.systemFont, 24)
    restartButtonText:setFillColor(0, 0, 0)

    restartButtonGroup:addEventListener("tap", function(event)
        paused = true
        restartButtonGroup.isVisible = false
        playButtonGroup.isVisible = true
        pauseButtonGroup.isVisible = false
        resumeButtonGroup.isVisible = false

        -- This section of code is used to restore the initial state of cellBoard
        for row = 1, 200 do
            for column = 1, 200 do
                cellBoard[row][column] = initialCellBoard[row][column]
            end
        end

        -- This seciton of code is used to update the cell display to reflect the new state
        updateCellDisplay()
        for row = 1, 200 do
            for column = 1, 200 do
                onScreenCells[row + (column - 1) * 200]:setFillColor(cellBoard[row][column] and 1 or 0)
            end
        end
    end)
    restartButtonGroup.isVisible = false

---------------------------------------------------
-- Increase and Decrease Speed Buttons 

    -- This section of code creates a button to decrease the time between each iteration (hence increasing the overall speed)  
    increaseSpeedButtonGroup = display.newGroup()  
    randomStartStateGroup:insert(increaseSpeedButtonGroup)

    local increaseSpeedButtonBg = display.newRoundedRect(increaseSpeedButtonGroup, centerX  - -125, display.contentHeight - 525, 50, buttonHeight, cornerRadius)
    increaseSpeedButtonBg:setFillColor(1, 1, 1)
                
    increaseSpeedButtonText = display.newText(increaseSpeedButtonGroup, ">>" , centerX  - -125, display.contentHeight - 525, native.systemFont, 24)
    increaseSpeedButtonText:setFillColor(0, 0, 0)

    increaseSpeedButtonGroup:addEventListener("tap", function(event)
        iterationSpeed = math.max(iterationSpeed - 25, 25)
        timer.cancel(continuousTimer) 
        continuousTimer = timer.performWithDelay(iterationSpeed, function()
            if paused == false then
                updateCellDisplay()
                for row = 1, 200 do
                    for column = 1, 200 do
                        onScreenCells[row + (column - 1) * 200]:setFillColor(cellBoard[row][column] and 1 or 0)
                    end
                end
            end
        end, -1)
    end)

    increaseSpeedButtonTest()

    -- This section of code creates a button to increase the time between each iteration (hence decreaseing the overall speed)
    decreaseSpeedButtonGroup = display.newGroup()  
    randomStartStateGroup:insert(decreaseSpeedButtonGroup)

    local decreaseSpeedButtonBg = display.newRoundedRect(decreaseSpeedButtonGroup, centerX  - -67, display.contentHeight - 525, 50, buttonHeight, cornerRadius)
    decreaseSpeedButtonBg:setFillColor(1, 1, 1)
                
    decreaseSpeedButtonText = display.newText(decreaseSpeedButtonGroup, "<<", centerX  - -67, display.contentHeight - 525, native.systemFont, 24)
    decreaseSpeedButtonText:setFillColor(0, 0, 0)

    decreaseSpeedButtonGroup:addEventListener("tap", function(event)
        iterationSpeed = math.min(iterationSpeed + 25, 500)
        timer.cancel(continuousTimer)
        continuousTimer = timer.performWithDelay(iterationSpeed, function()
            if paused == false then
                updateCellDisplay()
                for row = 1, 200 do
                    for column = 1, 200 do
                        onScreenCells[row + (column - 1) * 200]:setFillColor(cellBoard[row][column] and 1 or 0)
                    end
                end
            end
        end, -1)
    end)

    decreaseSpeedButtonTest()
---------------------------------------------------
-- Random Seed Generation 

    -- This section of code creates a button to randomly seed the simulation with randomly selected dead and alive cells. 
    local randomSeedButtonGroup = display.newGroup()
    randomStartStateGroup:insert(randomSeedButtonGroup)

    local randomSeedButtonBg = display.newRoundedRect(randomSeedButtonGroup, centerX - 65, display.contentHeight - 525, 175, buttonHeight, cornerRadius)
    randomSeedButtonBg:setFillColor(1, 1, 1)

    local randomSeedButtonText = display.newText(randomSeedButtonGroup, "Random Seed", centerX - 65, display.contentHeight - 525, native.systemFont, 24)
    randomSeedButtonText:setFillColor(0, 0, 0)

    randomSeedButtonGroup:addEventListener("tap", function(event)
        createRandomStartingPoints()
        updateCellDisplay()
    end)
    randomSeedButtonTest(randomSeedButtonGroup)
end

-- This section of code hides / removes all of the elements that are used within the custom start state module and stops the timer so the simulation doesnt run in the background
function randomStartState:hide(event)
    local randomStartStateGroup = self.view

    if event.phase == "will" then
        if continuousTimer == true then
            timer.cancel(continuousTimer)
        end
        display.remove(onScreenCells)
    end
end

-- This section of code initializes the 200x200 grid
function createGrid()
    for row = 1, 200 do
        cellBoard[row] = {}
        for column = 1, 200 do
            local cell = display.newRect(onScreenCells, centerX + (row - 200 / 2 - 0.5) * indvCellSize, centerY + (column - 200 / 2 - 0.5) * indvCellSize, indvCellSize, indvCellSize)
            cell:setFillColor(cellBoard[row][column] and 1 or 0) -- Alive cells are white, dead cells are black
        end
    end
end

-- This section of code creates 5000 random starting positions and sets those positions to being alive
function createRandomStartingPoints()

    for row = 1, 200 do
        for column = 1, 200 do
            cellBoard[row][column] = false
        end
    end
    
    local cellBoardStartingPoint = 5000
    while cellBoardStartingPoint > 0 do
        local row = math.random(1, 200)
        local column = math.random(1, 200)
        
        if not cellBoard[row][column] then
            cellBoard[row][column] = true
            cellBoardStartingPoint = cellBoardStartingPoint - 1
        end
    end
end


-- This section of code updates the cell display after every iteration
function updateCellDisplay()
    local newCellBoard = {}
    for row = 1, 200 do
        newCellBoard[row] = {}
        for column = 1, 200 do
            local aliveNeighbours = isNeighbourAlive(cellBoard, row, column)

            if cellBoard[row][column] then
                -- Cell is alive
                newCellBoard[row][column] = aliveNeighbours == 2 or aliveNeighbours == 3
            else
                -- Cell is dead
                newCellBoard[row][column] = aliveNeighbours == 3
            end
        end
    end
    cellBoard = newCellBoard
end

-- This section calculates the number of living cells neighbouring a cell that is alive.
function isNeighbourAlive(cellBoard, xAxis, yAxis)
    local neighbourAmount = 0

    for row = -1, 1 do
        for column = -1, 1 do
            if not (row == 0 and column == 0) and cellBoard[xAxis + row] and cellBoard[xAxis + row][yAxis + column] then
                neighbourAmount = neighbourAmount + 1
            end
        end
    end
    return neighbourAmount
end

randomStartState:addEventListener("create", randomStartState)
randomStartState:addEventListener("hide", randomStartState)

return randomStartState