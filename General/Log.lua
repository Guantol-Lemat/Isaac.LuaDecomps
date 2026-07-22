---@class LogModule
local Module = {}

---@enum eLogType
local eLogType = {
    INFO = 0,
    WARN = 1,
    ERROR = 2,
    ASSERT = 3,
}

---@param type integer
---@param message string
local function LogMessage(type, message)
end

--#region Module

Module.eLogType = eLogType
Module.LogMessage = LogMessage

--#endregion

return Module