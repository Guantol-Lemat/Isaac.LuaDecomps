---@param x integer
---@return BitSet128
local function NewFromFlag(x)
    return x >= 64 and BitSet128(0, 1 << (x - 64)) or BitSet128(1 << x, 0)
end

---@param source BitSet128
---@return BitSet128
local function Copy(source)
    return BitSet128(source.l, source.h)
end

---@param value BitSet128
---@param other BitSet128
local function Assign(value, other)
    value.l = other.l
    value.h = other.h
end

---@class VanillaAPI.BitSet128
local Module = {}

--#region Module

Module.NewFromFlag = NewFromFlag
Module.Copy = Copy
Module.Assign = Assign

--#endregion

return Module