--#region Dependencies

local RoomUpdate = require("Game.Room.Update.Logic")

--#endregion

---@class LevelUpdateLogic
local Module = {}

---@param level LevelComponent
local function Update(level)
    RoomUpdate.Update(context, level.m_room)
end

--#region Module

Module.Update = Update

--#endregion

return Module