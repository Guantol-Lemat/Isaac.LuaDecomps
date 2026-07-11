--#region Dependencies

local Enums = require("General.Enums")
local IManager = require("Isaac.Interface.Manager")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local IGame = require("Isaac.Interface.Game")
local ILevel = require("Isaac.Interface.Level")
local IRoom = require("Isaac.Interface.Room")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local IEntityEffect = require("Isaac.Interface.Entity_Effect")
local IPlayerManager = require("Isaac.Interface.PlayerManager")
local IItemPool = require("Isaac.Interface.ItemPool")
local IHud = require("Isaac.Interface.HUD")
local IsaacUtils = require("Isaac.Utils.Common")
local VectorUtils = require("General.Math.VectorUtils")
local SlotUtils = require("Isaac.Gameplay.Slot.SlotUtils")
local PickupUtils = require("Isaac.Gameplay.Pickup.PickupUtils")

--#endregion

local eCompletionType = Enums.eCompletionType

local VECTOR_ZERO = Vector(0, 0)

local EVENT_FX = "FX"
local EVENT_POOF = "Poof"

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function HomeClosetPlayer_UpdateState(slot, ctx)
    local mySprite = slot.m_sprite

    local waitingReward = slot.m_state == SlotState.REWARD
    if not waitingReward then
        return
    end

    local event_spawnFx = mySprite:IsEventTriggered(EVENT_FX)
    if event_spawnFx then
        local fx = IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_EFFECT, EffectVariant.TEAR_POOF_A,
            slot.m_position, VECTOR_ZERO, nil,
            10, IsaacUtils.Random()
        )

        ---@cast fx Component.Entity.Effect
        local fx_sprite = fx.m_sprite

        IEntityEffect.FollowParent(fx, slot)
        fx.m_depthOffset = -10.0
        local scale = mySprite.Scale
        fx_sprite.Scale = scale
        fx_sprite.Offset = scale * Vector(0.0, -20.0)
        fx.m_flags = fx.m_flags | EntityFlag.FLAG_TRANSITION_UPDATE
        fx:Update(ctx)
        fx.m_rotation = 0.0
    end

    local event_poof = mySprite:IsEventTriggered(EVENT_POOF)
    if event_poof then
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_EFFECT, EffectVariant.POOF01,
            slot.m_position, VECTOR_ZERO, nil,
            0, IsaacUtils.Random()
        )
    end
end

---@type Slot.Switch.UpdatePrize
local function HomeClosetPlayer_UpdatePrize(slot, ctx, player, extraRng)
    slot:Remove(ctx)
    player = IGame.GetPlayer(ctx.game, 0)
    local playerCompletionDef = IPersistentGameData.GetCompletionEventDef(player.m_playerType)

    if playerCompletionDef then
        local def = playerCompletionDef[eCompletionType.TAINTED + 1]
        IPersistentGameData.TryUnlock(ctx.manager.m_persistentGameData, ctx, def.achievement)
    end
end

---@class Actor.HomeClosetPlayer
local Module = {}

--#region Module

Module.UpdateState = HomeClosetPlayer_UpdateState
Module.UpdatePrize = HomeClosetPlayer_UpdatePrize

--#endregion

return Module