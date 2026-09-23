---@class Component.MTRNG

---@param rng Component.MTRNG
---@param seed integer
local function Init(rng, seed)
end

---@param seed integer
---@return Component.MTRNG
local function New(seed)
    ---@type Component.MTRNG
    return {}
end

---@param rng Component.MTRNG
---@return integer
local function Next(rng)
end

---@param rng Component.MTRNG
---@param max integer
---@return integer
local function RandomInt(rng, max)
    if max == 0 then
        return 0
    end

    return Next(rng) % max
end

---@class UnnamedModule
local Module = {}

--#region Module

Module.New = New
Module.Init = Init
Module.Next = Next
Module.RandomInt = RandomInt

--#endregion

return Module