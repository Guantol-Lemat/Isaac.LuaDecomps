---@class Decomp.Room.SubSystem.Spawn
local RoomSpawn = {}

local Lib = {
    Table = require("Lib.Table"),
    Level = require("Lib.Level"),
    Pickup = require("Lib.EntityPickup"),
    Slot = require("Lib.EntitySlot"),
    NPC = require("Lib.EntityNPC"),
}

require("Lib.PersistentGameData")

local Enums = require("General.Enums")

local STB_EFFECT = 999
local GRID_FIREPLACE = 1400
local GRID_FIREPLACE_RED = 1410
local RUNE_VARIANT = 301

local function switch_break()
end

---@param position Vector
---@param gridWidth integer
---@return integer gridIdx
local function get_grid_idx(position, gridWidth)
    return position.X + position.Y * gridWidth
end

---@param gridIdx integer
---@param gridWidth integer
---@return Vector coordinates
local function get_grid_coordinates(gridIdx, gridWidth)
    local x = gridIdx % gridWidth
    local y = gridIdx / gridWidth
    return Vector(x, y)
end

local function manhattan_distance(gridCoords1, gridCoords2)
    local distance = gridCoords1 - gridCoords2
    distance.X = math.abs(distance.X)
    distance.Y = math.abs(distance.Y)
    return distance.X + distance.Y
end

---@param api Decomp.IGlobalAPI
---@param room Decomp.RoomObject
---@param spawn RoomConfig_Spawn
---@return Vector spawnPosition
local function get_spawn_position(api, room, spawn)
    local gridIdx = get_grid_idx(Vector(spawn.X + 1, spawn.Y + 1), api.Room.GetWidth(room))
    return api.Room.GetGridPosition(room, gridIdx)
end

--#region Flags

---@class Decomp.Room.SubSystem.Spawn.ExtraFlags
---@field enableWater boolean
---@field disableWater boolean
---@field noWater boolean
---@field maxWater boolean
---@field hereticInRoom boolean
---@field raglichInRoom boolean

---@class Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
---@field _API Decomp.IGlobalAPI
---@field room Decomp.RoomObject
---@field desc RoomDescriptor
---@field spawn RoomConfig_Spawn
---@field spawnEntry RoomConfig_Entry
---@field extraFlags Decomp.Room.SubSystem.Spawn.ExtraFlags

---@param io Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
local function enable_water(io)
    io.extraFlags.enableWater = true
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
local function disable_water(io)
    io.extraFlags.disableWater = true
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
local function no_water(io)
    io.extraFlags.noWater = true
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
local function max_water(io)
    io.extraFlags.maxWater = true
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
local function flag_alternate_backdrop(io)
    io.desc.Flags = io.desc.Flags | RoomDescriptor.FLAG_USE_ALTERNATE_BACKDROP
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
local function heretic_in_room(io)
    io.extraFlags.hereticInRoom = true
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
local function raglich_in_room(io)
    io.extraFlags.hereticInRoom = true
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
local function flag_pitch_black(io)
    io.desc.Flags = io.desc.Flags | RoomDescriptor.FLAG_PITCH_BLACK
end

local waterCurrentVelocity = {
    [0] = Vector(-1.0, 0.0),
    [1] = Vector(0.0, -1.0),
    [2] = Vector(1.0, 0.0),
    [3] = Vector(0.0, 1.0),
}

---@param io Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
local function handle_water_environment(io)
    local subType = io.spawnEntry.Subtype

    if subType == 20 then
        disable_water(io)
        return
    end

    if subType == 11 then
        max_water(io)
        return
    end

    if subType == 10 then
        no_water(io)
        return
    end

    if subType < 4 then
        io._API.Room.SetWaterCurrent(io.room, waterCurrentVelocity[subType])
    end
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
local function flag_cursed_mist(io)
    io.desc.Flags = io.desc.Flags | RoomDescriptor.FLAG_CURSED_MIST
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
local function mark_death_match_spawn_point(io)
    local position = get_spawn_position(io._API, io.room, io.spawn)
    ---Can't really do much about this
end

local switch_EvaluateEnvironmentDescFlags = {
    [0] = flag_pitch_black,
    [1] = handle_water_environment,
    [3] = flag_cursed_mist,
    [4] = mark_death_match_spawn_point,
    default = switch_break,
}

---@param io Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
local function handle_environment(io)
    local evaluateEnvironment = switch_EvaluateEnvironmentDescFlags[io.spawnEntry.Variant] or switch_EvaluateEnvironmentDescFlags.default
    evaluateEnvironment(io)
end

local switch_EvaluateRoomFlags = {
    [EntityType.ENTITY_FIRE_WORM] = enable_water,
    [EntityType.ENTITY_GIDEON] = enable_water,
    [EntityType.ENTITY_MOLE] = disable_water,
    [EntityType.ENTITY_DUMP] = no_water,
    [EntityType.ENTITY_TURDLET] = no_water,
    [EntityType.ENTITY_DUST] = flag_alternate_backdrop,
    [EntityType.ENTITY_HERETIC] = heretic_in_room,
    [EntityType.ENTITY_RAGLICH] = raglich_in_room,
    [EntityType.ENTITY_ENVIRONMENT] = handle_environment,
    default = switch_break
}

---@param spawns CppList_RoomConfigSpawn
---@param index integer
---@param rng RNG
---@param io Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
local function evaluate_spawn_room_flags(spawns, index, rng, io)
    io.spawn = spawns:Get(index)
    local randomFloat = rng:RandomFloat()
    if io.spawn.EntryCount == 0 then
        return
    end

    io.spawnEntry = io.spawn:PickEntry(randomFloat)

    local evaluateFlags = switch_EvaluateRoomFlags[io.spawnEntry.Type] or switch_EvaluateRoomFlags.default
    evaluateFlags(io)
end

---@param env Decomp.EnvironmentObject
---@param config RoomConfigRoom
---@param desc RoomDescriptor
---@return Decomp.Room.SubSystem.Spawn.ExtraFlags
function RoomSpawn.EvaluateRoomFlags(env, config, desc) -- Room::Init
    local api = env._API
    ---@type Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
    local switchIO = {
        _API = api,
        room = api.Environment.GetRoom(env),
        desc = desc,
        ---@diagnostic disable-next-line: assign-type-mismatch  
        spawn = nil,
        ---@diagnostic disable-next-line: assign-type-mismatch
        spawnEntry = nil,
        extraFlags = {
            enableWater = false,
            disableWater = false,
            noWater = false,
            maxWater = false,
            hereticInRoom = false,
            raglichInRoom = false
        }
    }

    local spawns = config.Spawns
    if #spawns == 0 then
        return switchIO.extraFlags
    end


    local spawnRNG = RNG(); spawnRNG:SetSeed(desc.SpawnSeed, 11)
    for i = 0, #spawns - 1, 1 do
        evaluate_spawn_room_flags(spawns, i, spawnRNG, switchIO)
    end

    return switchIO.extraFlags
end

--#endregion

--#region FixSpawnEntry

---@class Decomp.Room.Spawn.SpawnEntry
---@field type EntityType | StbGridType | integer
---@field variant integer
---@field subType integer

---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param gridIdx integer
---@param seed integer
---@return boolean overridden
local function run_mc_pre_room_entity_spawn(spawnEntry, gridIdx, seed)
    local overridden = false
    local callbackReturn = Isaac.RunCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, spawnEntry.type, spawnEntry.variant, spawnEntry.subType, gridIdx, seed)

    if type(callbackReturn) == "table" then
        if callbackReturn[1] then
            overridden = true
            spawnEntry.type = callbackReturn[1]
        end

        if callbackReturn[2] then
            overridden = true
            spawnEntry.variant = callbackReturn[2]
        end

        if callbackReturn[3] then
            overridden = true
            spawnEntry.subType = callbackReturn[3]
        end
    end

    return overridden
end

local s_DefaultHearts = {
    [HeartSubType.HEART_HALF_SOUL] = HeartSubType.HEART_SOUL,
    [HeartSubType.HEART_SCARED] = HeartSubType.HEART_FULL,
    [HeartSubType.HEART_BONE] = HeartSubType.HEART_HALF,
    [HeartSubType.HEART_ROTTEN] = HeartSubType.HEART_HALF,
}

local s_DefaultChests = {
    [PickupVariant.PICKUP_MEGACHEST] = PickupVariant.PICKUP_LOCKEDCHEST
}

