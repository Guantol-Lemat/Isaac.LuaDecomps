---@class ANM2Admin
local Module = {}

---@param admin ANM2AdminComponent
local function EnableScreenShaking(admin)
    admin.g_ScreenShakingEnabled = true
end

---@param admin ANM2AdminComponent
local function DisableScreenShaking(admin)
    admin.g_ScreenShakingEnabled = false
end

--#region Module

Module.EnableScreenShaking = EnableScreenShaking
Module.DisableScreenShaking = DisableScreenShaking

--#endregion

return Module