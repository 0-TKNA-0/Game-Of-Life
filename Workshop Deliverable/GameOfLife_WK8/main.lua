-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
-- Created By Brody Jeanes - 10568619

-- NOTE: I had originally completed week 8 deliverable prior to the email before the typo error was discovered so that is why there is the visual element of this deliverable included.

-- This section of code initializes up necessary display settings. The indvCellSize can be changed freely to change each cells size. gridPadding can be changed freely to change the width between each cell
local indvCellSize = 30 -- This dictates how large each cell is
local gridPadding = 4 -- This dictates the width between each cell

display.setDefault("background", 0.2, 0.2, 0.2) -- Sets the background colour. By default it is set to a gray

-- This section of code initializes the display screen
display.setStatusBar(display.HiddenStatusBar)

local centerX = display.contentCenterX -- X coordinate of the middle of the screen
local centerY = display.contentCenterY -- Y coordinate of the middle of the screen

local onScreenCells = display.newGroup() -- Creates the cell display group
local onScreenText = display.newGroup() -- Creates the text display group

-- This section of code is used to set up the cell display objects
function createCell(row, column)
    local x = (column - 1) * (indvCellSize + gridPadding) + centerX - (5 * (indvCellSize + gridPadding)) / 2 + indvCellSize / 2 -- Aligns cells in the center of the screen on the x axis
    local y = (row - 1) * (indvCellSize + gridPadding) + centerY - (5 * (indvCellSize + gridPadding)) / 2 + indvCellSize / 2 -- Aligns cells in the center of the screen on the y axis
    local cell = display.newRect(onScreenCells, x, y, indvCellSize, indvCellSize) -- Places the cells into the onScreenCells display group 
    return cell
end

-- This section of code creates the cell display objects
local cellDisplay = {} -- Creates an empty table for cell display objects
for row = 1, 5 do -- This loop iterates over each individual row
    cellDisplay[row] = {}
    for column = 1, 5 do -- This loop iterates over each individual column
        cellDisplay[row][column] = createCell(row, column)
    end
end

-- This section of code updates the cell display
function updateCellDisplay(cellBoard)
    for row = 1, 5 do -- This loop iterates over each individual row
        for column = 1, 5 do
            local cell = cellDisplay[row][column]

            if cellBoard[row][column] == 0 then -- If there are any cells that have a value of 0 (dead cells) then their colour will be changed
                cell.dead = {1} -- Cells that are dead are coloured white
                cell:setFillColor(unpack(cell.dead))
            else
                cell.alive = {0, 1, 0} -- Cells that are alive are coloured green
                cell:setFillColor(unpack(cell.alive))
            end
        end
    end
end

-- This section calculates the number of living cells neighbouring a cell that is alive.
function isNeighbourAlive(cellBoard, xAxis, yAxis)
    local neighbourAmount = 0 -- Creates a counter and sets it at 0

    for row = -1, 1 do
        for column = -1, 1 do
            if not (row == 0 and column == 0) and cellBoard[xAxis + row] and cellBoard[xAxis + row][yAxis + column] == 1 then
                neighbourAmount = neighbourAmount + 1 -- this checks to see if a neighbouring cell is alive, if it is the counter increases by 1.
            end
        end
    end
    return neighbourAmount

end

-- This section calculates the next potential state of a given cell, re-defining it as either living or dead.
function calculateNextState(cellBoard)
    local newCellBoard = {} -- creates a new 5x5 matrix to display the next set of cells

    for row = 1, 5 do
        newCellBoard[row] = {} -- creates 5 rows

        for column = 1, 5 do
            local aliveNeighbours = isNeighbourAlive(cellBoard, row, column) -- checks to see how many neighbours are alive which would allow a cell if it has enough neighbours to become alive.
            if cellBoard[row][column] == 1 and (aliveNeighbours == 2 or aliveNeighbours == 3) then
                newCellBoard[row][column] = 1 -- if a cell is alive and has 2 or 3 neighbours, then it will stay alive

            elseif cellBoard[row][column] == 0 and aliveNeighbours == 3 then
                newCellBoard[row][column] = 1 -- if a cell is dead but has 3 neighbours, then it will become alive.

            else
                newCellBoard[row][column] = 0
            end
        end
    end
    return newCellBoard
