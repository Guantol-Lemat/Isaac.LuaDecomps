--#region Dependencies



--#endregion

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param item ItemConfigItemComponent
---@param itemStateOnly boolean
local function AddCostume(myContext, player, item, itemStateOnly)
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param item ItemConfigItemComponent
local function RemoveCostume(myContext, player, item)
end

local Module = {}

--#region Module

Module.AddCostume = AddCostume
Module.RemoveCostume = RemoveCostume

--#endregion

return Module