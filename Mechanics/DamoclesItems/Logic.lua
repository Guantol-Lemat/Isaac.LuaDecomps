--#region Dependencies

local RoomUtils = require("Room.Utils")
local EntityUtils = require("Entity.Utils")
local VectorUtils = require("General.Math.VectorUtils")
local ItemConfigUtils = require("Config.ItemConfig.Utils")
local PickupInitLogic = require("Entity.Pickup.Init")
local PickupUtils = require("Entity.Pickup.Utils")
local SpawnLogic = require("Game.Spawn")

local VectorZero = VectorUtils.VectorZero

--#endregion

---@class DamoclesItemsLogic
local Module = {}

local DAMOCLES_OFFSETS = {
    {Vector(-1, 0), Vector(1, 0)},
    {Vector(0, -1), Vector(0, 1)},
    {Vector(-1, -1), Vector(1, 1)},
    {Vector(-1, 1), Vector(1, -1)},
    {Vector(-1, 1), Vector(1, -1)},
    {Vector(1, 1), Vector(-1, -1)},
    {Vector(-1, 0), Vector(0, 0)},
    {Vector(0, 0), Vector(1, 0)},
    {Vector(0, -1), Vector(0, 0)},
    {Vector(0, 0), Vector(0, 1)},
}

---@param room RoomComponent
local function Invalidate(room)
    room.m_damoclesItems_Invalidate = true
end

---@param room RoomComponent
---@param damoclesItems EntityPickupComponent[]
---@param gridMap integer[]
---@param offsets Pair<Vector, Vector>
---@return boolean
local function check_spawn_offsets(room, damoclesItems, gridMap, offsets)
    local spawnPositions = {}
    for i = 1, 448, 1 do
        spawnPositions[i] = gridMap[i]
    end

    for i = 1, #damoclesItems, 1 do
        local pickup = damoclesItems[i]
        local position = pickup.m_position
        local gridIdx = RoomUtils.GetGridIdx(room, position)
        local gridPosition = RoomUtils.GetGridPosition(room , gridIdx)
        local gridTile
        local newPositionTile
        local newGridIdx
        local spawnTile
        local spawnGridIdx

        if not VectorUtils.Equals(position, gridPosition) then
            goto continue
        end

        gridTile = RoomUtils.GetGridTile(room, gridIdx)
        newPositionTile = gridTile + offsets[1]
        newGridIdx = RoomUtils.GetGridIndexByTile(room, newPositionTile)

        spawnTile = gridTile + offsets[2]
        spawnGridIdx = RoomUtils.GetGridIndexByTile(room, spawnTile)

        if newGridIdx < 0 or spawnGridIdx < 0 or spawnPositions[newGridIdx] ~= 0 or spawnPositions[spawnGridIdx] ~= 0 then
            return false
        end

        spawnPositions[newGridIdx] = 1
        spawnPositions[spawnGridIdx] = 1
        spawnPositions[gridIdx] = 0
        ::continue::
    end

    return true
end

