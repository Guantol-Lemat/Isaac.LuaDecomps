---@class BitsetUtils
local Module = {}

---@param size number
local function SetAllBits(size)
    return (1 << size) - 1
end

---@param bitset integer
---@param flags integer
---@return boolean
local function Test(bitset, flags)
    return (bitset & flags) == flags
end

---@param bitset integer
---@param flags integer
---@return boolean
local function HasAny(bitset, flags)
    return (bitset & flags) ~= 0
end

---@param bitset integer
---@param flags integer
---@return integer
local function Set(bitset, flags)
    return bitset | flags
end

---@param bitset integer
---@param flags integer
---@return integer
local function Clear(bitset, flags)
    return bitset & ~flags
end

--#region Module

Module.SetAllBits = SetAllBits
Module.Test = Test
Module.HasAny = HasAny
Module.Set = Set
Module.Clear = Clear

--#endregion

return Module