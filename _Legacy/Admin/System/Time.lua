---@class SystemTimeModule
local Module = {}

local function GetMilliseconds()
    return Isaac.GetTime()
end

--#region Module

Module.GetMilliseconds = GetMilliseconds

--#endregion

return Module