---@class InputUtils
local Module = {}

---@param input InputComponent
---@param action ButtonAction
---@param controllerId integer
---@return boolean
local function IsActionPressed(input, action, controllerId)
end

---@param input InputComponent
---@param action ButtonAction
---@param controllerId integer
---@return integer
local function GetActionValue(input, action, controllerId)
end

---@param input InputComponent
---@param button MouseButton
---@return boolean
local function IsMouseButtonPressed(input, button)
end

---@param input InputComponent
---@return Vector
local function GetMousePosition(input)
end

--#region Module

Module.IsActionPressed = IsActionPressed
Module.GetActionValue = GetActionValue
Module.IsMouseButtonPressed = IsMouseButtonPressed
Module.GetMousePosition = GetMousePosition

--#endregion

return Module