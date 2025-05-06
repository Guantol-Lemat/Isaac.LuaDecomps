---@class Decomp.Class.Room
local Class_Room = {}
Decomp.Class.Room = Class_Room

require("Room.SubSystem.Spawn")

---@class Decomp.Object.Room : Decomp.IRoomObject
---@field _API Decomp.IGlobalAPI
---@field _ENV Decomp.IEnvironment
---@field m_IsInitialized boolean
---@field m_RoomType RoomType
---@field m_RoomDescriptor Decomp.IRoomDescObject
---@field m_GridWidth integer
---@field m_GridHeight integer
---@field m_Backdrop Decomp.IBackdropObject
---@field m_WaterAmount integer
---@field m_BossId BossType | integer
---@field m_SecondBossId BossType | integer
---@field m_BrokenWatchState integer
---@field m_IsFirsVisit boolean
---@field m_IsDeathListInactive boolean
---@field m_HasTakenRedHeartDamage boolean
---@field m_HasTriggeredPressurePlate boolean
---@field m_RoomClearDelay integer

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

--#region Initialization

local function reset_data(room)
    -- TODO
end

local function Reset(room)
    -- TODO
end

---@param room Decomp.Object.Room
---@param roomData RoomConfigRoom
---@param roomDesc Decomp.IRoomDescObject
local function Init(room, roomData, roomDesc)
    local api = room._API
    local game = api.Manager.GetGame(room._ENV)

    reset_data(room)
    api.Manager.LogMessage(0, "Room %d.%d(%s)", roomData.Type, roomData.Variant, roomData.Name)
    local itemPool = api.Game.GetItemPool(game)
    api.ItemPool.ResetRoomBlacklist(itemPool)
    Reset(room)

    room.m_GridWidth = roomData.Width + 2
    room.m_GridHeight = roomData.Height + 2

    -- Init Sprite for LightGradient
    -- Init Sprite for Spotlight

    -- Init DoorGridIdx
    room.m_RoomDescriptor = roomDesc
    room.m_RoomType = api.RoomDescriptor.GetRoomData(roomDesc).Type

    -- Init RailManager
    -- Init HellBackdrop

    -- Init BossIds
    room.m_HasTriggeredPressurePlate = false
    -- Init Shop Data

    -- Notify Netplay Frame

    local spawnSeed = api.RoomDescriptor.GetSpawnSeed(room.m_RoomDescriptor)
    api.Manager.LogMessage(0, "SpawnRNG seed: %u", spawnSeed)
    -- Evaluate Spawn Flags

    -- LoadBackdropGraphics

    -- Set Water Amount

    if api.RoomDescriptor.GetVisitedCount(room.m_RoomDescriptor) == 0 then
        -- Trigger On First Visit
    end

    -- Reset GridPaths
    room.m_RoomClearDelay = 0
    -- Calc Pit and Poop Count

    -- Set water to 0 if pitcount > 0 and CORPSE backdrop

    -- Tinted Rock Selection

    -- Spawn Entities

    if roomData.Type == RoomType.ROOM_TREASURE then
        -- More Options Blind Graphics
    end

    -- init_outputs()
    -- Make Doors and Walls

    -- Dungeon Rock Selection
    if room.m_RoomType == RoomType.ROOM_DUNGEON then
        -- Init Gravity
    else
        -- Create Decorations
    end

    if api.Game.IsGreedMode(game) and roomData.Type == RoomType.ROOM_DEFAULT then
        -- Create Decorations
    end

    -- Post Init GridEntityList

    -- init_train_tracks()

    -- Raglich flag evaluation

    -- RestoreState()
    -- RestoreDecorationEntities

    -- Something Spawn Womb Teleport

    if room.m_IsFirsVisit then
        -- On First Visit Item Effects (Card Reading, Collectible Isaac Tomb, Spawn G-Fuel etc)
    end

    if room.m_RoomType == RoomType.ROOM_DEVIL then
        -- Try Sanguine Bond
    end

    -- Spawn Broken Shovel Shadow

    -- Update Visit Side effects (Set Devil Visited, Treasure Visited, Planetarium Visited etc)

    if api.RoomDescriptor.GetVisitedCount(roomDesc) == 0 and room.m_RoomType == RoomType.ROOM_DUNGEON then
        -- Spawn Walls, or morph pillars (unk)
    end

    -- Remove Doors (for special bosses like Mom)

    room.m_BrokenWatchState = 0
    room.m_IsInitialized = true

    if api.RoomDescriptor.GetVisitedCount(room.m_RoomDescriptor) == 0 then
        -- Init RoomType special effects
    end

    if api.Game.GetChallenge(game) == Challenge.CHALLENGE_BACKASSWARDS then
        -- Spawn Trophy or Light door on starting room
    end

    if not api.Game.IsRestoringGlowingHourglass(game) then
        local visitedCount = api.RoomDescriptor.GetVisitedCount(room.m_RoomDescriptor)
        visitedCount = visitedCount + 1
        api.RoomDescriptor.SetVisitedCount(room.m_RoomDescriptor, visitedCount)

        if visitedCount == 1 then
            -- Update ScoreSheet discovery score
        end
    end

    local level = api.Game.GetLevel(game)
    local stage = api.Level.GetStage(level)
    local stageType = api.Level.GetStageType(level)

    if (stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2) and stageType == StageType.STAGETYPE_AFTERBIRTH then
        -- Spawn Embers
    end

    -- Flag Clear if no enemies
    if not api.RoomDescriptor.HasFlags(room.m_RoomDescriptor, RoomDescriptor.FLAG_CLEAR) and roomData.Type == RoomType.ROOM_MINIBOSS then
        -- Display Miniboss Name
    end

    if api.RoomDescriptor.HasFlags(room.m_RoomDescriptor, RoomDescriptor.FLAG_CLEAR) then
        room.m_IsDeathListInactive = true
    end

    room.m_HasTakenRedHeartDamage = false
    -- init_rain()

    -- Colorize Room
    if api.Level.GetStageID(level) == StbType.ASHPIT then
        -- Load Dust image
    end

    if api.RoomDescriptor.HasFlags(room.m_RoomDescriptor, RoomDescriptor.FLAG_ROTGUT_CLEARED) and room.m_BossId == BossType.ROTGUT then
        room.m_BossId = 0
    end

    -- Process Color Modifier
    -- Process Wall and Floor Color
    -- RecomputeRoomBounds(false)

    -- Free and Construct Camera

    -- Something For Shockwave Params
    -- Load Backdrop Graphics
    -- Anm2Cache Free Unreferenced Images

    local total_kb = collectgarbage("count")
    local kb = math.floor(total_kb)
    local bytes = math.floor((total_kb - kb) * 1024 + 0.5)

    api.Manager.LogMessage(0, "Lua mem usage: %d KB and %d bytes", kb, bytes)
    if room.m_BossId == BossType.ULTRA_GREED and api.Game.GetDifficulty(game) == Difficulty.DIFFICULTY_GREEDIER and api.RoomDescriptor.HasFlags(room.m_RoomDescriptor, RoomDescriptor.FLAG_CLEAR) then
        -- Turn Gold
    end
end

--#endregion

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