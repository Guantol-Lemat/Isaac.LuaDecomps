--#region Dependencies

local Enums = require("General.Enums")
local IManager = require("Isaac.Interface.Manager")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local IsaacUtils = require("Isaac.Utils.Common")
local SlotLib = require("Isaac.Actor.Lib.Slot")

--#endregion

local ePickVelType = Enums.ePickVelType

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_COIN_ICONS = "Prize"
local ANIMATION_DEATH = "Death"

local LAYER_ICON_HUNDREDS = 1
local LAYER_ICON_DECIMALS = 2
local LAYER_ICON_ONES = 3

local EVENT_COIN_INSERT = "CoinInsert"

local SOUND_COIN_INSERT = SoundEffect.SOUND_COIN_SLOT

local DONATION_ACHIEVEMENTS = {
    {10, Achievement.BLUE_MAP},
    {20, Achievement.STORE_UPGRADE_LV1},
    {50, Achievement.THERES_OPTIONS},
    {100, Achievement.STORE_UPGRADE_LV2},
    {150, Achievement.BLACK_CANDLE},
    {200, Achievement.STORE_UPGRADE_LV3},
    {400, Achievement.RED_CANDLE},
    {600, Achievement.STORE_UPGRADE_LV4},
    {900, Achievement.BLUE_CANDLE},
    {999, Achievement.STOP_WATCH},
}

---@param slot Component.Entity.Slot
---@param coinCounter integer
local function set_sprite_coin_icons(slot, coinCounter)
    local mySprite = slot.m_sprite

    mySprite:SetFrame(ANIMATION_COIN_ICONS, 0)
    mySprite:SetLayerFrame(LAYER_ICON_HUNDREDS, (coinCounter / 100) % 10)
    mySprite:SetLayerFrame(LAYER_ICON_DECIMALS, (coinCounter / 10) % 10)
    mySprite:SetLayerFrame(LAYER_ICON_ONES, (coinCounter % 10))
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param player Component.Entity.Player
local function give_karma_prize(slot, ctx, player)
    local myRng = slot.m_dropRNG
    local randomFloat = myRng:RandomFloat()

    local coinPrize = randomFloat < 0.4
    if coinPrize then
        local coinCount = IEntityPlayer.GetTrinketMultiplier(ctx, player, TrinketType.TRINKET_KARMA)
        IEntityPlayer.AddCoins(ctx, player, coinCount)
        return
    end

    local heartPrize = randomFloat < 0.8
    if heartPrize then
        local heartAmount = IEntityPlayer.GetTrinketMultiplier(ctx, player, TrinketType.TRINKET_KARMA) * 2
        IEntityPlayer.AddHearts(ctx, player, heartAmount, false)
        return
    end

    local luckPrize = randomFloat < 0.95
    if luckPrize then
        local luckAmount = IEntityPlayer.GetTrinketMultiplier(ctx, player, TrinketType.TRINKET_KARMA)
        IEntityPlayer.DonateLuck(ctx, player, luckAmount)
        return
    end

    -- beggar prize
    local seed = myRng:Next()
    local position = slot.m_position + Vector(0.0, 40.0)
    position = IRoom.FindFreePickupSpawnPosition(ctx.game.m_level.m_room, position, 0.0, false, false)

    IGame.Spawn(
        ctx, ctx.game,
        EntityType.ENTITY_SLOT, SlotVariant.BEGGAR,
        position, VECTOR_ZERO, slot,
        0, seed
    )
end

---@type Slot.Switch.UpdatePrize
local function DonationMachine_Init(slot, ctx)
    local game = ctx.game

    slot.m_positionOffset.Y = -8.0
    slot.m_sizeMulti = Vector(1.5, 0.75)

    local coinCounter = IPersistentGameData.GetEventCounter(ctx.manager.m_persistentGameData, EventCounter.DONATION_MACHINE_COUNTER)
    set_sprite_coin_icons(slot, coinCounter)

    local remove = IGame.GetStateFlag(game, GameStateFlag.STATE_DONATION_SLOT_BROKEN)
        or IGame.AchievementUnlocksDisallowed(game, ctx)
    if remove then
        slot:Remove(ctx)
    end

    local jammed = IGame.GetStateFlag(game, GameStateFlag.STATE_DONATION_SLOT_JAMMED)
    if jammed then
        local animation = IEntitySlot.RandomCoinJamAnim()
        slot.m_sprite:Play(animation, false)
        slot.m_state = SlotState.DESTROYED
    end

    slot.m_flags = slot.m_flags | EntityFlag.FLAG_NO_KNOCKBACK
end

