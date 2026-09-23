--#region Dependencies



--#endregion

---@param seed integer
---@param shiftIdx integer
---@return Component.RNG
local function New(seed, shiftIdx)
end

---@param rng Component.RNG
---@return integer
local function Next(rng)
end

---@param rng Component.RNG
---@return number
local function RandomFloat(rng)
end

---@param rng Component.RNG
---@param max integer
---@return integer
local function RandomInt(max)
end

---@param rng Component.RNG
---@param seed integer
---@param shiftIdx integer
---@return integer
local function SetSeed(rng, seed, shiftIdx)
end

---@class Utils.RNG
local Module = {}

--#region Module

Module.New = New
Module.Next = Next
Module.RandomFloat = RandomFloat
Module.RandomInt = RandomInt
Module.SetSeed = SetSeed

--#endregion

return Module