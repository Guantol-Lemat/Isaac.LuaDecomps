---@class Decomp.Lib.RNG
local Lib_RNG = {}

require("Lib.Bit32")

local Lib = Decomp.Lib

local INT_TO_FLOAT = Lib.Bit32.HexToFloat("2F7FFFFE") -- Something close to 1 / ((2 ^ 32) + (2 * 9)), tho it's hard to know how this number was obtained exactly
local INT_TO_FLOAT_INCLUSIVE = 1 / ((2^32) - 1);

---@param seed integer
---@param max integer
---@return integer int @ An integer in between [0, max)
local function SeedToInt(seed, max)
    return seed % max
end

---@param seed integer
---@return number float @ A number in between [0.0, 1.0)
local function SeedToFloat(seed)
    return seed * INT_TO_FLOAT
end

---@param seed integer
---@return number float @ A number in between [0.0, 1.0]
local function SeedToFloatInclusive(seed)
    return seed * INT_TO_FLOAT_INCLUSIVE
end

---#region Module

---@param seed integer
---@param max integer
---@return integer int @ An integer in between [0, max)
function Lib_RNG.SeedToInt(seed, max)
    return SeedToInt(seed, max)
end

---@param seed integer
---@return number float @ A number in between [0.0, 1.0)
function Lib_RNG.SeedToFloat(seed)
    return SeedToFloat(seed)
end

---@param seed integer
---@return number float @ A number in between [0.0, 1.0]
function Lib_RNG.SeedToFloatInclusive(seed)
    return SeedToFloatInclusive(seed)
end

---#endregion

return Lib_RNG