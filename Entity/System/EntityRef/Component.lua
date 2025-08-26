---@class EntityRefComponent
---@field entity EntityComponent?
---@field type EntityType | integer
---@field variant integer
---@field spawnerType EntityType | integer
---@field flags EntityFlag | integer

---@class EntityRefComponentUtils
local Module = {}


---@param entity EntityComponent
---@return EntityRefComponent
local function Create(entity)
end

--#region Module

Module.Create = Create

--#endregion

return Module
