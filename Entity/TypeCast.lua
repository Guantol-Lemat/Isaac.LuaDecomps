---@param entity Component.Entity
---@return Component.Entity.Player
local function StaticToPlayer(entity)
    ---@cast entity Component.Entity.Player
    return entity
end

---@param entity Component.Entity
---@return Component.Entity.Tear
local function StaticToTear(entity)
    ---@cast entity Component.Entity.Tear
    return entity
end

---@param entity Component.Entity
---@return Component.Entity.Familiar
local function StaticToFamiliar(entity)
    ---@cast entity Component.Entity.Familiar
    return entity
end

---@param entity Component.Entity
---@return Component.Entity.Bomb
local function StaticToBomb(entity)
    ---@cast entity Component.Entity.Bomb
    return entity
end

---@param entity Component.Entity
---@return Component.Entity.Pickup
local function StaticToPickup(entity)
    ---@cast entity Component.Entity.Pickup
    return entity
end

---@param entity Component.Entity
---@return Component.Entity.Slot
local function StaticToSlot(entity)
    ---@cast entity Component.Entity.Slot
    return entity
end

---@param entity Component.Entity
---@return Component.Entity.Laser
local function StaticToLaser(entity)
    ---@cast entity Component.Entity.Laser
    return entity
end

---@param entity Component.Entity
---@return Component.Entity.Knife
local function StaticToKnife(entity)
    ---@cast entity Component.Entity.Knife
    return entity
end

---@param entity Component.Entity
---@return Component.Entity.Projectile
local function StaticToProjectile(entity)
    ---@cast entity Component.Entity.Projectile
    return entity
end

---@param entity Component.Entity
---@return Component.Entity.Npc
local function StaticToNPC(entity)
    ---@cast entity Component.Entity.Npc
    return entity
end

---@param entity Component.Entity
---@return Component.Entity.Effect
local function StaticToEffect(entity)
    ---@cast entity Component.Entity.Effect
    return entity
end

---@param entity Component.Entity
---@return Component.Entity.Player?
local function ToPlayer(entity)
    if entity.m_type == EntityType.ENTITY_PLAYER then
        ---@cast entity Component.Entity.Player
        return entity
    end

    return nil
end

---@param entity Component.Entity
---@return Component.Entity.Tear?
local function ToTear(entity)
    if entity.m_type == EntityType.ENTITY_TEAR then
        ---@cast entity Component.Entity.Tear
        return entity
    end

    return nil
end

---@param entity Component.Entity
---@return Component.Entity.Familiar?
local function ToFamiliar(entity)
    if entity.m_type == EntityType.ENTITY_FAMILIAR then
        ---@cast entity Component.Entity.Familiar
        return entity
    end

    return nil
end

---@param entity Component.Entity
---@return Component.Entity.Bomb?
local function ToBomb(entity)
    if entity.m_type == EntityType.ENTITY_BOMB then
        ---@cast entity Component.Entity.Bomb
        return entity
    end

    return nil
end

---@param entity Component.Entity
---@return Component.Entity.Pickup?
local function ToPickup(entity)
    if entity.m_type == EntityType.ENTITY_PICKUP then
        ---@cast entity Component.Entity.Pickup
        return entity
    end

    return nil
end

---@param entity Component.Entity
---@return Component.Entity.Slot?
local function ToSlot(entity)
    if entity.m_type == EntityType.ENTITY_SLOT then
        ---@cast entity Component.Entity.Slot
        return entity
    end

    return nil
end

---@param entity Component.Entity
---@return Component.Entity.Laser?
local function ToLaser(entity)
    if entity.m_type == EntityType.ENTITY_LASER then
        ---@cast entity Component.Entity.Laser
        return entity
    end

    return nil
end

---@param entity Component.Entity
---@return Component.Entity.Knife?
local function ToKnife(entity)
    if entity.m_type == EntityType.ENTITY_KNIFE then
        ---@cast entity Component.Entity.Knife
        return entity
    end

    return nil
end

---@param entity Component.Entity
---@return Component.Entity.Projectile?
local function ToProjectile(entity)
    if entity.m_type == EntityType.ENTITY_PROJECTILE then
        ---@cast entity Component.Entity.Projectile
        return entity
    end

    return nil
end

---@param entity Component.Entity
---@return Component.Entity.Npc?
local function ToNPC(entity)
    if entity.m_type >= 10 and entity.m_type ~= EntityType.ENTITY_EFFECT then
        ---@cast entity Component.Entity.Npc
        return entity
    end

    return nil
end

---@param entity Component.Entity
---@return Component.Entity.Effect?
local function ToEffect(entity)
    if entity.m_type == EntityType.ENTITY_EFFECT then
        ---@cast entity Component.Entity.Effect
        return entity
    end

    return nil
end

local Module = {}

--#region Module

Module.StaticToPlayer = StaticToPlayer
Module.StaticToTear = StaticToTear
Module.StaticToFamiliar = StaticToFamiliar
Module.StaticToBomb = StaticToBomb
Module.StaticToPickup = StaticToPickup
Module.StaticToSlot = StaticToSlot
Module.StaticToLaser = StaticToLaser
Module.StaticToKnife = StaticToKnife
Module.StaticToProjectile = StaticToProjectile
Module.StaticToNPC = StaticToNPC
Module.StaticToEffect = StaticToEffect
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

--#endregion

return Module