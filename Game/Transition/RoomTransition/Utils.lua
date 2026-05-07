---@class RoomTransitionUtils
local Module = {}

---@param roomTransition RoomTransitionComponent
---@return boolean
local function IsActive(roomTransition)
end

---@param roomTransition RoomTransitionComponent
---@return number
local function GetAlpha(roomTransition)
end

---@param game Component.Game
---@param roomIdx GridRooms | integer
---@param direction Direction
---@param animation RoomTransitionAnim
---@param player Component.Entity.Player
---@param dimension integer
local function StartRoomTransition(game, roomIdx, direction, animation, player, dimension)
end

--#region Module

Module.IsActive = IsActive
Module.GetAlpha = GetAlpha
Module.StartRoomTransition = StartRoomTransition

--#endregion

return Module