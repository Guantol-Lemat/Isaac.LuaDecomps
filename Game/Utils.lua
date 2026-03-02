---@class GameUtils
local Module = {}

---@param game GameComponent
---@return boolean
local function IsGreedMode(game)
end

---@param game GameComponent
---@return integer
local function GetMode(game)
    return IsGreedMode(game) and 1 or 0
end

---@param game GameComponent
---@return boolean
local function IsHardMode(game)
    local difficulty = game.m_difficulty
    return difficulty == Difficulty.DIFFICULTY_HARD or difficulty == Difficulty.DIFFICULTY_GREEDIER
end

---@param game GameComponent
---@param flags GameStateFlag | integer
---@return boolean
local function HasGameStateFlags(game, flags)
end

---@param myContext Context.Manager
---@param game GameComponent
---@return boolean
local function IsPaused(myContext, game)
end

---@param myContext Context.Manager
---@param game GameComponent
---@return ChallengeParamsComponent
local function GetChallengeParams(myContext, game)
    local dailyChallenge = game.m_dailyChallenge
    if dailyChallenge.m_id ~= 0 then
        return dailyChallenge.m_challengeParams
    end

    local isaac = myContext.manager
    return isaac.m_challengeParams[game.m_challenge + 1]
end

---@param game GameComponent
---@return boolean
local function InChallenge(game)
    return not (game.m_dailyChallenge.m_id == 0 and game.m_challenge == Challenge.CHALLENGE_NULL)
end

---@param myContext Context.Manager
---@param game GameComponent
---@return boolean
local function AchievementUnlocksDisallowed(myContext, game)
end

--#region

Module.IsGreedMode = IsGreedMode
Module.GetMode = GetMode
Module.IsHardMode = IsHardMode
Module.HasGameStateFlags = HasGameStateFlags
Module.IsPaused = IsPaused
Module.GetChallengeParams = GetChallengeParams
Module.InChallenge = InChallenge
Module.AchievementUnlocksDisallowed = AchievementUnlocksDisallowed

--#endregion

return Module