---@class RoomTransitionUtils
local Module = {}

---@param roomTransition RoomTransitionComponent
---@return boolean
local function IsActive(roomTransition)
end

---@param roomTransition RoomTransitionComponent
---@return number
local function GetAlpha(roomTransition)
end

--#region Module

Module.IsActive = IsActive
Module.GetAlpha = GetAlpha

--#endregion

return Module