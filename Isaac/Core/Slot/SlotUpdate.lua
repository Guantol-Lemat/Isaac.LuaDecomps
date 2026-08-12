--#region Dependencies

local IGame = require("Isaac.Interface.Game")
local IEntity = require("Isaac.Interface.Entity")
local IPlayerManager = require("Isaac.Interface.PlayerManager")
local IsaacUtils = require("Isaac.Utils.Common")
local VectorUtils = require("General.Math.VectorUtils")

local ActorSlot = interface("Isaac.Mechanics.ActorSlot")

--#endregion

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_IDLE = "Idle"
local ANIMATION_WIGGLE = "Wiggle"
local ANIMATION_BROKEN = "Broken"

local EVENT_DISAPPEAR = "Disappear"

local STATE_APPEAR = 0
local STATE_SPECIAL = 5

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function state_appear(slot, ctx)
    local skip = ActorSlot.PreStateAppearUpdate(slot, ctx)
    if skip then return end

    local timeout = slot.m_timeout
    if timeout == 0 then
        local poofSubType = 3
        if ActorSlot.IsBeggar(slot) then
            poofSubType = 2
        end

        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_EFFECT, EffectVariant.POOF01,
            slot.m_position, VECTOR_ZERO, nil,
            poofSubType, IsaacUtils.Random()
        )
    end

    timeout = timeout + 1
    slot.m_timeout = timeout

    if timeout >= 3 then
        slot.m_visible = true
        slot.m_state = 1
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param player Component.Entity.Player
local function state_prize(slot, ctx, player)
    local extraRng = RNG(slot.m_dropRNG:GetSeed(), 3)
    ActorSlot.UpdatePrize(slot, ctx, player, extraRng)

    if slot.m_state == SlotState.REWARD and slot.m_sprite:IsFinished() and ActorSlot.PrizeWaitAnimationEnd(slot) then
        slot.m_state = SlotState.IDLE
        slot.m_sprite:Play(ANIMATION_IDLE, false)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function state_wait_prize(slot, ctx)
    if ActorSlot.IsMachine(slot) and slot.m_sprite:IsFinished() then
        slot.m_sprite:Play(ANIMATION_WIGGLE, false)
    end

    ActorSlot.UpdateStateWaitPrize(slot, ctx)
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function state_destroyed(slot, ctx)
    if ActorSlot.IsMachine(slot) and slot.m_sprite:GetCurrentAnimationData():IsLoopingAnimation() or slot.m_sprite:IsFinished() then
        slot.m_sprite:Play(ANIMATION_BROKEN, false)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function state_disappear(slot, ctx)
    slot.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

    if slot.m_sprite:IsEventTriggered(EVENT_DISAPPEAR) then -- event_disappear
        slot.m_shadowSize = 0.0
    end

    if slot.m_sprite:IsFinished() then
        slot:Remove(ctx)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function state_special(slot, ctx)
    ActorSlot.UpdateStateSpecial(slot, ctx)
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function Update(slot, ctx)
    ActorSlot.PreUpdate(slot, ctx)

    if slot.m_flags & EntityFlag.FLAG_APPEAR ~= 0 then -- setup appear
        slot.m_state = STATE_APPEAR
        slot.m_timeout = 0
        slot.m_flags = slot.m_flags & ~EntityFlag.FLAG_APPEAR

        ActorSlot.SetupAppear(slot, ctx)
    end

    if slot.m_state == STATE_APPEAR then
        state_appear(slot, ctx)
        return
    end

    ActorSlot.PrePhysicsUpdate(slot, ctx)

    local target = slot.m_target.ref
    if not target then
        target = IPlayerManager.GetPlayer(ctx.game.m_playerManager, 0)
    end
    ---@cast target Component.Entity.Player

    if VectorUtils.Equals(slot.m_targetPosition, VECTOR_ZERO) then -- init target position
        slot.m_targetPosition = VectorUtils.Copy(slot.m_position)
        slot.m_velocity = VectorUtils.Copy(VECTOR_ZERO)
    end

    local noTargetHoming = slot.m_state == SlotState.DESTROYED
        and not ActorSlot.IsBeggar(slot) and not ActorSlot.IsDonationMachine(slot)
    if not noTargetHoming then
        slot.m_velocity = slot.m_targetPosition - slot.m_position
    end

    IEntity.MultiplyFriction(slot, 0.8)

    if slot.m_state == SlotState.DESTROYED then
        slot.m_gridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
    end

    ActorSlot.UpdateTriggerTimerLogic(slot, ctx)

    if slot.m_timeout > 0 then
        slot.m_timeout = slot.m_timeout - 1
        if slot.m_timeout == 0 then
            ActorSlot.OnTimeoutEnd(slot, ctx)
        end
    end

    ActorSlot.PostTimeoutUpdate(slot, ctx, target)

    local state = slot.m_state
    if ActorSlot.IsPrizeState(slot) then
        state_prize(slot, ctx, target)
    elseif state == SlotState.REWARD then
        state_wait_prize(slot, ctx)
    elseif state == SlotState.DESTROYED then
        state_destroyed(slot, ctx)
    elseif ActorSlot.IsDisappearState(slot) then
        state_disappear(slot, ctx)
    elseif state == STATE_SPECIAL then
        state_special(slot, ctx)
    end

    if ActorSlot.IsShellGame(slot) then
        ActorSlot.ShellGame_Shuffle(slot, ctx)
    end

    if slot.m_consecutiveCollisionGraceTimer == 0 then
        slot.m_consecutiveCollisionFrames = 0
    else
        slot.m_consecutiveCollisionFrames = slot.m_consecutiveCollisionFrames + 1
        slot.m_consecutiveCollisionGraceTimer = slot.m_consecutiveCollisionGraceTimer - 1
    end

    IEntity.Update(ctx, slot)
    slot.m_shellGame_prizeSprite:Update()
end

---@class Core.Slot.Update
local Module = {}

--#region Module

Module.Update = Update

--#endregion

return Module