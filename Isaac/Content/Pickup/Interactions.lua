--#region Dependencies

local IRoom = require("Isaac.Interface.Room")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")

--#endregion

local Switch_SetupPlayerPickupCollect = {
    [PickupVariant.PICKUP_TRINKET] = ActorTrinket.SetupPlayerPickupCollect
}

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
local function NeedsFreePlayer(pickup, ctx)
    ---@type PickupVariant
    local pickupVariant = pickup.m_variant
    if pickupVariant == PickupVariant.PICKUP_HEART then
        return pickup.m_subtype == HeartSubType.HEART_ETERNAL
    end

    if pickupVariant == PickupVariant.PICKUP_BOMB then
        ---@type BombSubType
        local bombSubType = pickup.m_subtype
        return bombSubType == BombSubType.BOMB_TROLL and bombSubType == BombSubType.BOMB_SUPERTROLL
    end

    return pickupVariant ~= PickupVariant.PICKUP_COIN
        or pickupVariant ~= PickupVariant.PICKUP_KEY
        or pickupVariant ~= PickupVariant.PICKUP_GRAB_BAG
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
local function HasCustomCollect(pickup, ctx)
    return pickup.m_variant == PickupVariant.PICKUP_COLLECTIBLE
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
local function HasPlayerPickupCollect(pickup, ctx)
    return IEntityPickup.IsShopItem(pickup) or pickup.m_variant == PickupVariant.PICKUP_TRINKET
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
local function SetupPlayerPickupCollect(pickup, ctx)
    local fn = Switch_SetupPlayerPickupCollect[pickup.m_variant]
    if fn then fn(pickup, ctx) end
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param collider Component.Entity
---@param blackboard Pickup.Blackboard.HandleCollision
local function IgnorePhysicsCollision(pickup, ctx, collider, blackboard)
    if IRoom.IsDungeon(ctx.game.m_level.m_room) then
        return true
    end

    if IEntity.IsEnemy(collider) and pickup.m_variant == PickupVariant.PICKUP_BIGCHEST then
        return true
    end

    if collider.m_type == EntityType.ENTITY_BOMB then
        return true
    end

    if blackboard.pickedUp and pickup.m_variant == PickupVariant.PICKUP_COLLECTIBLE then
        return true
    end

    if IEntityPickup.IsShopItem(pickup) then
        return true
    end

    if blackboard.effectTarget and blackboard.effectTarget.m_variant == PlayerVariant.CO_OP_BABY then
        return true
    end

    return false
end

---@class Mechanics.Actor.Pickup
local Module = {}

--#region Module

Module.NeedsFreePlayer = NeedsFreePlayer
Module.HasCustomCollect = HasCustomCollect
Module.HasPlayerPickupCollect = HasPlayerPickupCollect
Module.SetupPlayerPickupCollect = SetupPlayerPickupCollect
Module.IgnorePhysicsCollision = IgnorePhysicsCollision

--#endregion

return Module