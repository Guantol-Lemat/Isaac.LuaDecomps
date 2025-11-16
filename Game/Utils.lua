---@class GameUtils
local Module = {}

---@param game GameComponent
---@return boolean
local function IsGreedMode(game)
end

---@param game GameComponent
---@param flags GameStateFlag | integer
---@return boolean
local function HasGameStateFlags(game, flags)
end

---@param game GameComponent
---@return boolean
local function IsPaused(game)
end

---@param game GameComponent
---@return boolean
local function InChallenge(game)
    return not (game.m_dailyChallenge.m_id == 0 and game.m_challenge == Challenge.CHALLENGE_NULL)
end

--#region

Module.IsGreedMode = IsGreedMode
Module.HasGameStateFlags = HasGameStateFlags
Module.IsPaused = IsPaused
Module.InChallenge = InChallenge

--#endregion

return Module