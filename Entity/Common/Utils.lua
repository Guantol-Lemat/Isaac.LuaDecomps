---@class EntityUtils
local Module = {}

---@param entity EntityComponent
---@param flags integer | EntityFlag
local function HasFlags(entity, flags)
    return (entity.m_flags & flags) == flags
end

---@param entity EntityComponent
---@param flags integer | EntityFlag
local function HasAnyFlag(entity, flags)
    return (entity.m_flags & flags) ~= 0
end

---@param entity EntityComponent
---@param target EntityComponent?
local function SetTarget(entity, target)
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
---@return EntityFamiliarComponent?
local function ToFamiliar(entity)
    if entity.m_type == EntityType.ENTITY_FAMILIAR then
        ---@cast entity EntityFamiliarComponent
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
---@return EntityKnifeComponent?
local function ToKnife(entity)
    if entity.m_type == EntityType.ENTITY_KNIFE then
        ---@cast entity EntityKnifeComponent
        return entity
    end

    return nil
end

--#region Module

Module.HasFlags = HasFlags
Module.HasAnyFlag = HasAnyFlag
Module.SetTarget = SetTarget
Module.ToPlayer = ToPlayer
Module.ToFamiliar = ToFamiliar
Module.ToTear = ToTear
Module.ToKnife = ToKnife

--#endregion

return Module