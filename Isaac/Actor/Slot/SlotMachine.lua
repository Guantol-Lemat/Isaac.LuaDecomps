--#region Dependencies

local Enums = require("Isaac.Enums")
local IManager = require("Isaac.Interface.Manager")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local IGame = require("Isaac.Interface.Game")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local IsaacUtils = require("Isaac.Utils.Common")
local SlotLib = require("Isaac.Actor.Lib.Slot")

--#endregion

---@alias SlotMachine.Switch.SolvePrize Slot.Switch.UpdatePrize

local ePickVelType = Enums.ePickVelType

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_WIGGLE_END = "WiggleEnd"
local ANIMATION_PRIZE = "Prize"
local ANIMATION_DEATH = "Death"

local LAYER_SLOT_1 = 1
local LAYER_SLOT_2 = 2
local LAYER_SLOT_3 = 3

local FRAME_SYMBOL_FLY = 0
local FRAME_SYMBOL_DOLLAR = 1
local FRAME_SYMBOL_BOMB = 2
local FRAME_SYMBOL_COIN = 3
local FRAME_SYMBOL_KEY = 4
local FRAME_SYMBOL_PILL = 5
local FRAME_SYMBOL_HEART = 6
local NUM_SYMBOL_FRAMES = 7

local SOUND_NO_PRIZE = SoundEffect.SOUND_SCAMPER
local SOUND_SPAWN_PRIZE = SoundEffect.SOUND_SLOTSPAWN
local SOUND_PAY = SoundEffect.SOUND_COIN_SLOT

local PRIZE_FLY = 3
local PRIZE_BOMB = 4
local PRIZE_HEART_1 = 5
local PRIZE_HEART_2 = 6
local PRIZE_KEY = 7
local PRIZE_PILL = 8
local PRIZE_DOLLAR = 9
local PRIZE_COIN_1 = 10
local PRIZE_COIN_2 = 11
local PRIZE_COIN_3 = 12

local PRIZE_TO_ICON = {
    [PRIZE_FLY] = FRAME_SYMBOL_FLY,
    [PRIZE_BOMB] = FRAME_SYMBOL_BOMB,
    [PRIZE_HEART_1] = FRAME_SYMBOL_HEART,
    [PRIZE_HEART_2] = FRAME_SYMBOL_HEART,
    [PRIZE_KEY] = FRAME_SYMBOL_KEY,
    [PRIZE_PILL] = FRAME_SYMBOL_PILL,
    [PRIZE_DOLLAR] = FRAME_SYMBOL_DOLLAR,
    [PRIZE_COIN_1] = FRAME_SYMBOL_COIN,
    [PRIZE_COIN_2] = FRAME_SYMBOL_COIN,
    [PRIZE_COIN_3] = FRAME_SYMBOL_COIN,
}

---@param slot Component.Entity.Slot
---@param iconFrame integer
local function set_icon(slot, iconFrame)
    local mySprite = slot.m_sprite
    mySprite:SetLayerFrame(LAYER_SLOT_1, iconFrame)
    mySprite:SetLayerFrame(LAYER_SLOT_2, iconFrame)
    mySprite:SetLayerFrame(LAYER_SLOT_3, iconFrame)
end

---@param slot Component.Entity.Slot
---@param rng RNG
local function set_no_prize_icon(slot, rng)
    local mySprite = slot.m_sprite

    local slot1
    local slot2
    local slot3

    repeat
        slot1 = rng:RandomInt(NUM_SYMBOL_FRAMES)
        slot2 = rng:RandomInt(NUM_SYMBOL_FRAMES)
        slot3 = rng:RandomInt(NUM_SYMBOL_FRAMES)
    until slot1 ~= slot2 or slot2 ~= slot3

    mySprite:SetLayerFrame(LAYER_SLOT_1, slot1)
    mySprite:SetLayerFrame(LAYER_SLOT_2, slot2)
    mySprite:SetLayerFrame(LAYER_SLOT_3, slot3)
end

