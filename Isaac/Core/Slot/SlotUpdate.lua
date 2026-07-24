--#region Dependencies

local IGame = require("Isaac.Interface.Game")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IPlayerManager = require("Isaac.Interface.PlayerManager")
local IsaacUtils = require("Isaac.Utils.Common")
local VectorUtils = require("General.Math.VectorUtils")
local SlotUtils = require("Isaac.Core.Slot.SlotUtils")
local Log = require("General.Log")

local Actor_SlotMachine = require("Isaac.Actor.Slot.SlotMachine")
local Actor_BloodDonationMachine = require("Isaac.Actor.Slot.BloodDonationMachine")
local Actor_FortuneTellingMachine = require("Isaac.Actor.Slot.FortuneTellingMachine")
local Actor_Beggar = require("Isaac.Actor.Slot.Beggar")
local Actor_DevilBeggar = require("Isaac.Actor.Slot.DevilBeggar")
local Actor_ShellGame = require("Isaac.Actor.Slot.ShellGame")
local Actor_KeyMaster = require("Isaac.Actor.Slot.KeyMaster")
local Actor_DonationMachine = require("Isaac.Actor.Slot.DonationMachine")
local Actor_BombBum = require("Isaac.Actor.Slot.BombBum")
local Actor_ShopRestockMachine = require("Isaac.Actor.Slot.ShopRestockMachine")
local Actor_GreedDonationMachine = require("Isaac.Actor.Slot.GreedDonationMachine")
local Actor_MomsDressingTable = require("Isaac.Actor.Slot.MomsDressingTable")
local Actor_BatteryBum = require("Isaac.Actor.Slot.BatteryBum")
local Actor_HomeClosetPlayer = require("Isaac.Actor.Slot.HomeClosetPlayer")
local Actor_CraneGame = require("Isaac.Actor.Slot.CraneGame")
local Actor_Confessional = require("Isaac.Actor.Slot.Confessional")
local Actor_RottenBeggar = require("Isaac.Actor.Slot.RottenBeggar")

--#endregion

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_IDLE = "Idle"
local ANIMATION_APPEAR = "Appear"
local ANIMATION_PAY_PRIZE = "PayPrize"
local ANIMATION_WIGGLE = "Wiggle"
local ANIMATION_BROKEN = "Broken"

local EVENT_DISAPPEAR = "Disappear"

---@alias Slot.Switch.UpdatePrize fun(slot: Component.Entity.Slot, ctx: Context.Common, player: Component.Entity.Player, extraRng: RNG)

---@type Slot.Switch.UpdatePrize
local function UpdatePrize_default(slot)
    Log.LogMessage(0, string.format("Slot type %d is not implemented!\n", slot.m_variant))
end

