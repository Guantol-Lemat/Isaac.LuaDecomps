--#region Dependencies

local Log = require("General.Log")

--#endregion

---@param persistentGameData PersistentDataComponent
---@param value boolean
local function SetReadOnly(persistentGameData, value)
    local valueString = value and "True" or "False"
    Log.LogMessage(0, string.format("Setting PersistentGameData ReadOnly to %s\n", valueString))
    persistentGameData.m_readOnly = value
end

local Module = {}

--#region Module

Module.SetReadOnly = SetReadOnly

--#endregion

return Module