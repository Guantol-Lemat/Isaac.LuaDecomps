---@class SystemTimeModule
local Module = {}

---@param system SystemAdminComponent
local function GetMilliseconds(system)
    return Isaac.GetTime()
end

--#region Module

Module.GetMilliseconds = GetMilliseconds

--#endregion

return Module