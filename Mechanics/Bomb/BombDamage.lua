--#region Dependencies

local RoomUtils = require("Game.Room.Utils")

--#endregion

---@class BombDamageLogic
local Module = {}

---@param room RoomComponent
---@param position Vector
---@param radius number
---@return Set<integer>
local function get_grid_indexes(room, position, radius)
    local gridIndexesSet = {}
    local angleSamples = math.ceil(radius * 8.0 / 40.0)
    local angleStep = 6.2831855 / angleSamples

    local currentAngle = 0.0

    local gridPosition = RoomUtils.GetGridIdx(room, position)
    if gridPosition >= 0 then
        gridIndexesSet[gridPosition] = true
    end

    if radius <= 0.0 then
        return gridIndexesSet
    end

    local gridWidth = room.m_gridWidth
    local gridHeight = room.m_gridHeight

    for i = 1, angleSamples, 1 do
        local currentDirection = Vector(math.cos(currentAngle), math.sin(currentAngle))

        -- Ray march on the current direction
        local currentRadius = 0.0
        repeat
            currentRadius = math.min(currentRadius + 20.0, radius) -- step forward by 20.0 until we reach radius
            local currentSample = position + currentDirection * currentRadius
            local gridTile = RoomUtils.ToGridTile(currentSample)

            if not ((0 <= gridTile.X and gridTile.X < gridWidth) and (0 <= gridTile.Y and gridTile.Y < gridHeight)) then
                goto continue
            end

            local sampleGridIdx = RoomUtils.GetGridIdx(room, currentSample)
            local gridEntity = RoomUtils.GetGridEntity(room, sampleGridIdx)

            if not gridEntity then
                goto continue
            end

            gridIndexesSet[gridEntity.m_gridIdx] = true
            if gridEntity.m_desc.m_type == GridEntityType.GRID_ROCKB then
                break
            end

            ::continue::
        until currentRadius >= radius

        currentAngle = currentAngle + angleStep
    end

    return gridIndexesSet
end

---@param game GameComponent
---@param position Vector
---@param damage number
---@param radius number
---@param linCheck boolean
---@param source EntityComponent?
---@param tearFlags TearFlags | BitSet128
---@param damageFlags DamageFlag | integer
---@param damageSource boolean
local function BombDamage(game, position, damage, radius, linCheck, source, tearFlags, damageFlags, damageSource)
    local room = game.m_level.m_room
    local gridIndexesSet = get_grid_indexes(room, position, radius)

    for gridIdx, _ in pairs(gridIndexesSet) do
        -- TODO: Get Grid Index
    end
end

--#region Module

Module.BombDamage = BombDamage

--#endregion

return Module