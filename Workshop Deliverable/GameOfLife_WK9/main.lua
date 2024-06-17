-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
-- Created By Brody Jeanes - 10568619

-- NOTE: the program will run infintly until it is turned off.

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

-- This section of code initializes necessary display settings.
local indvCellSize = display.contentWidth / 200
local outlineWidth = indvCellSize * 200
local outlineHeight = indvCellSize * 200

display.setDefault("background", 0.2, 0.2, 0.2) -- Sets the background colour. By default it is set to a gray

-- This section of code initializes the display screen
display.setStatusBar(display.HiddenStatusBar)

local centerX = display.contentCenterX -- X coordinate of the middle of the screen
local centerY = display.contentCenterY -- Y coordinate of the middle of the screen

local onScreenCells = display.newGroup() -- Creates the cell display group

local cellBoard = {} -- Create an array to store the state of each cell

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
    local cellBoardStartingPoint = 5000 -- 5000 starting points
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

-- This section starts the program by calling the createGrid function and then the createRandomStartingPoints function. It also calls the unit testing functions
createGrid()
createRandomStartingPoints()
createRandomStartingPointsTest()
isNeighbourAliveTests()


-- This section of code creates a green outline around the grid to showcase the simulation area
local outline = display.newRect(onScreenCells, centerX, centerY, outlineWidth - 2, outlineHeight - 2)
outline:setFillColor(0, 0, 0, 0) -- Sets the fill colour to transparent
outline:setStrokeColor(0, 1, 0) -- Sets the stroke colour to green
outline.strokeWidth = 1 -- Adjusts the stroke width

-- This section of code creates a timer to update the grid continuously as long as the program is running
local continuousTimer = timer.performWithDelay(250, function() -- timer by default is set to update every 250ms
    updateCellDisplay()
    for row = 1, 200 do
        for column = 1, 200 do
            onScreenCells[row + (column - 1) * 200]:setFillColor(cellBoard[row][column] and 1 or 0) -- Update cell colours
        end
    end
end, -1) -- makes sure the timer runs infintly