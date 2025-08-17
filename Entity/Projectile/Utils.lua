---@class ProjectileUtils
local Module = {}

---@param entity EntityProjectileComponent
---@param flags ProjectileFlags | integer
local function HasProjectileFlags(entity, flags)
    return (entity.m_projectileFlags & flags) == flags
end

--#region Module

Module.HasProjectileFlags = HasProjectileFlags

--#endregion

return Module