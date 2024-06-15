-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
-- Created By Brody Jeanes - 10568619

-- This section of the code first creates and initializes the grid / board that the cells will be placed on
local cellBoard = {} -- this is the board / matrix
for row = 1, 5 do 
    cellBoard[row] = {} -- creates 5 rows

    for column = 1, 5 do
        cellBoard[row][column] = 0 -- creates 5 columns and fills in the matrix with 0's. 0 means dead, and 1 means alive.
    end

end

-- This section of code places the alive cells on the matrix that is shown in figure 2a.
cellBoard[3][2] = 1 
cellBoard[3][3] = 1
cellBoard[3][4] = 1

-- This section calculates the number of living cells neighbouring a cell that is alive.
function isNeighbourAlive(cellBoard, xAxis, yAxis)
    local neighbourAmount = 0 -- creates a counter and sets it at 0

    for row = -1, 1 do
        for column = -1, 1 do
            if not (row == 0 and column == 0) and (cellBoard[xAxis + row]) and (cellBoard[xAxis + row][yAxis + column] == 1) then
                neighbourAmount = neighbourAmount + 1 -- this checks to see if a neighbouring cell is alive, if it is the counter increases by 1.
            end
        end
    end
    return neighbourAmount

end

-- This section calculates the next potential state of a given cell, re-defining it as either living or dead.
function cellNextState(cellBoard)
    local newcellBoard = {} -- creates a new 5x5 matrix to display the next set of cells

    for row = 1, 5 do
        newcellBoard[row] = {} -- creates 5 rows

        for column = 1, 5 do
            local aliveNeighbours = isNeighbourAlive(cellBoard, row, column) -- checks to see how many neighbours are alive which would allow a cell if it has enough neighbours to become alive.
            if (cellBoard[row][column] == 1) and (aliveNeighbours == 2 or aliveNeighbours == 3) then
                newcellBoard[row][column] = 1 -- if a cell is alive and has 2 or 3 neighbours, then it will stay alive
                
            elseif (cellBoard[row][column] == 0) and (aliveNeighbours == 3) then
                newcellBoard[row][column] = 1 -- if a cell is dead but has 3 neighbours, then it will become alive.
                
            else
                newcellBoard[row][column] = 0

            end
        end
    end
    return newcellBoard

end

-- This section will run the matrix simulation for a fixed amount of iterations. By default i have set it to 4. You can simply change this number and it will make more iterations when run.
local fixedIterations = 4 -- amount of iterations to be simulated.
for row = 1, fixedIterations do
    cellBoard = cellNextState(cellBoard) -- calls the cellNextState function to update the original matrix with the new cells.

    print("\nIteration: " .. row .. "")

    for row = 1, 5 do
        local rowSeperator = ""

        for column = 1, 5 do

            if cellBoard[row][column] == 1 then
                rowSeperator = rowSeperator .. "# " -- this changes the alive cells' display from 1 to a # which was my own personal preferance. Simply changing this icon will change what an alive cell looks like in the simulation.

            else
                rowSeperator = rowSeperator .. cellBoard[row][column] .. " "
            end
        
        end
        print(rowSeperator) -- prints the matrix to the terminal
    end
end