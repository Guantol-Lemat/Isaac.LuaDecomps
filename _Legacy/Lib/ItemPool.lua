---@class Decomp.Lib.ItemPool
local Lib_ItemPool = {}

local s_GreedItemPool = {
    [ItemPoolType.POOL_TREASURE] = ItemPoolType.POOL_GREED_TREASURE,
    [ItemPoolType.POOL_SHOP] = ItemPoolType.POOL_GREED_SHOP,
    [ItemPoolType.POOL_BOSS] = ItemPoolType.POOL_GREED_BOSS,
    [ItemPoolType.POOL_DEVIL] = ItemPoolType.POOL_GREED_DEVIL,
    [ItemPoolType.POOL_ANGEL] = ItemPoolType.POOL_GREED_ANGEL,
    [ItemPoolType.POOL_SECRET] = ItemPoolType.POOL_GREED_SECRET,
    [ItemPoolType.POOL_CURSE] = ItemPoolType.POOL_GREED_CURSE,
}

---@param poolType ItemPoolType | integer
---@return ItemPoolType | integer
local function GetGreedModePool(poolType)
    return s_GreedItemPool[poolType] or poolType
end

---@param spawn RoomConfig_Spawn
---@return RoomConfig_Entry?
local function get_highest_weight_entry(spawn)
    local bestWeight = 0.0
    local highestEntry = nil

    local entries = spawn.Entries
    for i = 0, spawn.EntryCount - 1, 1 do
        ---@type RoomConfig_Entry
---@diagnostic disable-next-line: assign-type-mismatch
        local entry = entries:Get(i)
        if entry.Weight >= bestWeight then
            bestWeight = entry.Weight
            highestEntry = entry
        end
    end

    return highestEntry
end

---@param spawn RoomConfig_Spawn
---@return BossType | integer
local function get_spawn_boss_id(spawn)
    local entry = get_highest_weight_entry(spawn)
    if not entry then
        return 0
    end

    return g_EntityConfig.GetEntity(entry.Type, entry.Variant, entry.Subtype):GetBossID()
end

---@param roomData RoomConfigRoom
local function get_room_boss_id(roomData)
    local spawns = roomData.Spawns
    for i = roomData.SpawnCount - 1, 0, -1 do
        local bossId = get_spawn_boss_id(spawns:Get(i))
        if bossId ~= 0 then
            return bossId
        end
    end

    return 0
end

local function get_gold_treasure_room_idx(level)
    return g_Game:IsGreedMode() and 85 or -1
end

---@param roomDesc RoomDescriptor
---@param boss BossType | integer
local function get_pool_room_type(roomDesc, boss)
    local roomData = roomDesc.Data
    local roomType = roomData.Type

    if roomType == RoomType.ROOM_BOSS and boss == 0 then
        boss = get_room_boss_id(roomData)
    end

    if boss == BossType.FALLEN then
        return RoomType.ROOM_DEVIL
    end

    if roomType == RoomType.ROOM_BOSS and g_Level:GetStateFlag(LevelStateFlag.STATE_SATANIC_BIBLE_USED) then
        return RoomType.ROOM_DEVIL
    end

    if roomType == RoomType.ROOM_TREASURE then
        if g_Game:IsGreedMode() and roomDesc.GridIndex ~= get_gold_treasure_room_idx(g_Level) then
            return RoomType.ROOM_BOSS
        end

        if roomDesc.Flags & RoomDescriptor.FLAG_DEVIL_TREASURE ~= 0 then
            return RoomType.ROOM_DEVIL
        end
    end

    if roomType == RoomType.ROOM_CHALLENGE and roomData.Subtype == 1 then
        return RoomType.ROOM_BOSS
    end

    return roomType
end

---@param seed integer
---@param roomDesc RoomDescriptor
---@param boss BossType | integer
---@return ItemPoolType | integer
local function GetPoolForRoom(seed, roomDesc, boss)
    local roomData = roomDesc.Data
    if roomData.Type == RoomType.ROOM_DEFAULT and roomData.StageID == StbType.HOME and roomData.Subtype == 2 then
        return ItemPoolType.POOL_MOMS_CHEST
    end

    local roomType = get_pool_room_type(roomDesc, boss)
    return g_ItemPool:GetPoolForRoom(roomType, seed)
end

---@param roomDescriptor RoomDescriptor
---@param seed integer
---@param advanceRNG boolean
---@return CollectibleType | integer
local function GetSeededCollectible(roomDescriptor, seed, advanceRNG)
    local poolType = GetPoolForRoom(seed, roomDescriptor, 0)
    if poolType == ItemPoolType.POOL_NULL then
        poolType = ItemPoolType.POOL_TREASURE
    end

    return g_ItemPool:GetCollectible(poolType, not advanceRNG, seed, CollectibleType.COLLECTIBLE_NULL)
end

--#region Module

Lib_ItemPool.GetGreedModePool = GetGreedModePool
Lib_ItemPool.GetPoolForRoom = GetPoolForRoom
Lib_ItemPool.GetSeededCollectible = GetSeededCollectible

--#endregion

return Lib_ItemPool