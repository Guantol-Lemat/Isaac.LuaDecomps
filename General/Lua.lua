---@class LuaUtils
local Module = {}

---@param value any
---@return boolean?
local function CheckBoolean(value)
    if type(value) == "boolean" then
        return value
    end
end

---@generic T : boolean | nil
---@param optional boolean?
---@param default T
---@return T
local function OptBoolean(optional, default)
    return not optional and default or optional
end

---@generic T
---@param optional T | nil
---@param default T
---@return T
local function Opt(optional, default)
    return optional and optional or default
end

--#region Module

Module.CheckBoolean = CheckBoolean
Module.OptBoolean = OptBoolean
Module.Opt = Opt

--#endregion

return Module