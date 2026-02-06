--#region Dependencies



--#endregion

---@param context Context.Room
---@param gridEntity GridEntityComponent
---@return boolean
local function IsEasyCrushableOrWalkable(context, gridEntity)
end

---@param context Context.Room
---@param gridEntity GridEntityComponent
---@return boolean
local function IsDangerousCrushableOrWalkable(context, gridEntity)
end

local Module = {}

--#region Module

Module.IsEasyCrushableOrWalkable = IsEasyCrushableOrWalkable
Module.IsDangerousCrushableOrWalkable = IsDangerousCrushableOrWalkable

--#endregion

return Module