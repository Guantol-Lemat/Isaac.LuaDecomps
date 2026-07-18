--#region Dependencies

local Enums = require("General.Enums")
local IManager = require("Isaac.Interface.Manager")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local IGame = require("Isaac.Interface.Game")
local ILevel = require("Isaac.Interface.Level")
local IRoom = require("Isaac.Interface.Room")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local IEntityNPC = require("Isaac.Interface.Entity_NPC")
local IItemPool = require("Isaac.Interface.ItemPool")
local IsaacUtils = require("Isaac.Utils.Common")
local PlayerEffects = require("Isaac.Interface.Custom.PlayerEffects")
local SlotLib = require("Isaac.Actor.Lib.Slot")

--#endregion

local eGetCollectibleFlag = Enums.eGetCollectibleFlag

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_IDLE = "Idle"
local ANIMATION_TELEPORT = "Teleport"
local ANIMATION_PAY_SHUFFLE = "PayShuffle"
local ANIMATION_SHELL_PRIZE = {
    [1] = "Shell1Prize",
    [2] = "Shell2Prize",
    [3] = "Shell3Prize",
}

local PRIZE_ANIMATION_DEFAULT = "Prizes"

local EVENT_PRIZE = "Prize"
local EVENT_SHUFFLE = "Shuffle"

local SOUND_SPAWN = SoundEffect.SOUND_SLOTSPAWN
local SOUND_NO_PRIZE = SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ
local SOUND_SHUFFLE = SoundEffect.SOUND_SHELLGAME
local SOUND_PAY = SoundEffect.SOUND_SCAMPER

local BLUE_SPIDER_PRIZE = PickupVariant.PICKUP_NULL

local SHELL_GAME_PRIZE_POOL = {
    PickupVariant.PICKUP_HEART, PickupVariant.PICKUP_COIN,
    PickupVariant.PICKUP_KEY, PickupVariant.PICKUP_BOMB,
}

local SHELL_GAME_LAYER_TO_PRIZE = {
    [0 + 1] = PickupVariant.PICKUP_COLLECTIBLE,
    [1 + 1] = PickupVariant.PICKUP_BOMB,
    [2 + 1] = PickupVariant.PICKUP_HEART,
    [3 + 1] = PickupVariant.PICKUP_KEY,
    [4 + 1] = PickupVariant.PICKUP_COIN,
    [5 + 1] = true, -- skull layer
}

local HELL_GAME_PRIZE_POOL = {
    PickupVariant.PICKUP_HEART, PickupVariant.PICKUP_COIN,
    PickupVariant.PICKUP_KEY, PickupVariant.PICKUP_BOMB,
    PickupVariant.PICKUP_TAROTCARD, BLUE_SPIDER_PRIZE
}

local HELL_GAME_LAYER_TO_PRIZE = {
    [0 + 1] = BLUE_SPIDER_PRIZE,
    [1 + 1] = PickupVariant.PICKUP_BOMB,
    [2 + 1] = PickupVariant.PICKUP_HEART,
    [3 + 1] = PickupVariant.PICKUP_KEY,
    [4 + 1] = PickupVariant.PICKUP_COIN,
    [5 + 1] = true, -- skull layer
    [6 + 1] = PickupVariant.PICKUP_TAROTCARD,
    [7 + 1] = PickupVariant.PICKUP_COLLECTIBLE,
}

local LAYER_COLLECTIBLE = 7

---@param slot Component.Entity.Slot
---@return Vector
local function get_shell_position_offset(slot)
    return Vector((slot.m_shellGame_shellIndex - 1) * 37.0, 5.0)
end

---@param slot Component.Entity.Slot
---@return Vector
local function get_shell_base_velocity(slot)
    return Vector((slot.m_shellGame_shellIndex - 1) * 4.0, 4.0)
end

