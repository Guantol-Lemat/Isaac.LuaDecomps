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

local ePickVelType = Enums.ePickVelType
local eCompletionType = Enums.eCompletionType

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_APPEAR = "Appear"
local ANIMATION_COIN_ICONS = "Prize"
local ANIMATION_DEATH = "Death"

local LAYER_ICON_HUNDREDS = 1
local LAYER_ICON_DECIMALS = 2
local LAYER_ICON_ONES = 3

local EVENT_COIN_INSERT = "CoinInsert"

local SOUND_COIN_INSERT = SoundEffect.SOUND_COIN_SLOT

local DONATION_ACHIEVEMENTS = {
    {2, Achievement.LUCKY_PENNIES},
    {14, Achievement.SPECIAL_HANGING_SHOPKEEPERS},
    {33, Achievement.WOODEN_NICKEL},
    {68, Achievement.CAIN_HOLDS_PAPERCLIP},
    {111, Achievement.EVERYTHING_IS_TERRIBLE_2},
    {234, Achievement.SPECIAL_SHOPKEEPERS},
    {439, Achievement.EVE_HOLDS_RAZOR_BLADE},
    {500, Achievement.GREEDIER},
    {666, Achievement.STORE_KEY},
    {879, Achievement.LOST_HOLDS_HOLY_MANTLE},
}

---@param slot Component.Entity.Slot
---@param coinCount integer
local function set_sprite_coin_icons(slot, coinCount)
    local mySprite = slot.m_sprite

    mySprite:SetFrame(ANIMATION_COIN_ICONS, 0)
    mySprite:SetLayerFrame(LAYER_ICON_HUNDREDS, (coinCount / 100) % 10)
    mySprite:SetLayerFrame(LAYER_ICON_DECIMALS, (coinCount / 10) % 10)
    mySprite:SetLayerFrame(LAYER_ICON_ONES, (coinCount % 10))
end

---@type Slot.Switch.UpdatePrize
local function GreedDonationMachine_Init(slot, ctx)
    local game = ctx.game

    slot.m_positionOffset.Y = -8.0
    slot.m_sizeMulti = Vector(1.5, 0.75)

    local coinCount = IPersistentGameData.GetEventCounter(ctx.manager.m_persistentGameData, EventCounter.GREED_DONATION_MACHINE_COUNTER)
    set_sprite_coin_icons(slot, coinCount)

    local remove = IGame.AchievementUnlocksDisallowed(game, ctx)
    if remove then
        slot:Remove(ctx)
    end

    local jammed = IGame.GetStateFlag(game, GameStateFlag.STATE_GREED_SLOT_JAMMED)
    if jammed then
        local animation = IEntitySlot.RandomCoinJamAnim()
        slot.m_sprite:Play(animation, false)
        slot.m_state = SlotState.DESTROYED
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function GreedDonationMachine_CustomSetupAppear(slot, ctx)
    slot.m_sprite:Play(ANIMATION_APPEAR, false)
    slot.m_visible = true
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function GreedDonationMachine_CustomUpdateAppear(slot, ctx)
    local sprite = slot.m_sprite
    sprite:Update()

    local event_endAppear = sprite:IsFinished()
    if not event_endAppear then
        return
    end

    slot.m_state = SlotState.IDLE
    local coinCount = IPersistentGameData.GetEventCounter(ctx.manager.m_persistentGameData, EventCounter.GREED_DONATION_MACHINE_COUNTER)
    set_sprite_coin_icons(slot, coinCount)
end

