---@class Decomp.Lib.Bit32
local Bit32 = {}
Decomp.Lib.Bit32 = Bit32

local s_Uint32Overflow = 2^32
local s_Uint32Max = 2^32 - 1
local s_Int32Overflow = 2^31

---@param number number
---@return integer integral
local function truncate(number)
    local integral, _ = math.modf(number)
    return integral
end

---@param number number
---@return integer int32
local function ToInt32(number)
	local integer = truncate(number)
    integer = math.abs(integer) & s_Uint32Max -- using the % operator returns 0 for numbers above the 32-bit limit
    if integer >= s_Int32Overflow then
        return integer - s_Uint32Overflow
    end
    return integer
end

---@param number number
---@return integer uint32
local function ToUint32(number)
	local integer = truncate(number)
    return math.abs(integer) & s_Uint32Max
end

---@param number number
---@return number float
local function ToFloat(number)
	local float = string.unpack("f", string.pack("f", number))
	return float
end

---@param hex string
---@return number float
local function HexToFloat(hex)
    local uint32 = tonumber(hex, 16)
    local float = string.unpack("f", string.pack("I4", uint32))
    return float
end

Bit32.ToInt32 = ToInt32
Bit32.ToUint32 = ToUint32
Bit32.ToFloat = ToFloat
Bit32.HexToFloat = HexToFloat