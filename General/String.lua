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

---@param str string
---@param endPos integer
---@param charset string
---@return integer?
local function FindLastOf(str, endPos, charset)
    local prefix = str:sub(1, endPos)
    local pos

    for i in prefix:gmatch("()[" .. charset .. "]") do
        pos = i
    end

    return pos
end

--#region Module

Module.At = At
Module.FindLastOf = FindLastOf

--#endregion

return Module