---@type Slot.Switch.UpdatePrize
local function GreedDonationMachine_UpdatePrize(slot, ctx, player, extraRng)
    local mySprite = slot.m_sprite
    local event_coinInsert = mySprite:IsOverlayEventTriggered(EVENT_COIN_INSERT)

    if not event_coinInsert then
        return
    end

    local game = ctx.game
    local persistentGameData = ctx.manager.m_persistentGameData
    local myRng = slot.m_dropRNG

    slot.m_state = SlotState.IDLE
    IPersistentGameData.IncreasePlayerEventCounter(persistentGameData, ctx, eCompletionType.GREED_DONATION_MACHINE, player.m_playerType, false)

    local coinCount = IPersistentGameData.GetEventCounter(persistentGameData, EventCounter.GREED_DONATION_MACHINE_COUNTER)
    coinCount = (coinCount % 1000) + 1
    IPersistentGameData.IncreaseEventCounter(persistentGameData, ctx, EventCounter.GREED_DONATION_MACHINE_COUNTER, 1)
    set_sprite_coin_icons(slot, coinCount)

    for i = 1, #DONATION_ACHIEVEMENTS, 1 do
        local achievementDesc = DONATION_ACHIEVEMENTS[i]
        if coinCount >= achievementDesc[1] then
            IPersistentGameData.TryUnlock(persistentGameData, ctx, achievementDesc[2])
        end
    end

    if coinCount >= 999 then
        local unlockedNow = IPersistentGameData.TryUnlock(persistentGameData, ctx, Achievement.GENEROSITY)
        if unlockedNow then
            -- celebrate
            local fireworks = IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_EFFECT, EffectVariant.FIREWORKS,
                slot.m_position, VECTOR_ZERO, slot,
                0, IsaacUtils.Random()
            )
            ---@cast fireworks Component.Entity.Effect
            fireworks.m_timeout = 450
            fireworks.m_positionOffset = Vector(0.0, -80.0)
            fireworks:Update(ctx)
        end
    end

    local overflow = coinCount >= 1000
    if overflow then
        IPersistentGameData.TryUnlock(persistentGameData, ctx, Achievement.KEEPER)

        IGame.Spawn(
            ctx, game,
            EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION,
            slot.m_position, VECTOR_ZERO, nil,
            0, IsaacUtils.Random()
        )

        mySprite:Play(ANIMATION_DEATH, false)
        slot.m_state = SlotState.DESTROYED

        for i = 1, 15, 1 do
            local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, nil)
            IGame.Spawn(
                ctx, game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,
                slot.m_position, velocity, nil,
                CoinSubType.COIN_DIME, myRng:Next()
            )
        end
    end

    local beforeOverflow = coinCount == 999
    if beforeOverflow then
        -- prevent accidental blow up
        slot.m_consecutiveCollisionFrames = 0
        slot.m_timeout = 20
    else
        slot.m_timeout = math.floor(math.max(15 - slot.m_consecutiveCollisionFrames / 10, 0))
    end

    IManager.PlaySound(ctx, SOUND_COIN_INSERT, 1.0, 2, false, 1.0)
    local jam = slot.m_state ~= SlotState.DESTROYED
        and (myRng:RandomFloat() * 100.0 < IEntityPlayer.GetGreedDonationBreakChance(ctx, player))

    if jam then
        local animation = IEntitySlot.RandomCoinJamAnim()
        mySprite:Play(animation, false)
        IGame.SetStateFlag(game, GameStateFlag.STATE_GREED_SLOT_JAMMED, true)
        slot.m_state = SlotState.DESTROYED
    end
end

---@type Slot.Switch.PaySlot
local function GreedDonationMachine_PaySlot(slot, ctx, player)
    return SlotLib.PayCoins(ctx, player, 1)
end

local GreedDonationMachine_PlayerInteraction = SlotLib.DonationMachine_PlayerInteraction

---no logic, cannot be destroyed
---@type Slot.Switch.CustomDestroy
local function GreedDonationMachine_CustomDestroy(slot, ctx)
    return
end

---@class Actor.GreedDonationMachine
local Module = {}

--#region Module

Module.Init = GreedDonationMachine_Init
Module.CustomSetupAppear = GreedDonationMachine_CustomSetupAppear
Module.CustomUpdateAppear = GreedDonationMachine_CustomUpdateAppear
Module.UpdatePrize = GreedDonationMachine_UpdatePrize
Module.PaySlot = GreedDonationMachine_PaySlot
Module.PlayerInteraction = GreedDonationMachine_PlayerInteraction
Module.CustomDestroy = GreedDonationMachine_CustomDestroy

--#endregion

return Module