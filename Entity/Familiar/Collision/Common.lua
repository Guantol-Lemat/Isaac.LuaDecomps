--#region Dependencies

local EntityRefComponent = require("Entity.System.EntityRef.Component")
local EntityUtils = require("Entity.Utils")
local FamiliarRules = require("Entity.Familiar.Rules")
local ProjectileUtils = require("Entity.Projectile.Utils")
local HitListUtils = require("Entity.System.HitList.Utils")

--#endregion

---@class FamiliarCollisionCommon
local Module = {}

---@param entity EntityFamiliarComponent
---@param collider EntityComponent
---@param low boolean
---@return boolean
local function CanCollideWithEnemy(entity, collider, low)
    if !low then
        return false
    end

    if not EntityUtils.IsVulnerableEnemy(collider) then
        return false
    end

    if HitListUtils.Contains(entity.m_hitList, collider) then
        return false
    end

    return true
end

---@param context Context
---@param entity EntityFamiliarComponent
---@param collider EntityComponent
local function TriggerSpinCollision(context, entity, collider)
    
end

---@param context Context
---@param entity EntityFamiliarComponent
---@param collider EntityComponent
---@param low boolean
local function HandleSpinCollision(context, entity, collider, low)
    if CanCollideWithEnemy(entity, collider, low) and EntityUtils.HasFlags(entity, EntityFlag.FLAG_SPIN) then
        TriggerSpinCollision(context, entity, collider)
    end
end

---@param entity EntityFamiliarComponent
---@param collider EntityComponent
---@param low boolean
---@return boolean
local function EvaluateCollisionDamage(entity, collider, low)
    return CanCollideWithEnemy(entity, collider, low) and entity.m_collisionDamage > 0.0
end

---@param context Context
---@param entity EntityFamiliarComponent
---@param collider EntityComponent
---@param multiplier number
local function TriggerCollisionDamage(context, entity, collider, multiplier)
    local damage = multiplier * entity.m_collisionDamage
    local source = EntityRefComponent.Create(entity)
    collider:TakeDamage(context, damage, 0, source, 30)
end

---@param context Context
---@param entity EntityFamiliarComponent
---@param collider EntityComponent
---@param low boolean
---@param multiplier number
local function HandleCollisionDamage(context, entity, collider, low, multiplier)
    if EvaluateCollisionDamage(entity, collider, low) then
        HitListUtils.InsertEntity(entity.m_hitList, collider)
        TriggerCollisionDamage(context, entity, collider, multiplier)
    end
end

---@param context Context
---@param entity EntityFamiliarComponent
---@param collider EntityComponent
---@param low boolean
---@return boolean? collisionOccurred
local function HandleProjectileCollision(context, entity, collider, low)
    if not low or collider.m_type ~= EntityType.ENTITY_PROJECTILE then
        return
    end

    local projectile = EntityUtils.ToProjectile(entity)
    assert(projectile, "Could not convert projectile ToProjectile")

    if ProjectileUtils.HasProjectileFlags(projectile, ProjectileFlags.CANT_HIT_PLAYER) then
        return true
    end

    if FamiliarRules.CanBlockProjectiles(context, entity) then
        collider.m_isDead = true
        return
    end

    return true
end

--#region Module

Module.CanCollideWithEnemy = CanCollideWithEnemy
Module.HandleSpinCollision = HandleSpinCollision
Module.TriggerSpinCollision = TriggerSpinCollision
Module.HandleCollisionDamage = HandleCollisionDamage
Module.EvaluateCollisionDamage = EvaluateCollisionDamage
Module.TriggerCollisionDamage = TriggerCollisionDamage
Module.HandleProjectileCollision = HandleProjectileCollision

--#endregion

return Module