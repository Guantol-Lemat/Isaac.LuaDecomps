---@class NetplayManagerUtils
local Module = {}

---@param manager NetplayManagerComponent
---@return boolean
local function IsNetplay(manager)
    return false
end

---@param manager NetplayManagerComponent
---@param controllerIdx integer
---@return boolean
local function IsIdxLocalPlayer(manager, controllerIdx)
    return true
end

--#region Module

Module.IsNetplay = IsNetplay
Module.IsIdxLocalPlayer = IsIdxLocalPlayer

--#endregion

return Module