---@type SlotMachine.Switch.SolvePrize
local function solve_heart(slot, ctx, player, extraRng)
    IManager.PlaySound(ctx, SOUND_SPAWN_PRIZE, 1.0, 2, false, 1.0)
    local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
    IGame.Spawn(
        ctx, ctx.game,
        EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART,
        slot.m_position, velocity, nil,
        0, slot.m_dropRNG:Next()
    )
    slot.m_state = SlotState.IDLE
end

---@type SlotMachine.Switch.SolvePrize
local function solve_coin(slot, ctx, player, extraRng)
    local coinCount = math.max(slot.m_dropRNG:RandomInt(3), 1)
    for i = 1, coinCount, 1 do
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,
            slot.m_position, velocity, nil,
            0, slot.m_dropRNG:Next()
        )
    end
    slot.m_state = SlotState.IDLE
end

---@type table<integer, SlotMachine.Switch.SolvePrize>
local SWITCH_SOLVE_PRIZE = {
    [PRIZE_FLY] = function (slot, ctx, player, extraRng)
        local myRng = slot.m_dropRNG

        local prettyFly = myRng:RandomInt(3) == 0
        if prettyFly then
            IEntityPlayer.AddPrettyFly(ctx, player)
            IEntityPlayer.AnimateHappy(ctx, player)
            slot.m_state = SlotState.IDLE

            return
        end

        -- enemy fly
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)

        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_FLY, 0,
            slot.m_position, velocity, nil,
            0, myRng:Next()
        )

        IEntityPlayer.AnimateSad(ctx, player)
        slot.m_state = SlotState.IDLE
    end,
    [PRIZE_BOMB] = function (slot, ctx, player, extraRng)
        IManager.PlaySound(ctx, SOUND_SPAWN_PRIZE, 1.0, 2, false, 1.0)
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB,
            slot.m_position, velocity, nil,
            0, slot.m_dropRNG:Next()
        )
        slot.m_state = SlotState.IDLE
    end,
    [PRIZE_HEART_1] = solve_heart,
    [PRIZE_HEART_2] = solve_heart,
    [PRIZE_KEY] = function (slot, ctx, player, extraRng)
        IManager.PlaySound(ctx, SOUND_SPAWN_PRIZE, 1.0, 2, false, 1.0)
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY,
            slot.m_position, velocity, nil,
            0, slot.m_dropRNG:Next()
        )
        slot.m_state = SlotState.IDLE
    end,
    [PRIZE_PILL] = function (slot, ctx, player, extraRng)
        IManager.PlaySound(ctx, SOUND_SPAWN_PRIZE, 1.0, 2, false, 1.0)
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL,
            slot.m_position, velocity, nil,
            0, slot.m_dropRNG:Next()
        )
        slot.m_state = SlotState.IDLE
    end,
    [PRIZE_DOLLAR] = function (slot, ctx, player, extraRng)
        IManager.PlaySound(ctx, SOUND_SPAWN_PRIZE, 1.0, 2, false, 1.0)
        IGame.ButterBeanFart(ctx, ctx.game, slot.m_position, 9.0, slot, false, false)

        slot:Remove(ctx)

        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION,
            slot.m_position, VECTOR_ZERO, nil,
            0, IsaacUtils.Random()
        )

        local dollar = IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
            slot.m_position, VECTOR_ZERO, nil,
            CollectibleType.COLLECTIBLE_DOLLAR, slot.m_dropRNG:Next()
        )
        ---@cast dollar Component.Entity.Pickup
        IEntityPickup.SetAlternatePedestal(ctx, dollar, PedestalType.SLOT_MACHINE)
        dollar:Update(ctx)

        slot.m_state = SlotState.IDLE
    end,
    [PRIZE_COIN_1] = solve_coin,
    [PRIZE_COIN_2] = solve_coin,
    [PRIZE_COIN_3] = solve_coin,
}

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function SlotMachine_OnTimeoutEnd(slot, ctx)
    if slot.m_state == SlotState.REWARD then
        slot.m_sprite:Play(ANIMATION_WIGGLE_END)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param player Component.Entity.Player
