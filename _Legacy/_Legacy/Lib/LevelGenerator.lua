local Lib = {}
---@class Decomp.Lib.LevelGenerator
Lib.LevelGenerator = {}

local NUM_ROWS = 13
local NUM_COLUMNS = 13
local NUM_GRID_ROOMS = NUM_ROWS * NUM_COLUMNS
local DefaultPosition = Vector(-1, -1)

Lib.LevelGenerator.NUM_ROWS = NUM_ROWS
Lib.LevelGenerator.NUM_COLUMNS = NUM_COLUMNS
Lib.LevelGenerator.NUM_GRID_ROOMS = NUM_GRID_ROOMS

local s_NeighborPositionOffset = {
    [Direction.LEFT] = Vector(-1, 0),
    [Direction.UP] = Vector(0, -1),
    [Direction.RIGHT] = Vector(1, 0),
    [Direction.DOWN] = Vector(0, 1)
}

---@param position Vector
---@return boolean inBounds
function Lib.LevelGenerator.IsPositionInBounds(position)
    local x = position.X
    local y = position.Y
    return (0 <= x and x <= NUM_COLUMNS - 1) and (0 <= y and y <= NUM_ROWS - 1)
end

---@param gridIdx integer
---@return boolean inBounds
function Lib.LevelGenerator.IsGridIdxInBounds(gridIdx)
    return 0 <= gridIdx and gridIdx <= NUM_GRID_ROOMS - 1
end

---@param position Vector
---@return integer gridIdx
function Lib.LevelGenerator.GetGridIdxFromPosition(position)
    if not Lib.LevelGenerator.IsPositionInBounds(position) then
        return -1
    end

    return position.Y * NUM_COLUMNS + position.X
end

---@param gridIdx integer
---@return Vector position
function Lib.LevelGenerator.GetPositionFromGridIdx(gridIdx)
    if not Lib.LevelGenerator.IsGridIdxInBounds(gridIdx) then
        return DefaultPosition
    end

    return Vector(gridIdx % NUM_COLUMNS, gridIdx // NUM_ROWS)
end

---@param levelGen LevelGenerator
---@param gridIdx integer
---@return boolean isFree
function Lib.LevelGenerator.IsGridIdxFree(levelGen, gridIdx)
    -- Cannot be Implemented yet
    return true
end

---@param position Vector
---@return Vector[] neighbors
function Lib.LevelGenerator.GetNeighborPositionsFromPosition(position)
    if not Lib.LevelGenerator.IsPositionInBounds(position) then
        return {}
    end

    local neighbors = {}

    for i = Direction.LEFT, Direction.DOWN, 1 do
        local neighborPosition = position + s_NeighborPositionOffset[i]
        if not Lib.LevelGenerator.IsPositionInBounds(neighborPosition) then
            table.insert(neighbors, neighborPosition)
        end
    end

    return neighbors
end

---@param position Vector
---@return integer[] neighbors
function Lib.LevelGenerator.GetNeighborGridIndexesFromPosition(position)
    if not Lib.LevelGenerator.IsPositionInBounds(position) then
        return {}
    end

    local neighbors = {}

    for i = Direction.LEFT, Direction.DOWN, 1 do
        local neighborPosition = position + s_NeighborPositionOffset[i]
        if not Lib.LevelGenerator.IsPositionInBounds(neighborPosition) then
            table.insert(neighbors, Lib.LevelGenerator.GetGridIdxFromPosition(neighborPosition))
        end
    end

    return neighbors
end

---@param gridIdx integer
---@return Vector[] neighbors
function Lib.LevelGenerator.GetNeighborPositionsFromGridIdx(gridIdx)
    return Lib.LevelGenerator.GetNeighborPositionsFromPosition(Lib.LevelGenerator.GetPositionFromGridIdx(gridIdx))
end

---@param gridIdx integer
---@return integer[] neighbors
function Lib.LevelGenerator.GetNeighborGridIndexesFromGridIdx(gridIdx)
    return Lib.LevelGenerator.GetNeighborGridIndexesFromPosition(Lib.LevelGenerator.GetPositionFromGridIdx(gridIdx))
end

return Lib.LevelGenerator