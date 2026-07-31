--#region Dependencies



--#endregion

local Switch_TryCollectPickup = {
    [EntityType.ENTITY_ULTRA_GREED] = UltraGreed_HandlePickup,
    [EntityType.ENTITY_BUMBINO] = Bumbino_HandlePickup,
}

---@param npc Component.Entity.Npc
---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param collisionParams Pickup.Params.HandleCollision
---@return boolean?
local function HandlePickup(npc, ctx, pickup, collisionParams)
    local handle_pickup = Switch_TryCollectPickup[npc.m_type]
    if handle_pickup then return handle_pickup(npc, ctx, pickup, collisionParams) end
end

---@class Mechanics.Npc.Interactions
local Module = {}

--#region Module

Module.HandlePickup = HandlePickup

--#endregion

return Module