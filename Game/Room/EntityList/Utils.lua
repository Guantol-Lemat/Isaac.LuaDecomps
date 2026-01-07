--#region Dependencies



--#endregion

---@class EntityListUtils
local Module = {}

---@param entityList EntityListComponent
---@param entityType EntityType | integer
---@param variant integer
---@param subtype integer
---@param cache boolean
---@param ignoreFriendly boolean
---@return ELComponent
local function QueryType(entityList, entityType, variant, subtype, cache, ignoreFriendly)
end

--#region Module

Module.QueryType = QueryType

--#endregion

return Module