---@param env Decomp.EnvironmentObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param rng RNG
local function fix_pickup_spawns(env, spawnEntry, rng)
    assert(spawnEntry.type ~= EntityType.ENTITY_PICKUP)

    local seed = rng:Next()

    if Lib.EntityPickup.IsAvailable(env, spawnEntry.variant, spawnEntry.subType) then
        return
    end

    if Lib.EntityPickup.IsChest(spawnEntry.variant) then
        spawnEntry.variant = s_DefaultChests[spawnEntry.variant] or PickupVariant.PICKUP_CHEST
        return
    end

    if spawnEntry.variant == PickupVariant.PICKUP_HEART then
        spawnEntry.subType = s_DefaultHearts[spawnEntry.subType] or 0
        return
    end

    if spawnEntry.variant == PickupVariant.PICKUP_TAROTCARD and spawnEntry.subType ~= 0 then
        local itemPool = env._API.Environment.GetItemPool(env)
        spawnEntry.subType = Lib.EntityPickup.GetCard(env, itemPool, seed, 25, 10, 10, true)
        return
    end

    spawnEntry.subType = 0
end

local s_DefaultSlots = {
    [SlotVariant.HELL_GAME] = {EntityType.ENTITY_SLOT, SlotVariant.DEVIL_BEGGAR, nil},
    [SlotVariant.CRANE_GAME] = {EntityType.ENTITY_SLOT, SlotVariant.SLOT_MACHINE, nil},
    [SlotVariant.CONFESSIONAL] = {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL},
    [SlotVariant.ROTTEN_BEGGAR] = {EntityType.ENTITY_SLOT, SlotVariant.KEY_MASTER, nil},
}

---@param env Decomp.EnvironmentObject
---@param player Decomp.EntityPlayerObject
---@return boolean unlocked
local function has_unlocked_tainted_character(env, player)
    local api = env._API

    local completionEvents = Lib.PersistentGameData.GetCompletionEventsDef(api.EntityPlayer.GetPlayerType(player))
    if not completionEvents then
        return false
    end

    local taintedCharacterAchievement = completionEvents[Lib.PersistentGameData.eCompletionEvent.TAINTED_PLAYER].achievement
    if taintedCharacterAchievement < 0 then
        return false
    end

    local persistentGameData = api.Environment.GetPersistentGameData(env)
    return api.PersistentGameData.Unlocked(persistentGameData, taintedCharacterAchievement)
end

---@param env Decomp.EnvironmentObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
local function fix_slot_spawns(env, spawnEntry)
    assert(spawnEntry.type == EntityType.ENTITY_SLOT)

    local api = env._API
    local persistentGameData = api.Environment.GetPersistentGameData(env)
    if spawnEntry.variant == SlotVariant.HOME_CLOSET_PLAYER then
        if not has_unlocked_tainted_character(env, api.Environment.GetPlayer(env, 0)) then
            return
        end

        if api.PersistentGameData.Unlocked(persistentGameData, Achievement.INNER_CHILD) then
            spawnEntry.type = EntityType.ENTITY_PICKUP
            spawnEntry.variant = PickupVariant.PICKUP_COLLECTIBLE
            spawnEntry.subType = CollectibleType.COLLECTIBLE_INNER_CHILD
            return
        end

        spawnEntry.type = EntityType.ENTITY_SHOPKEEPER
        spawnEntry.variant = 0
        spawnEntry.subType = 0
        return
    end

    if Lib.EntitySlot.IsAvailable(spawnEntry.variant) then
        return
    end

    local defaultEntry = s_DefaultSlots[spawnEntry.variant] or {EntityType.ENTITY_SLOT, SlotVariant.SLOT_MACHINE, nil}
    spawnEntry.type = defaultEntry[1] or spawnEntry.type
    spawnEntry.variant = defaultEntry[2] or spawnEntry.variant
    spawnEntry.subType = defaultEntry[3] or spawnEntry.subType
end

---@param env Decomp.EnvironmentObject
---@param rng RNG
local function is_heavens_trapdoor(env, rng)
    local api = env._API
    local room = api.Environment.GetRoom(env)

    if api.Room.GetRoomType(room) == RoomType.ROOM_ANGEL then
        return true
    end

    local game = api.Environment.GetGame(env)
    local level = api.Game.GetLevel(game)
    local absoluteStage = Lib.Level.GetTrueAbsoluteStage(env, level)
    local forcedDevilPath = false
    local forcedAngelPath = false

    local game = api.Environment.GetGame(env)
    if api.Game.GetChallenge(game) ~= Challenge.CHALLENGE_NULL then
        local challengeParams = api.Game.GetChallengeParams(game)
        forcedAngelPath = api.ChallengeParams.IsAltPath(challengeParams)
        forcedDevilPath = not forcedAngelPath
    end

    if api.Room.GetRoomType(room) == RoomType.ROOM_ERROR and
       (absoluteStage == LevelStage.STAGE4_2 or absoluteStage == LevelStage.STAGE4_3) and
       ((rng:RandomInt(2) == 0 and not forcedDevilPath) or forcedAngelPath) then
        return true
    end

    if absoluteStage >= LevelStage.STAGE5 and api.Level.GetStageType(level) ~= StageType.STAGETYPE_ORIGINAL then
        return true
    end

    if api.Level.GetCurrentRoomIndex(level) == GridRooms.ROOM_GENESIS_IDX then
        return true
    end

    return false
end

---@param env Decomp.EnvironmentObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
local function fix_heavens_trapdoor(env, spawnEntry)
    local api = env._API
    local level = api.Environment.GetLevel(env)

    if not api.Level.IsNextStageAvailable(level) then
        spawnEntry.type = StbGridType.CRAWLSPACE
        spawnEntry.variant = 3
        return
    end

    if api.Level.IsStageAvailable(level, LevelStage.STAGE5, StageType.STAGETYPE_WOTL) then
        spawnEntry.type = STB_EFFECT
        spawnEntry.variant = EffectVariant.HEAVEN_LIGHT_DOOR
        return
    end
end

---@param env Decomp.EnvironmentObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param rng RNG
local function fix_error_room_trapdoor_spawn(env, spawnEntry, rng)
    local api = env._API

    local room = api.Environment.GetRoom(env)
    if api.Room.GetRoomType(room) ~= RoomType.ROOM_ERROR then
        return
    end

    local level = api.Environment.GetLevel(env)
    local persistentGameData = api.Environment.GetPersistentGameData(env)
    local absoluteStage = Lib.Level.GetTrueAbsoluteStage(env, level)

    if absoluteStage == LevelStage.STAGE6 then
        local game = api.Environment.GetGame(env)
        local challengeParams = api.Game.GetChallengeParams(game)
        local challengeEndStage = api.ChallengeParams.GetEndStage(challengeParams)
        local endStage = api.PersistentGameData.Unlocked(persistentGameData, Achievement.VOID_FLOOR) and LevelStage.STAGE7 or LevelStage.STAGE6
        endStage = challengeEndStage ~= LevelStage.STAGE_NULL and challengeEndStage or endStage

        if endStage >= LevelStage.STAGE7 then
            spawnEntry.variant = 1
            return
        end
    end

    if not api.Level.IsNextStageAvailable(level) then
        spawnEntry.type = StbGridType.CRAWLSPACE
        spawnEntry.variant = 3
        return
    end

    if is_heavens_trapdoor(env, rng) then
        fix_heavens_trapdoor(env, spawnEntry)
        return
    end
end

---@param env Decomp.EnvironmentObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param rng RNG
local function fix_trapdoor_spawn(env, spawnEntry, rng)
    local api = env._API

    local game = api.Environment.GetGame(env)
    if spawnEntry.type ~= StbGridType.TRAP_DOOR or api.Game.IsGreedMode(game) then
        return
    end

    local level = api.Game.GetLevel(game)
    if api.Level.IsAscent(level) then
        spawnEntry.type = STB_EFFECT
        spawnEntry.variant = EffectVariant.HEAVEN_LIGHT_DOOR
        return
    end

    local room = api.Level.GetRoom(level)
    if api.Room.GetRoomType(room) == RoomType.ROOM_ERROR then
        fix_error_room_trapdoor_spawn(env, spawnEntry, rng)
        return
    end

    if is_heavens_trapdoor(env, rng) then
        fix_heavens_trapdoor(env, spawnEntry)
        return
    end
end

