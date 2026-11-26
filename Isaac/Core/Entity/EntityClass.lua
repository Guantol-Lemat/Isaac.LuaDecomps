---@param entity Component.Entity
---@return boolean
local function IsPlayer(entity)
    return entity.m_type == EntityType.ENTITY_PLAYER
end

---@param entity Component.Entity
---@return boolean
local function IsTear(entity)
    return entity.m_type == EntityType.ENTITY_TEAR
end

---@param entity Component.Entity
---@return boolean
local function IsFamiliar(entity)
    return entity.m_type == EntityType.ENTITY_FAMILIAR
end

---@param entity Component.Entity
---@return boolean
local function IsBomb(entity)
    return entity.m_type == EntityType.ENTITY_BOMB
end

---@param entity Component.Entity
---@return boolean
local function IsPickup(entity)
    return entity.m_type == EntityType.ENTITY_PICKUP
end

---@param entity Component.Entity
---@return boolean
local function IsSlot(entity)
    return entity.m_type == EntityType.ENTITY_SLOT
end

---@param entity Component.Entity
---@return boolean
local function IsLaser(entity)
    return entity.m_type == EntityType.ENTITY_LASER
end

---@param entity Component.Entity
---@return boolean
local function IsKnife(entity)
    return entity.m_type == EntityType.ENTITY_KNIFE
end

---@param entity Component.Entity
---@return boolean
local function IsProjectile(entity)
    return entity.m_type == EntityType.ENTITY_PROJECTILE
end

---@param entity Component.Entity
---@return boolean
local function IsEnemy(entity)
    local entType = entity.m_type
    return 10 <= entType and entType < 1000
end

---@param entity Component.Entity
---@return boolean
local function IsEffect(entity)
    return entity.m_type == EntityType.ENTITY_EFFECT
end

---@param entity Component.Entity
---@return Component.Entity.Player?
local function ToPlayer(entity)
---@diagnostic disable-next-line: return-type-mismatch
    return IsPlayer(entity) and entity or nil
end

---@param entity Component.Entity
---@return Component.Entity.Tear?
local function ToTear(entity)
---@diagnostic disable-next-line: return-type-mismatch
    return IsTear(entity) and entity or nil
end

---@param entity Component.Entity
---@return Component.Entity.Familiar?
local function ToFamiliar(entity)
---@diagnostic disable-next-line: return-type-mismatch
    return IsFamiliar(entity) and entity or nil
end

---@param entity Component.Entity
---@return Component.Entity.Bomb?
local function ToBomb(entity)
---@diagnostic disable-next-line: return-type-mismatch
    return IsBomb(entity) and entity or nil
end

---@param entity Component.Entity
---@return Component.Entity.Pickup?
local function ToPickup(entity)
---@diagnostic disable-next-line: return-type-mismatch
    return IsPickup(entity) and entity or nil
end

---@param entity Component.Entity
---@return Component.Entity.Slot?
local function ToSlot(entity)
---@diagnostic disable-next-line: return-type-mismatch
    return IsSlot(entity) and entity or nil
end

---@param entity Component.Entity
---@return Component.Entity.Laser?
local function ToLaser(entity)
---@diagnostic disable-next-line: return-type-mismatch
    return IsLaser(entity) and entity or nil
end

---@param entity Component.Entity
---@return Component.Entity.Knife?
local function ToKnife(entity)
---@diagnostic disable-next-line: return-type-mismatch
    return IsKnife(entity) and entity or nil
end

---@param entity Component.Entity
---@return Component.Entity.Projectile?
local function ToProjectile(entity)
---@diagnostic disable-next-line: return-type-mismatch
    return IsProjectile(entity) and entity or nil
end

---@param entity Component.Entity
---@return Component.Entity.Npc?
local function ToNPC(entity)
---@diagnostic disable-next-line: return-type-mismatch
    return IsEnemy(entity) and entity or nil
end

---@param entity Component.Entity
---@return Component.Entity.Effect?
local function ToEffect(entity)
---@diagnostic disable-next-line: return-type-mismatch
    return IsEffect(entity) and entity or nil
end