--#region Dependencies

local Actor_Gurdy = require("Isaac.Actor.Boss.Gurdy")

--#endregion

---@alias Npc.Event.TriggerPlayerDamaged fun(npc: Component.Entity.Npc, ctx: Context.Common, damage: number, damageFlags: DamageFlag | integer, source: Component.Entity.EntityRef)

local Switch_TriggerPlayerDamaged = {
    [EntityType.ENTITY_GURDY] = Actor_Gurdy.TriggerPlayerDamaged,
    [EntityType.ENTITY_SATAN] = Actor_Satan.TriggerPlayerDamaged,
    [EntityType.ENTITY_BEAST] = Actor_Beast.TriggerPlayerDamaged,
}

---@param npc Component.Entity.Npc
---@param ctx Context.Common
---@param damage number
---@param damageFlags DamageFlag | integer
---@param source Component.Entity.EntityRef
local function TriggerPlayerDamaged(npc, ctx, damage, damageFlags, source)
    local trigger = Switch_TriggerPlayerDamaged[npc.m_type]
    if trigger then trigger(npc, ctx, damage, damageFlags, source) end
end

---@class Npc.Events
local Module = {}

--#region Module

Module.TriggerPlayerDamaged = TriggerPlayerDamaged

--#endregion

return Module