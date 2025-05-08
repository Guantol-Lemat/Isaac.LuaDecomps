---@class Decomp.Level.SubSystem.Room
local CurrentRoom = {}

---@class Decomp.Level.SubSystem.Room.Data
---@field _ENV Decomp.EnvironmentObject
---@field _API Decomp.IGlobalAPI
---@field m_Room Decomp.RoomObject
---@field m_RoomIdx GridRooms | integer
---@field m_Dimension Dimension
---@field m_EnterDoor DoorSlot

local Lib = {
    Table = require("Lib.Table")
}

---@param api Decomp.IGlobalAPI
---@param game Decomp.GameObject
---@param roomDesc Decomp.RoomDescObject
---@return boolean
local function should_force_more_options(api, game, roomDesc)
    if not (api.RoomDescriptor.GetRoomData(roomDesc).Type == RoomType.ROOM_TREASURE and api.RoomDescriptor.GetVisitedCount(roomDesc) == 0) then
        return false
    end

    local playerManager = api.Game.GetPlayerManager(game)
    if api.PlayerManager.AnyoneHasCollectible(playerManager, CollectibleType.COLLECTIBLE_MORE_OPTIONS) then
        return true
    end

    local roomTransition = api.Game.GetRoomTransition(game)
    if api.RoomTransition.IsActive(roomTransition) and api.RoomTransition.HasFlags(roomTransition, 1) then
        return true
    end

    local level = api.Game.GetLevel(game)
    if api.PlayerManager.AnyoneHasTrinket(playerManager, TrinketType.TRINKET_BROKEN_GLASSES) and api.Level.IsAltPath(level) then
        local seed = api.RoomDescriptor.GetSpawnSeed(roomDesc)
        local rng = RNG(); rng:SetSeed(seed, 61)

        if rng:RandomInt(2) < api.PlayerManager.GetTrinketMultiplier(playerManager, TrinketType.TRINKET_BROKEN_GLASSES) then
            return true
        end
    end

    return false
end

local s_OffGridRoomsWithEnterDoor = Lib.Table.CreateDictionary({
    GridRooms.ROOM_DEVIL_IDX, GridRooms.ROOM_BLACK_MARKET_IDX, GridRooms.ROOM_DEBUG_IDX,
    GridRooms.ROOM_BOSSRUSH_IDX, GridRooms.ROOM_BOSSRUSH_IDX, GridRooms.ROOM_BLUE_WOOM_IDX,
    GridRooms.ROOM_THE_VOID_IDX, GridRooms.ROOM_SECRET_EXIT_IDX, GridRooms.ROOM_EXTRA_BOSS_IDX,
    GridRooms.ROOM_ANGEL_SHOP_IDX
})

---@param currentRoom Decomp.Level.SubSystem.Room.Data
---@param level Decomp.LevelObject
local function LoadRoom(currentRoom, level)
    local api = currentRoom._API
    local game = api.Environment.GetGame(currentRoom._ENV)
    local playerManager = api.Game.GetPlayerManager(game)

    local roomDesc = api.Level.GetRoomByIdx(level, currentRoom.m_RoomIdx, Dimension.CURRENT)
    local roomData = api.RoomDescriptor.GetRoomData(roomDesc)

    if api.PlayerManager.AnyoneHasTrinket(playerManager, TrinketType.TRINKET_RIB_OF_GREED) and roomData.Type ~= RoomType.ROOM_DEVIL then
        api.RoomDescriptor.ClearFlags(roomDesc, RoomDescriptor.FLAG_SURPRISE_MINIBOSS)
    end

    local roomTransition = api.Game.GetRoomTransition(game)
    if api.RoomTransition.IsActive(roomTransition) and api.RoomTransition.HasFlags(roomTransition, 1 << 1) and roomData.Type == RoomType.ROOM_SHOP then
        api.RoomDescriptor.ClearFlags(roomDesc, RoomDescriptor.FLAG_SURPRISE_MINIBOSS)
    end

    if should_force_more_options(api, game, roomDesc) then
        local moreOptionsRoom = get_more_options_room()
        api.RoomDescriptor.SetRoomData(roomDesc, moreOptionsRoom)
    end

    roomData = api.RoomDescriptor.GetEffectiveRoomData(roomDesc)
    choose_enter_door()

    local room = currentRoom.m_Room
    api.Room.Init(room, roomData, roomDesc)

    if api.Room.GetRoomType(room) == RoomType.ROOM_ULTRASECRET then
        guarantee_ultra_secret_exit()
    end

    if not api.Game.IsGreedMode(game) and not api.Level.IsBackwardsPath(level) and api.Level.IsAltPath(level) then
        unk_mineshaft_entrance_related()
    end

    if s_OffGridRoomsWithEnterDoor[currentRoom.m_RoomIdx] then
        init_offgrid_enter_door()
    else
        init_doors_states()
    end

    roomDesc = api.Level.GetRoomByIdx(level, currentRoom.m_RoomIdx, Dimension.CURRENT)
    if api.RoomDescriptor.HasFlags(roomDesc, RoomDescriptor.FLAG_CLEAR) then
        if not api.Game.IsGreedMode(game) then
            api.Room.TrySpawnSecretExit(room, false, false)
            api.Room.TrySpawnDevilRoomDoor(room, false, false)
            api.Room.TrySpawnBossRushDoor(room, false, false)
            api.Room.TrySpawnTheVoidDoor(room, false)
        end
        api.Room.TrySpawnBlueWombDoor(room, false, false, false)
    end

    unk_try_remove_doors()

    api.Room.TrySpawnSecretShop(room, false)

    try_apply_alternate_backdrop()

    roomDesc = api.Room.GetRoomDescriptor(room)
    if currentRoom.m_RoomIdx == GridRooms.ROOM_GENESIS_IDX and api.RoomDescriptor.GetVisitedCount(roomDesc) == 1 then
        trigger_genesis()
    end

    local deathmatchManager = api.Game.GetDeathmatchManager(game)
    if not api.DeathmatchManager.IsInDeathmatch(deathmatchManager) then
        api.PlayerManager.TriggerNewRoom(playerManager)
    end

    fx_layers_update(true)
    api.Room.UpdateRedKey(room)

    local entities = api.Room.GetRoomEntities(room)
    for index, value in api.CppContainer.iterator(entities) do
        ---@cast value Decomp.EntityObject
        value:Update()
    end

    api.Environment.RunCallback(currentRoom._ENV, ModCallbacks.MC_POST_NEW_ROOM)
end