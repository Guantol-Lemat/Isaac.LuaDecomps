--#region Dependencies

local BitSetUtils = require("General.Bitset")
local StringUtils = require("General.String")

--#endregion

---@class SeedsUtils
local Module = {}

---@param seeds SeedsComponent
---@param stage LevelStage | integer
---@return integer
local function GetStageSeed(seeds, stage)
    assert(seeds.m_startSeed ~= 0, "Game Start Seed was not set")
    return seeds.m_stageSeeds[stage + 1]
end

local VALID_SEED_CHARACTERS = "ABCDEFGHJKLMNPQRSTWXYZ01234V6789"
local CHARACTER_TO_SEED_VALUES = {}

for i = 1, 256, 1 do
    CHARACTER_TO_SEED_VALUES[i] = 0xff
end

for i = 1, #VALID_SEED_CHARACTERS, 1 do
    local stringByte = string.byte(VALID_SEED_CHARACTERS, i)
    CHARACTER_TO_SEED_VALUES[stringByte + 1] = i - 1
end

---@param n integer
---@return integer
local function to_uint8(n)
    return n & 0xFF
end

---@param stringSeed string
---@return integer
local function String2Seed(stringSeed)
    if #stringSeed ~= 9 then
        return 0
    end

    if StringUtils.At(stringSeed, 5) ~= ' ' then
        return 0
    end

    local seedValues = {}
    for i = 1, 4, 1 do
        local byteVal = string.byte(stringSeed, i)
        local mappedValue = CHARACTER_TO_SEED_VALUES[byteVal + 1]
        table.insert(seedValues, mappedValue)

        if mappedValue == 0xff then
            return 0
        end
    end

    -- skip blank space at position 5

    for i = 6, 9, 1 do
        local byteVal = string.byte(stringSeed, i)
        local mappedValue = CHARACTER_TO_SEED_VALUES[byteVal + 1]
        table.insert(seedValues, mappedValue)

        if mappedValue == 0xff then
            return 0
        end
    end

    local temp = seedValues[1] << 5 | seedValues[2]
    temp = temp << 5 | seedValues[3]
    temp = temp << 5 | seedValues[4]
    temp = temp << 5 | seedValues[5]
    temp = temp << 5 | seedValues[6]
    temp = temp << 2 | (seedValues[7] >> 3)
    local seed = temp ~ 0xfef7ffd

    local remaining = seed
    local computedCheck = 0
    while (remaining ~= 0) do
        local tmp = to_uint8(computedCheck + to_uint8(remaining))
        computedCheck = to_uint8(tmp * 2) + (tmp >> 7)
        remaining = remaining >> 5
    end

    local expectedCheck = to_uint8(seedValues[7] << 5 | seedValues[8])
    if (computedCheck ~= expectedCheck) then
        return 0
    end

    return seed
end

---@param seeds SeedsComponent
---@param seed SeedEffect
---@return boolean
local function HasSeedEffect(seeds, seed)
end

---@param seeds SeedsComponent
---@return LevelCurse | integer
local function GetSpecialSeedPermanentCurses(seeds)
    local curses = 0
    if HasSeedEffect(seeds, SeedEffect.SEED_PERMANENT_CURSE_DARKNESS) then
        curses = curses | LevelCurse.CURSE_OF_DARKNESS
    end

    if HasSeedEffect(seeds, SeedEffect.SEED_PERMANENT_CURSE_LABYRINTH) then
        curses = curses | LevelCurse.CURSE_OF_LABYRINTH
    end

    if HasSeedEffect(seeds, SeedEffect.SEED_PERMANENT_CURSE_LOST) then
        curses = curses | LevelCurse.CURSE_OF_THE_LOST
    end

    if HasSeedEffect(seeds, SeedEffect.SEED_PERMANENT_CURSE_UNKNOWN) then
        curses = curses | LevelCurse.CURSE_OF_THE_UNKNOWN
    end

    if HasSeedEffect(seeds, SeedEffect.SEED_PERMANENT_CURSE_MAZE) then
        curses = curses | LevelCurse.CURSE_OF_MAZE
    end

    if HasSeedEffect(seeds, SeedEffect.SEED_PERMANENT_CURSE_BLIND) then
        curses = curses | LevelCurse.CURSE_OF_BLIND
    end

    if HasSeedEffect(seeds, SeedEffect.SEED_PERMANENT_CURSE_CURSED) then
        curses = curses | LevelCurse.CURSE_OF_THE_CURSED
    end

    return curses
end

---@param seeds SeedsComponent
---@return LevelCurse | integer
local function GetSpecialSeedBannedCurses(seeds)
    local curses = 0
    if HasSeedEffect(seeds, SeedEffect.SEED_PREVENT_CURSE_DARKNESS) then
        curses = curses | LevelCurse.CURSE_OF_DARKNESS
    end

    if HasSeedEffect(seeds, SeedEffect.SEED_PREVENT_CURSE_LABYRINTH) then
        curses = curses | LevelCurse.CURSE_OF_LABYRINTH
    end

    if HasSeedEffect(seeds, SeedEffect.SEED_PREVENT_CURSE_LOST) then
        curses = curses | LevelCurse.CURSE_OF_THE_LOST
    end

    if HasSeedEffect(seeds, SeedEffect.SEED_PREVENT_CURSE_UNKNOWN) then
        curses = curses | LevelCurse.CURSE_OF_THE_UNKNOWN
    end

    if HasSeedEffect(seeds, SeedEffect.SEED_PREVENT_CURSE_MAZE) then
        curses = curses | LevelCurse.CURSE_OF_MAZE
    end

    if HasSeedEffect(seeds, SeedEffect.SEED_PREVENT_CURSE_BLIND) then
        curses = curses | LevelCurse.CURSE_OF_BLIND
    end

    if HasSeedEffect(seeds, SeedEffect.SEED_PREVENT_ALL_CURSES) then
        curses = curses | BitSetUtils.SetAllBits(LevelCurse.NUM_CURSES)
    end

    if HasSeedEffect(seeds, SeedEffect.SEED_G_FUEL) then
        curses = curses | LevelCurse.CURSE_OF_BLIND
    end

    return curses
end

--#region Module

Module.String2Seed = String2Seed
Module.GetStageSeed = GetStageSeed
Module.HasSeedEffect = HasSeedEffect
Module.GetSpecialSeedPermanentCurses = GetSpecialSeedBannedCurses
Module.GetSpecialSeedBannedCurses = GetSpecialSeedPermanentCurses

--#endregion

return Module