---A custom version of EntityPickup.get_random_pickup_velocity
---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@return Vector position
---@return Vector velocity
local function get_random_pickup_velocity(slot, ctx)
    local position = get_shell_position_offset(slot)
    local baseVelocity = get_shell_base_velocity(slot)
    local velocity

    local tries = 0
    local validVelocity = false
    local room = ctx.game.m_level.m_room

    repeat
        local randomDirection = IsaacUtils.RandomVector()
        velocity = baseVelocity + randomDirection * 2.0
        local checkPosition = slot.m_position + (velocity * 7.0)
        validVelocity = IRoom.CheckLine(ctx, room, position, checkPosition, LineCheckMode.RAYCAST, 0, false, false)
    until tries > 10 or validVelocity

    return position, velocity
end

---@type Slot.Switch.UpdatePrize
local function award_prize(slot, ctx, player)
    local myRng = slot.m_dropRNG
    local prize = myRng:RandomInt(3) == 0
        or (IEntityPlayer.HasCollectible(ctx, player, CollectibleType.COLLECTIBLE_LUCKY_FOOT, false)
        and IEntityPlayer.GetCollectibleRNG(player, CollectibleType.COLLECTIBLE_LUCKY_FOOT):RandomInt(3) == 0)

    if not prize then
        IManager.PlaySound(ctx, SOUND_NO_PRIZE, 1.0, 2, false, 1.0)
        local position = slot.m_position + get_shell_position_offset(slot)

        if slot.m_variant == SlotVariant.HELL_GAME then
            IEntityNPC.ThrowSpider(ctx, position, nil, VECTOR_ZERO, false, -30.0)
        else
            local randomDirection = IsaacUtils.RandomVector()
            local baseVelocity = get_shell_base_velocity(slot)
            local velocity = baseVelocity + (randomDirection * 2.0)

            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_ATTACKFLY, 0,
                position, velocity, nil,
                0, myRng:Next()
            )
        end
    end

    IManager.PlaySound(ctx, SOUND_SPAWN, 1.0, 2, false, 1.0)
    local prizeType = slot.m_prizeType

    local prizeCount = 1
    if prizeType == PickupVariant.PICKUP_COIN then
        prizeCount = myRng:RandomInt(2) + 2
    elseif prizeType ~= PickupVariant.PICKUP_COLLECTIBLE then
        prizeCount = math.max(myRng:RandomInt(3), 2)
    end

    if prizeType == BLUE_SPIDER_PRIZE then
        local spawnPosition = slot.m_position + get_shell_position_offset(slot)
        for i = 1, prizeCount, 1 do
            IEntityPlayer.ThrowBlueSpider(ctx, player, spawnPosition, VECTOR_ZERO)
        end

        return
    end

    if prizeType == PickupVariant.PICKUP_COLLECTIBLE then
        if slot.m_variant == SlotVariant.HELL_GAME then
            local game = ctx.game
            local position = IEntitySlot.get_collectible_spawn_pos(slot, ctx)
            local collectible = slot.m_prizeCollectible

            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
                position, VECTOR_ZERO, nil,
                collectible, myRng:Next()
            )

            IItemPool.RemoveCollectible(game.m_itemPool, ctx, collectible, false, false)
        else
            local position = IEntitySlot.get_collectible_spawn_pos(slot, ctx)
            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
                position, VECTOR_ZERO, nil,
                CollectibleType.COLLECTIBLE_SKATOLE, myRng:Next()
            )
        end

        slot.m_state = SlotState.PAYOUT
        slot.m_sprite:Play(ANIMATION_TELEPORT, false)
        return
    end

    -- configure generic pickup spawn
    local pickupSubType = 0
    if prizeType == PickupVariant.PICKUP_HEART and slot.m_variant == SlotVariant.HELL_GAME then
        prizeCount = 1
        pickupSubType = HeartSubType.HEART_BLACK
    end

    if prizeType == PickupVariant.PICKUP_TAROTCARD then
        prizeCount = 1
    end

    -- spawn generic pickup
    for i = 1, prizeCount, 1 do
        local position, velocity = get_random_pickup_velocity(slot, ctx)

        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, prizeType,
            position, velocity, nil,
            pickupSubType, myRng:Next()
        )
    end
end

---@type Slot.Switch.Init
local function ShellGame_Init(slot, ctx)
    slot.m_positionOffset.Y = -8.0
    slot.m_sizeMulti = Vector(3.0, 0.75)
    slot.m_shellGame_prizeSprite = slot.m_sprite:Copy()
