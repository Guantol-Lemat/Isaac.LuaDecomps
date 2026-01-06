--#region Dependencies

local BitsetUtils = require("General.Bitset")
local LevelUtils = require("Level.Utils")
local CurseInitLogic = require("Mechanics.Level.Curse.InitLogic")
local SeedsUtils = require("Admin.Seeds.Utils")

--#endregion

---@class LevelInitLogic
local Module = {}

---@param context Context
---@param level LevelComponent
local function hook_pre_level_reset(context, level)
    local game = context:GetGame()
    BitsetUtils.Clear(game.m_gameStateFlags, GameStateFlag.STATE_SECRET_PATH)

    -- fill myosotis pickup buffer
end

---@param context Context
---@param level LevelComponent
local function hook_on_level_reset(context, level)
    -- portal reset
    -- greed wave without hearts picked
    -- hearts picked
    -- can see everything
    -- glitter bombs
    -- donation mod angel
    -- delirium list idx
    -- dungeon room idx and return pos
    -- death certificate backups
    -- greed wave
    -- greed mode treasure room idx
    -- angel room chance mod
    -- evaluate has Boss Challenge

    -- generate perlin maps
end

---@param context Context
---@param level LevelComponent
local function level_reset(context, level)
    -- not everything here is actually reset in the same step, some of these should actually be in init_level_data
    -- but they were all placed together for cohesion and because nothing here uses the generationRNG.

    level.m_currentDimensionLookup = level.m_dimensionLookups[Dimension.NORMAL + 1]
    level.m_dimension = Dimension.NORMAL
    level.m_lastDimension = Dimension.NORMAL
    level.m_levelStateFlags = 0
    level.m_isDevilRoomDisabled = false
    level.m_enterDoor = DoorSlot.NO_DOOR_SLOT
    level.m_leaveDoor = DoorSlot.NO_DOOR_SLOT
    level.m_startingRoomIdx = 84
    -- reset_room_list()

    hook_on_level_reset(context, level)
end

---@param context Context
---@param level LevelComponent
---@param rng RNG
local function hook_init_level_data(context, level, rng)
    CurseInitLogic.Init(context, level, rng)
    -- invalidate hud crafting item
end

---@param context Context
---@param level LevelComponent
---@param rng RNG
local function hook_pre_generate_layout(context, level, rng)
    -- clear generated rooms
    -- load / reset void room configs
end

---@param context Context
---@param level LevelComponent
---@param rng RNG
local function hook_post_generate_layout(context, level, rng)
    level.m_dungeonPlacementSeed = level.m_generationRNG:Next()
    -- calculate delirium distance for each room (if void)
end

---@param context Context
---@param level LevelComponent
---@param rng RNG
local function generate_layout(context, level, rng)
    -- reset current stage id weights
    hook_pre_generate_layout(context, level, rng)
    -- generate layout
    -- precalc_allowed_doors
    hook_post_generate_layout(context, level, rng)
end

---@param context Context
---@param level LevelComponent
---@param rng RNG
local function init_level_data(context, level, rng)
    level.m_curses = 0
    hook_init_level_data(context, level, rng)
end

---@param context Context
---@param level LevelComponent
local function Init(context, level)
    hook_pre_level_reset(context, level)
    level.m_isInitializing = true
    level_reset(context, level)

    local seeds = context:GetSeeds()
    local floor = LevelUtils.GetFloor(level.m_stage, level.m_stageType)
    local seed = SeedsUtils.GetStageSeed(seeds, floor)

    level.m_generationRNG:SetSeed(seed, 35)
    level.m_devilAngelRoomRNG:SetSeed(seed, 2)

    level.m_generationRNG:Next()
    local additionalRNG = RNG(); additionalRNG:SetSeed(level.m_generationRNG:Next(), 35)

    level.m_curses = 0
    hook_init_level_data(context, level, additionalRNG)
    generate_layout(context, level, additionalRNG)

    level.m_roomIdx = level.m_startingRoomIdx
    level.m_lastRoomIdx = level.m_startingRoomIdx

    -- pre_load_starting_room
        -- if backwards path change the roomIdx and last roomIdx
        -- if backasswards change the roomIdx and lastRoomIdx
    -- end

    -- load_room
    -- play music

    -- post_load_starting_room
        -- more backasswards stuff (update room)
        -- evaluate adding key pieces on stage 6
    -- end

    -- post_level_init 
        -- setup next backwards mom and dad sound timer
        -- player manager trigger new stage
        -- itempool unused special item chance related
        -- camera init position
        -- update camera
        -- anm cache free images
        -- post level init callback
    -- end

    level.m_isInitializing = false
end

--#region Module

Module.Init = Init

--#endregion

return Module