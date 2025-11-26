--#region Dependencies



--#endregion

---@class StringUtils
local Module = {}

---@param str string
---@param n integer
---@return string
local function At(str, n)
    return string.sub(str, n, n)
end

--#region Module

Module.At = At

--#endregion

return Module