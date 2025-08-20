---@class MinimapComponent
---@field m_state MinimapState
---@field m_keepMapExpanded boolean
---@field m_heldTime integer
---@field m_normalMapDesc MinimapDescComponent
---@field m_expandedMapDesc MinimapDescComponent

---@class MinimapDescComponent
---@field m_alpha number

---@class MinimapComponentUtils
local Module = {}

---@return MinimapComponent
local function Create()
end

--#region Module

Module.Create = Create

--#endregion

return Module