---@param env Decomp.EnvironmentObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
local function morph_pickup_spawn(env, spawnEntry)
    assert(spawnEntry.type ~= EntityType.ENTITY_PICKUP, "attempted to morph a non pickup")

    local api = env._API
    local roomDesc = api.Environment.GetCurrentRoomDesc(env)

    if api.RoomDescriptor.HasFlags(roomDesc, RoomDescriptor.FLAG_DEVIL_TREASURE) and spawnEntry.variant == PickupVariant.PICKUP_COLLECTIBLE then
        spawnEntry.variant = PickupVariant.PICKUP_SHOPITEM
        return
    end
end

---@param env Decomp.EnvironmentObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param seed integer
local function morph_slot_spawn(env, spawnEntry, seed)
    assert(spawnEntry.type ~= EntityType.ENTITY_SLOT, "attempted to morph a non slot")

    local rng = RNG(); rng:SetSeed(seed, 68)

    local api = env._API
    local game = api.Environment.GetGame(env)

    if spawnEntry.variant == SlotVariant.SHELL_GAME and Lib.EntitySlot.IsAvailable(SlotVariant.HELL_GAME) and
       api.Game.GetDevilRoomDeals(game) > 0 and rng:RandomInt(4) == 0 then
        spawnEntry.variant = SlotVariant.HELL_GAME
        return
    end

    if spawnEntry.variant == SlotVariant.BEGGAR and Lib.EntitySlot.IsAvailable(SlotVariant.ROTTEN_BEGGAR) and
       rng:RandomInt(15) == 0 then
        spawnEntry.variant = SlotVariant.ROTTEN_BEGGAR
        return
    end
end

---@class Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
---@field api Decomp.IGlobalAPI
---@field room Decomp.RoomObject
---@field spawnEntry Decomp.Room.Spawn.SpawnEntry
---@field gridIdx integer
---@field rng RNG
---@field isBurningBasement boolean
---@field isFloodedCaves boolean
---@field isDankDepths boolean
---@field isScarredWomb boolean
---@field isAltBasement boolean
---@field isAltCaves boolean
---@field gateOpen boolean

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function gaper_stage_modifier(io)
    if io.isBurningBasement and io.rng:RandomInt(5) < 3 then
        io.spawnEntry.variant = 2
        return true
    end

    return false
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function horf_stage_modifier(io)
    if io.rng:RandomInt(60) == 0 then
        io.spawnEntry.type = EntityType.ENTITY_SUB_HORF
        io.spawnEntry.variant = 0
        return true
    end

    return false
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function hive_stage_modifier(io)
    if io.isFloodedCaves and io.rng:RandomInt(2) == 0 then
        io.spawnEntry.variant = 1
        return true
    end

    return false
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function charger_stage_modifier(io)
    if io.isFloodedCaves and io.rng:RandomInt(2) == 0 then
        io.spawnEntry.type = EntityType.ENTITY_CHARGER -- Don't know why but it does this
        io.spawnEntry.variant = 1
        return true
    end

    return false
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function globin_stage_modifier(io)
    if io.isDankDepths and io.rng:RandomInt(2) == 0 then
        io.spawnEntry.variant = 2
        return true
    end

    return false
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function boomfly_stage_modifier(io)
    if io.isFloodedCaves and io.rng:RandomInt(2) == 0 then
        io.spawnEntry.variant = 2
        return true
    end

    return false
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function host_stage_modifier(io)
    if not io.isAltCaves and io.rng:RandomInt(5) == 0 and io.gateOpen then
        io.spawnEntry.type = EntityType.ENTITY_MUSHROOM
        io.spawnEntry.variant = 0
        return true
    end

    return false
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function hopper_stage_modifier(io)
    if io.spawnEntry.variant == 0 and io.isBurningBasement and io.rng:RandomInt(5) < 3 then
        io.spawnEntry.type = EntityType.ENTITY_FLAMINGHOPPER
        io.spawnEntry.variant = 0
        return true
    end

    return false
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function mrmaw_stage_modifier(io)
    if io.rng:RandomInt(15) == 0 then
        io.spawnEntry.variant = 2
        return true
    end

    return false
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function vis_stage_modifier(io)
    if io.spawnEntry.variant ~= 2 and io.isScarredWomb and io.rng:RandomInt(2) == 0 then
        io.spawnEntry.variant = 3
        return true
    end

    return false
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function guts_stage_modifier(io)
    if io.isScarredWomb and io.rng:RandomInt(2) == 0 then
        io.spawnEntry.variant = 1
        return true
    end

    return false
end

local para_bite_stage_modifier = guts_stage_modifier

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function knight_stage_modifier(io)
    if io.spawnEntry.variant == 0 and io.rng:RandomInt(60) == 0 then
        io.spawnEntry.variant = 2
        return true
    end

    return false
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function spider_stage_modifier(io)
    if io.isAltBasement then
        io.spawnEntry.type = EntityType.ENTITY_STRIDER
        io.spawnEntry.variant = 0
        return true
    end

    return false
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function fatty_stage_modifier(io)
    if io.gateOpen and io.spawnEntry.variant == 1 and io.rng:RandomInt(10) == 0 then
        io.spawnEntry.type = EntityType.ENTITY_STONEY
        io.spawnEntry.variant = 0
        return true
    end

    if io.isBurningBasement and io.rng:RandomInt(5) < 3 then
        io.spawnEntry.variant = 2
        return true
    end

    return false
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function deaths_head_stage_modifier(io)
    if io.isDankDepths and io.rng:RandomInt(2) == 0 then
        io.spawnEntry.variant = 1
        return true
    end

    return false
end

local squirt_stage_modifier = deaths_head_stage_modifier

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function skinny_stage_modifier(io)
    if io.isBurningBasement and io.rng:RandomInt(5) < 2 then
        io.spawnEntry.variant = 2
        return true
    end

    return false
end

---@param api Decomp.IGlobalAPI
---@param room Decomp.RoomObject
---@param doorSlot DoorSlot
---@param spawnCoordinates Vector
local function is_nerve_close_to_door_slot(api, room, doorSlot, spawnCoordinates)
    if not api.Room.IsDoorSlotAllowed(room, doorSlot) then
        return false
    end

    local doorPosition = api.Room.GetDoorSlotPosition(room, doorSlot)
    local doorGridCoordinates = get_grid_coordinates(api.Room.GetGridIndex(room, doorPosition), api.Room.GetWidth(room))
    return manhattan_distance(doorGridCoordinates, spawnCoordinates) < 4
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function nerve_ending_stage_modifier(io)
    if not (io.gateOpen and io.rng:RandomInt(5) == 0) then
        return false
    end

    local spawnCoordinates = get_grid_coordinates(io.gridIdx, io.api.Room.GetWidth(io.room))

    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1, 1 do
        if is_nerve_close_to_door_slot(io.api, io.room, i, spawnCoordinates) then
            return false
        end
    end

    io.spawnEntry.variant = 1
    return true
end

local switch_TryStageSpawnModifiers = {
    [EntityType.ENTITY_GAPER] = gaper_stage_modifier,
    [EntityType.ENTITY_HORF] = horf_stage_modifier,
    [EntityType.ENTITY_HIVE] = hive_stage_modifier,
    [EntityType.ENTITY_CHARGER] = charger_stage_modifier,
    [EntityType.ENTITY_GLOBIN] = globin_stage_modifier,
    [EntityType.ENTITY_BOOMFLY] = boomfly_stage_modifier,
    [EntityType.ENTITY_HOST] = host_stage_modifier,
    [EntityType.ENTITY_HOPPER] = hopper_stage_modifier,
    [EntityType.ENTITY_MRMAW] = mrmaw_stage_modifier,
    [EntityType.ENTITY_VIS] = vis_stage_modifier,
    [EntityType.ENTITY_GUTS] = guts_stage_modifier,
    [EntityType.ENTITY_PARA_BITE] = para_bite_stage_modifier,
    [EntityType.ENTITY_KNIGHT] = knight_stage_modifier,
    [EntityType.ENTITY_SPIDER] = spider_stage_modifier,
    [EntityType.ENTITY_FATTY] = fatty_stage_modifier,
    [EntityType.ENTITY_DEATHS_HEAD] = deaths_head_stage_modifier,
    [EntityType.ENTITY_SQUIRT] = squirt_stage_modifier,
    [EntityType.ENTITY_SKINNY] = skinny_stage_modifier,
    [EntityType.ENTITY_NERVE_ENDING] = nerve_ending_stage_modifier,
    default = switch_break,
}

