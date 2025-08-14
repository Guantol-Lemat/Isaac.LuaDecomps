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

--#region

Module.IsGreedMode = IsGreedMode
Module.HasGameStateFlags = HasGameStateFlags

--#endregion

return Module