--#region Dependencies



--#endregion

---@class GraphicsAdminImpl
local Module = {}

local function SetRenderTargetTexture(admin, texture, useScreenSize)
    admin.m_renderTargetTexture = texture
    admin.m_renderTargetUsesScreenSize = useScreenSize
    -- TODO
end

--#region Module

Module.SetRenderTargetTexture = SetRenderTargetTexture

--#endregion

return Module