end

---@type Slot.Switch.UpdatePrize
local function ShellGame_UpdatePrize(slot, ctx, player, extraRng)
    local mySprite = slot.m_sprite
    mySprite:Play(ANIMATION_SHELL_PRIZE[slot.m_shellGame_shellIndex + 1], false)

    local event_prize = mySprite:IsEventTriggered(EVENT_PRIZE)
    if event_prize then
        award_prize(slot, ctx, player, extraRng)
    end

    local event_returnIdle = mySprite:IsFinished()
    if event_returnIdle then
        slot.m_state = SlotState.IDLE
        mySprite:Play(ANIMATION_IDLE, false)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function ShellGame_PostUpdate(slot, ctx)
    local event_soundShuffle = slot.m_sprite:IsPlaying(ANIMATION_PAY_SHUFFLE) and slot.m_sprite:IsEventTriggered(EVENT_SHUFFLE)
    if event_soundShuffle then
        local pitch = IsaacUtils.RandomFloat() * 0.1 + 1.0
        local volume = IsaacUtils.RandomFloat() * 0.1 + 0.5
        IManager.PlaySound(ctx, SOUND_SHUFFLE, volume, 2, false, pitch)
    end
end

---@param slot Component.Entity.Slot
local function ShellGame_PostRender(slot)
    local prizeSprite = slot.m_shellGame_prizeSprite
    if prizeSprite:IsPlaying() then
        prizeSprite:Render(slot.m_screenPosition, VECTOR_ZERO, VECTOR_ZERO)
    end
end

---@type Slot.Switch.PaySlot
local function ShellGame_PaySlot(slot, ctx, player)
    if slot.m_state == SlotState.IDLE then
        return SlotLib.PayCoins(ctx, player, 1)
    end

    -- the interaction is free if choosing
    return slot.m_state == SlotState.CHOICE
end

---@type Slot.Switch.PaySlot
local function HellGame_PaySlot(slot, ctx, player)
    if slot.m_state == SlotState.IDLE then
        return SlotLib.PayHeart(slot, ctx, player, 1.0)
    end

    -- the interaction is free if choosing
    local payed = slot.m_state == SlotState.CHOICE
    return payed, not payed
end

