--#region Dependencies

local StringUtils = require("General.String")

--#endregion

local STRING_BLANK_POS = 5
local SEED_STRING_XOR = 0xfef7ffd
local SEED_CHARACTERS = "ABCDEFGHJKLMNPQRSTWXYZ01234V6789"
local ENCODE_BIT_MASK = 0x1f -- mask 5 bits
local INVALID_CHARACTER_IDX = 0xff
local CHARACTER_TO_CHAR_IDX = {}

for i = 1, 256, 1 do
    CHARACTER_TO_CHAR_IDX[i] = INVALID_CHARACTER_IDX
end

for i = 1, #SEED_CHARACTERS, 1 do
    local stringByte = string.byte(SEED_CHARACTERS, i)
    CHARACTER_TO_CHAR_IDX[stringByte + 1] = i - 1
end

-- Since there are only 32 possible characters, with indices in the [0, 31] range, we only need
-- 5 bits to encode each character. We use the Seed to encode/decode the first 6 non blank
-- characters, and the 2 most significant bits of the 7th character. The remaining 3 bits of the
-- 7th and the 8th character are encoded/decoded using the Check value.

---@param n integer
---@return integer
local function to_uint8(n)
    return n & 0xFF
end

---@param seed integer
---@return integer
local function compute_check(seed)
    local remaining = seed
    local computedCheck = 0
    while (remaining ~= 0) do
        local tmp = to_uint8(computedCheck + to_uint8(remaining))
        computedCheck = to_uint8(to_uint8(tmp * 2) + (tmp >> 7))
        remaining = remaining >> 5
    end

    return computedCheck
end

---@param str string
---@return integer
local function String2Seed(str)
    if #str ~= 9 then
        return 0
    end

    if StringUtils.At(str, STRING_BLANK_POS) ~= ' ' then
        return 0
    end

    -- get char indices
    local charIndices = {}
    for i = 1, 9, 1 do
        if i == STRING_BLANK_POS then
            goto continue
        end

        local byteVal = string.byte(str, i)
        local charIdx = CHARACTER_TO_CHAR_IDX[byteVal + 1]
        table.insert(charIndices, charIdx)

        if charIdx == INVALID_CHARACTER_IDX then
            return 0
        end
        ::continue::
    end

    local seed = 0
    for i = 1, 6, 1 do
        seed = seed | (charIndices[i] << (5 * (6 - i) + 2))
    end
    seed = seed | (charIndices[7] >> 3)
    seed = seed ~ SEED_STRING_XOR

    local computedCheck = compute_check(seed)
    local expectedCheck = to_uint8(charIndices[7] << 5 | charIndices[8])
    if (computedCheck ~= expectedCheck) then
        return 0
    end

    return seed
end

---@param seed integer
---@return string
local function Seed2String(seed)
    local str = ""

    local computedCheck = compute_check(seed)

    seed = seed ~ SEED_STRING_XOR
    local charIndices = {}
    for i = 1, 6, 1 do
        charIndices[i] = to_uint8(seed >> (5 * (6 - i) + 2)) & ENCODE_BIT_MASK
    end

    -- last 2 bits from seed and first 3 from check
    charIndices[7] = (((seed << 8) | computedCheck) >> 5) & ENCODE_BIT_MASK
    charIndices[8] = computedCheck & ENCODE_BIT_MASK

    local SPACE_INDEX = 5
    for i = 1, 9, 1 do
        if i == SPACE_INDEX then
            str = str .. " "
            goto continue
        end

        local idx = i > SPACE_INDEX and i - 1 or i
        local charIdx = charIndices[idx] + 1
        str = str .. StringUtils.At(SEED_CHARACTERS, charIdx)
        ::continue::
    end

    return str
end

---@param str string
---@return boolean
local function IsStringValidSeed(str)
    return String2Seed(str) ~= 0
end

---@class Gameplay.Seeds.StringConversion
local Module = {}

--#region Module

Module.Seed2String = Seed2String
Module.String2Seed = String2Seed
Module.IsStringValidSeed = IsStringValidSeed

--#endregion

return Module