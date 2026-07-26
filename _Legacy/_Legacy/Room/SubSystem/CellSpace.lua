---@class Decomp.Class.CellSpace
local CellSpace = {}
Decomp.Class.CellSpace = CellSpace

require("Entity.Entity")

local Class = Decomp.Class

---@class Decomp.Class.CellSpace.Data
---@field m_ParentList Decomp.Class.EntityList.Data
---@field m_GridWidth integer
---@field m_CellSize number
---@field m_Cells Decomp.Class.CellSpace.Cell[]

---@class Decomp.Class.CellSpace.Cell
---@field m_Entities Entity[] -- A Entity*[40] in-game
---@field m_EntityCount integer

---@param cellSpace Decomp.Class.CellSpace.Data
---@param row integer
---@param column integer
local function get_cell_idx(cellSpace, row, column)
    return (cellSpace.m_GridWidth * row + column) + 1
end

--#region Insert

---@param size Vector
---@param rotation number
---@return Vector
local function get_axis_aligned_bounding_box(size, rotation)
    local direction = Vector.FromAngle(rotation)
    local x = math.abs(direction.X * size.X) + math.abs(direction.Y * size.Y)
    local y = math.abs(direction.X * size.Y) + math.abs(direction.Y * size.X)
    return Vector(x, y)
end

