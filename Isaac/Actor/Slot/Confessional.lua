--#region Dependencies

local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local ILevel = require("Isaac.Interface.Level")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local IItemPool = require("Isaac.Interface.ItemPool")
local IHud = require("Isaac.Interface.HUD")
local IsaacUtils = require("Isaac.Utils.Common")
local PickupUtils = require("Isaac.Gameplay.Pickup.PickupUtils")
local SlotLib = require("Isaac.Actor.Lib.Slot")

--#endregion

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_WIGGLE = "Wiggle"
local ANIMATION_PRIZE = "Prize"
local ANIMATION_NO_PRIZE = "NoPrize"
local ANIMATION_DEATH = "Death"
local ANIMATION_HEART_INSERT = "HeartInsert"

local EVENT_PRIZE = "Prize"

local SOUND_HEAL_BROKEN_HEART = SoundEffect.SOUND_THUMBSUP
local SOUND_GET_SOUL_HEART = SoundEffect.SOUND_HOLY
local SOUND_GET_ETERNAL_HEART = SoundEffect.SOUND_SUPERHOLY

local STRING_YOU_FEEL_BLESSED = "#YOU_FEEL_BLESSED"

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param player Component.Entity.Player
local function give_prize(slot, ctx, player)
    local myRng = slot.m_dropRNG

    local explode = myRng:RandomInt(20) == 0
    if explode then
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION,
            slot.m_position, VECTOR_ZERO, nil,
            0, IsaacUtils.Random()
        )

        IEntitySlot.CreateDropsFromExplosion(ctx, slot)
        slot.m_sprite:Play(ANIMATION_DEATH, false)
        slot.m_state = SlotState.DESTROYED
        return
    end

    local collectiblePrize = myRng:RandomInt(30) == 0
    if collectiblePrize then
        local game = ctx.game

        slot:Remove(ctx)
        IGame.Spawn(
            ctx, game,
            EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION,
            slot.m_position, VECTOR_ZERO, nil,
            0, IsaacUtils.Random()
        )

        local redemption = game.m_devilRoomDeals > 0 and IItemPool.RemoveCollectible(game.m_itemPool, ctx, CollectibleType.COLLECTIBLE_REDEMPTION, true, false)
        local collectible

        if redemption then
            collectible = CollectibleType.COLLECTIBLE_REDEMPTION
        else
            local itemPool = game.m_itemPool
            local pool = IItemPool.GetPoolForRoom(itemPool, ctx, RoomType.ROOM_ANGEL, slot.m_initSeed)
            collectible = IItemPool.GetCollectible(itemPool, ctx, pool, slot.m_initSeed, 0, CollectibleType.COLLECTIBLE_BIBLE)
        end

        if collectible ~= CollectibleType.COLLECTIBLE_NULL then
            local seed = myRng:Next()
            local pedestal = IGame.Spawn(
                ctx, game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
                slot.m_position, VECTOR_ZERO, nil,
                collectible, seed
            )

            ---@cast pedestal Component.Entity.Pickup
            IEntityPickup.SetAlternatePedestal(ctx, pedestal, PedestalType.CONFESSIONAL)
            pedestal:Update(ctx)
        end

        return
    end

    local healBrokenHearts = player.m_brokenHearts > 0
    if healBrokenHearts then
        IEntityPlayer.AddBrokenHearts(ctx, player, -1)
        IEntityPlayer.UseActiveItem(ctx, player, CollectibleType.COLLECTIBLE_NECRONOMICON, UseFlag.USE_NOANIM, -1, 0)
        IManager.PlaySound(ctx, SOUND_HEAL_BROKEN_HEART, 1.0, 2, false, 1.0)
        return
    end

    local addSoulHearts = myRng:RandomInt(2) == 0
        and not (IEntityPlayer.HasTrinket(ctx, player, TrinketType.TRINKET_DAEMONS_TAIL, false)
        and PickupUtils.TryDaemonsTailBlock(IEntityPlayer.GetTrinketRNG(player, TrinketType.TRINKET_DAEMONS_TAIL)))

    if addSoulHearts then
        IEntityPlayer.AddSoulHearts(ctx, player, 2)
        IManager.PlaySound(ctx, SOUND_GET_SOUL_HEART, 1.0, 2, false, 1.0)
        IEntityPlayer.AnimateHappy(ctx, player)
        return
    end

    local addEternalHeart = myRng:RandomInt(16) == 0
        and not (IEntityPlayer.HasTrinket(ctx, player, TrinketType.TRINKET_DAEMONS_TAIL, false)
        and PickupUtils.TryDaemonsTailBlock(IEntityPlayer.GetTrinketRNG(player, TrinketType.TRINKET_DAEMONS_TAIL)))

    if addEternalHeart then
        IEntityPlayer.AddEternalHearts(ctx, player, 1)
        IManager.PlaySound(ctx, SOUND_GET_ETERNAL_HEART, 1.0, 2, false, 1.0)
        IEntityPlayer.AnimateHappy(ctx, player)
        return
    end

    -- angel chance
    local game = ctx.game
    local level = game.m_level
    ILevel.RemoveCurses(ctx, level, LevelCurse.CURSE_NONE)
    ILevel.AddAngelRoomChance(level, 0.1)
    local youFeelBlessed = IManager.GetString_DefaultCategory(ctx.manager, STRING_YOU_FEEL_BLESSED)
    IHud.ShowFortuneTextWrapped(game.m_hud, ctx, youFeelBlessed)
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param player Component.Entity.Player
local function Confessional_UpdateTimeoutPrize(slot, ctx, player)
    local shouldUpdate = slot.m_timeout == 0
    if not shouldUpdate then
        return
    end

    local mySprite = slot.m_sprite
    local myRng = slot.m_dropRNG

    local event_choosePrize = mySprite:IsPlaying(ANIMATION_WIGGLE)
    if event_choosePrize then
        local chance = ctx.game.m_difficulty == Difficulty.DIFFICULTY_HARD and 0.25 or 0.3
        if IEntityPlayer.HasCollectible(ctx, player, CollectibleType.COLLECTIBLE_LUCKY_FOOT, false) then
            chance = chance * 1.5
        end

        local prize = myRng:RandomFloat() < chance
        if prize then
            mySprite:Play(ANIMATION_PRIZE, false)
        else
            mySprite:Play(ANIMATION_NO_PRIZE, false)
        end
    end

    local event_prize = mySprite:IsEventTriggered(EVENT_PRIZE)
    if event_prize then
        give_prize(slot, ctx, player)
    end
end

--- no logic
local function Confessional_UpdatePrize()
    return
end

---@type Slot.Switch.PaySlot
local function Confessional_PaySlot(slot, ctx, player)
    return SlotLib.PayHeart(slot, ctx, player, 1.0)
end

---@type Slot.Switch.PlayerInteraction
local function Confessional_PlayerInteraction(slot, ctx)
    SlotLib.SlotMachine_SetupPrize(slot)
    slot.m_sprite:PlayOverlay(ANIMATION_HEART_INSERT, true)
end

---@class Actor.Confessional
local Module = {}

--#region Module

Module.UpdateTimeoutPrize = Confessional_UpdateTimeoutPrize
Module.UpdatePrize = Confessional_UpdatePrize
Module.PaySlot = Confessional_PaySlot
Module.PlayerInteraction = Confessional_PlayerInteraction

--#endregion

return Module