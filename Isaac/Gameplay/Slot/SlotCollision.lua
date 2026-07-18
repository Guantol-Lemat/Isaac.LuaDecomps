--#region Dependencies

local IManager = require("Isaac.Interface.Manager")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IItemConfig = require("Isaac.Interface.ItemConfig")
local SlotUtils = require("Isaac.Gameplay.Slot.SlotUtils")

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
local PlayerEffects = require("Isaac.Interface.Custom.PlayerEffects")

--#endregion

---@alias Slot.Switch.PaySlot fun(slot: Component.Entity.Slot, ctx: Context.Common, player: Component.Entity.Player): boolean, boolean?
---@alias Slot.Switch.PlayerInteraction fun(slot: Component.Entity.Slot, ctx: Context.Common, player: Component.Entity.Player, collider: Component.Entity.Player)

---@type Slot.Switch.PaySlot
local function PaySlot_default(slot)
    return false
end

---@type table<SlotVariant, Slot.Switch.PaySlot>
local Switch_PaySlot = {
    [SlotVariant.SLOT_MACHINE] = Actor_SlotMachine.PaySlot,
    [SlotVariant.BLOOD_DONATION_MACHINE] = Actor_BloodDonationMachine.PaySlot,
    [SlotVariant.FORTUNE_TELLING_MACHINE] = Actor_FortuneTellingMachine.PaySlot,
    [SlotVariant.BEGGAR] = Actor_Beggar.PaySlot,
    [SlotVariant.DEVIL_BEGGAR] = Actor_DevilBeggar.PaySlot,
    [SlotVariant.SHELL_GAME] = Actor_ShellGame.ShellGame_PaySlot,
    [SlotVariant.KEY_MASTER] = Actor_KeyMaster.PaySlot,
    [SlotVariant.DONATION_MACHINE] = Actor_DonationMachine.PaySlot,
    [SlotVariant.BOMB_BUM] = Actor_BombBum.PaySlot,
    [SlotVariant.SHOP_RESTOCK_MACHINE] = Actor_ShopRestockMachine.PaySlot,
    [SlotVariant.GREED_DONATION_MACHINE] = Actor_GreedDonationMachine.PaySlot,
    [SlotVariant.MOMS_DRESSING_TABLE] = PaySlot_default,
    [SlotVariant.BATTERY_BUM] = Actor_BatteryBum.PaySlot,
    [SlotVariant.HOME_CLOSET_PLAYER] = Actor_HomeClosetPlayer.PaySlot,
    [SlotVariant.HELL_GAME] = Actor_ShellGame.HellGame_PaySlot,
    [SlotVariant.CRANE_GAME] = Actor_CraneGame.PaySlot,
    [SlotVariant.CONFESSIONAL] = Actor_Confessional.PaySlot,
    [SlotVariant.ROTTEN_BEGGAR] = Actor_RottenBeggar.PaySlot
}

---@type Slot.Switch.PlayerInteraction
local function PlayerInteraction_default(slot, ctx, player)
end