---@param env Decomp.EnvironmentObject
---@param room Decomp.RoomObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param gridIdx integer
---@param rng RNG
---@return boolean appliedModifier
local function try_stage_npc_variant(env, room, spawnEntry, gridIdx, rng)
    local api = env._API
    local level = api.Environment.GetLevel(env)
    local persistentGameData = api.Environment.GetPersistentGameData(env)

    local stage = Lib.Level.GetTrueAbsoluteStage(env, level)
    local stageType = api.Level.GetStageType(level)
    local isAltPath = api.Level.IsAltPath(level)

    ---@type Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
    local switchIO = {
        api = api,
        room = room,
        spawnEntry = spawnEntry,
        gridIdx = gridIdx,
        rng = rng,
        isBurningBasement = stageType == StageType.STAGETYPE_AFTERBIRTH and (stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2),
        isFloodedCaves = stageType == StageType.STAGETYPE_AFTERBIRTH and (stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2),
        isDankDepths = stageType == StageType.STAGETYPE_AFTERBIRTH and (stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2),
        isScarredWomb = stageType == StageType.STAGETYPE_AFTERBIRTH and (stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2),
        isAltBasement = isAltPath and (stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2),
        isAltCaves = isAltPath and (stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2),
        gateOpen = api.PersistentGameData.Unlocked(persistentGameData, Achievement.THE_GATE_IS_OPEN),
    }

    local TryStageSpawnModifiers = switch_TryStageSpawnModifiers[spawnEntry.type] or switch_TryStageSpawnModifiers.default
    return TryStageSpawnModifiers(switchIO)
end

local s_HasHardRareSpawnVariant = Lib.Table.CreateDictionary({
    EntityType.ENTITY_CLOTTY, EntityType.ENTITY_MULLIGAN, EntityType.ENTITY_MAW,
    EntityType.ENTITY_BOIL, EntityType.ENTITY_VIS, EntityType.ENTITY_LEECH,
    EntityType.ENTITY_WALKINGBOIL
})

---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param rng RNG
local function try_rare_hard_npc_variant(spawnEntry, rng)
    if s_HasHardRareSpawnVariant[spawnEntry.type] and rng:RandomInt(100) == 0 then
        spawnEntry.variant = 2
    end
end

---@class Decomp.Entity.SubSystem.Spawn.Switch.TryAltNpcVariantIO
---@field env Decomp.EnvironmentObject
---@field api Decomp.IGlobalAPI
---@field level Decomp.LevelObject
---@field has21Chance boolean
---@field has25Chance boolean

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryAltNpcVariantIO
local function set_21_chance(io)
    io.has21Chance = true
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryAltNpcVariantIO
local function set_25_chance(io)
    io.has25Chance = true
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryAltNpcVariantIO
local function set_all_tries(io)
    io.has21Chance = true
    io.has25Chance = true
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryAltNpcVariantIO
local function try_boomfly_alt_variant(io)
    if Lib.Level.GetTrueAbsoluteStage(io.env, io.level) >= LevelStage.STAGE2_1 then
        set_all_tries(io)
    end
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryAltNpcVariantIO
local function try_vis_alt_variant(io)
    local stage = Lib.Level.GetTrueAbsoluteStage(io.env, io.level)
    if (stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2) and io.api.Level.GetStageType(io.level) == StageType.STAGETYPE_WOTL then
        set_21_chance(io)
    end
end

local switch_TryAltNpcVariant = {
    [EntityType.ENTITY_POOTER] = set_all_tries,
    [EntityType.ENTITY_MULLIGAN] = set_all_tries,
    [EntityType.ENTITY_GLOBIN] = set_all_tries,
    [EntityType.ENTITY_MAW] = set_all_tries,
    [EntityType.ENTITY_HOST] = set_all_tries,
    [EntityType.ENTITY_BOOMFLY] = try_boomfly_alt_variant,
    [EntityType.ENTITY_HOPPER] = set_21_chance,
    [EntityType.ENTITY_BOIL] = set_21_chance,
    [EntityType.ENTITY_BABY] = set_21_chance,
    [EntityType.ENTITY_STONEHEAD] = set_21_chance,
    [EntityType.ENTITY_MEMBRAIN] = set_21_chance,
    [EntityType.ENTITY_SUCKER] = set_21_chance,
    [EntityType.ENTITY_WALKINGBOIL] = set_21_chance,
    [EntityType.ENTITY_VIS] = try_vis_alt_variant,
    [EntityType.ENTITY_KNIGHT] = set_25_chance,
    [EntityType.ENTITY_LEECH] = set_25_chance,
    [EntityType.ENTITY_EYE] = set_25_chance,
    default = switch_break,
}

---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param rng RNG
local function try_alt_npc_variant(env, spawnEntry, rng)
    local api = env._API

    ---@type Decomp.Entity.SubSystem.Spawn.Switch.TryAltNpcVariantIO
    local switchIO = {
        env = env,
        api = api,
        level = api.Environment.GetLevel(env),
        has21Chance = false,
        has25Chance = false,
    }

    local TryAltNpcVariant = switch_TryAltNpcVariant[spawnEntry.type] or switch_TryAltNpcVariant.default
    TryAltNpcVariant(switchIO)

    if not switchIO.has21Chance and not switchIO.has25Chance then
        return
    end

    if (switchIO.has21Chance and rng:RandomInt(21) == 0) or (switchIO.has25Chance and rng:RandomInt(25) == 0) or rng:RandomInt(100) == 0 then
        spawnEntry.variant = 1
    end
end

---@param env Decomp.EnvironmentObject
---@param room Decomp.RoomObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param gridIdx integer
---@param rng RNG
local function apply_spawn_modifiers(env, room, spawnEntry, gridIdx, rng)
    local api = env._API
    local game = api.Environment.GetGame(env)

    if spawnEntry.type == EntityType.ENTITY_STONEY then
        local dailyChallenge = api.Game.GetDailyChallenge(game)
        if (api.Game.GetChallenge(game) == Challenge.CHALLENGE_APRILS_FOOL or api.DailyChallenge.GetSpecialRunID(dailyChallenge) == 7) and rng:RandomInt(5) == 0 then
            spawnEntry.variant = 10
            return
        end
    end

    local modifierApplied = try_stage_npc_variant(env, room, spawnEntry, gridIdx, rng)
    if modifierApplied then
        return
    end

    try_rare_hard_npc_variant(spawnEntry, rng)
    try_alt_npc_variant(env, spawnEntry, rng)

    if spawnEntry.type == EntityType.ENTITY_BOOMFLY and spawnEntry.variant == 3 and spawnEntry.subType == 100 then
        spawnEntry.subType = rng:RandomInt(2)
    end
end

---@param env Decomp.EnvironmentObject
---@param room Decomp.RoomObject
---@param spawnEntry RoomConfig_Entry
---@param gridIdx integer
---@param seed integer
---@return Decomp.Room.Spawn.SpawnEntry fixedSpawnEntry
local function FixSpawnEntry(env, room, spawnEntry, gridIdx, seed)
    local api = env._API
    local rng = RNG(); rng:SetSeed(seed, 7)
    local fixedEntry = {type = spawnEntry.Type, variant = spawnEntry.Variant, subType = spawnEntry.Subtype}

    if fixedEntry.type == GRID_FIREPLACE then
        fixedEntry.type = EntityType.ENTITY_FIREPLACE
        fixedEntry.variant = rng:RandomInt(40) == 0 and 1 or 0
    end

    if fixedEntry.type == GRID_FIREPLACE_RED then
        fixedEntry.type = EntityType.ENTITY_FIREPLACE
        fixedEntry.variant = 1
    end

    local overridden = run_mc_pre_room_entity_spawn(fixedEntry, gridIdx, seed)

    if fixedEntry.type == EntityType.ENTITY_PICKUP and fixedEntry.variant == RUNE_VARIANT then
        fixedEntry.variant = PickupVariant.PICKUP_TAROTCARD
        local itemPool = api.Environment.GetItemPool(env)
        fixedEntry.subType = Decomp.Lib.EntityPickup.GetRune(env, itemPool, rng:Next())
    end

    if overridden then
        return fixedEntry
    end

    if fixedEntry.type == EntityType.ENTITY_PICKUP then
        fix_pickup_spawns(env, fixedEntry, rng)
    end

    if fixedEntry.type == EntityType.ENTITY_SLOT then
        fix_slot_spawns(env, fixedEntry)
    end

    if fixedEntry.type == StbGridType.TRAP_DOOR then
        fix_trapdoor_spawn(env, fixedEntry, rng)
    end

    if fixedEntry.type == EntityType.ENTITY_PICKUP then
        morph_pickup_spawn(env, fixedEntry)
    end

    if fixedEntry.type == EntityType.ENTITY_SLOT then
        morph_slot_spawn(env, fixedEntry, seed)
    end

    if 1 <= fixedEntry.type and fixedEntry.type <= 999 then
        fixedEntry.type, fixedEntry.variant = Lib.NPC.Redirect(env, fixedEntry.type, fixedEntry.variant)
    end

    if api.Room.GetRoomType(room) == RoomType.ROOM_SECRET_EXIT or not api.Room.HasRoomConfigFlag(room, 1) then
        return fixedEntry
    end

    apply_spawn_modifiers(env, room, fixedEntry, gridIdx, rng)
    return fixedEntry
