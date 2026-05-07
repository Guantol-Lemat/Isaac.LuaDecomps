---@class Component.EntityRef
---@field entity Component.Entity?
---@field type EntityType | integer
---@field variant integer
---@field spawnerType EntityType | integer
---@field flags EntityFlag | integer

---@class EntityRefComponentUtils
local Module = {}


---@param entity Component.Entity
---@return Component.EntityRef
local function Create(entity)
end

--#region Module

Module.Create = Create

--#endregion

return Module
