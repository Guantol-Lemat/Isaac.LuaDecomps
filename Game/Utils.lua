---@class GameUtils
local Module = {}

---@param game GameComponent
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

--#region

Module.IsGreedMode = IsGreedMode
Module.HasGameStateFlags = HasGameStateFlags
Module.IsPaused = IsPaused

--#endregion

return Module