end


--#endregion

--#region ReadSpawnEntry

---@param roomData RoomConfigRoom
---@return boolean knifeTreasureRoom
local function is_knife_treasure_room(roomData)
    return roomData.Type == RoomType.ROOM_TREASURE and roomData.Subtype == RoomSubType.TREASURE_KNIFE_PIECE
end

---@param api Decomp.IGlobalAPI
---@param level Decomp.LevelObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param respawning boolean
local function try_block_spawn(api, level, spawnEntry, respawning)
    if spawnEntry.type == EntityType.ENTITY_PICKUP and spawnEntry.variant == PickupVariant.PICKUP_COLLECTIBLE and
       api.Level.GetCurrentRoomIndex(level) == GridRooms.ROOM_GENESIS_IDX then
        return true
    end

    local room = api.Level.GetRoom(level)
    local roomDesc = api.Room.GetRoomDescriptor(room)

    if spawnEntry.type == EntityType.ENTITY_PICKUP and not respawning and
       api.Level.HasMirrorDimension(level) and api.Level.GetDimension(level) == Dimension.KNIFE_PUZZLE and
       not is_knife_treasure_room(api.RoomDescriptor.GetRoomData(roomDesc)) then
        return true
    end

    if spawnEntry.type == EntityType.ENTITY_SLOT and spawnEntry.variant == SlotVariant.DONATION_MACHINE and
       api.Room.GetRoomType(room) == RoomType.ROOM_SHOP and api.RoomDescriptor.GetGridIdx(roomDesc) < 0 then
        return true
    end

    return false
end

---@param api Decomp.IGlobalAPI
---@param level Decomp.LevelObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param rng RNG
local function try_rock_dangerous_morph(api, level, spawnEntry, rng)
    local room = api.Level.GetRoom(level)
    if api.Level.GetStageType(level) ~= StageType.STAGETYPE_AFTERBIRTH or api.Room.GetRoomType(room) ~= RoomType.ROOM_DEFAULT then
        return
    end

    if rng:RandomInt(10) ~= 0 then
        return
    end

    local stage = api.Level.GetStage(level)
    if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 then
        spawnEntry.type = EntityType.ENTITY_FIREPLACE
        spawnEntry.variant = rng:RandomInt(40) == 0 and 1 or 0
        spawnEntry.subType = 0
    elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
        spawnEntry.type = StbGridType.PIT
        spawnEntry.variant = 0
        spawnEntry.subType = 0
    elseif stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 then
        spawnEntry.type = StbGridType.SPIKES
        spawnEntry.variant = 0
        spawnEntry.subType = 0
    elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 then
        spawnEntry.type = StbGridType.RED_POOP
        spawnEntry.variant = 0
        spawnEntry.subType = 0
    end
end

---@param env Decomp.EnvironmentObject
---@param room Decomp.RoomObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param seed integer
---@return boolean morphed
local function try_dirty_mind_morph(env, room, spawnEntry, seed)
    local api = env._API

    if api.Room.GetRoomType(room) == RoomType.ROOM_DUNGEON then
        return false
    end

    local rng = RNG(); rng:SetSeed(seed, 2)
    local playerManager = api.Environment.GetPlayerManager(env)
    local randomPlayer = api.PlayerManager.GetRandomCollectibleOwner(playerManager, CollectibleType.COLLECTIBLE_DIRTY_MIND, rng:Next())
    if not randomPlayer then
        return false
    end

    local chance = math.min(api.EntityPlayer.GetLuck(randomPlayer) * 0.005 + 0.0625, 0.1)
    if rng:RandomFloat() > chance then
        return false
    end

    spawnEntry.type = StbGridType.POOP
    spawnEntry.variant = 0
    spawnEntry.subType = 0
    return true
end

---@param env Decomp.EnvironmentObject
---@param room Decomp.RoomObject
---@return boolean canSpawn
local function can_spawn_trapdoor(env, room)
    local api = env._API
    local level = api.Environment.GetLevel(env)

    if api.Level.IsNextStageAvailable(level) then
        return true
    end

    local roomType = api.Room.GetRoomType(room)
    if roomType == RoomType.ROOM_ERROR or roomType == RoomType.ROOM_SECRET_EXIT then
        return true
    end

    if api.Level.GetCurrentRoomIndex(level) == GridRooms.ROOM_GENESIS_IDX then
        return true
    end

    local roomDesc = api.Room.GetRoomDescriptor(room)
    local roomData = api.RoomDescriptor.GetRoomData(roomDesc)
    if (roomType == RoomType.ROOM_BOSS and roomData.Subtype == BossType.MOTHER) then
        return true
    end

    return false
end

---@param api Decomp.IGlobalAPI
---@param room Decomp.RoomObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param gridIdx integer
---@return boolean
local function can_morph_rock_entry(api, room, spawnEntry, gridIdx)
    return ((spawnEntry.type == StbGridType.ROCK and api.Room.GetTintedRockIdx(room) ~= gridIdx)) or spawnEntry.type == StbGridType.BOMB_ROCK or spawnEntry.type == StbGridType.ALT_ROCK
end

---@param env Decomp.EnvironmentObject
---@param room Decomp.RoomObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param rng RNG
---@param gridIdx integer
local function try_morph_spawn(env, room, spawnEntry, gridIdx, rng)
    local api = env._API

    if spawnEntry.type == StbGridType.ROCK and api.Room.GetTintedRockIdx(room) == gridIdx then
        return
    end

    local rockSeed = rng:GetSeed()

    local level = api.Environment.GetLevel(env)
    local dangerousGridMorph = api.Room.HasRoomConfigFlag(room, 1 << 3)
    if dangerousGridMorph and can_morph_rock_entry(api, room, spawnEntry, gridIdx) then
        try_rock_dangerous_morph(api, level, spawnEntry, rng)
    end

    if can_morph_rock_entry(api, room, spawnEntry, gridIdx) then
        if try_dirty_mind_morph(env, room, spawnEntry, rockSeed) then
            return
        end
    end

    if spawnEntry.type == StbGridType.TNT and rng:RandomInt(10) == 0 then
        spawnEntry.type = EntityType.ENTITY_MOVABLE_TNT
        spawnEntry.variant = 0
        spawnEntry.subType = 0
        return
    end

    if (spawnEntry.type == StbGridType.TRAP_DOOR or (spawnEntry.type == STB_EFFECT and spawnEntry.variant == EffectVariant.HEAVEN_LIGHT_DOOR)) then
        if not can_spawn_trapdoor(env, room) then
            spawnEntry.type = StbGridType.COBWEB
            spawnEntry.variant = 0
            spawnEntry.subType = 0
            return
        end

        if api.Level.HasMirrorDimension(level) and api.Level.GetDimension(level) == Dimension.KNIFE_PUZZLE then
            spawnEntry.type = StbGridType.DECORATION
            spawnEntry.variant = 0
            spawnEntry.subType = 0
            return
        end
    end

    local persistentGameData = api.Environment.GetPersistentGameData(env)
    if spawnEntry.type == EntityType.ENTITY_SHOPKEEPER then
        if spawnEntry.variant == 0 and rng:RandomInt(4) == 0 and api.PersistentGameData.Unlocked(persistentGameData, Achievement.SPECIAL_SHOPKEEPERS) then
            spawnEntry.variant = 3
        end

        if spawnEntry.variant == 1 and rng:RandomInt(4) == 0 and api.PersistentGameData.Unlocked(persistentGameData, Achievement.SPECIAL_HANGING_SHOPKEEPERS) then
            spawnEntry.variant = 4
        end
    end

    local bossPool = api.Environment.GetBossPool(env)
    if spawnEntry.type == StbGridType.DEVIL_STATUE and api.BossPool.GetRemovedBosses(bossPool)[BossType.SATAN] then
        spawnEntry.type = StbGridType.ROCK
        spawnEntry.variant = 0
        spawnEntry.subType = 1
        return
    end