end

-- This section of code creates a list of the initial patterns shown in figure 2b - 2d. 0's represent dead cells and 1's represent alive cells.
local figurePatterns = {
    {
        {0, 0, 0, 0, 0},
        {0, 1, 1, 0, 0},
        {0, 1, 1, 0, 0},
        {0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0}
    },
    {
        {0, 0, 0, 0, 0},
        {0, 1, 0, 0, 0},
        {0, 0, 1, 0, 0},
        {0, 0, 0, 1, 0},
        {0, 0, 0, 0, 0}
    },
    {
        {0, 0, 0, 0, 0},
        {0, 1, 0, 0, 0},
        {0, 0, 1, 1, 0},
        {0, 1, 1, 0, 0},
        {0, 0, 0, 0, 0}
    }
}

-- This section will run the simulation for a fixed amount of iterations.
function fixedIterations(figurePattern, figurePatternIndex, iteration)
    local cellBoard = figurePattern
    updateCellDisplay(cellBoard)

    -- This sub section removes previous infoText object if they exists so they do not overlap
    if onScreenText.numChildren > 0 then
        onScreenText[1]:removeSelf()
    end

    -- This sub section creates and updates the pattern and iteration text dynamically
    local infoText = display.newText(onScreenText, "Pattern " .. figurePatternIndex .. " - Iteration " .. iteration, centerX, centerY + 150, native.systemFont, 20)
    infoText:setFillColor(1) -- sets the text colour to white

    if iteration == 1 then
        print("\nPattern " .. figurePatternIndex .. " - Iteration ".. iteration)
        for row = 1, 5 do
            local rowSeperator = ""
            for column = 1, 5 do
                if cellBoard[row][column] == 1 then
                    rowSeperator = rowSeperator .. "# "
                else
                    rowSeperator = rowSeperator .. cellBoard[row][column] .. " "
                end
            end
            print(rowSeperator)
        end
    end

    if iteration < 5 then
        timer.performWithDelay(500,  -- starts a timer for 500ms activates for every iteration and will move onto the next iteration once that timer is up.
        function()
            cellBoard = calculateNextState(cellBoard)
            updateCellDisplay(cellBoard) -- passes the 5x5 grid to the updateCellDisplay Function

            print("\nPattern " .. figurePatternIndex .. " - Iteration ".. (iteration + 1))
            for row = 1, 5 do
                local rowSeperator = ""
                for column = 1, 5 do
                    if cellBoard[row][column] == 1 then
                        rowSeperator = rowSeperator .. "# "  -- this changes the alive cells' display from 1 to a # which was my own personal preferance. Simply changing this icon will change what an alive cell looks like in the simulation.
                    else
                        rowSeperator = rowSeperator .. cellBoard[row][column] .. " "
                    end
                end
                print(rowSeperator)
            end
            infoText.text = "Pattern " .. figurePatternIndex .. " - Iteration " .. iteration -- Displays text on the screen that states what iteration and pattern the program is currently on
            fixedIterations(cellBoard, figurePatternIndex, iteration + 1)
        end)
    else
        timer.performWithDelay(1000, -- starts a timer for 1000ms that activates when a pattern has iterateded 5 times and will move onto the next patter once that timer is up
        function()
            figurePatternIndex = figurePatternIndex + 1 -- updates the figurePatternIndex variable so that it will use the next pattern
            if figurePatternIndex <= #figurePatterns then
                fixedIterations(figurePatterns[figurePatternIndex], figurePatternIndex, 1) -- calls the fixedIteration function again for a new pattern
            else
                print("\nAll Patterns Completed")
                local infoText = display.newText(onScreenText, "End", centerX, centerY + 180, native.systemFont, 20)
            end
        end)
    end
end

-- This section of code starts the program with the first pattern
fixedIterations(figurePatterns[1], 1, 1)