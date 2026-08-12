--#region Dependencies

local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local ActorSlot = interface("Isaac.Mechanics.ActorSlot")

--#endregion

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param damage number
---@param flags integer
---@param source Component.Entity.EntityRef
---@param damageCountdown integer
---@return boolean
local function TakeDamage(slot, ctx, damage, flags, source, damageCountdown)
    ---@type SlotVariant
    local variant = slot.m_variant

    local skip = ActorSlot.CustomTakeDamage(slot, ctx, damage, flags, source, damageCountdown)
    if skip then return false end

    if flags & DamageFlag.DAMAGE_EXPLOSION == 0 then
        return false
    end

    skip = ActorSlot.CustomDestroy(slot, ctx, damage, flags, source, damageCountdown)
    if skip then return false end

    -- destroy
    if slot.m_state == SlotState.DESTROYED then
        return false
    end

    local destroy = ActorSlot.PreDestroy(slot, ctx, damage, flags, source, damageCountdown)
    if not destroy then return false end

    slot.m_state = SlotState.DESTROYED
    ActorSlot.OnDestroy(slot, ctx, damage, flags, source, damageCountdown)
    IEntitySlot.CreateDropsFromExplosion(slot, ctx)

    return true
end

---@class Gameplay.Slot.Damage
local Module = {}

--#region Module

Module.TakeDamage = TakeDamage

--#endregion

return Module