end

---@class Decomp.Room.Spawn.SpawnDesc
---@field spawnType integer 0 for nothing 1 for entities, 2 for gridEntity
---@field entityDesc Decomp.Room.Spawn.EntityDesc | Decomp.Room.Spawn.GridEntityDesc | nil
---@field addOutput boolean?
---@field initRail boolean?

---@class Decomp.Room.Spawn.EntityDesc
---@field type EntityType | integer
---@field variant integer
---@field subType integer
---@field initSeed integer

---@class Decomp.Room.Spawn.GridEntityDesc
---@field type GridEntityType | integer
---@field variant integer
---@field varData integer
---@field spawnSeed integer
---@field spawnFissureSpawner boolean
---@field fissureSpawnerSeed integer -- Technically unneeded, but just in case
---@field increasePoopCount boolean
---@field increasePitCount boolean

--#region ReadEntityDesc

---@param api Decomp.IGlobalAPI
---@param room Decomp.RoomObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@return boolean cleared
local function consider_room_cleared(api, room, spawnEntry)
    local roomDesc = api.Room.GetRoomDescriptor(room)
    if api.RoomDescriptor.HasFlags(roomDesc, RoomDescriptor.FLAG_CLEAR) then
        return true
    end

    if api.Room.GetRoomType(room) == RoomType.ROOM_BOSS and api.RoomDescriptor.HasFlags(roomDesc, RoomDescriptor.FLAG_ROTGUT_CLEARED) then
        return spawnEntry.type ~= EntityType.ENTITY_ROTGUT
    end

    return false
end

---@param env Decomp.EnvironmentObject
---@param room Decomp.RoomObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param respawning boolean
---@return boolean
local function can_spawn_entity(env, room, spawnEntry, respawning)
    local api = env._API
    if not consider_room_cleared(api, room, spawnEntry) or respawning then
        return true
    end

    if api.Room.is_persistent_room_entity(room, spawnEntry.type, spawnEntry.variant) then
        return true
    end

    if api.Room.ShouldSaveEntity(room, spawnEntry.type, spawnEntry.variant, spawnEntry.subType, EntityType.ENTITY_NULL, true) then
        return true
    end

    local seeds = api.Environment.GetSeeds(env)
    if api.Seeds.HasSeedEffect(seeds, SeedEffect.SEED_PACIFIST) or api.Seeds.HasSeedEffect(seeds, SeedEffect.SEED_ENEMIES_RESPAWN) then
        return true
    end

    return false
end

---@param env Decomp.EnvironmentObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param gridIdx integer
---@param rng RNG
---@param respawning boolean
---@return Decomp.Room.Spawn.SpawnDesc?
local function build_entity_spawn(env, spawnEntry, gridIdx, rng, respawning)
    local api = env._API

    if spawnEntry.type == STB_EFFECT then
        spawnEntry.type = EntityType.ENTITY_EFFECT
    end

    if spawnEntry.type == EntityType.ENTITY_ENVIRONMENT then
        return
    end

    if spawnEntry.type == EntityType.ENTITY_TRIGGER_OUTPUT then
        ---@type Decomp.Room.Spawn.SpawnDesc
        return {spawnType = 0, entityDesc = nil, addOutput = true}
    end

    local level = api.Environment.GetLevel(env)
    if spawnEntry.type == EntityType.ENTITY_PICKUP and api.Level.IsCorpseEntrance(level) then
        return
    end

    local roomDesc = api.Environment.GetCurrentRoomDesc(env)
    if spawnEntry.type == EntityType.ENTITY_MINECART and api.RoomDescriptor.HasFlags(roomDesc, RoomDescriptor.FLAG_SACRIFICE_DONE) then -- ???
        return
    end

    local room = api.Environment.GetRoom(env)
    if not can_spawn_entity(env, room, spawnEntry, respawning) then
        return
    end

    ---@type Decomp.Room.Spawn.EntityDesc
    local entityDesc = {type = spawnEntry.type, variant = spawnEntry.variant, subType = spawnEntry.subType, initSeed = rng:Next()}

    ---@type Decomp.Room.Spawn.SpawnDesc
    return {spawnType = 1, entityDesc = entityDesc}
end

--#endregion

--#region ReadGridEntityDesc

local s_StbGridConversion = {
    [StbGridType.ROCK] = {GridEntityType.GRID_ROCK},
    [StbGridType.BOMB_ROCK] = {GridEntityType.GRID_ROCK_BOMB},
    [StbGridType.ALT_ROCK] = {GridEntityType.GRID_ROCK_ALT},
    [StbGridType.TINTED_ROCK] = {GridEntityType.GRID_ROCKT},
    [StbGridType.MARKED_SKULL] = {GridEntityType.GRID_ROCK_ALT2},
    [StbGridType.EVENT_ROCK] = {GridEntityType.GRID_ROCK, 10000},
    [StbGridType.SPIKE_ROCK] = {GridEntityType.GRID_ROCK_SPIKED},
    [StbGridType.FOOLS_GOLD_ROCK] = {GridEntityType.GRID_ROCK_GOLD},
    [StbGridType.TNT] = {GridEntityType.GRID_TNT},
    [1400] = {GridEntityType.GRID_FIREPLACE, 0},
    [1410] = {GridEntityType.GRID_FIREPLACE, 1},
    [StbGridType.RED_POOP] = {GridEntityType.GRID_POOP, GridPoopVariant.RED},
    [StbGridType.RAINBOW_POOP] = {GridEntityType.GRID_POOP, GridPoopVariant.RAINBOW},
    [StbGridType.CORN_POOP] = {GridEntityType.GRID_POOP, GridPoopVariant.CORN},
    [StbGridType.GOLDEN_POOP] = {GridEntityType.GRID_POOP, GridPoopVariant.GOLDEN},
    [StbGridType.BLACK_POOP] = {GridEntityType.GRID_POOP, GridPoopVariant.BLACK},
    [StbGridType.HOLY_POOP] = {GridEntityType.GRID_POOP, GridPoopVariant.HOLY},
    [StbGridType.GIANT_POOP] = {GridEntityType.GRID_POOP, GridPoopVariant.GIANT_TL},
    [StbGridType.POOP] = {GridEntityType.GRID_POOP, GridPoopVariant.NORMAL},
    [StbGridType.CHARMING_POOP] = {GridEntityType.GRID_POOP, GridPoopVariant.CHARMING},
    [StbGridType.BLOCK] = {GridEntityType.GRID_ROCKB},
    [StbGridType.PILLAR] = {GridEntityType.GRID_PILLAR},
    [StbGridType.SPIKES] = {GridEntityType.GRID_SPIKES},
    [StbGridType.RETRACTING_SPIKES] = {GridEntityType.GRID_SPIKES_ONOFF},
    [StbGridType.COBWEB] = {GridEntityType.GRID_SPIDERWEB},
    [StbGridType.INVISIBLE_BLOCK] = {GridEntityType.GRID_WALL},
    [StbGridType.PIT] = {GridEntityType.GRID_PIT},
    [3001] = {GridEntityType.GRID_PIT},
    [StbGridType.EVENT_RAIL] = {GridEntityType.GRID_PIT},
    [StbGridType.EVENT_PIT] = {GridEntityType.GRID_PIT, 128},
    [StbGridType.KEY_BLOCK] = {GridEntityType.GRID_LOCK},
    [StbGridType.PRESSURE_PLATE] = {GridEntityType.GRID_PRESSURE_PLATE},
    [StbGridType.DEVIL_STATUE] = {GridEntityType.GRID_STATUE, 0},
    [StbGridType.ANGEL_STATUE] = {GridEntityType.GRID_STATUE, 1},
    [StbGridType.RAIL_PIT] = {GridEntityType.GRID_PIT},
    [StbGridType.TELEPORTER] = {GridEntityType.GRID_TELEPORTER},
    [StbGridType.TRAP_DOOR] = {GridEntityType.GRID_TRAPDOOR, 0},
    [StbGridType.CRAWLSPACE] = {GridEntityType.GRID_STAIRS},
    [StbGridType.GRAVITY] = {GridEntityType.GRID_GRAVITY},
}

