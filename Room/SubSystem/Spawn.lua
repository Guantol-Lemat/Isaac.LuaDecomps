---@class Decomp.Room.SubSystem.Spawn
local RoomSpawn = {}
Decomp.Room.SubSystem.Spawn = RoomSpawn

local Table = require("Lib.Table")
require("Lib.Level")
require("Lib.EntityPickup")
require("Lib.EntitySlot")
require("Lib.EntityNPC")
require("Lib.PersistentGameData")

require("Room.Room")
require("Entity.EntityPickup")

local g_Game = Game()
local g_Level = g_Game:GetLevel()
local g_Seeds = g_Game:GetSeeds()
local g_PersistentGameData = Isaac.GetPersistentGameData()

local Lib = Decomp.Lib
local Class_Room = Decomp.Class.Room
local Class_EntityPickup = Decomp.Class.EntityPickup

local STB_EFFECT = 999
local GRID_FIREPLACE = 1400
local GRID_FIREPLACE_RED = 1410
local RUNE_VARIANT = 301

local function switch_break()
end

---@param room Room
---@param position Vector
---@return integer gridIdx
local function get_grid_idx(room, position)
    return position.X + position.Y * room:GetGridWidth()
end

---@param room Room
---@param gridIdx integer
---@return Vector coordinates
local function get_grid_coordinates(room, gridIdx)
    local gridWidth = room:GetGridWidth()
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

---@param room Room
---@param spawn RoomConfig_Spawn
---@return Vector spawnPosition
local function get_spawn_position(room, spawn)
    local gridIdx = get_grid_idx(room, Vector(spawn.X + 1, spawn.Y + 1))
    return room:GetGridPosition(gridIdx)
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
---@field room Room
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
        io.room:SetWaterCurrent(waterCurrentVelocity[subType])
    end
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
local function flag_cursed_mist(io)
    io.desc.Flags = io.desc.Flags | RoomDescriptor.FLAG_CURSED_MIST
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
local function mark_death_match_spawn_point(io)
    local position = get_spawn_position(io.room, io.spawn)
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