---@type Slot.Switch.UpdatePrize
local function DonationMachine_UpdatePrize(slot, ctx, player, extraRng)
    local mySprite = slot.m_sprite
    local event_coinInsert = mySprite:IsOverlayEventTriggered(EVENT_COIN_INSERT)

    if not event_coinInsert then
        return
    end

    local persistentGameData = ctx.manager.m_persistentGameData
    local game = ctx.game
    local myRng = slot.m_dropRNG

    slot.m_state = SlotState.IDLE

    local coinCounter = IPersistentGameData.GetEventCounter(persistentGameData, EventCounter.DONATION_MACHINE_COUNTER)
    coinCounter = coinCounter % 1000 + 1
    IPersistentGameData.IncreaseEventCounter(persistentGameData, ctx, EventCounter.DONATION_MACHINE_COUNTER, 1)
    set_sprite_coin_icons(slot, coinCounter)

    local giveLuck = myRng:RandomInt(50) == 0
    if giveLuck then
        IEntityPlayer.DonateLuck(ctx, player, 1)
    end

    local karmaPrize = IEntityPlayer.HasTrinket(ctx, player, TrinketType.TRINKET_KARMA, false)
        and myRng:RandomInt(3) == 0

    if karmaPrize then
        give_karma_prize(slot, ctx, player)
    end

    IGame.DonateAngel(game, 1)
    IGame.DonateGreed(game, 1)

    for i = 1, #DONATION_ACHIEVEMENTS, 1 do
        local achievementDesc = DONATION_ACHIEVEMENTS[i]
        if coinCounter >= achievementDesc[1] then
            IPersistentGameData.TryUnlock(persistentGameData, ctx, achievementDesc[2])
        end
    end

    local overflow = coinCounter > 999
    if overflow then
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

        IGame.SetStateFlag(game, GameStateFlag.STATE_DONATION_SLOT_BROKEN, true)
    end

    local beforeOverflow = coinCounter == 999
    if beforeOverflow then
        -- prevent accidental blow up
        slot.m_consecutiveCollisionFrames = 0
        slot.m_timeout = 20
    else
        slot.m_timeout = math.floor(math.max(15 - slot.m_consecutiveCollisionFrames / 10, 0))
    end

    IManager.PlaySound(ctx, SOUND_COIN_INSERT, 1.0, 2, false, 1.0)
    local jam = slot.m_state ~= SlotState.DESTROYED
        and (myRng:RandomInt(2000) < game.m_donationModGreed * 3)

    if jam then
        local animation = IEntitySlot.RandomCoinJamAnim()
        mySprite:Play(animation, false)
        IGame.SetStateFlag(game, GameStateFlag.STATE_DONATION_SLOT_JAMMED, true)
        slot.m_state = SlotState.DESTROYED
    end
end

---@type Slot.Switch.PaySlot
local function DonationMachine_PaySlot(slot, ctx, player)
    return SlotLib.PayCoins(ctx, player, 1)
end

local DonationMachine_PlayerInteraction = SlotLib.DonationMachine_PlayerInteraction

---@type Slot.Switch.CustomDestroy
local function DonationMachine_CustomDestroy(slot, ctx)
    local destroyed = slot.m_state == SlotState.DESTROYED
    if destroyed then
        return
    end

    local persistentGameData = ctx.manager.m_persistentGameData
    local mySprite = slot.m_sprite
    local myRng = slot.m_dropRNG

    mySprite:Play(ANIMATION_DEATH, false)
    slot.m_state = SlotState.DESTROYED

    local lostCoins = myRng:RandomInt(9) + 7
    local totalCoin = IPersistentGameData.GetEventCounter(persistentGameData, EventCounter.DONATE_MACHINE_COUNTER) % 1000
    lostCoins = math.min(lostCoins, totalCoin)

    IPersistentGameData.IncreaseEventCounter(persistentGameData, ctx, EventCounter.DONATE_MACHINE_COUNTER, -lostCoins)
    local droppedCoins = lostCoins - 1

    for i = 1, droppedCoins, 1 do
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, myRng)
        local seed = myRng:Next()
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,
            slot.m_position, velocity, nil,
            CoinSubType.COIN_PENNY, seed
        )
    end

    local game = ctx.game
    local setFlags = (1 << GameStateFlag.STATE_DONATION_SLOT_BLOWN) | (1 << GameStateFlag.STATE_DONATION_SLOT_BROKEN)
    game.m_gameStateFlags = game.m_gameStateFlags | setFlags
end

---@class Actor.DonationMachine
local Module = {}

--#region Module

Module.Init = DonationMachine_Init
Module.UpdatePrize = DonationMachine_UpdatePrize
Module.PaySlot = DonationMachine_PaySlot
Module.PlayerInteraction = DonationMachine_PlayerInteraction
Module.CustomDestroy = DonationMachine_CustomDestroy

--#endregion

return Module