---@param myContext DamoclesItemsContext.Update
---@param room RoomComponent
local function Update(myContext, room)
    if not room.m_damoclesItems_Invalidate then
        return
    end

    local itemConfig = myContext.itemConfig

    PickupInitLogic.StartIgnoreModifiers()
    ---@type EntityPickupComponent[]
    local damoclesItems = {}

    ---@type integer[]
    local gridMap = {}
    local gridSize = room.m_gridHeight * room.m_gridWidth
    for i = 1, gridSize, 1 do
        local gridCollision = RoomUtils.GetGridCollision(room, i)
        local mapValue = gridCollision == GridCollisionClass.COLLISION_NONE and 0 or -1
        table.insert(gridMap, mapValue)
    end

    local entityList = room.m_entityList
    local roomEL = entityList.m_updateEL
    local roomList = roomEL.data

    for i = 1, roomEL.size, 1 do
        local entity = roomList[i]
        local pickup
        local gridIdx

        if not entity or entity.m_type ~= EntityType.ENTITY_PICKUP or entity.m_variant ~= PickupVariant.PICKUP_COLLECTIBLE then
            goto continue
        end

        pickup = EntityUtils.ToPickup(entity)
        assert(pickup, "ENTITY_PICKUP is not a pickup.")

        gridIdx = RoomUtils.GetGridIdx(room, pickup.m_position)
        if gridIdx ~= -1 then
            gridMap[gridIdx + 1] = 1
        end

        if pickup.m_isDead then
            goto continue
        end

        if pickup.m_price ~= 0 then
            goto continue
        end

        if not EntityUtils.HasAnyFlag(entity, EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE) then
            goto continue
        end

        if ItemConfigUtils.IsTaggedCollectible(itemConfig, pickup.m_subtype, ItemConfig.TAG_QUEST) then
            goto continue
        end

        EntityUtils.ClearFlags(pickup, EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)
        table.insert(damoclesItems, pickup)
        ::continue::
    end

    local try = 1
    local success
    repeat
        local offsets = DAMOCLES_OFFSETS[try]
        success = check_spawn_offsets(room, damoclesItems, gridMap, offsets)
        try = try + 1
    until success or try > 10

    local offsetIndex = success and try or 0
    ---@type table<integer, integer>
    local optionsIndexMap = {}

    for i = 1, #damoclesItems, 1 do
        local pickup = damoclesItems[i]
        local rng = RNG(pickup.m_initSeed, 21)

        rng:Next()
        rng:Next()

        local position = pickup.m_position
        local gridIdx = RoomUtils.GetGridIdx(room, pickup.m_position)
        local gridPosition = RoomUtils.GetGridPosition(room, gridIdx)
        local newPickupPosition
        local duplicateSpawnPosition

        if offsetIndex >= 1 and VectorUtils.Equals(position, gridPosition) then
            local offsets = DAMOCLES_OFFSETS[offsetIndex]
            newPickupPosition = VectorUtils.Copy(offsets[1])
            duplicateSpawnPosition = VectorUtils.Copy(offsets[2])
        else
            newPickupPosition = RoomUtils.FindFreePickupSpawnPosition(room, position, 60.0, false, false)
            local newPickupIdx = RoomUtils.GetGridIdx(room, newPickupPosition)

            if -1 < newPickupIdx < 448 then
                local pathValue = RoomUtils.GetGridPath(room, newPickupIdx)
                local pathMarker = pathValue % 1000
                if pathMarker < 900 then
                    RoomUtils.SetGridPath(room, newPickupIdx, (pathValue - pathMarker) + 900)
                end
            end

            duplicateSpawnPosition = RoomUtils.FindFreePickupSpawnPosition(room, position, 60.0, true, false)
        end

        if room.m_type == RoomType.ROOM_DUNGEON then
            newPickupPosition.Y = newPickupPosition.Y + 30.0
            duplicateSpawnPosition.Y = duplicateSpawnPosition.Y + 30.0
        end

        local ent = SpawnLogic.Spawn(myContext, pickup.m_type, pickup.m_variant, 0, rng:Next(), duplicateSpawnPosition, VectorZero, nil)
        local duplicateItem = EntityUtils.ToPickup(ent)
        assert(duplicateItem, "ENTITY_PICKUP is not a pickup.")

        local pedestalType = PickupUtils.GetAlternatePedestal(pickup)
        PickupUtils.SetAlternatePedestal(duplicateItem, pedestalType)

        if 0 <= gridIdx then
            gridMap[gridIdx + 1] = 0
        end

        local duplicateSpawnIdx = RoomUtils.GetGridIdx(room, duplicateSpawnPosition)
        local newPickupGridIdx = RoomUtils.GetGridIdx(room, newPickupPosition)

        if 0 <= duplicateSpawnIdx then
            gridMap[duplicateSpawnIdx + 1] = 1
        end

        if 0 <= newPickupGridIdx then
            gridMap[newPickupGridIdx + 1] = 1
        end

        pickup.m_position = VectorUtils.Copy(newPickupPosition)
        pickup.m_targetPosition = VectorUtils.Copy(newPickupPosition)

        local optionsPickupIndex = pickup.m_optionsPickupIndex
        if optionsPickupIndex > 0 then
            local mappedOptionsPickupIndex = optionsIndexMap[optionsPickupIndex]

            if not mappedOptionsPickupIndex then
                local newOptionsIndex = PickupUtils.SetNewOptionsPickupIndex(duplicateItem)
                optionsIndexMap[optionsPickupIndex] = newOptionsIndex
            else
                duplicateItem.m_optionsPickupIndex = mappedOptionsPickupIndex
            end
        end
    end

    PickupInitLogic.EndIgnoreModifiers()
    room.m_damoclesItems_Invalidate = false
end

--#region Module

Module.Invalidate = Invalidate
Module.Update = Update

--#endregion

return Module