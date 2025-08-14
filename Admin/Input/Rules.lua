---@class InputRules
local Module = {}

---@param context Context
---@param action ButtonAction
---@param controllerId integer
---@param entity EntityComponent?
---@return boolean
local function IsActionPressed(context, action, controllerId, entity)

end

---@param context Context
---@param action ButtonAction
---@param controllerId integer
---@param entity EntityComponent?
---@return integer
local function GetActionValue(context, action, controllerId, entity)
end

--#region Module

Module.IsActionPressed = IsActionPressed
Module.GetActionValue = GetActionValue

--#endregion

return Module