---@param cellSpace Decomp.Class.CellSpace.Data
---@param row integer
---@param column integer
---@param entity Entity
local function insert_entity(cellSpace, row, column, entity)
    local cellIdx = get_cell_idx(cellSpace, row, column)
    if not (1 <= cellIdx and cellIdx <= #cellSpace) then
        return
    end

    local cell = cellSpace.m_Cells[cellIdx]
    if cell.m_EntityCount >= 40 then
        return
    end

    cell.m_Entities[cell.m_EntityCount + 1] = entity
    cell.m_EntityCount = cell.m_EntityCount + 1
end

---@param cellSpace Decomp.Class.CellSpace.Data
---@param entity Entity
local function Insert(cellSpace, entity)
    local sizeMulti = entity.SizeMulti
    local size = entity.Size * sizeMulti
    local rotation = entity.SpriteRotation

    if (sizeMulti.X ~= 1.0 or sizeMulti.Y ~= 1.0) and (rotation ~= 0.0) then
        size = get_axis_aligned_bounding_box(size, rotation)
    end

    local position = entity.Position
    if (position.X + size.X <= position.X - size.X) or -- Right box edge is to the left of the Left box edge
       (position.Y + size.Y <= position.Y - size.Y) then -- Bottom box edge is above the Top box edge
        Isaac.DebugString(string.format("[ASSERT] Entity Teleport Detected! Type: %d, Variant: %d, Subtype: %d; Pos: %f, %f; Size: %f, %f", entity.Type, entity.Variant, entity.SubType, position.X, position.Y, size.X, size.Y))
    end

    local cellSize = cellSpace.m_CellSize

    local minRowIndex = math.floor((position.Y - size.Y) / cellSize)
    local maxRowIndex = math.floor((position.Y + size.Y) / cellSize)
    if (maxRowIndex < minRowIndex) or (minRowIndex + 1 <= minRowIndex) or (maxRowIndex + 1 <= maxRowIndex) then
        Isaac.DebugString("[ASSERT] CellSpace::insert: y1 > y2")
    end

    local minColumnIndex = math.floor((position.X - size.X) / cellSize)
    local maxColumnIndex = math.floor((position.X + size.X) / cellSize)
    if (maxColumnIndex < minColumnIndex) or (minColumnIndex + 1 <= minColumnIndex) or (maxColumnIndex + 1 <= maxColumnIndex) then
        Isaac.DebugString("[ASSERT] CellSpace::insert: x1 > x2")
    end

    for row = minRowIndex, maxRowIndex, 1 do
        for column = minColumnIndex, maxColumnIndex, 1 do
            insert_entity(cellSpace, row, column, entity)
        end
    end
end

--#endregion

--#region Collide

local cellspace_collcount = 0 -- It's increased every time a collision occurs, but it's never used

---@param entity Entity
---@param other Entity
---@param collisionMap boolean[]
---@param collisionMapWidth integer
local function try_collide_entities(entity, other, collisionMap, collisionMapWidth)
    if GetPtrHash(entity) == GetPtrHash(other) then
        return
    end

    local entityData = Class.Entity.GetData(entity)
    local otherData = Class.Entity.GetData(other)

    local mapRow = math.max(entityData.m_CollisionIndex, otherData.m_CollisionIndex)
    local mapColumn = math.min(entityData.m_CollisionIndex, otherData.m_CollisionIndex)
    local mapIndex = mapRow * collisionMapWidth + mapColumn + 1

    if mapIndex > #collisionMap then
        return
    end

    if collisionMap[mapIndex] == true then
        return
    end

    collisionMap[mapIndex] = true
    Class.Entity.Collide(entity, other)
    cellspace_collcount = cellspace_collcount + 1
end

---@param cellSpace Decomp.Class.CellSpace.Data
---@param other Decomp.Class.CellSpace.Data
local function Collide(cellSpace, other)
    if #cellSpace.m_Cells ~= #other.m_Cells then
        Isaac.DebugString("[ASSERT] CellSpace::collide - cell counts don't match!")
    end

    local entityList = cellSpace.m_ParentList
    local cells = cellSpace.m_Cells
    local cellsOther = cellSpace.m_Cells

    for cellIdx = 1, #cells, 1 do
        local cell = cells[cellIdx]
        local cellOther = cellsOther[cellIdx]
        for i = 1, cell.m_EntityCount, 1 do
            for j = 1, cellOther.m_EntityCount, 1 do
                try_collide_entities(cell.m_Entities[i], cellOther.m_Entities[j], entityList.m_CollisionMap, entityList.m_CollisionMapWidth)
            end
        end
    end
end

---@param cellSpace Decomp.Class.CellSpace.Data
---@param row integer
---@param column integer
---@param entity Entity
local function collide_entity_with_cell(cellSpace, row, column, entity)
    local cellIdx = get_cell_idx(cellSpace, row, column)
    if not (1 <= cellIdx and cellIdx <= #cellSpace) then
        return
    end

    local entityList = cellSpace.m_ParentList
    local cell = cellSpace.m_Cells[cellIdx]

    for i = 1, cell.m_EntityCount, 1 do
        try_collide_entities(cell.m_Entities[i], entity, entityList.m_CollisionMap, entityList.m_CollisionMapWidth)
    end
end

---@param cellSpace Decomp.Class.CellSpace.Data
---@param entity Entity
local function CollideWithEntity(cellSpace, entity)
    if entity.EntityCollisionClass == EntityCollisionClass.ENTCOLL_NONE then
        return
    end

    local position = entity.Position
    local size = entity.Size * entity.SizeMulti
    local cellSize = cellSpace.m_CellSize

    local minRowIndex = math.floor((position.Y - size.Y) / cellSize)
    local maxRowIndex = math.floor((position.Y + size.Y) / cellSize)
    local minColumnIndex = math.floor((position.X - size.X) / cellSize)
    local maxColumnIndex = math.floor((position.X + size.X) / cellSize)

    for row = minRowIndex, maxRowIndex, 1 do
        for column = minColumnIndex, maxColumnIndex, 1 do
            collide_entity_with_cell(cellSpace, row, column, entity)
        end
    end
end

--#endregion

--#region Module

---@param cellSpace Decomp.Class.CellSpace.Data
---@param entity Entity
function CellSpace.insert(cellSpace, entity)
    Insert(cellSpace, entity)
end

---@param cellSpace Decomp.Class.CellSpace.Data
---@param other Decomp.Class.CellSpace.Data
function CellSpace.collide(cellSpace, other)
    Collide(cellSpace, other)
end

---@param cellSpace Decomp.Class.CellSpace.Data
function CellSpace.collide_self(cellSpace)
    Collide(cellSpace, cellSpace)
end

---@param cellSpace Decomp.Class.CellSpace.Data
---@param entity Entity
function CellSpace.collide_entity(cellSpace, entity)
    CollideWithEntity(cellSpace, entity)
end

--#endregion