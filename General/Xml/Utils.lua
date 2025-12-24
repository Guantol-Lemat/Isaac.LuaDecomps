--#region Dependencies



--#endregion

---@class XmlUtils
local Module = {}

---@param value string
---@return integer
local function atoi(value)
    local s = value:match("^%s*([+-]?%d+)") -- extract integer prefix
    return s and tonumber(s) or 0
end

---@param value string
---@return number
local function atof(value)
    return tonumber(value) or 0.0
end

---@param value string
---@return integer
local function ToInteger(value)
    return atoi(value)
end

---@param value string
---@return number
local function ToFloat(value)
    return atof(value)
end

---@param value string
---@return boolean
local function ToBoolean(value)
    return value == "true" or value == "True" or atoi(value) ~= 0
end

--#region Module

Module.ToInteger = ToInteger
Module.ToFloat = ToFloat
Module.ToBoolean = ToBoolean

--#endregion

return Module