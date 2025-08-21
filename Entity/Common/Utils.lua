---@class EntityUtils
local Module = {}

---@param entity EntityComponent
---@param flags integer | EntityFlag
local function HasFlags(entity, flags)
    return (entity.m_flags & flags) == flags
end

---@param entity EntityComponent
---@param flags integer | EntityFlag
local function ClearFlags(entity, flags)
    entity.m_flags = entity.m_flags & ~flags
end

---@param entity EntityComponent
---@param tags EntityTag | integer
---@return boolean
local function HasConfigTags(entity, tags)
    return (entity.m_config.tags & tags) == tags
end

---@param entity EntityComponent
---@param tags EntityTag | integer
---@return boolean
local function HasAnyConfigTags(entity, tags)
    return (entity.m_config.tags & tags) ~= 0
end

---@param entity EntityComponent
---@param target EntityComponent?
local function SetTarget(entity, target)
end

---@param entity EntityComponent
---@param parent EntityComponent?
local function SetParent(entity, parent)
end

---@param entity EntityComponent
---@param child EntityComponent?
local function SetChild(entity, child)
end

---@param entity EntityComponent
---@return EntityPlayerComponent?
local function ToPlayer(entity)
    if entity.m_type == EntityType.ENTITY_PLAYER then
        ---@cast entity EntityPlayerComponent
        return entity
    end

    return nil
end

---@param entity EntityComponent
---@return EntityTearComponent?
local function ToTear(entity)
    if entity.m_type == EntityType.ENTITY_TEAR then
        ---@cast entity EntityTearComponent
        return entity
    end

    return nil
end

---@param entity EntityComponent
---@return EntityFamiliarComponent?
local function ToFamiliar(entity)
    if entity.m_type == EntityType.ENTITY_FAMILIAR then
        ---@cast entity EntityFamiliarComponent
        return entity
    end

    return nil
end

---@param entity EntityComponent
---@return EntityBombComponent?
local function ToBomb(entity)
    if entity.m_type == EntityType.ENTITY_BOMB then
        ---@cast entity EntityBombComponent
        return entity
    end

    return nil
end

---@param entity EntityComponent
---@return EntityPickupComponent?
local function ToPickup(entity)
    if entity.m_type == EntityType.ENTITY_PICKUP then
        ---@cast entity EntityPickupComponent
        return entity
    end

    return nil
end

---@param entity EntityComponent
---@return EntitySlotComponent?
local function ToSlot(entity)
    if entity.m_type == EntityType.ENTITY_SLOT then
        ---@cast entity EntitySlotComponent
        return entity
    end

    return nil
end

---@param entity EntityComponent
---@return EntityLaserComponent?
local function ToLaser(entity)
    if entity.m_type == EntityType.ENTITY_LASER then
        ---@cast entity EntityLaserComponent
        return entity
    end

    return nil
end

---@param entity EntityComponent
---@return EntityKnifeComponent?
local function ToKnife(entity)
    if entity.m_type == EntityType.ENTITY_KNIFE then
        ---@cast entity EntityKnifeComponent
        return entity
    end

    return nil
end

---@param entity EntityComponent
---@return EntityProjectileComponent?
local function ToProjectile(entity)
    if entity.m_type == EntityType.ENTITY_PROJECTILE then
        ---@cast entity EntityProjectileComponent
        return entity
    end

    return nil
end

---@param entity EntityComponent
---@return EntityNPCComponent?
local function ToNPC(entity)
    if entity.m_type >= 10 and entity.m_type ~= EntityType.ENTITY_EFFECT then
        ---@cast entity EntityNPCComponent
        return entity
    end

    return nil
end

---@param entity EntityComponent
---@return EntityEffectComponent?
local function ToEffect(entity)
    if entity.m_type == EntityType.ENTITY_EFFECT then
        ---@cast entity EntityEffectComponent
        return entity
    end

    return nil
end

---@param entity EntityComponent
---@return boolean
local function IsEnemy(entity)
    local type = entity.m_type
    return 10 <= type and type < 1000
end

---@param entity EntityComponent
---@return boolean
local function IsVulnerableEnemy(entity)
end

---@param entity EntityComponent
---@return boolean
local function DoesEntityShareStatus(entity)
end

---@param entity EntityComponent
---@return EntityComponent
local function GetStatusEffectTarget(entity)
end

--#region Module

Module.HasFlags = HasFlags
Module.ClearFlags = ClearFlags
Module.HasConfigTags = HasConfigTags
Module.HasAnyConfigTags = HasAnyConfigTags
Module.SetTarget = SetTarget
Module.SetParent = SetParent
Module.SetChild = SetChild
Module.ToPlayer = ToPlayer
Module.ToTear = ToTear
Module.ToFamiliar = ToFamiliar
Module.ToBomb = ToBomb
Module.ToPickup = ToPickup
Module.ToSlot = ToSlot
Module.ToLaser = ToLaser
Module.ToKnife = ToKnife
Module.ToProjectile = ToProjectile
Module.ToNPC = ToNPC
Module.ToEffect = ToEffect
Module.IsEnemy = IsEnemy
Module.IsVulnerableEnemy = IsVulnerableEnemy
Module.DoesEntityShareStatus = DoesEntityShareStatus
Module.GetStatusEffectTarget = GetStatusEffectTarget

--#endregion

return Module