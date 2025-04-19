---@class Decomp.Class.Room
local Class_Room = {}
Decomp.Class.Room = Class_Room

require("Room.SubSystem.Spawn")

local g_Game = Game()
local g_Level = g_Game:GetLevel()
local RoomSubSystem = Decomp.Room.SubSystem

---@return boolean
local function return_true()
    return true
end

---@return boolean
local function return_false()
    return false
end

---@return boolean
local function IsBeastDungeon()
    local roomData = g_Level:GetCurrentRoomDesc().Data
    if not roomData then
        return false
    end

    return roomData.Type == RoomType.ROOM_DUNGEON and roomData.StageID == StbType.HOME
end

--#region SaveState

---@param variant integer
---@return boolean
local function is_poky_persistent(variant)
    return variant ~= 0
end

local s_PersistentRoomEntity = {
    [EntityType.ENTITY_STONEHEAD] = return_true,
    [EntityType.ENTITY_GAPING_MAW] = return_true,
    [EntityType.ENTITY_BROKEN_GAPING_MAW] = return_true,
    [EntityType.ENTITY_CONSTANT_STONE_SHOOTER] = return_true,
    [EntityType.ENTITY_BRIMSTONE_HEAD] = return_true,
    [EntityType.ENTITY_POKY] = is_poky_persistent,
    [EntityType.ENTITY_WALL_HUGGER] = return_true,
    [EntityType.ENTITY_QUAKE_GRIMACE] = return_true,
    [EntityType.ENTITY_BOMB_GRIMACE] = return_true,
    [EntityType.ENTITY_GRUDGE] = return_true,
    [EntityType.ENTITY_BALL_AND_CHAIN] = return_true,
    [EntityType.ENTITY_SPIKEBALL] = return_true,
    [EntityType.ENTITY_MINECART] = return_true,
    default = return_false,
}

---@param type EntityType | integer
---@param variant integer
---@return boolean
function IsPersistentRoomEntity(type, variant)
    local PersistentRoomEntity = s_PersistentRoomEntity[type] or s_PersistentRoomEntity.default
    return PersistentRoomEntity(variant)
end

---@param type EntityType | integer
---@param variant integer
---@param subType integer
---@param spawnerType EntityType | integer
---@param roomCleared boolean
---@return boolean
function ShouldSaveEntity(type, variant, subType, spawnerType, roomCleared)
    -- TODO
end

--#endregion

--#region Module

---@param room Room
---@return boolean
function Class_Room.IsBeastDungeon(room)
    return IsBeastDungeon()
end

---@param room Room
---@param spawnEntry RoomConfig_Entry
---@param gridIdx integer
---@param seed integer
---@return Decomp.Room.SubSystem.Spawn.SpawnEntry fixedSpawnEntry
function Class_Room.FixSpawnEntry(room, spawnEntry, gridIdx, seed)
    return RoomSubSystem.Spawn.FixSpawnEntry(room, spawnEntry, gridIdx, seed)
end

---@param room Room
---@param gridIdx integer
---@param spawnEntry RoomConfig_Entry
---@param seed integer
---@param spawnedEntity Entity[]? -- Used as a return container
---@param respawning boolean
function Class_Room.spawn_entity(room, gridIdx, spawnEntry, seed, spawnedEntity, respawning)
    local entity = RoomSubSystem.Spawn.SpawnEntity(room, gridIdx, spawnEntry, seed, respawning)
    if spawnedEntity then
        spawnedEntity[1] = entity
    end
end

---@param type EntityType | integer
---@param variant integer
---@return boolean
function Class_Room.is_persistent_room_entity(type, variant)
    return IsPersistentRoomEntity(type, variant)
end

---@param type EntityType | integer
---@param variant integer
---@param subType integer
---@param spawnerType EntityType | integer
---@param roomCleared boolean
---@return boolean
function Class_Room.ShouldSaveEntity(type, variant, subType, spawnerType, roomCleared)
    return ShouldSaveEntity(type, variant, subType, spawnerType, roomCleared)
end

--#endregion