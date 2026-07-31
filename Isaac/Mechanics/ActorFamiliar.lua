--#region Dependencies

local IEntityList = require("Isaac.Interface.EntityList")

--#endregion

local Switch_TriggerNewRoomTemporaryEffects = {
    [FamiliarVariant.BLOOD_OATH] = Actor_BloodOath.apply_effects,
    [FamiliarVariant.PASCHAL_CANDLE] = Actor_PaschalCandle.apply_effects,
}

local Switch_TryCollectPickup = {
    [FamiliarVariant.BUM_FRIEND] = Actor_BumFriend.handle_pickup,
    [FamiliarVariant.DARK_BUM] = Actor_DarkBum.handle_pickup,
    [FamiliarVariant.BUMBO] = Actor_Bumbo.handle_pickup,
    [FamiliarVariant.KEY_BUM] = Actor_KeyBum.handle_pickup,
    [FamiliarVariant.SUPER_BUM] = Actor_SuperBum.handle_pickup,
    [FamiliarVariant.LIL_PORTAL] = Actor_LilPortal.handle_pickup,
}

---@param entityList Component.EntityList
---@param ctx Context.Common
local function TriggerNewRoom_TemporaryEffects(entityList, ctx)
    local familiars = IEntityList.QueryType(entityList, EntityType.ENTITY_FAMILIAR, -1, -1, true, false)
    for i = 1, #familiars, 1 do
        local familiar = familiars[i]
        local apply_effects = Switch_TriggerNewRoomTemporaryEffects[familiar.m_variant]
        if apply_effects then apply_effects(familiar, ctx) end
    end
end

---@param familiar Component.Entity.Familiar
---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param collisionParams Pickup.Blackboard.HandleCollision
---@param low boolean
local function HandlePickup(familiar, ctx, pickup, collisionParams, low)
    if low then
        return
    end

    local try_collect_pickup = Switch_TryCollectPickup[familiar.m_variant]
    if try_collect_pickup then return try_collect_pickup(familiar, ctx, pickup, collisionParams) end
end

---@class Mechanics.Actor.Familiar
local Module = {}

--#region Module

Module.TriggerNewRoom_TemporaryEffects = TriggerNewRoom_TemporaryEffects
Module.HandlePickup = HandlePickup

--#endregion

return Module