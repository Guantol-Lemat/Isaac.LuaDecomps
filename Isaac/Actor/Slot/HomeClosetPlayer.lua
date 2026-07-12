--#region Dependencies

local Enums = require("General.Enums")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local IEntityConfig = require("Isaac.Interface.EntityConfig")
local IGame = require("Isaac.Interface.Game")
local IEntityEffect = require("Isaac.Interface.Entity_Effect")
local IsaacUtils = require("Isaac.Utils.Common")

--#endregion

local eCompletionType = Enums.eCompletionType

local VECTOR_ZERO = Vector(0, 0)

local EVENT_FX = "FX"
local EVENT_POOF = "Poof"

local TAINTED_PLAYER = {
    [PlayerType.PLAYER_ISAAC + 1] = PlayerType.PLAYER_ISAAC_B,
    [PlayerType.PLAYER_MAGDALENE + 1] = PlayerType.PLAYER_MAGDALENE_B,
    [PlayerType.PLAYER_CAIN + 1] = PlayerType.PLAYER_CAIN_B,
    [PlayerType.PLAYER_JUDAS + 1] = PlayerType.PLAYER_JUDAS_B,
    [PlayerType.PLAYER_BLUEBABY + 1] = PlayerType.PLAYER_BLUEBABY_B,
    [PlayerType.PLAYER_EVE + 1] = PlayerType.PLAYER_EVE_B,
    [PlayerType.PLAYER_SAMSON + 1] = PlayerType.PLAYER_SAMSON_B,
    [PlayerType.PLAYER_AZAZEL + 1] = PlayerType.PLAYER_AZAZEL_B,
    [PlayerType.PLAYER_LAZARUS + 1] = PlayerType.PLAYER_LAZARUS_B,
    [PlayerType.PLAYER_EDEN + 1] = PlayerType.PLAYER_EDEN_B,
    [PlayerType.PLAYER_THELOST + 1] = PlayerType.PLAYER_THELOST_B,
    [PlayerType.PLAYER_LAZARUS2 + 1] = PlayerType.PLAYER_LAZARUS_B,
    [PlayerType.PLAYER_BLACKJUDAS + 1] = PlayerType.PLAYER_JUDAS_B,
    [PlayerType.PLAYER_LILITH + 1] = PlayerType.PLAYER_LILITH_B,
    [PlayerType.PLAYER_KEEPER + 1] = PlayerType.PLAYER_KEEPER_B,
    [PlayerType.PLAYER_APOLLYON + 1] = PlayerType.PLAYER_APOLLYON_B,
    [PlayerType.PLAYER_THEFORGOTTEN + 1] = PlayerType.PLAYER_THEFORGOTTEN_B,
    [PlayerType.PLAYER_THESOUL + 1] = PlayerType.PLAYER_THEFORGOTTEN_B,
    [PlayerType.PLAYER_BETHANY + 1] = PlayerType.PLAYER_BETHANY_B,
    [PlayerType.PLAYER_JACOB + 1] = PlayerType.PLAYER_JACOB_B,
    [PlayerType.PLAYER_ESAU + 1] = PlayerType.PLAYER_JACOB_B,
}

---@type Slot.Switch.Init
local function HomeClosetPlayer_Init(slot, ctx)
    local player = IGame.GetPlayer(ctx.game, 0)
    local taintedId = TAINTED_PLAYER[player.m_playerType] or player.m_playerType
    local playerConfig = IEntityConfig.GetPlayer(ctx.manager.m_entityConfig, taintedId)

    if playerConfig then
        local mySprite = slot.m_sprite
        local skinPath = playerConfig.m_skinPath

        for i = 1, mySprite:GetLayerCount(), 1 do
            local layerId = i - 1
            mySprite:ReplaceSpritesheet(layerId, skinPath, false)
        end

        mySprite:LoadGraphics()
    end
end

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

Module.Init = HomeClosetPlayer_Init
Module.UpdateState = HomeClosetPlayer_UpdateState
Module.UpdatePrize = HomeClosetPlayer_UpdatePrize

--#endregion

return Module