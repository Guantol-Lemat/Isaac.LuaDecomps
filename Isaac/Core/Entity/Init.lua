--#region Dependencies

local g = require("Isaac.Global")
local c = require("Isaac.Constants")
local VectorUtils = require("General.Math.VectorUtils")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPtr = IEntity.EntityPtr

--#endregion

local VECTOR_ZERO = c.VECTOR_ZERO

---@param entity Component.Entity
---@param type EntityType | integer
---@param variant integer
---@param subtype integer
---@param seed integer
local function Init(entity, type, variant, subtype, seed)
    entity.m_type = type
    entity.m_variant = variant
    entity.m_subtype = subtype
    entity.m_initSeed = seed
    entity.m_dropRNG:SetSeed(seed, 30)
    entity.m_splatColor:Reset()

    entity:LoadEntityConfig()

    entity.m_friction = entity.m_initialFriction
    VectorUtils.Assign(entity.m_shadowOffset, VECTOR_ZERO)
    entity.m_pauseTimer = 0
    entity.m_index = 0
    entity.m_collisionIndex = 0
    entity.m_spawnFrame = g.Game.m_frameCount
    entity.m_health = entity.m_maxHealth
    entity.m_spawnGridIdx = -1
    VectorUtils.Assign(entity.m_targetPosition, VECTOR_ZERO)
    entity.m_timeScale = 1.0
    entity.m_lastLocalFrame = -1.0e-5
    entity.m_localFrame = 0.0
    VectorUtils.Assign(entity.m_positionOffset, VECTOR_ZERO)
    entity.m_renderZOffset = 0
    entity.m_depthOffset = 0.0
    entity.m_sortingLayer = SortingLayer.SORTING_NORMAL
    entity.m_visible = true
    entity.m_exists = true
    entity.m_isDead = false
    entity.m_unkBool = false
    entity.m_blockSpriteBatch = false
    entity.m_removedByFactoryCreate = false
    entity.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    entity.m_modifiedInEntityList_collide = false
    entity.m_collidesWithGrid = false
    VectorUtils.Assign(entity.m_gridCollisionDirection, VECTOR_ZERO)
    VectorUtils.Assign(entity.m_velocityOnGridCollide, VECTOR_ZERO)
    entity.m_color = Color(1.0, 1.0, 1.0, 1.0)
    entity.m_fireDamageCountdown = 0
    entity.m_damageCountdown = 0
    entity.m_freezeCountdown = 0
    entity.m_poisonCountdown = 0
    entity.m_poisonDamage = 2.0
    entity.m_burnDamage = 2.0
    entity.m_slowingCountdown = 0
    entity.m_slowStatusFrictionMult_qqq = 0.9
    entity.m_charmedCountdown = 0
    entity.m_confusionCountdown = 0
    entity.m_midasFreezeCountdown = 0
    entity.m_fearCountdown = 0
    entity.m_burnCountdown = 0
    entity.m_shrinkCountdown = 0
    entity.m_bleedingCountdown = 0
    entity.m_bleedDamageDistance_qqq = 0.0
    entity.m_poisonDamageTimer = 0
    entity.m_burnDamageTimer = 0
    entity.m_magnetizedCountdown = 0
    entity.m_baitedCountdown = 0
    entity.m_knockback_countdown = 0
    entity.m_iceCountdown = 0
    entity.m_weaknessCountdown = 0
    entity.m_brimstoneMarkCountdown = 0
    entity.m_magnetizedPullingEffect.ref = nil ---@Bug: Not using SetReference
    entity.m_statusImmunity_cooldown = 0
    entity.m_flags = 0
    entity.m_damage_entries = {}
    entity.m_damage_damageTaken = 0.0
    entity.m_damage_flagsTaken = 0
    entity.m_invincible = false
    entity.m_interpolated = false
    entity.m_stop_countdown = 0
    entity.m_shrink_scale = 1.0
    entity.m_shrink_targetScale = 1.0
    entity.m_parent.ref = nil ---@Bug: Not using SetReference
    entity.m_child.ref = nil ---@Bug: Not using SetReference
    entity.m_target.ref = nil ---@Bug: Not using SetReference
    IEntityPtr.SetReference(entity.m_minecart, nil)
    IEntityPtr.SetReference(entity.m_bishopRelated, nil)
    VectorUtils.Assign(entity.m_preUpdatePos, entity.m_position)
    VectorUtils.Assign(entity.m_preUpdateVel, entity.m_velocity)
    entity.m_pitfallState = 0
    entity.m_pitfallRelated = 0
    VectorUtils.Assign(entity.m_unkVector2, VECTOR_ZERO)
    entity:ResetColor()
    entity.m_luaData = nil
end

---@class Entity.Init
local Module = {}

--#region Module

Module.Init = Init

--#endregion

return Module