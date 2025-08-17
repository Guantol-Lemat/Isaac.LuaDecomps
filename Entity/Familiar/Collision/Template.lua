--#region Dependencies

local EntityUtils = require("Entity.Common.Utils")
local FamiliarRules = require("Entity.Familiar.Rules")
local CollisionCommon = require("Entity.Familiar.Collision.Common")

--#endregion

---@class FamiliarCollisionHooks
---@field HandleBehavior FamiliarCollisionHook.HandleBehavior

---@alias FamiliarCollisionHook.HandleBehavior fun(context: Context, entity: EntityFamiliarComponent, collider: EntityComponent, low: boolean): boolean?

---@class FamiliarCollisionTemplate
local Module = {}

---@param template FamiliarCollisionHooks
---@param context Context
---@param entity EntityFamiliarComponent
---@param collider EntityComponent
---@param low boolean
---@return boolean?
local function hook_behavior(template, context, entity, collider, low)
    local collisionOccurred = template.HandleBehavior(context, entity, collider, low)
    if type(collisionOccurred) ~= "boolean" then
        return nil
    end

    return collisionOccurred
end

---@param template FamiliarCollisionHooks
---@param context Context
---@param entity EntityFamiliarComponent
---@param collider EntityComponent
---@param low boolean
---@return boolean
local function HandleCollision(template, context, entity, collider, low)
    -- callback handler
    if EntityUtils.IsEnemy(collider) then
        if EntityUtils.HasFlags(collider, EntityFlag.FLAG_FRIENDLY) or EntityUtils.HasFlags(entity, EntityFlag.FLAG_CHARM) or false --[[something with room]] then
            return true
        end
    end

    local collisionOccurred = true

    local hookResult = hook_behavior(template, context, entity, collider, low)
    if hookResult then
        collisionOccurred = hookResult
    end

    return collisionOccurred
end

---@type FamiliarCollisionHook.HandleBehavior
local function DefaultBehavior(context, entity, collider, low)
    local multiplier = FamiliarRules.GetMultiplier(context, entity)
    CollisionCommon.HandleSpinCollision(context, entity, collider, low)
    CollisionCommon.HandleCollisionDamage(context, entity, collider, low, multiplier)
    local collisionOccurred = CollisionCommon.HandleProjectileCollision(context, entity, collider, low)
    return collisionOccurred
end

--#region Module

Module.HandleCollision = HandleCollision
Module.DefaultBehavior = DefaultBehavior

--#endregion

return Module