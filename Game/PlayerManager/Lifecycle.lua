--#region Dependencies



--#endregion

---@param manager PlayerManagerComponent
---@param playerType PlayerType | integer
---@return EntityPlayerComponent
local function SpawnCoPlayer(manager, playerType)
end

---@param manager PlayerManagerComponent
---@param player EntityPlayerComponent
local function RemoveCoPlayer(manager, player)
end

---@param manager PlayerManagerComponent
---@param player EntityPlayerComponent
---@param other EntityPlayerComponent
local function ReplacePlayer(manager, player, other)
end

local Module = {}

--#region Module

Module.SpawnCoPlayer = SpawnCoPlayer
Module.RemoveCoPlayer = RemoveCoPlayer
Module.ReplacePlayer = ReplacePlayer

--#endregion

return Module