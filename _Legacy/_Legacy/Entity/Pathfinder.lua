---@class Decomp.Class.Pathfinder
local Class_Pathfinder = {}
Decomp.Class.Pathfinder = Class_Pathfinder

---@class Decomp.Class.Pathfinder.API
local PathfinderAPI = {}

---@class Decomp.Class.Pathfinder.Data
---@field m_Entity EntityPtr
---@field m_HasDirectPath boolean
---@field m_CanCrushRocks boolean
---@field m_PositionBackup Vector

local g_Game = Game()

function PathfinderAPI.MoveRandomly()
end

function PathfinderAPI.EvadeTarget()
end

local function move_confused()
end

---@param pathFinder Decomp.Class.Pathfinder.Data
---@param position Vector
---@param speed number
---@param pathMarker integer
---@param useDirectPath boolean
local function find_grid_path(pathFinder, position, speed, pathMarker, useDirectPath)
    local entity = pathFinder.m_Entity.Ref
    if not entity then
        return
    end

    if entity:HasEntityFlags(EntityFlag.FLAG_CONFUSION) and not entity:HasEntityFlags(EntityFlag.FLAG_CHARM) then
        move_confused()
    end

    local entitySize = entity.Size * entity.SizeMulti * 2
    local bigBoi = entitySize.X > 40.0 or entitySize.Y > 40.0
    local otherBool = entity:GetType() == EntityType.ENTITY_FAMILIAR and pathMarker <= 0

    local vector = Vector(math.fmod(entitySize.X, 80.0), math.fmod(entitySize.Y, 80.0))
    local otherVector = Vector(0, 0)

    if vector.X > 40.0 then
        otherVector.X = otherVector.X + 19.960001
    end
    if vector.Y > 40.0 then
        otherVector.Y = otherVector.Y + 19.960001
    end

    local yetOtherVector = entity.Position - otherVector

    local room = g_Game:GetRoom()
    local positionGridIdx = room:GetGridIndex(position)
    local gridEntity = room:GetGridEntity(positionGridIdx)

    -- Here you either do m_BackupPosition = position or GetGridIndex(m_BackupPosition)
    if not pathFinder.m_CanCrushRocks then
        -- look at the comment
    end

    local yetOtherIndex = room:GetGridIndex(yetOtherVector)
end

function PathfinderAPI.FindGridPath()
end