---@type Slot.Switch.PlayerInteraction
local function ShellGame_PlayerInteraction(slot, ctx, player, collider)
    local isSelecting = slot.m_state == SlotState.CHOICE
        and slot.m_sprite:IsPlaying()

    if isSelecting then
        local delta = collider.m_position.X - slot.m_position.X
        local selectedShell = 1 -- center

        if delta < -20.0 then
            selectedShell = 0 -- left
        elseif delta > 20.0 then
            selectedShell = 2 -- right
        end

        slot.m_shellGame_shellIndex = selectedShell
        slot.m_state = SlotState.REWARD_SHELL_GAME
        return
    end

    local isIdle = slot.m_state == SlotState.IDLE
    if not isIdle then
        return
    end

    -- play
    local mySprite = slot.m_sprite
    local prizeSprite = slot.m_shellGame_prizeSprite
    local myRng = slot.m_dropRNG

    mySprite:Play(ANIMATION_PAY_SHUFFLE, false)
    prizeSprite:Play(PRIZE_ANIMATION_DEFAULT, true)

    if slot.m_variant == SlotVariant.HELL_GAME then
        local prizeIdx = myRng:RandomInt(#HELL_GAME_PRIZE_POOL) + 1
        local collectiblePrize = myRng:RandomInt(13) == 0

        local prizeType = collectiblePrize
            and PickupVariant.PICKUP_COLLECTIBLE
            or HELL_GAME_PRIZE_POOL[prizeIdx]

        slot.m_prizeType = prizeType
        local layers = prizeSprite:GetAllLayers()
        for i = 1, #layers, 1 do
            local layerPrize = HELL_GAME_LAYER_TO_PRIZE[i]
            local isVisible = prizeType == layerPrize
                or layerPrize == true -- always visible

            layers[i]:SetVisible(isVisible)
        end

        if prizeType == PickupVariant.PICKUP_COLLECTIBLE then
            local itemPool = ctx.game.m_itemPool
            local pool = IItemPool.GetPoolForRoom(itemPool, ctx, RoomType.ROOM_DEVIL, slot.m_initSeed)
            local flags = eGetCollectibleFlag.NO_DECREASE
            local collectible = IItemPool.GetCollectible(itemPool, ctx, pool, slot.m_initSeed, flags, CollectibleType.COLLECTIBLE_DEMON_BABY)

            IEntitySlot.SetPrizeCollectible(slot, ctx, collectible)
        end
    else
        local prizeIdx = myRng:RandomInt(#SHELL_GAME_PRIZE_POOL) + 1
        local collectiblePrize = myRng:RandomInt(13) == 0
            and IItemPool.CanSpawnCollectible(ctx.game.m_itemPool, ctx, CollectibleType.COLLECTIBLE_SKATOLE, 0)

        local prizeType = collectiblePrize
            and PickupVariant.PICKUP_COLLECTIBLE
            or SHELL_GAME_PRIZE_POOL[prizeIdx]

        local heartBlock = prizeType == PickupVariant.PICKUP_HEART
            and IEntityPlayer.HasTrinket(ctx, player, TrinketType.TRINKET_DAEMONS_TAIL, false)
            and PlayerEffects.TryDaemonsTailBlock(IEntityPlayer.GetTrinketRNG(player, TrinketType.TRINKET_DAEMONS_TAIL))

        if heartBlock then
            prizeIdx = myRng:RandomInt(3) + 1
            prizeType = SHELL_GAME_PRIZE_POOL[prizeIdx]
        else
            myRng:Next() -- make seed match regardless
        end

        slot.m_prizeType = prizeType
        local layers = prizeSprite:GetAllLayers()
        for i = 1, #layers, 1 do
            local layerPrize = SHELL_GAME_LAYER_TO_PRIZE[i]
            local isVisible = prizeType == layerPrize
                or layerPrize == true -- always visible

            layers[i]:SetVisible(isVisible)
        end
    end

    slot.m_state = SlotState.CHOICE
    IPersistentGameData.IncreaseEventCounter(ctx.manager.m_persistentGameData, ctx, EventCounter.SHELLGAMES_PLAYED, 1)
    IManager.PlaySound(ctx, SOUND_PAY, 1.0, 2, false, 1.0)
end

local ShellGame_OnDestroy = SlotLib.Beggar_Destroy

---@type Slot.Switch.OnSetPrizeCollectible
local function HellGame_OnSetPrizeCollectible(slot, ctx, collectible)
    local prizeSprite = slot.m_shellGame_prizeSprite

    local curseOfBlind = ILevel.GetCurses(ctx, ctx.game.m_level) & LevelCurse.CURSE_OF_BLIND ~= 0
    IEntityPickup.SetupCollectibleGraphics(ctx, prizeSprite, LAYER_COLLECTIBLE, collectible, slot.m_dropRNG:GetSeed(), curseOfBlind)
    prizeSprite:LoadGraphics()
end

---@type Slot.Switch.CustomExplosionDrops
local function HellGame_CustomExplosionDrops(slot, ctx)
    IEntityNPC.ThrowSpider(ctx, slot.m_position, slot, VECTOR_ZERO, false, -30.0)
    IEntityNPC.ThrowSpider(ctx, slot.m_position, slot, VECTOR_ZERO, false, -30.0)
end

---@class Actor.ShellGame
local Module = {}

--#region Module

Module.Init = ShellGame_Init
Module.UpdatePrize = ShellGame_UpdatePrize
Module.PostUpdate = ShellGame_PostUpdate
Module.PostRender = ShellGame_PostRender
Module.ShellGame_PaySlot = ShellGame_PaySlot
Module.HellGame_PaySlot = HellGame_PaySlot
Module.PlayerInteraction = ShellGame_PlayerInteraction
Module.OnDestroy = ShellGame_OnDestroy
Module.HellGame_OnSetPrizeCollectible = HellGame_OnSetPrizeCollectible
Module.HellGame_CustomExplosionDrops = HellGame_CustomExplosionDrops

--#endregion

return Module