--#region Dependencies

local BlendMode = require("Admin.Graphics.BlendMode")
local Log = require("General.Log")

--#endregion

---@class GraphicsAdmin
local Module = {}

---@enum ePredefinedShader
local ePredefinedShader = {
    SHADER_1 = 0,
    SHADER_2 = 1,
    SHADER_3 = 2,
}

---@param admin GraphicsAdminComponent
local function PushRenderTarget(admin)
    local stack = admin.g_renderTargetStack
    if #stack >= 16 then
        Log.LogMessage(3, "PushRenderTarget: stack overflow!\n")
    end

    table.insert(admin.g_renderTargetStack, {admin.m_renderTargetTexture, admin.m_renderTargetUsesScreenSize})
end

---@param admin GraphicsAdminComponent
local function PopRenderTarget(admin)

end

---@param admin GraphicsAdminComponent
---@param blendMode eBlendMode
local function SetBlendMode(admin, blendMode)
    local mode = BlendMode.GetBlendMode(admin, blendMode)
    admin:SetBlendMode(mode)
end

---@param admin GraphicsAdminComponent
---@return BlendModeComponent
local function GetBlendMode(admin)
    return BlendMode.Copy(admin.m_blendMode)
end

---@param admin GraphicsAdminComponent
local function Present(admin)
end

---@param admin GraphicsAdminComponent
---@param quad DestinationQuadComponent
---@return boolean
local function IsQuadOnScreen(admin, quad)
end

---@param admin GraphicsAdminComponent
---@return ePredefinedShader
local function get_predefined_shader(admin)
end

---@param admin GraphicsAdminComponent
---@param shader ePredefinedShader
local function set_predefined_shader(admin, shader)
end

---@param admin GraphicsAdminComponent
---@return number
local function get_pixel_scale(admin)
end

--#region Module

Module.ePredefinedShader = ePredefinedShader
Module.PushRenderTarget = PushRenderTarget
Module.PopRenderTarget = PopRenderTarget
Module.GetBlendMode = GetBlendMode
Module.SetBlendMode = SetBlendMode
Module.Present = Present
Module.IsQuadOnScreen = IsQuadOnScreen
Module.get_predefined_shader = get_predefined_shader
Module.set_predefined_shader = set_predefined_shader
Module.get_pixel_scale = get_pixel_scale

--#endregion

return Module