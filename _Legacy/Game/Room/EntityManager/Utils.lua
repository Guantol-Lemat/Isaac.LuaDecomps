--#region Dependencies



--#endregion

---@class EntityListUtils
local Module = {}

---Clears all caches
---@param entityManager Component.EntityList
local function ClearResults(entityManager)

end

---@param entityList Component.EntityList
---@param entityType EntityType | integer
---@param variant integer
---@param subtype integer
---@param cache boolean
---@param ignoreFriendly boolean
---@return Component.EntityList.EL
local function QueryType(entityList, entityType, variant, subtype, cache, ignoreFriendly)
end

--#region Module

Module.ClearResults = ClearResults
Module.QueryType = QueryType

--#endregion

return Module