local function SlotMachine_TrySetPrize(slot, ctx, player)
    local event_setPrize = slot.m_timeout == 0 and slot.m_sprite:IsFinished(ANIMATION_WIGGLE_END)
    if not event_setPrize then
        return
    end

    local mySprite = slot.m_sprite
    local myRng = slot.m_dropRNG

    mySprite:SetFrame(ANIMATION_PRIZE, 0)
    local explode = myRng:RandomInt(50) == 0

    if explode then
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION,
            slot.m_position, VECTOR_ZERO, nil,
            0, IsaacUtils.Random()
        )

        IEntitySlot.CreateDropsFromExplosion(slot, ctx)
        slot.m_state = SlotState.DESTROYED
        mySprite:Play(ANIMATION_DEATH)

        return
    end

    slot.m_prizeType = 0
    local hasLuckyFoot = IEntityPlayer.HasCollectible(ctx, player, CollectibleType.COLLECTIBLE_LUCKY_FOOT, false)
    local prizePool = hasLuckyFoot and 15 or 21
    local prize = myRng:RandomInt(prizePool) + 3

    -- this reduces the chance of dollar appearing, as well as slightly reducing the chance of a coin appearing
    local rarerDollar = prize > 8 and myRng:RandomInt(10) ~= 0
    if rarerDollar then
        prize = prize + 1
    end

    local blockKey = prize == PRIZE_KEY and myRng:RandomInt(3) == 0
    if blockKey then
        prize = PRIZE_COIN_1
    end

    local blockHeart = (prize == PRIZE_HEART_1 or prize == PRIZE_HEART_2)
        and IEntityPlayer.HasTrinket(ctx, player, TrinketType.TRINKET_DAEMONS_TAIL, false)
        and IEntityPlayer.GetTrinketRNG(player, TrinketType.TRINKET_DAEMONS_TAIL):RandomInt(5) ~= 0

    if blockHeart then
        prize = PRIZE_COIN_1
    end

    local hardModeNoPrize = ctx.game.m_difficulty == Difficulty.DIFFICULTY_HARD and myRng:RandomInt(2) == 0
    if hardModeNoPrize then
        prize = 0
    end

    slot.m_prizeType = prize

    local prizeIcon = PRIZE_TO_ICON[prize]
    local noPrize = prizeIcon == nil

    if noPrize then
        set_no_prize_icon(slot, myRng)
        IManager.PlaySound(ctx, SOUND_NO_PRIZE, 1.0, 2, false, 1.0)
    else
        set_icon(slot, prizeIcon)
    end
end

---@type Slot.Switch.UpdatePrize
local function SlotMachine_UpdatePrize(slot, ctx, player, extraRng)
    local mySprite = slot.m_sprite
    local shouldUpdate = mySprite:GetAnimation() == ANIMATION_PRIZE

    if not shouldUpdate then
        return
    end

    local solvePrize = SWITCH_SOLVE_PRIZE[slot.m_prizeType]
    if solvePrize then
        solvePrize(slot, ctx, player, extraRng)
    end
end

---@type Slot.Switch.PaySlot
local function SlotMachine_PaySlot(slot, ctx, player)
    return SlotLib.PayCoins(ctx, player, 1)
end

---@type Slot.Switch.PlayerInteraction
local function SlotMachine_PlayerInteraction(slot, ctx)
    IManager.PlaySound(ctx, SOUND_PAY, 1.0, 2, false, 1.0)
    SlotLib.SlotMachine_SetupPrize(slot)
end

---@type Slot.Switch.OnDestroy
local function SlotMachine_OnDestroy(slot, ctx)
    local persistentData = ctx.manager.m_persistentGameData
    IPersistentGameData.IncreaseEventCounter(persistentData, ctx, EventCounter.SLOT_MACHINES_BROKEN, 1)
end

---@class Actor.SlotMachine
local Module = {}

--#region Module

Module.OnTimeoutEnd = SlotMachine_OnTimeoutEnd
Module.TrySetPrize = SlotMachine_TrySetPrize
Module.UpdatePrize = SlotMachine_UpdatePrize
Module.PaySlot = SlotMachine_PaySlot
Module.PlayerInteraction = SlotMachine_PlayerInteraction
Module.OnDestroy = SlotMachine_OnDestroy

--#endregion

return Module