--#region Dependencies

local BitsetUtils = require("General.Bitset")
local Enums = require("General.Enums")
local ChallengeParamsUtils = require("Admin.Challenge.Utils")
local PersistentDataRules = require("Admin.PersistentData.Rules")
local PlayerManagerRules = require("Game.PlayerManager.Rules")
local BackwardsPathRules = require("Level.BackwardsPath.Rules")
local CurseUtils = require("Level.Curse.Utils")

local eSpecialDailyRuns = Enums.eSpecialDailyRuns

--#endregion

---@class CurseInitLogic
local Module = {}

---@param context Context
---@param level LevelComponent
---@param rng RNG
---@param chance integer
---@return integer
local function hook_evaluate_curse_chance(context, level, rng, chance)
    local isHardMode = context:GetGame().m_difficulty == Difficulty.DIFFICULTY_HARD
    local persistentData = context:GetPersistentGameData()

    if PersistentDataRules.IsUnlocked(context, persistentData, Achievement.WOMB) then
        chance = isHardMode and 20 or 30
    end

    local everythingIsTerrible = PersistentDataRules.IsUnlocked(context, persistentData, Achievement.EVERYTHING_IS_TERRIBLE)
    if everythingIsTerrible then
        chance = isHardMode and 6 or 10
    end

    if persistentData.m_eventCounters[EventCounter.ISAAC_KILLS] ~= 0 then
        chance = isHardMode and 3 or 5
    end

    if level.m_stage == LevelStage.STAGE1_1 and not everythingIsTerrible then
        chance = 0
    end

    return chance
end

---@param context Context
---@param level LevelComponent
---@param rng RNG
---@param block boolean
---@return boolean override
local function hook_block_evaluate_curse(context, level, rng, block)
    local game = context:GetGame()
    local playerManager = context:GetPlayerManager()

    if level.m_stage == LevelStage.STAGE8 then
        return true
    end

    if BackwardsPathRules.IsBackwardsPath(game, level) then
        return true
    end

    if PlayerManagerRules.AnyoneHasCollectible(context, playerManager, CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        return true
    end

    if game.m_dailyChallenge.m_specialDailyChallenge == eSpecialDailyRuns.SATORU_IWATA_S_BIRTHDAY then
        return true
    end

    return block
end

---@param context Context
---@param level LevelComponent
---@param rng RNG
---@return integer chance, boolean blocked
local function evaluate_curse(context, level, rng)
    local game = context:GetGame()
    local block = false
    local chance = game.m_difficulty == Difficulty.DIFFICULTY_HARD and 40 or 80
    chance = hook_evaluate_curse_chance(context, level, rng, chance)

    if chance == 0 then
        return chance, block
    end

    block = hook_block_evaluate_curse(context, level, rng, block)
    return chance, block
end

---@type fun(context: Context, level: LevelComponent): LevelCurse | integer
local function set_curse_of_labyrinth(context, level)
    if CurseUtils.CanStageHaveCurseOfLabyrinth(context, level.m_stage) then
        return LevelCurse.CURSE_OF_LABYRINTH
    end

    return 0
end

---@type fun(context: Context, level: LevelComponent): LevelCurse | integer
local function set_curse_of_the_lost(context)
    if CurseUtils.CanHaveCurseOfTheLost(context) then
        return LevelCurse.CURSE_OF_THE_LOST
    end

    return 0
end

---@type fun(context: Context, level: LevelComponent): LevelCurse | integer
local function set_curse_of_darkness(context)
    return LevelCurse.CURSE_OF_DARKNESS
end

---@type fun(context: Context, level: LevelComponent): LevelCurse | integer
local function set_curse_of_unknown(context)
    return LevelCurse.CURSE_OF_THE_UNKNOWN
end

---@type fun(context: Context, level: LevelComponent): LevelCurse | integer
local function set_curse_of_maze(context)
    if CurseUtils.CanHaveCurseOfMaze(context) then
        return LevelCurse.CURSE_OF_MAZE
    end

    return 0
end

---@type fun(context: Context, level: LevelComponent): LevelCurse | integer
local function set_curse_of_blind(context)
    if CurseUtils.CanHaveCurseOfBlind(context) then
        return LevelCurse.CURSE_OF_BLIND
    end

    return 0
end

local SWITCH_OUTCOME_TO_CURSE_SETTER = {
    [0] = set_curse_of_labyrinth,
    [1] = set_curse_of_the_lost,
    [2] = set_curse_of_darkness,
    [3] = set_curse_of_unknown,
    [4] = set_curse_of_maze,
    [5] = set_curse_of_blind,
    default = function() return 0 end;
}

---@param context Context
---@param level LevelComponent
---@param rng RNG
---@return LevelCurse | integer
local function pick_curse(context, level, rng)
    local outcome = rng:RandomInt(6)
    local curseSetter = SWITCH_OUTCOME_TO_CURSE_SETTER[outcome] or SWITCH_OUTCOME_TO_CURSE_SETTER.default
    return curseSetter(context, level)
end

---@param context Context
---@param level LevelComponent
---@param rng RNG
---@param curses LevelCurse | integer
---@return LevelCurse | integer
local function hook_post_get_curse(context, level, rng, curses)
    local game = context:GetGame()
    if game.m_dailyChallenge.m_specialDailyChallenge == eSpecialDailyRuns.I_FORGOT_DAY then
        curses = curses | LevelCurse.CURSE_OF_BLIND | LevelCurse.CURSE_OF_THE_UNKNOWN | LevelCurse.CURSE_OF_THE_LOST
    end

    if game.m_challenge ~= Challenge.CHALLENGE_NULL and not CurseUtils.CanStageHaveCurseOfLabyrinth(context, level.m_stage) then
        curses = BitsetUtils.Clear(curses, LevelCurse.CURSE_OF_LABYRINTH)
    end

    if level.m_stage == LevelStage.STAGE4_3 or game.m_victoryRun_currentLap > 2 then
        curses = BitsetUtils.Clear(curses, LevelCurse.CURSE_OF_DARKNESS)
    end

    return curses
end

---@param context Context
---@param level LevelComponent
---@param rng RNG
---@return LevelCurse | integer
local function get_curse_flags(context, level, rng)
    local curses = 0

    local chance, blocked = evaluate_curse(context, level, rng)
    if chance ~= 0 and not blocked then
        if rng:RandomInt(chance) == 0 then
            curses = curses | pick_curse(context, level, rng)
        end
        -- PostCurseEval callback
    end

    local game = context:GetGame()
    if game.m_challenge ~= Challenge.CHALLENGE_NULL then
        local challengeParams = context:GetChallengeParams(game.m_challenge)
        curses = ChallengeParamsUtils.ApplyCurseModifiers(challengeParams, curses)
    end

    curses = hook_post_get_curse(context, level, rng, curses)
    return curses
end

---@param context Context
---@param level LevelComponent
---@param rng RNG
local function Init(context, level, rng)
    level.m_curses = get_curse_flags(context, level, rng)
end

--#region Module

Module.Init = Init

--#endregion

return Module