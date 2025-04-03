---@class Decomp.Lib.RNG
local Lib_RNG = {}
Decomp.Lib.RNG = Lib_RNG

require("Lib.Bit32")

local Lib = Decomp.Lib

local INT_TO_FLOAT = Lib.Bit32.HexToFloat("2F7FFFFE") -- Something close to 1 / ((2 ^ 32) + (2 * 9)), tho it's hard to know how this number was obtained exactly
local INT_TO_FLOAT_INCLUSIVE = 1 / ((2^32) - 1);

---@param seed integer
---@param max integer
---@return integer int @ An integer in between [0.0, max)
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

Lib_RNG.SeedToInt = SeedToInt
Lib_RNG.SeedToFloat = SeedToFloat
Lib_RNG.SeedToFloatInclusive = SeedToFloatInclusive