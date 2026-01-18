--#region Dependencies



--#endregion

---@class NetPlayManagerUtils
local Module = {}

---@param netManager NetManagerComponent
---@return boolean
local function IsNetPlay(netManager)
    return #netManager.m_inputDevices ~= 0
end

---@param netManager NetManagerComponent
---@param userId UserId
---@return NetInputDeviceComponent?
local function GetDeviceByUserId(netManager, userId)
end

--#region Module

Module.IsNetPlay = IsNetPlay
Module.GetDeviceByUserId = GetDeviceByUserId

--#endregion

return Module