--#region Dependencies



--#endregion

---@class NetPlayManagerUtils
local Module = {}

---@param netManager Component.NetManager
---@return boolean
local function IsNetPlay(netManager)
    return #netManager.m_inputDevices ~= 0
end

---@param netManager Component.NetManager
---@param idx integer
---@return boolean
local function IsIdxLocalPlayer(netManager, idx)

end

---@param netManager Component.NetManager
---@param userId UserId
---@return NetInputDeviceComponent?
local function GetDeviceByUserId(netManager, userId)
end

--#region Module

Module.IsNetPlay = IsNetPlay
Module.IsIdxLocalPlayer = IsIdxLocalPlayer
Module.GetDeviceByUserId = GetDeviceByUserId

--#endregion

return Module