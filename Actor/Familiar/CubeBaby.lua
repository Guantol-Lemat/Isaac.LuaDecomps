--#region Dependencies

local LuaUtils = require("General.Lua")
local MathUtils = require("General.Math")
local EntityRules = require("Entity.Common.Rules")
local FamiliarRules = require("Entity.Familiar.Rules")
local FamiliarCollisionCommon = require("Entity.Familiar.Collision.Common")
local HitListUtils = require("Entity.System.HitList.Utils")
local EntityRefComponent = require("Entity.System.EntityRef.Component")

--#endregion

---@class CubeBabyActor
local Module = {}

local SLOWING_COLOR = Color(1.0, 1.0, 1.0, 1.3, 40, 40, 40)

---@param context Context
---@param entity EntityFamiliarComponent
local function get_collision_multiplier(context, entity)
    local multiplier = FamiliarRules.GetMultiplier(context, entity)

    local speed = entity.m_velocity:Length()
    local speedMultiplier = MathUtils.Clamp(speed / 3.0, 0.0, 5.0)
    multiplier = multiplier * speedMultiplier

    return multiplier
end

---@param entity EntityFamiliarComponent
---@param collider EntityComponent
local function handle_player_redirect(entity, collider)
    local playerSpeed = collider.m_velocity:Length()
    if playerSpeed <= 2.0 then
        return
    end

    local pushSpeed = math.min(playerSpeed * 3.0, 14.0)
    local distance = entity.m_position - collider.m_position

    entity.m_velocity = entity.m_velocity + distance:Resize(pushSpeed)
end

---@param context Context
---@param entity EntityFamiliarComponent
---@param collider EntityComponent
---@param multiplier number
local function trigger_collision_damage(context, entity, collider, multiplier)
    HitListUtils.InsertEntity(entity.m_hitList, collider)
    FamiliarCollisionCommon.TriggerCollisionDamage(context, entity, collider, multiplier)
    if multiplier <= 0.0 then
        return
    end

    HitListUtils.Clear(entity.m_hitList)
    HitListUtils.InsertEntity(entity.m_hitList, collider)

    local source = EntityRefComponent.Create(entity)
    EntityRules.AddSlowing(context, collider, source, 15, 0.9, SLOWING_COLOR)
end

---@type FamiliarCollisionHook.HandleBehavior
local function CollisionBehavior(context, entity, collider, low)
    local collisionOccurred = nil
    local colliderType = collider.m_type

    if colliderType == EntityType.ENTITY_PLAYER then
        if entity.m_orbitSpeed < 0.0 then
            return true
        end
    elseif colliderType ~= EntityType.ENTITY_FAMILIAR then
        collisionOccurred = false
    end

    local multiplier = get_collision_multiplier(context, entity)

    if colliderType == EntityType.ENTITY_PLAYER and entity.m_fireCooldown <= 0 and entity.m_orbitSpeed >= 0.0 then
        handle_player_redirect(entity, collider)
    end

    FamiliarCollisionCommon.HandleSpinCollision(context, entity, collider, low)

    if FamiliarCollisionCommon.EvaluateCollisionDamage(entity, collider, low) then
        trigger_collision_damage(context, entity, collider, multiplier)
    end

    local projectileCollision = FamiliarCollisionCommon.HandleProjectileCollision(context, entity, collider, low)
    collisionOccurred = LuaUtils.OptBoolean(projectileCollision, collisionOccurred)
    return collisionOccurred
end

--#region Module



--#endregion

return Module