---@param room Room
---@param config RoomConfigRoom
---@param desc RoomDescriptor
---@return Decomp.Room.SubSystem.Spawn.ExtraFlags
function RoomSpawn.EvaluateRoomFlags(room, config, desc) -- Room::Init
    ---@type Decomp.Entity.SubSystem.Spawn.Switch.EvaluateRoomFlagsIO
    local switchIO = {
        room = g_Game:GetRoom(),
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

---@class Decomp.Room.SubSystem.Spawn.SpawnEntry
---@field type EntityType | StbGridType | integer
---@field variant integer
---@field subType integer

---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
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

---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
---@param rng RNG
local function fix_pickup_spawns(spawnEntry, rng)
    if spawnEntry.type ~= EntityType.ENTITY_PICKUP then
        return
    end

    local seed = rng:Next()

    if Lib.EntityPickup.IsAvailable(spawnEntry.variant, spawnEntry.subType) then
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
        spawnEntry.subType = Lib.EntityPickup.GetCard(seed, 25, 10, 10, true)
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

---@param player EntityPlayer
---@return boolean unlocked
local function has_unlocked_tainted_character(player)
    local completionEvents = Lib.PersistentGameData.GetCompletionEventsDef(player:GetType())
    if not completionEvents then
        return false
    end

    local taintedCharacterAchievement = completionEvents[Lib.PersistentGameData.eCompletionEvent.TAINTED_PLAYER].achievement
    if taintedCharacterAchievement < 0 then
        return false
    end

    return g_PersistentGameData:Unlocked(taintedCharacterAchievement)
end

---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
local function fix_slot_spawns(spawnEntry)
    if spawnEntry.type ~= EntityType.ENTITY_SLOT then
        return
    end

    if spawnEntry.variant == SlotVariant.HOME_CLOSET_PLAYER then
        if not has_unlocked_tainted_character(g_Game:GetPlayer(0)) then
            return
        end

        if g_PersistentGameData:Unlocked(Achievement.INNER_CHILD) then
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

---@param room Room
---@param rng RNG
local function is_heavens_trapdoor(room, rng)
    if room:GetType() == RoomType.ROOM_ANGEL then
        return true
    end

    local absoluteStage = Lib.Level.GetTrueAbsoluteStage(g_Level)
    local forcedDevilPath = false
    local forcedAngelPath = false

    if g_Game.Challenge ~= Challenge.CHALLENGE_NULL then
        forcedAngelPath = g_Game:GetChallengeParams().IsAltPath()
        forcedDevilPath = not forcedAngelPath
    end

    if room:GetType() == RoomType.ROOM_ERROR and
       (absoluteStage == LevelStage.STAGE4_2 or absoluteStage == LevelStage.STAGE4_3) and
       ((rng:RandomInt(2) == 0 and not forcedDevilPath) or forcedAngelPath) then
        return true
    end

    if absoluteStage >= LevelStage.STAGE5 and g_Level:GetStageType() ~= StageType.STAGETYPE_ORIGINAL then
        return true
    end

    if g_Level:GetCurrentRoomIndex() == GridRooms.ROOM_GENESIS_IDX then
        return true
    end

    return false
end

---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
local function fix_heavens_trapdoor(spawnEntry)
    if not g_Level:IsNextStageAvailable() then
        spawnEntry.type = StbGridType.CRAWLSPACE
        spawnEntry.variant = 3
        return
    end

    if g_Level:IsStageAvailable(LevelStage.STAGE5, StageType.STAGETYPE_WOTL) then
        spawnEntry.type = STB_EFFECT
        spawnEntry.variant = EffectVariant.HEAVEN_LIGHT_DOOR
        return
    end
end

---@param room Room
---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
---@param rng RNG
local function fix_error_room_trapdoor_spawn(room, spawnEntry, rng)
    if room:GetType() ~= RoomType.ROOM_ERROR then
        return
    end

    local absoluteStage = Lib.Level.GetTrueAbsoluteStage(g_Level)
    if absoluteStage == LevelStage.STAGE6 then
        local challengeEndStage = g_Game:GetChallengeParams().GetEndStage()
        local endStage = g_PersistentGameData:Unlocked(Achievement.VOID_FLOOR) and LevelStage.STAGE7 or LevelStage.STAGE6
        endStage = challengeEndStage ~= LevelStage.STAGE_NULL and challengeEndStage or endStage

        if endStage >= LevelStage.STAGE7 then
            spawnEntry.variant = 1
            return
        end
    end

    if not g_Level:IsNextStageAvailable() then
        spawnEntry.type = StbGridType.CRAWLSPACE
        spawnEntry.variant = 3
        return
    end

    if is_heavens_trapdoor(room, rng) then
        fix_heavens_trapdoor(spawnEntry)
        return
    end
end

---@param room Room
---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
---@param rng RNG
local function fix_trapdoor_spawn(room, spawnEntry, rng)
    if spawnEntry.type ~= StbGridType.TRAP_DOOR or g_Game:IsGreedMode() then
        return
    end

    if g_Level:IsAscent() then
        spawnEntry.type = STB_EFFECT
        spawnEntry.variant = EffectVariant.HEAVEN_LIGHT_DOOR
        return
    end

    if room:GetType() == RoomType.ROOM_ERROR then
        fix_error_room_trapdoor_spawn(room, spawnEntry, rng)
        return
    end

    if is_heavens_trapdoor(room, rng) then
        fix_heavens_trapdoor(spawnEntry)
        return
    end
end

---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
local function morph_pickup_spawn(spawnEntry)
    if spawnEntry.type ~= EntityType.ENTITY_PICKUP then
        return
    end

    if (g_Level:GetCurrentRoomDesc().Flags & RoomDescriptor.FLAG_DEVIL_TREASURE) ~= 0 and spawnEntry.variant == PickupVariant.PICKUP_COLLECTIBLE then
        spawnEntry.variant = PickupVariant.PICKUP_SHOPITEM
        return
    end
end

---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
---@param seed integer
local function morph_slot_spawn(spawnEntry, seed)
    if spawnEntry.type ~= EntityType.ENTITY_SLOT then
        return
    end

    local rng = RNG(); rng:SetSeed(seed, 68)

    if spawnEntry.variant == SlotVariant.SHELL_GAME and Lib.EntitySlot.IsAvailable(SlotVariant.HELL_GAME) and
    g_Game:GetDevilRoomDeals() > 0 and rng:RandomInt(4) == 0 then
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
---@field room Room
---@field spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
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

---@param room Room
---@param doorSlot DoorSlot
---@param spawnCoordinates Vector
local function is_nerve_close_to_door_slot(room, doorSlot, spawnCoordinates)
    if not room:IsDoorSlotAllowed(doorSlot) then
        return false
    end

    local doorGridCoordinates = get_grid_coordinates(room, room:GetGridIndex(room:GetDoorSlotPosition(doorSlot)))
    return manhattan_distance(doorGridCoordinates, spawnCoordinates) < 4
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
local function nerve_ending_stage_modifier(io)
    if not (io.gateOpen and io.rng:RandomInt(5) == 0) then
        return false
    end

    local spawnCoordinates = get_grid_coordinates(io.room, io.gridIdx)

    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1, 1 do
        if is_nerve_close_to_door_slot(io.room, i, spawnCoordinates) then
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

---@param room Room
---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
---@param gridIdx integer
---@param rng RNG
---@return boolean appliedModifier
local function try_stage_npc_variant(room, spawnEntry, gridIdx, rng)
    local stage = Lib.Level.GetTrueAbsoluteStage(g_Level)
    local stageType = g_Level:GetStageType()
    local isAltPath = Lib.Level.IsAltPath(g_Level)

    ---@type Decomp.Entity.SubSystem.Spawn.Switch.TryStageSpawnModifiersIO
    local switchIO = {
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
        gateOpen = g_PersistentGameData:Unlocked(Achievement.THE_GATE_IS_OPEN),
    }

    local TryStageSpawnModifiers = switch_TryStageSpawnModifiers[spawnEntry.type] or switch_TryStageSpawnModifiers.default
    return TryStageSpawnModifiers(switchIO)
end

local s_HasHardRareSpawnVariant = Table.CreateDictionary({
    EntityType.ENTITY_CLOTTY, EntityType.ENTITY_MULLIGAN, EntityType.ENTITY_MAW,
    EntityType.ENTITY_BOIL, EntityType.ENTITY_VIS, EntityType.ENTITY_LEECH,
    EntityType.ENTITY_WALKINGBOIL
})

---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
---@param rng RNG
local function try_rare_hard_npc_variant(spawnEntry, rng)
    if s_HasHardRareSpawnVariant[spawnEntry.type] and rng:RandomInt(100) == 0 then
        spawnEntry.variant = 2
    end
end

---@class Decomp.Entity.SubSystem.Spawn.Switch.TryAltNpcVariantIO
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
    if Lib.Level.GetTrueAbsoluteStage(g_Level) >= LevelStage.STAGE2_1 then
        set_all_tries(io)
    end
end

---@param io Decomp.Entity.SubSystem.Spawn.Switch.TryAltNpcVariantIO
local function try_vis_alt_variant(io)
    local stage = Lib.Level.GetTrueAbsoluteStage(g_Level)
    if (stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2) and g_Level:GetStageType() == StageType.STAGETYPE_WOTL then
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

---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
---@param rng RNG
local function try_alt_npc_variant(spawnEntry, rng)
    ---@type Decomp.Entity.SubSystem.Spawn.Switch.TryAltNpcVariantIO
    local switchIO = {
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

---@param room Room
---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
---@param gridIdx integer
---@param rng RNG
local function apply_spawn_modifiers(room, spawnEntry, gridIdx, rng)
    if spawnEntry.type == EntityType.ENTITY_STONEY then
        if (g_Game.Challenge == Challenge.CHALLENGE_APRILS_FOOL) and rng:RandomInt(5) == 0 then -- Also checks for April Fools Special Daily
            spawnEntry.variant = 10
            return
        end
    end

    local modifierApplied = try_stage_npc_variant(room, spawnEntry, gridIdx, rng)
    if modifierApplied then
        return
    end

    try_rare_hard_npc_variant(spawnEntry, rng)
    try_alt_npc_variant(spawnEntry, rng)

    if spawnEntry.type == EntityType.ENTITY_BOOMFLY and spawnEntry.variant == 3 and spawnEntry.subType == 100 then
        spawnEntry.subType = rng:RandomInt(2)
    end
end

---@param room Room
---@param spawnEntry RoomConfig_Entry
---@param gridIdx integer
---@param seed integer
---@return Decomp.Room.SubSystem.Spawn.SpawnEntry fixedSpawnEntry
function RoomSpawn.FixSpawnEntry(room, spawnEntry, gridIdx, seed) -- Room::FixSpawnEntry
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
        fixedEntry.subType = Decomp.Lib.EntityPickup.GetRune(rng:Next())
    end

    if overridden then
        return fixedEntry
    end

    if fixedEntry.type == EntityType.ENTITY_PICKUP then
        fix_pickup_spawns(fixedEntry, rng)
    end

    if fixedEntry.type == EntityType.ENTITY_SLOT then
        fix_slot_spawns(fixedEntry)
    end

    if fixedEntry.type == StbGridType.TRAP_DOOR then
        fix_trapdoor_spawn(room, fixedEntry, rng)
    end

    if fixedEntry.type == EntityType.ENTITY_PICKUP then
        morph_pickup_spawn(fixedEntry)
    end

    if fixedEntry.type == EntityType.ENTITY_SLOT then
        morph_slot_spawn(fixedEntry, seed)
    end

    if 0 < fixedEntry.type and fixedEntry.type <= 1000 then
        fixedEntry.type, fixedEntry.variant = Lib.EntityNPC.Redirect(fixedEntry.type, fixedEntry.variant)
    end

    if room:GetType() == RoomType.ROOM_SECRET_EXIT then -- This should also check if the first flag in RoomConfig_Room is set
        return fixedEntry
    end

    apply_spawn_modifiers(room, fixedEntry, gridIdx, rng)
    return fixedEntry
end


--#endregion

--#region SpawnEntity

---@param roomDescriptor RoomDescriptor
---@return boolean knifeTreasureRoom
local function is_knife_treasure_room(roomDescriptor)
    local roomData = roomDescriptor.Data
    return roomData.Type == RoomType.ROOM_TREASURE and roomData.Subtype == RoomSubType.TREASURE_KNIFE_PIECE
end

---@param room Room
---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
---@param respawning boolean
local function try_block_spawn(room, spawnEntry, respawning)
    if spawnEntry.type == EntityType.ENTITY_PICKUP and spawnEntry.variant == PickupVariant.PICKUP_COLLECTIBLE and
       g_Level:GetCurrentRoomIndex() == GridRooms.ROOM_GENESIS_IDX then
        return true
    end

    if spawnEntry.type == EntityType.ENTITY_PICKUP and
       not respawning and
       g_Level:HasMirrorDimension() and g_Level:GetDimension() == Dimension.KNIFE_PUZZLE and
       not is_knife_treasure_room(g_Level:GetCurrentRoomDesc()) then
        return true
    end

    if spawnEntry.type == EntityType.ENTITY_SLOT and spawnEntry.variant == SlotVariant.DONATION_MACHINE and
       room:GetType() == RoomType.ROOM_SHOP and g_Level:GetCurrentRoomDesc().GridIndex < 0 then
        return true
    end

    return false
end

---@param room Room
---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
---@param rng RNG
local function try_rock_dangerous_morph(room, spawnEntry, rng)
    if g_Level:GetStageType() ~= StageType.STAGETYPE_AFTERBIRTH or room:GetType() ~= RoomType.ROOM_DEFAULT then
        return
    end

    if rng:RandomInt(10) ~= 0 then
        return
    end

    local stage = g_Level:GetStage()
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

---@param room Room
---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
---@param seed integer
---@return boolean morphed
local function try_dirty_mind_morph(room, spawnEntry, seed)
    if room:GetType() == RoomType.ROOM_DUNGEON then
        return false
    end

    local rng = RNG(); rng:SetSeed(seed, 2)
    ---@type EntityPlayer?, RNG?
    local randomPlayer, dirtyMindRNG = PlayerManager.GetRandomCollectibleOwner(CollectibleType.COLLECTIBLE_DIRTY_MIND, rng:Next())
    if not randomPlayer then
        return false
    end

    local chance = math.min(randomPlayer.Luck * 0.005 + 0.0625, 0.1)
    if rng:RandomFloat() > chance then
        return false
    end

    spawnEntry.type = StbGridType.POOP
    spawnEntry.variant = 0
    spawnEntry.subType = 0
    return true
end

---@param room Room
---@return boolean canSpawn
local function can_spawn_trapdoor(room)
    if g_Level:IsNextStageAvailable() then
        return true
    end

    local roomType = room:GetType()
    if roomType == RoomType.ROOM_ERROR or roomType == RoomType.ROOM_SECRET_EXIT or
       g_Level:GetCurrentRoomIndex() == GridRooms.ROOM_GENESIS_IDX or
       (roomType == RoomType.ROOM_BOSS and g_Level:GetCurrentRoomDesc().Data.Subtype == BossType.MOTHER) then
        return true
    end

    return false
end

---@param room Room
---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
---@param rng RNG
---@param gridIdx integer
---@param respawning boolean
local function try_morph_spawn(room, spawnEntry, gridIdx, rng, respawning)
    if spawnEntry.type == StbGridType.ROCK and room:GetTintedRockIdx() == gridIdx then
        return
    end

    local rockSeed = rng:GetSeed()

    local dangerousGridMorph = false -- This should check the 4th flag of the RoomConfig_Room
    if dangerousGridMorph and (spawnEntry.type == StbGridType.ROCK or spawnEntry.type == StbGridType.BOMB_ROCK or spawnEntry.type == StbGridType.ALT_ROCK) then
        try_rock_dangerous_morph(room, spawnEntry, rng)
    end

    if spawnEntry.type == StbGridType.ROCK or spawnEntry.type == StbGridType.BOMB_ROCK or spawnEntry.type == StbGridType.ALT_ROCK then
        if try_dirty_mind_morph(room, spawnEntry, rockSeed) then
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
        if not can_spawn_trapdoor(room) then
            spawnEntry.type = StbGridType.COBWEB
            spawnEntry.variant = 0
            spawnEntry.subType = 0
            return
        end

        if g_Level:HasMirrorDimension() and g_Level:GetDimension() == Dimension.KNIFE_PUZZLE then
            spawnEntry.type = StbGridType.DECORATION
            spawnEntry.variant = 0
            spawnEntry.subType = 0
            return
        end
    end

    if spawnEntry.type == EntityType.ENTITY_SHOPKEEPER then
        if spawnEntry.variant == 0 and rng:RandomInt(4) == 0 and g_PersistentGameData:Unlocked(Achievement.SPECIAL_SHOPKEEPERS) then
            spawnEntry.variant = 3
        end

        if spawnEntry.variant == 1 and rng:RandomInt(4) == 0 and g_PersistentGameData:Unlocked(Achievement.SPECIAL_HANGING_SHOPKEEPERS) then
            spawnEntry.variant = 4
        end
    end

    if spawnEntry.type == StbGridType.DEVIL_STATUE and BossPoolManager.GetRemovedBosses()[BossType.SATAN] then
        spawnEntry.type = StbGridType.ROCK
        spawnEntry.variant = 0
        spawnEntry.subType = 1
        return
    end
end

---@param room Room
---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
---@return boolean cleared
local function consider_room_cleared(room, spawnEntry)
    local roomDesc = g_Level:GetCurrentRoomDesc()
    if (roomDesc.Flags & RoomDescriptor.FLAG_CLEAR) ~= 0 then
        return true
    end

    if room:GetType() == RoomType.ROOM_BOSS and (roomDesc.Flags & RoomDescriptor.FLAG_ROTGUT_CLEARED) ~= 0 then
        return spawnEntry.type ~= EntityType.ENTITY_ROTGUT
    end

    return false
end

---@param room Room
---@return boolean
local function has_room_mutually_exclusive_collectibles(room)
    local roomData = g_Level:GetCurrentRoomDesc().Data
    local roomType = room:GetType()

    if roomType == RoomType.ROOM_ANGEL or roomType == RoomType.ROOM_BOSSRUSH or roomType == RoomType.ROOM_PLANETARIUM then
        return true
    end

    if roomType == RoomType.ROOM_TREASURE and
       ((roomData.Subtype == RoomSubType.TREASURE_OPTIONS or roomData.Subtype == RoomSubType.TREASURE_PAY_TO_PLAY_OPTIONS) or
       Lib.Level.IsAltPath(g_Level)) then
        return true
    end

    return false
end

---@param pickup EntityPickup
local function init_spawned_pickup(pickup)
    pickup.Wait = 0

    if pickup.Type == EntityType.ENTITY_PICKUP and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE and
       (pickup.SubType == CollectibleType.COLLECTIBLE_KNIFE_PIECE_1 or pickup.SubType == CollectibleType.COLLECTIBLE_KNIFE_PIECE_2) then
        pickup:TryInitOptionCycle(0) -- Negate cycles
    end

    Class_EntityPickup.InitFlipState(pickup)
end

---@param room Room
---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
---@param rng RNG
---@param gridIdx integer
---@param respawning boolean
---@return Entity? spawnedEntity
local function spawn_regular_entity(room, spawnEntry, gridIdx, rng, respawning)
    if spawnEntry.type == STB_EFFECT then
        spawnEntry.type = EntityType.ENTITY_EFFECT
    end

    if spawnEntry.type == EntityType.ENTITY_ENVIRONMENT then
        return
    end

    if spawnEntry.type == EntityType.ENTITY_TRIGGER_OUTPUT then
        -- Room::TriggerOutput (Unavailable)
        return
    end

    if spawnEntry.type == EntityType.ENTITY_PICKUP and Lib.Level.IsCorpseEntrance(g_Level) then
        return
    end

    local roomDesc = g_Level:GetCurrentRoomDesc()
    if spawnEntry.type == EntityType.ENTITY_MINECART and (roomDesc.Flags & RoomDescriptor.FLAG_SACRIFICE_DONE) ~= 0 then -- ???
        return
    end

    if consider_room_cleared(room, spawnEntry) and not respawning and
       not Class_Room.is_persistent_room_entity(spawnEntry.type, spawnEntry.variant) and
       not Class_Room.ShouldSaveEntity(spawnEntry.type, spawnEntry.variant, spawnEntry.subType, EntityType.ENTITY_NULL, true) and
       not g_Seeds:HasSeedEffect(SeedEffect.SEED_PACIFIST) and not g_Seeds:HasSeedEffect(SeedEffect.SEED_ENEMIES_RESPAWN) then
        return
    end

    local gridEntity = room:GetGridEntity(gridIdx)
    if gridEntity then
        gridEntity:Destroy(true)
    end

    local position = room:GetGridPosition(gridIdx)
    local entity = g_Game:Spawn(spawnEntry.type, spawnEntry.variant, position, Vector(0, 0), nil, spawnEntry.subType, rng:Next())
    entity.SpawnGridIndex = gridIdx

    local pickup = entity:ToPickup()
    if entity.Type == EntityType.ENTITY_PICKUP and pickup then
        init_spawned_pickup(pickup)
    end

    if Class_Room.ShouldSaveEntity(spawnEntry.type, spawnEntry.variant, spawnEntry.subType, EntityType.ENTITY_NULL, false) then
        roomDesc:AddRestrictedGridIndex(gridIdx)
    end

    if pickup and has_room_mutually_exclusive_collectibles(room) and entity.Type == EntityType.ENTITY_PICKUP and
       spawnEntry.type == EntityType.ENTITY_PICKUP and spawnEntry.variant == PickupVariant.PICKUP_COLLECTIBLE then
        pickup.OptionsPickupIndex = 1
    end

    return entity
end

---@param room Room
---@param spawnEntry Decomp.Room.SubSystem.Spawn.SpawnEntry
---@param gridIdx integer
---@param respawning boolean
local function spawn_stb_grid_entity(room, spawnEntry, gridIdx, respawning)
    if respawning then
        return
    end

    if spawnEntry.type == StbGridType.RAIL then
        -- Setup Rail
        return
    end

    if spawnEntry.type == StbGridType.RAIL_PIT then
        -- Setup Rail
        spawnEntry.type = StbGridType.PIT
    end

    if room:GetGridEntity(gridIdx) then
        return
    end

    -- TODO
end

---@param room Room
---@param gridIdx integer
---@param spawnEntry RoomConfig_Entry
---@param seed integer
---@param respawning boolean
---@return Entity? spawnedEntity
function RoomSpawn.SpawnEntity(room, gridIdx, spawnEntry, seed, respawning) -- Room::spawn_entity
    local rng = RNG(); rng:SetSeed(seed, 35)
    local fixedSpawnEntry = Class_Room.FixSpawnEntry(room, spawnEntry, gridIdx, seed)

    if try_block_spawn(room, fixedSpawnEntry, respawning) then
        return
    end

    try_morph_spawn(room, fixedSpawnEntry, gridIdx, rng, respawning)

    if 1 <= fixedSpawnEntry.type and fixedSpawnEntry.type <= 999 then
        return spawn_regular_entity(room, fixedSpawnEntry, gridIdx, rng, respawning)
    else
        spawn_stb_grid_entity(room, fixedSpawnEntry, gridIdx, respawning)
    end
end

---@param desc RoomDescriptor
local function is_restricted_grid_idx(desc, gridIdx)
    local restrictedGrids = desc:GetRestrictedGridIndexes()
    for index, value in ipairs(restrictedGrids) do
        if value == gridIdx then
            return true
        end
    end

    return false
end

---@param room Room
---@param desc RoomDescriptor
---@param spawns CppList_RoomConfigSpawn
---@param index integer
---@param rng RNG
local function try_spawn_entry(room, desc, spawns, index, rng)
    local spawn = spawns:Get(index)
    local randomFloat = rng:RandomFloat()
    if spawn.EntryCount == 0 then
        return
    end

    local spawnEntry = spawn:PickEntry(randomFloat)
    local gridIdx = get_grid_idx(room, Vector(spawn.X + 1, spawn.Y + 1))
    if is_restricted_grid_idx(desc, gridIdx) then
        return
    end

    Class_Room.spawn_entity(room, gridIdx, spawnEntry, rng:GetSeed(), nil, false)
end

---@param room Room
---@param desc RoomDescriptor
---@param config RoomConfigRoom
function RoomSpawn.SpawnRoomConfigEntities(room, desc, config) -- Room::Init
    local spawnRNG = RNG(); spawnRNG:SetSeed(desc.SpawnSeed, 11)
    local spawns = config.Spawns

    for i = 0, #spawns - 1, 1 do
        try_spawn_entry(room, desc, spawns, i, spawnRNG)
    end
end