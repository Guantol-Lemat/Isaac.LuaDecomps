--#region Dependencies



--#endregion

---@param room Component.Room
---@return boolean
local function IsAmbushChallenge(room)
    return room.m_type == RoomType.ROOM_CHALLENGE
        or room.m_type == RoomType.ROOM_BOSSRUSH
end

---@class Mechanics.Room.Misc
local Module = {}

--#region Module

Module.IsAmbushChallenge = IsAmbushChallenge

--#endregion

return Module