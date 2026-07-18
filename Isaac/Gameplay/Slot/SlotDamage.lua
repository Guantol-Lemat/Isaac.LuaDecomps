--#region Dependencies

local IEntitySlot = require("Isaac.Interface.Entity_Slot")

local Actor_SlotMachine = require("Isaac.Actor.Slot.SlotMachine")
local Actor_BloodDonationMachine = require("Isaac.Actor.Slot.BloodDonationMachine")
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
local Actor_RottenBeggar = require("Isaac.Actor.Slot.RottenBeggar")

--#endregion

---@alias Slot.Function.TakeDamage fun(slot: Component.Entity.Slot, ctx: Context.Common, damage: number, flags: DamageFlag | integer, source: Component.Entity.EntityRef, damageCountdown: integer)

---@alias Slot.Switch.CustomDestroy Slot.Function.TakeDamage
---@alias Slot.Switch.PreDestroy fun(slot: Component.Entity.Slot, ctx: Context.Common, damage: number, flags: DamageFlag | integer, source: Component.Entity.EntityRef, damageCountdown: integer): boolean
---@alias Slot.Switch.OnDestroy Slot.Function.TakeDamage

---@type table<SlotVariant, Slot.Switch.CustomDestroy>
local Switch_CustomDestroy = {
    [SlotVariant.DONATION_MACHINE] = Actor_DonationMachine.CustomDestroy,
    [SlotVariant.GREED_DONATION_MACHINE] = Actor_GreedDonationMachine.CustomDestroy,
    [SlotVariant.SHOP_RESTOCK_MACHINE] = Actor_ShopRestockMachine.CustomDestroy
}

---@type table<SlotVariant, Slot.Switch.PreDestroy>
local Switch_PreDestroy = {
    [SlotVariant.BOMB_BUM] = Actor_BombBum.PreDestroy
}

---@type table<SlotVariant, Slot.Switch.OnDestroy>
local Switch_OnDestroy = {
    [SlotVariant.SLOT_MACHINE] = Actor_SlotMachine.OnDestroy,
    [SlotVariant.BLOOD_DONATION_MACHINE] = Actor_BloodDonationMachine.OnDestroy,
    [SlotVariant.BEGGAR] = Actor_Beggar.OnDestroy,
    [SlotVariant.DEVIL_BEGGAR] = Actor_DevilBeggar.OnDestroy,
    [SlotVariant.SHELL_GAME] = Actor_ShellGame.OnDestroy,
    [SlotVariant.KEY_MASTER] = Actor_KeyMaster.OnDestroy,
    [SlotVariant.BOMB_BUM] = Actor_BombBum.OnDestroy,
    [SlotVariant.MOMS_DRESSING_TABLE] = Actor_MomsDressingTable.OnDestroy,
    [SlotVariant.BATTERY_BUM] = Actor_BatteryBum.OnDestroy,
    [SlotVariant.HELL_GAME] = Actor_ShellGame.OnDestroy,
    [SlotVariant.ROTTEN_BEGGAR] = Actor_RottenBeggar.OnDestroy,
}

---@param ctx Context.Common
---@param slot Component.Entity.Slot
---@param damage number
---@param flags integer
---@param source Component.Entity.EntityRef
---@param damageCountdown integer
---@return boolean
local function TakeDamage(slot, ctx, damage, flags, source, damageCountdown)
    ---@type SlotVariant
    local variant = slot.m_variant

    if variant == SlotVariant.HOME_CLOSET_PLAYER then
        Actor_HomeClosetPlayer.CustomTakeDamage(slot)
        return false
    end

    if flags & DamageFlag.DAMAGE_EXPLOSION == 0 then
        return false
    end

    -- custom destroy
    local CustomDestroy = Switch_CustomDestroy[variant]
    if CustomDestroy then
        CustomDestroy(slot, ctx, damage, flags, source, damageCountdown)
        return false
    end

    -- destroy
    if slot.m_state == SlotState.DESTROYED then
        return false
    end

    local PreDestroy = Switch_PreDestroy[variant]
    if PreDestroy then
        local destroy = PreDestroy(slot, ctx, damage, flags, source, damageCountdown)
        if not destroy then
            return false
        end
    end

    slot.m_state = SlotState.DESTROYED

    local OnDestroy = Switch_OnDestroy[variant]
    if OnDestroy then OnDestroy(slot, ctx, damage, flags, source, damageCountdown) end

    IEntitySlot.CreateDropsFromExplosion(slot, ctx)
    return true
end

---@class Gameplay.Slot.Damage
local Module = {}

--#region Module

Module.TakeDamage = TakeDamage

--#endregion

return Module