---@param env Decomp.EnvironmentObject
---@param rng RNG
---@return Vector
local function get_gold_vein_size(env, rng)
    local api = env._API
    local level = api.Environment.GetLevel(env)
    local stageID = api.Level.GetStageID(level)

    local veinWidthScale = 1.25
    local veinHeightScale = 0.3
    if stageID == StbType.MINES or stageID == StbType.ASHPIT then
        veinWidthScale = 1.80
        veinHeightScale = 0.5
    end

    local sizeX = ((rng:RandomFloat() + rng:RandomFloat()) * veinWidthScale) + 0.5
    local sizeY = ((rng:RandomFloat() + rng:RandomFloat()) * veinHeightScale) + 0.3

    return Vector(sizeX, sizeY)
end

---@param env Decomp.EnvironmentObject
---@param gridIdx integer
---@param seed integer
---@return boolean
local function is_grid_idx_in_gold_vein(env, gridIdx, seed)
    local rng = RNG(); rng:SetSeed(seed, 19)

    if rng:RandomInt(10) ~= 0 then
        return false
    end

    local api = env._API
    local room = api.Environment.GetRoom(env)
    local roomWidth = api.Room.GetWidth(room)
    local roomHeight = api.Room.GetHeight(room)

    local goldVeinPosition = Vector(rng:RandomFloat() * roomHeight, rng:RandomFloat() * roomHeight)
    local gridToVeinPosition = goldVeinPosition - get_grid_coordinates(gridIdx, roomWidth)
    local veinSize = get_gold_vein_size(env, rng)
    gridToVeinPosition = gridToVeinPosition:Rotated(rng:RandomFloat() * 360.0)
    gridToVeinPosition = gridToVeinPosition / veinSize

    return gridToVeinPosition:LengthSquared() <= 1.0
end

---@param env Decomp.EnvironmentObject
---@param rng RNG
---@return GridEntityType
local function init_tinted_rock(env, rng)
    local api = env._API
    local persistentGameData = api.Environment.GetPersistentGameData(env)

    if rng:RandomInt(20) == 0 and api.PersistentGameData.Unlocked(persistentGameData, Achievement.SUPER_SPECIAL_ROCKS) then
        return GridEntityType.GRID_ROCK_SS
    end

    return GridEntityType.GRID_ROCKT
end

---@param env Decomp.EnvironmentObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param gridIdx integer
---@param rng RNG
---@return GridEntityType
local function do_rock_morph(env, spawnEntry, gridIdx, rng)
    assert(spawnEntry.type == StbGridType.ROCK)
    local api = env._API
    local room = api.Environment.GetRoom(env)
    local roomDesc = api.Room.GetRoomDescriptor(room)

    local persistentGameData = api.Environment.GetPersistentGameData(env)
    local foolsRockMorph = api.PersistentGameData.Unlocked(persistentGameData, Achievement.FOOLS_GOLD) and is_grid_idx_in_gold_vein(env, gridIdx, api.RoomDescriptor.GetDecorationSeed(roomDesc))

    local randomNumber = rng:RandomInt(1001)
    if api.Room.GetTintedRockIdx(room) == gridIdx then
        return init_tinted_rock(env, rng)
    end

    if randomNumber < 10 then
        return GridEntityType.GRID_ROCK_BOMB
    end

    if foolsRockMorph then
        return GridEntityType.GRID_ROCK_GOLD
    end

    return randomNumber < 16 and GridEntityType.GRID_ROCK_ALT or GridEntityType.GRID_ROCK
end

---@param env Decomp.EnvironmentObject
---@param rng RNG
---@return GridPoopVariant?
local function try_normal_poop_morph(env, rng)
    if rng:RandomInt(40) == 0 then
        return GridPoopVariant.CORN
    end

    local api = env._API
    local persistentGameData = api.Environment.GetPersistentGameData(env)
    if rng:RandomInt(100) == 0 and api.PersistentGameData.Unlocked(persistentGameData, Achievement.CHARMING_POOP) then
        return GridPoopVariant.CHARMING
    end
end

local s_CornPoopOutcomes = {
    [1] = GridPoopVariant.GOLDEN,
    [2] = GridPoopVariant.GOLDEN,
    [5] = GridPoopVariant.RAINBOW,
    [6] = GridPoopVariant.RAINBOW,
    [7] = GridPoopVariant.RAINBOW,
}

---@param rng RNG
---@return GridPoopVariant?
local function try_corn_poop_morph(rng)
    local randomNumber = rng:RandomInt(40)
    return s_CornPoopOutcomes[randomNumber]
end

---@param seed integer
---@return GridPoopVariant?
local function try_meconium_morph(seed)
    local rng = RNG(); rng:SetSeed(seed, 13)
    local randomNumber = rng:RandomInt(100)

    if randomNumber <= 32 then
        return GridPoopVariant.BLACK
    end
end

---@param env Decomp.EnvironmentObject
---@param variant GridPoopVariant
---@param rng RNG
---@return GridPoopVariant
local function do_poop_morph(env, variant, rng)
    if variant == GridPoopVariant.NORMAL then
        variant = try_normal_poop_morph(env, rng) or variant
    end

    if variant == GridPoopVariant.CORN then
        variant = try_corn_poop_morph(rng) or variant
    end

    local api = env._API
    local playerManager = api.Environment.GetPlayerManager(env)
    if api.PlayerManager.AnyoneHasTrinket(playerManager, TrinketType.TRINKET_MECONIUM) then
        variant = try_meconium_morph(rng:GetSeed()) or variant
    end

    return variant
end

---@param env Decomp.EnvironmentObject
---@param spawnEntry Decomp.Room.Spawn.SpawnEntry
---@param gridIdx integer
---@param rng RNG
---@param seed integer
---@param respawning boolean
---@return Decomp.Room.Spawn.SpawnDesc?
local function build_grid_entity_spawn(env, spawnEntry, gridIdx, rng, seed, respawning)
    if respawning then
        return
    end

    if spawnEntry.type == StbGridType.RAIL then
        ---@type Decomp.Room.Spawn.SpawnDesc
        return {spawnType = 0, entityDesc = nil, initRail = true}
    end

    local initRail = false
    if spawnEntry.type == StbGridType.RAIL_PIT then
        initRail = true
        spawnEntry.type = StbGridType.PIT
    end

    ---@type Decomp.Room.Spawn.GridEntityDesc
    local gridEntityDesc = {
        type = 0,
        variant = 0,
        varData = 0,
        spawnSeed = 0,
        spawnFissureSpawner = false,
        fissureSpawnerSeed = 0,
        increasePitCount = false,
        increasePoopCount = false,
    }

    local api = env._API

    local convertedGrid = s_StbGridConversion[spawnEntry.type] or {GridEntityType.GRID_DECORATION}
    gridEntityDesc.type = convertedGrid[1]
    gridEntityDesc.variant = convertedGrid[2] or spawnEntry.variant
    gridEntityDesc.varData = spawnEntry.type == StbGridType.TRAP_DOOR and spawnEntry.variant or 0

    if spawnEntry.type == 3001 then
        gridEntityDesc.spawnFissureSpawner = true
        gridEntityDesc.fissureSpawnerSeed = rng:Next()
    end

    gridEntityDesc.increasePitCount = gridEntityDesc.type == GridEntityType.GRID_PIT
    gridEntityDesc.increasePoopCount = gridEntityDesc.type == GridEntityType.GRID_POOP

    local persistentGameData = api.Environment.GetPersistentGameData(env)
    if gridEntityDesc.type == GridEntityType.GRID_ROCK_GOLD and not api.PersistentGameData.Unlocked(persistentGameData, Achievement.FOOLS_GOLD) then
        gridEntityDesc.type = GridEntityType.GRID_ROCK
    end

    local room = api.Environment.GetRoom(env)
    local mineshaftChase = api.Room.HasRoomConfigFlag(room, Enums.eRoomConfigFlag.MINESHAFT_CHASE)

    if spawnEntry.type == StbGridType.ROCK and not mineshaftChase and spawnEntry.subType == 0 then
        gridEntityDesc.type = do_rock_morph(env, spawnEntry, gridIdx, rng)
    end

    if gridEntityDesc.type == GridEntityType.GRID_POOP and not mineshaftChase and spawnEntry.subType == 0 then
        gridEntityDesc.variant = do_poop_morph(env, gridEntityDesc.variant, rng)
    end

    gridEntityDesc.spawnSeed = seed
    ---@type Decomp.Room.Spawn.SpawnDesc
    return {spawnType = 2, entityDesc = gridEntityDesc, initRail = initRail}
end

--#endregion

