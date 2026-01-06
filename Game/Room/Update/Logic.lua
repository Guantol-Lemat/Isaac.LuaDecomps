--#region Dependencies

local Enums = require("General.Enums")
local RoomUtils = require("Room.Utils")
local GameUtils = require("Game.Utils")
local PlayerManagerUtils = require("Game.PlayerManager.Utils")
local TemporaryEffectsUtils = require("Entity.Player.Inventory.TemporaryEffects")
local LevelUtils = require("Level.Utils")
local DamoclesItems = require("Mechanics.DamoclesItems.Logic")

local BossLifecycle = require("Room.Boss.Lifecycle")

local eMode = Enums.eMode

--#endregion

---@class RoomUpdateLogic
local Module = {}

---@param myContext RoomUpdateContext.Update
---@param room RoomComponent
local function Update(myContext, room)
    local game = myContext.game
    local level = myContext.level
    local playerManager = myContext.playerManager
    local musicManager = myContext.musicManager
    local ambush = myContext.ambush
    local mode = myContext.mode
    local challenge = myContext.challenge
    local frameCount = myContext.frameCount

    local roomDesc = room.m_roomDescriptor
    local temporaryEffects = room.m_temporaryEffects
    local entityList = room.m_entityList
    local roomType = room.m_type

    room.m_interpolatedPositions = false
    local roomFrameCount = RoomUtils.GetFrameCount(myContext, room)

    if roomFrameCount == 1 then
        -- initialization
    end

    if room.m_genesisItems_Countdown > -1 then
        if room.m_genesisItems_Countdown == 0 and level.m_roomIdx == GridRooms.ROOM_GENESIS_IDX then
            -- update genesis Items
        end

        room.m_genesisItems_Countdown = room.m_genesisItems_Countdown - 1
    end

    room.m_ghost_Persists = PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_VADE_RETRO)

    local shouldUpdatePitchSlide = TemporaryEffectsUtils.HasCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION)
    if shouldUpdatePitchSlide then
        -- update pitch 
    end

    if TemporaryEffectsUtils.HasNullEffect(temporaryEffects, NullItemID.ID_REVERSE_STRENGTH) then
        -- fxLayers add PoopFx
    end

    local weirdVector = {}
    if roomFrameCount == 0 then
        if challenge == Challenge.CHALLENGE_SEEING_DOUBLE then
            -- something with weirdVector
        end

        -- something else with G-Fuel and weirdVector
    end

    if room.m_waterLerpColorCountdown > 0 then
        room.m_waterLerpColorCountdown = room.m_waterLerpColorCountdown - 1
    end

    local gridSize = room.m_gridWidth * room.m_gridHeight

    -- remove grid entity tree
    -- update grid entities

    if frameCount % 3 == 0 then
        -- update grid paths
    end

    local shouldAutomaticallyStartBossRush = PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_1)
    if shouldAutomaticallyStartBossRush and roomFrameCount == 4 and roomType == RoomType.ROOM_BOSSRUSH and not RoomUtils.IsClear(room) then
        -- start ambush
    end

    if (roomType == RoomType.ROOM_CHALLENGE or roomType == RoomType.ROOM_BOSSRUSH) and ambush.isActive then
        -- update ambush
    end

    if room.m_cardAgainstHumanity_IsActive then
        -- update card against humanity
    end

    BossLifecycle.UpdateBossCount(room)

    -- entityList::update()

    -- fxLayers::update()

    -- backdrop::update()

    -- hellbackdrop::update()

    if roomFrameCount == 1 then
        -- try play music layer
    end

    local dataminerEffect = TemporaryEffectsUtils.HasCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_DATAMINER)
    if dataminerEffect then
        -- mess up music
    end

    -- temporaryEffects::Update()

    -- update death list

    if not RoomUtils.IsClear(room) and not ambush.isActive then
        -- something with Trigger Output
    end

    if ambush.isActive then
        local clearDelay = 10
        if roomType == RoomType.ROOM_DUNGEON and roomDesc.m_data.m_subtype == 3 then
            clearDelay = 20
        end
        room.m_clearDelay = clearDelay
    else
        -- evaluate clear
    end

    -- check pressure plates triggered
    -- check player enter door

    local stage = level.m_stage
    local stageType = level.m_stageType

    if mode == eMode.GREED then
        -- convert stage to greed
        stageType = StageType.STAGETYPE_ORIGINAL
    end

    -- update stage vfx

    local stageID = LevelUtils.GetStageID(myContext, level)
    if stageID == StbType.DOWNPOUR then
        -- update lightning
    end

    -- update rain
    -- update mist
    -- update water current

    if LevelUtils.IsCorpseEntrance(level) then
        -- set darkness
    end

    if RoomUtils.IsBeastDungeon(room) then
        -- unk
    end

    -- update shock wave

    -- update wall blood

    local flushEffect = TemporaryEffectsUtils.HasCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_FLUSH)
    if flushEffect and roomType ~= RoomType.ROOM_DUNGEON then
        -- update flush water
    end

    -- update lava

    local isPaused = GameUtils.IsPaused(game)
    if (level.m_levelStateFlags & LevelStateFlag.STATE_MAMA_MEGA_USED) ~= 0 and (roomDesc.m_flags & RoomDescriptor.FLAG_MAMA_MEGA) == 0 and frameCount == 1 and not isPaused then
        -- mama mega explosion
    end

    if room.m_slowdownDuration > 0 then
        room.m_slowdownDuration = room.m_slowdownDuration - 1
    end

    -- update greed mode
    -- update ambient sounds

    if room.m_shopRestock_Countdown > 0 then
        local countdown = room.m_shopRestock_Countdown - 1
        if countdown <= 0 then
            countdown = -1
            -- restock partial
        end

        room.m_shopRestock_Countdown = countdown
    end

    if roomType == RoomType.ROOM_SHOP and PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_COUPON) then
        -- coupon effect
    end

    if room.m_curseOfTower_Countdown > 0 then
        -- update m_curseOfTower
        room.m_curseOfTower_Countdown = room.m_curseOfTower_Countdown - 1
    end

    if room.m_pickupVision_Invalidate then
        -- update pickup vision
        room.m_pickupVision_Invalidate = false
    end

    DamoclesItems.Update(myContext, room)

    -- resolve weird vector
    return
end

--#region Module

Module.Update = Update

--#endregion

return Module