---@type table<SlotVariant, Slot.Switch.PlayerInteraction>
local Switch_PlayerInteraction = {
    [SlotVariant.SLOT_MACHINE] = Actor_SlotMachine.PlayerInteraction,
    [SlotVariant.BLOOD_DONATION_MACHINE] = Actor_BloodDonationMachine.PlayerInteraction,
    [SlotVariant.FORTUNE_TELLING_MACHINE] = Actor_FortuneTellingMachine.PlayerInteraction,
    [SlotVariant.BEGGAR] = Actor_Beggar.PlayerInteraction,
    [SlotVariant.DEVIL_BEGGAR] = Actor_DevilBeggar.PlayerInteraction,
    [SlotVariant.SHELL_GAME] = Actor_ShellGame.PlayerInteraction,
    [SlotVariant.KEY_MASTER] = Actor_KeyMaster.PlayerInteraction,
    [SlotVariant.DONATION_MACHINE] = Actor_DonationMachine.PlayerInteraction,
    [SlotVariant.BOMB_BUM] = Actor_BombBum.PlayerInteraction,
    [SlotVariant.SHOP_RESTOCK_MACHINE] = Actor_ShopRestockMachine.PlayerInteraction,
    [SlotVariant.GREED_DONATION_MACHINE] = Actor_GreedDonationMachine.PlayerInteraction,
    [SlotVariant.MOMS_DRESSING_TABLE] = PlayerInteraction_default,
    [SlotVariant.BATTERY_BUM] = Actor_BatteryBum.PlayerInteraction,
    [SlotVariant.HOME_CLOSET_PLAYER] = Actor_HomeClosetPlayer.PlayerInteraction,
    [SlotVariant.HELL_GAME] = Actor_ShellGame.PlayerInteraction,
    [SlotVariant.CRANE_GAME] = Actor_CraneGame.PlayerInteraction,
    [SlotVariant.CONFESSIONAL] = Actor_Confessional.PlayerInteraction,
    [SlotVariant.ROTTEN_BEGGAR] = Actor_RottenBeggar.PlayerInteraction
}

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param collider Component.Entity.Player
---@param isForced boolean
---@return boolean? ignoreCollision
local function handle_player_collision(slot, ctx, collider, isForced)
    ---@type SlotVariant
    local variant = slot.m_variant

    if variant == SlotVariant.MOMS_DRESSING_TABLE then
        Actor_MomsDressingTable.CustomHandlePlayerCollision(slot, ctx, collider)
        return
    end

    local function can_interact_with_player()
        if slot.m_state == SlotState.CHOICE then
            local isShellGame = variant == SlotVariant.SHELL_GAME or variant == SlotVariant.HELL_GAME
            return isShellGame
        end

        if slot.m_state == SlotState.IDLE then
            if slot.m_timeout > 0 then
                return false
            end

            if SlotUtils.IsBeggar(variant) then
                local isBusy = not slot.m_sprite:GetCurrentAnimationData():IsLoopingAnimation() and slot.m_sprite:IsPlaying()
                if isBusy then
                    return false
                end
            end

            return true
        end

        return false
    end

    if not can_interact_with_player() then
        return
    end

    local target = IEntityPlayer.GetEffectTarget(collider)
    if not isForced then
        local PaySlot = Switch_PaySlot[variant] or PaySlot_default
        local payed, ignoreCollision = PaySlot(slot, ctx, target)

        if not payed then
            return ignoreCollision
        end
    end

    IEntity.SetTarget(slot, target)

    if SlotUtils.IsBeggar(variant) then
        PlayerEffects.BethsEssence_OnBeggarPay(target, ctx, slot)
    end

    local PlayerInteraction = Switch_PlayerInteraction[slot.m_variant] or PlayerInteraction_default
    PlayerInteraction(slot, ctx, target, collider)
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param collider Component.Entity
---@param low boolean
---@return boolean skipCollision
local function HandleCollision(slot, ctx, collider, low)
    local isForced = IEntity.IsForcedCollision()

    if collider.m_type == EntityType.ENTITY_PLAYER then
        ---@cast collider Component.Entity.Player
        local ignoreCollision = handle_player_collision(slot, ctx, collider, isForced)
        if not ignoreCollision then
            return false
        end
    end

    local updatePlayerCooldown = slot.m_state ~= SlotState.DESTROYED
        and collider.m_type == EntityType.ENTITY_PLAYER and collider.m_variant == PlayerVariant.PLAYER
    if updatePlayerCooldown then
        slot.m_consecutiveCollisionGraceTimer = 4
    end

    local ignoreCollision = IEntity.IsEnemy(collider) or collider.m_type == EntityType.ENTITY_BOMB
    return ignoreCollision
end

---@class Gameplay.Slot.Collision
local Module = {}

--#region Module

Module.HandleCollision = HandleCollision

--#endregion

return Module