---@param env Decomp.EnvironmentObject
---@param room Decomp.RoomObject
---@param spawnEntry RoomConfig_Entry
---@param seed integer
---@param respawning boolean
---@return Decomp.Room.Spawn.SpawnDesc?
local function BuildSpawnDesc(env, room, gridIdx, spawnEntry, seed, respawning)
    local rng = RNG(); rng:SetSeed(seed, 35)
    local fixedSpawnEntry = FixSpawnEntry(env, room, spawnEntry, gridIdx, seed)

    local api = env._API
    local level = api.Environment.GetLevel(env)
    if try_block_spawn(api, level, fixedSpawnEntry, respawning) then
        return
    end

    try_morph_spawn(env, room, fixedSpawnEntry, gridIdx, rng)

    if fixedSpawnEntry.type == EntityType.ENTITY_ENVIRONMENT then
        return
    end

    if 1 <= fixedSpawnEntry.type and fixedSpawnEntry.type <= 999 then
        return build_entity_spawn(env, fixedSpawnEntry, gridIdx, rng, respawning)
    else
        return build_grid_entity_spawn(env, fixedSpawnEntry, gridIdx, rng, seed, respawning)
    end
end

--#endregion

--#region Spawn Entity

---@param spawnDesc Decomp.Room.Spawn.SpawnDesc
---@param gridIndex integer
local function apply_spawn_effects(spawnDesc, gridIndex)
    if spawnDesc.addOutput then
        -- AddOutput
    end

    if spawnDesc.initRail then
        -- InitRail
    end
end

---@param api Decomp.IGlobalAPI
---@param level Decomp.LevelObject
---@param room Decomp.RoomObject
---@return boolean
local function has_room_mutually_exclusive_collectibles(api, level, room)
    local roomDesc = api.Room.GetRoomDescriptor(room)
    local roomData = api.RoomDescriptor.GetRoomData(roomDesc)
    local roomType = api.Room.GetRoomType(room)

    if roomType == RoomType.ROOM_ANGEL or roomType == RoomType.ROOM_BOSSRUSH or roomType == RoomType.ROOM_PLANETARIUM then
        return true
    end

    if roomType == RoomType.ROOM_TREASURE and
       ((roomData.Subtype == RoomSubType.TREASURE_OPTIONS or roomData.Subtype == RoomSubType.TREASURE_PAY_TO_PLAY_OPTIONS) or
       api.Level.IsAltPath(level)) then
        return true
    end

    return false
end

---@param api Decomp.IGlobalAPI
---@param pickup Decomp.EntityPickupObject
local function init_spawned_pickup(api, pickup)
    api.EntityPickup.SetWait(pickup, 0)
    local subType = api.Entity.GetSubType(pickup)

    if api.Entity.GetType(pickup) == EntityType.ENTITY_PICKUP and api.Entity.GetVariant(pickup) == PickupVariant.PICKUP_COLLECTIBLE and
       (subType == CollectibleType.COLLECTIBLE_KNIFE_PIECE_1 or subType == CollectibleType.COLLECTIBLE_KNIFE_PIECE_2) then
        api.EntityPickup.SetCycleNum(pickup, 0) -- Negate cycles
    end

    api.EntityPickup.InitFlipState(pickup)
end

---@param env Decomp.EnvironmentObject
---@param room Decomp.RoomObject
---@param entityDesc Decomp.Room.Spawn.EntityDesc
---@param gridIdx integer
---@return Decomp.EntityObject spawnedEntity
local function spawn_regular_entity(env, room, entityDesc, gridIdx)
    local api = env._API

    local gridEntity = api.Room.GetGridEntity(room, gridIdx)
    if gridEntity then
        gridEntity:Destroy(true)
    end

    local game = api.Environment.GetGame(env)
    local position = api.Room.GetGridPosition(room, gridIdx)

    local entity = api.Game.Spawn(game, entityDesc.type, entityDesc.variant, position, Vector(0, 0), nil, entityDesc.subType, entityDesc.initSeed)
    api.Entity.SetSpawnGridIndex(entity, gridIdx)

    local pickup = api.Entity.ToPickup(entity)
    if api.Entity.GetType(entity) == EntityType.ENTITY_PICKUP and pickup then
        init_spawned_pickup(api, pickup)
    end

    if api.Room.ShouldSaveEntity(room, entityDesc.type, entityDesc.variant, entityDesc.subType, EntityType.ENTITY_NULL, false) then
        local roomDesc = api.Room.GetRoomDescriptor(room)
        api.RoomDescriptor.AddRestrictedGridIndex(roomDesc, gridIdx)
    end

    local level = api.Game.GetLevel(game)
    if pickup and has_room_mutually_exclusive_collectibles(api, level, room) and api.Entity.GetType(entity) == EntityType.ENTITY_PICKUP and
       entityDesc.type == EntityType.ENTITY_PICKUP and entityDesc.variant == PickupVariant.PICKUP_COLLECTIBLE then
        api.EntityPickup.SetOptionsPickupIndex(pickup, 1)
    end

    return entity
end

---@param env Decomp.EnvironmentObject
---@param room Decomp.RoomObject
---@param gridEntityDesc Decomp.Room.Spawn.GridEntityDesc
---@param gridIdx integer
local function spawn_grid_entity(env, room, gridEntityDesc, gridIdx)
    local api = env._API

    if api.Room.GetGridEntity(room, gridIdx) then
        return
    end

    -- TODO
end

---@param env Decomp.EnvironmentObject
---@param room Decomp.RoomObject
---@param gridIdx integer
---@param spawnEntry RoomConfig_Entry
---@param seed integer
---@param respawning boolean
---@return Entity? spawnedEntity
local function SpawnEntity(env, room, gridIdx, spawnEntry, seed, respawning)
    local spawnDesc = BuildSpawnDesc(env, room, gridIdx, spawnEntry, seed, respawning)
    if not spawnDesc then
        return
    end

    apply_spawn_effects(spawnDesc, gridIdx)
    if spawnDesc.spawnType == 1 then
        local entityDesc = spawnDesc.entityDesc
        ---@cast entityDesc Decomp.Room.Spawn.EntityDesc
        spawn_regular_entity(env, room, entityDesc, gridIdx)
    elseif spawnDesc.spawnType == 2 then
        local gridDesc = spawnDesc.entityDesc
        ---@cast gridDesc Decomp.Room.Spawn.GridEntityDesc
        spawn_grid_entity(env, room, gridDesc, gridIdx)
    end
end

---@param api Decomp.IGlobalAPI
---@param desc Decomp.RoomDescObject
---@param gridIdx integer
local function is_restricted_grid_idx(api, desc, gridIdx)
    local restrictedGrids = api.RoomDescriptor.GetRestrictedGridIndexes(desc)
    for index, value in ipairs(restrictedGrids) do
        if value == gridIdx then
            return true
        end
    end

    return false
end

---@param env Decomp.EnvironmentObject
---@param room Decomp.RoomObject
---@param desc Decomp.RoomDescObject
---@param spawns CppList_RoomConfigSpawn
---@param index integer
---@param rng RNG
local function try_spawn_entry(env, room, desc, spawns, index, rng)
    local api = env._API

    local spawn = spawns:Get(index)
    local randomFloat = rng:RandomFloat()
    if spawn.EntryCount == 0 then
        return
    end

    local spawnEntry = spawn:PickEntry(randomFloat)
    local gridIdx = get_grid_idx(Vector(spawn.X + 1, spawn.Y + 1), api.Room.GetWidth(room))
    if is_restricted_grid_idx(api, desc, gridIdx) then
        return
    end

    SpawnEntity(env, room, gridIdx, spawnEntry, rng:GetSeed(), false)
end

---@param env Decomp.EnvironmentObject
---@param room Decomp.RoomObject
---@param desc Decomp.RoomDescObject
---@param config RoomConfigRoom
local function SpawnRoomConfigEntities(env, room, desc, config) -- Room::Init
    local api = env._API

    local spawnRNG = RNG(); spawnRNG:SetSeed(api.RoomDescriptor.GetSpawnSeed(desc), 11)
    local spawns = config.Spawns

    for i = 0, #spawns - 1, 1 do
        try_spawn_entry(env, room, desc, spawns, i, spawnRNG)
    end
end

--#endregion

--#region Module

RoomSpawn.FixSpawnEntry = FixSpawnEntry -- Room::FixSpawnEntry
RoomSpawn.BuildSpawnDesc = BuildSpawnDesc
RoomSpawn.SpawnEntity = SpawnEntity -- Room::spawn_entity
RoomSpawn.SpawnRoomConfigEntities = SpawnRoomConfigEntities -- Room::Init

--#endregion