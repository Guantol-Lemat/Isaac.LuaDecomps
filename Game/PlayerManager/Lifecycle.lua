--#region Dependencies



--#endregion

---@param manager Component.PlayerManager
---@param playerType PlayerType | integer
---@return Component.Entity.Player
local function SpawnCoPlayer(manager, playerType)
end

---@param manager Component.PlayerManager
---@param player Component.Entity.Player
local function RemoveCoPlayer(manager, player)
end

---@param manager Component.PlayerManager
---@param player Component.Entity.Player
---@param other Component.Entity.Player
local function ReplacePlayer(manager, player, other)
end

local Module = {}

--#region Module

Module.SpawnCoPlayer = SpawnCoPlayer
Module.RemoveCoPlayer = RemoveCoPlayer
Module.ReplacePlayer = ReplacePlayer

--#endregion

return Module