local Switch_UpdatePrize = {
    [SlotVariant.SLOT_MACHINE] = Actor_SlotMachine.UpdatePrize,
    [SlotVariant.BLOOD_DONATION_MACHINE] = Actor_BloodDonationMachine.UpdatePrize,
    [SlotVariant.FORTUNE_TELLING_MACHINE] = Actor_FortuneTellingMachine.UpdatePrize,
    [SlotVariant.BEGGAR] = Actor_Beggar.UpdatePrize,
    [SlotVariant.DEVIL_BEGGAR] = Actor_DevilBeggar.UpdatePrize,
    [SlotVariant.SHELL_GAME] = Actor_ShellGame.UpdatePrize,
    [SlotVariant.KEY_MASTER] = Actor_KeyMaster.UpdatePrize,
    [SlotVariant.DONATION_MACHINE] = Actor_DonationMachine.UpdatePrize,
    [SlotVariant.BOMB_BUM] = Actor_BombBum.UpdatePrize,
    [SlotVariant.SHOP_RESTOCK_MACHINE] = Actor_ShopRestockMachine.UpdatePrize,
    [SlotVariant.GREED_DONATION_MACHINE] = Actor_GreedDonationMachine.UpdatePrize,
    [SlotVariant.MOMS_DRESSING_TABLE] = UpdatePrize_default,
    [SlotVariant.BATTERY_BUM] = Actor_BatteryBum.UpdatePrize,
    [SlotVariant.HOME_CLOSET_PLAYER] = Actor_HomeClosetPlayer.UpdatePrize,
    [SlotVariant.HELL_GAME] = Actor_ShellGame.UpdatePrize,
    [SlotVariant.CRANE_GAME] = Actor_CraneGame.UpdatePrize,
    [SlotVariant.CONFESSIONAL] = Actor_Confessional.UpdatePrize,
    [SlotVariant.ROTTEN_BEGGAR] = Actor_RottenBeggar.UpdatePrize
}

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function state_appear(slot, ctx)
    -- if only there was a way to check if the slot was specifically a GreedDonationMachine
    local isGreedDonationMachine = slot.m_sprite:GetAnimation() == ANIMATION_APPEAR
    if isGreedDonationMachine then
        Actor_GreedDonationMachine.CustomUpdateAppear(slot, ctx)
        return
    end

    local timeout = slot.m_timeout
    if timeout == 0 then
        local poofSubType = 3
        if SlotUtils.IsBeggar(slot.m_variant) then
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
local function handle_reward(slot, ctx, player)
    ---@type SlotVariant
    local variant = slot.m_variant

    local function should_trigger_reward_logic()
        local state = slot.m_state
        local isShellGame = variant == SlotVariant.SHELL_GAME or variant == SlotVariant.HELL_GAME

        -- shell game is the exception
        if isShellGame and state == SlotState.REWARD_SHELL_GAME then
            return true
        end

        local waitPayPrizeAnimation = SlotUtils.IsBeggar(variant)
            or variant == SlotVariant.HOME_CLOSET_PLAYER

        if waitPayPrizeAnimation and slot.m_sprite:IsPlaying(ANIMATION_PAY_PRIZE) and not slot.m_sprite:IsFinished() then
            return false
        end

        return state == SlotState.REWARD and slot.m_timeout == 0
    end

    if not should_trigger_reward_logic() then
        local state = slot.m_state
        if state == SlotState.REWARD then
            local usesWiggleAnimation = variant == SlotVariant.SLOT_MACHINE
                or variant == SlotVariant.BLOOD_DONATION_MACHINE or variant == SlotVariant.FORTUNE_TELLING_MACHINE
                or variant == SlotVariant.CRANE_GAME or variant == SlotVariant.CONFESSIONAL

            if usesWiggleAnimation and slot.m_sprite:IsFinished() then
                slot.m_sprite:Play(ANIMATION_WIGGLE, false)
            end
        elseif state == SlotState.DESTROYED then
            local usesBrokenAnimation = variant == SlotVariant.SLOT_MACHINE
                or variant == SlotVariant.BLOOD_DONATION_MACHINE or variant == SlotVariant.FORTUNE_TELLING_MACHINE
                or variant == SlotVariant.CRANE_GAME or variant == SlotVariant.CONFESSIONAL

            if usesBrokenAnimation and slot.m_sprite:GetCurrentAnimationData():IsLoopingAnimation() or slot.m_sprite:IsFinished() then
                slot.m_sprite:Play(ANIMATION_BROKEN, false)
            end
        elseif state == SlotState.PAYOUT and variant ~= SlotVariant.CRANE_GAME then -- state 4 is special for crane game
            slot.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            local event_disappear = slot.m_sprite:IsEventTriggered(EVENT_DISAPPEAR)

            if event_disappear then
                slot.m_shadowSize = 0.0
            end

            local event_remove = slot.m_sprite:IsFinished()
            if event_remove then
                slot:Remove(ctx)
            end
        end

        if variant == SlotVariant.HOME_CLOSET_PLAYER then
            Actor_HomeClosetPlayer.UpdateState(slot, ctx)
        elseif variant == SlotVariant.BOMB_BUM then
            Actor_BombBum.UpdateState(slot, ctx)
        end

        return
    end

    local extraRng = RNG(slot.m_dropRNG:GetSeed(), 3)

    local UpdatePrize = Switch_UpdatePrize[slot.m_variant] or UpdatePrize_default
    UpdatePrize(slot, ctx, player, extraRng)

    local returnsIdle = variant ~= SlotVariant.SLOT_MACHINE
        and variant ~= SlotVariant.DONATION_MACHINE
        and variant ~= SlotVariant.SHOP_RESTOCK_MACHINE
        and variant ~= SlotVariant.GREED_DONATION_MACHINE

    if slot.m_state == SlotState.REWARD and slot.m_sprite:IsFinished() and returnsIdle then
        slot.m_state = SlotState.IDLE
        slot.m_sprite:Play(ANIMATION_IDLE, false)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function Update(slot, ctx)
    ---@type SlotVariant
    local variant = slot.m_variant

    if variant == SlotVariant.CRANE_GAME then
        Actor_CraneGame.PreUpdate(slot, ctx)
    elseif variant == SlotVariant.MOMS_DRESSING_TABLE then
        Actor_MomsDressingTable.PreUpdate(slot, ctx)
    end

    if slot.m_flags & EntityFlag.FLAG_APPEAR ~= 0 then
        slot.m_state = 0
        slot.m_timeout = 0
        slot.m_flags = slot.m_flags & ~EntityFlag.FLAG_APPEAR

        if variant == SlotVariant.GREED_DONATION_MACHINE then
            Actor_GreedDonationMachine.CustomSetupAppear(slot, ctx)
        end
    end

    if slot.m_state == 0 then
        state_appear(slot, ctx)
        return
    end

    if variant == SlotVariant.ROTTEN_BEGGAR then
        Actor_RottenBeggar.SpawnWorms(slot, ctx)
    end

    local target = slot.m_target.ref
    if not target then
        target = IPlayerManager.GetPlayer(ctx.game.m_playerManager, 0)
    end
    ---@cast target Component.Entity.Player

    if VectorUtils.Equals(slot.m_targetPosition, VECTOR_ZERO) then
        slot.m_targetPosition = VectorUtils.Copy(slot.m_position)
        slot.m_velocity = VectorUtils.Copy(VECTOR_ZERO)
    end

    local noTargetHoming = slot.m_state == SlotState.DESTROYED
        and variant ~= SlotVariant.SHELL_GAME and variant ~= SlotVariant.HELL_GAME
        and variant ~= SlotVariant.DONATION_MACHINE and variant ~= SlotVariant.GREED_DONATION_MACHINE
    if not noTargetHoming then
        slot.m_velocity = slot.m_targetPosition - slot.m_position
    end
    slot.m_friction = slot.m_friction * 0.8

    if slot.m_state == SlotState.DESTROYED then
        slot.m_gridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
    end

    if variant == SlotVariant.SHOP_RESTOCK_MACHINE then
        Actor_ShopRestockMachine.HandleRestock(slot, ctx)
    elseif variant == SlotVariant.BOMB_BUM then
        Actor_BombBum.BombedSpawnBomb(slot, ctx)
    end

    if slot.m_timeout > 0 then
        slot.m_timeout = slot.m_timeout - 1
        if slot.m_timeout == 0 and variant == SlotVariant.SLOT_MACHINE then
            Actor_SlotMachine.OnTimeoutEnd(slot, ctx)
        end
    end

    -- post timeout update
    if variant == SlotVariant.SLOT_MACHINE then
        Actor_SlotMachine.TrySetPrize(slot, ctx, target)
    elseif variant == SlotVariant.CRANE_GAME then
        Actor_CraneGame.UpdateTimeoutPrize(slot, ctx)
    elseif variant == SlotVariant.CONFESSIONAL then
        Actor_Confessional.UpdateTimeoutPrize(slot, ctx, target)
    end

    handle_reward(slot, ctx, target)

    local isShellGame = variant == SlotVariant.SHELL_GAME or variant == SlotVariant.HELL_GAME
    if isShellGame then
        Actor_ShellGame.PostUpdate(slot, ctx)
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

---@class Gameplay.Slot.Update
local Module = {}

--#region Module

Module.Update = Update

--#endregion

return Module