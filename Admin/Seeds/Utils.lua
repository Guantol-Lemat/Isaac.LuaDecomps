--#region Dependencies

local BitSetUtils = require("General.Bitset")

--#endregion

---@class SeedsUtils
local Module = {}

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

Module.HasSeedEffect = HasSeedEffect
Module.GetSpecialSeedPermanentCurses = GetSpecialSeedBannedCurses
Module.GetSpecialSeedBannedCurses = GetSpecialSeedPermanentCurses

--#endregion

return Module