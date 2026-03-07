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

---@param game GameComponent
---@param roomIdx GridRooms | integer
---@param direction Direction
---@param animation RoomTransitionAnim
---@param player EntityPlayerComponent
---@param dimension integer
local function StartRoomTransition(game, roomIdx, direction, animation, player, dimension)
end

--#region Module

Module.IsActive = IsActive
Module.GetAlpha = GetAlpha
Module.StartRoomTransition = StartRoomTransition

--#endregion

return Module