--#region Dependencies

local Log = require("General.Log")

--#endregion

---@param persistentData Component.PersistentGameData
---@param value boolean
local function SetReadOnly(persistentData, value)
    local toString = value and "True" or "False"
    Log.LogMessage(Log.eLogType.INFO, string.format("Setting PersistentGameData ReadOnly to %s\n", toString))
    persistentData.m_readOnly = value
end

---@class Gameplay.PersistentData.Misc
local Module = {}

--#region Module

Module.SetReadOnly = SetReadOnly

--#endregion

return Module