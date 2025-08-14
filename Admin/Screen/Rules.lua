--#region Dependencies

local ScreenUtils = require("Admin.Screen.Utils")

--#endregion

---@class ModuleName
local Module = {}

---@param context Context
---@param screen ScreenComponent
---@param position Vector
---@return Vector
local function WorldToScreenPosition(context, screen, position)
    local game = context:GetGame()
    local room = context:GetRoom()

    local screenPosition = ScreenUtils.GetScreenPosition(screen, position, true)
    screenPosition = screenPosition + room.m_renderScrollOffset
    screenPosition = screenPosition + game.m_screenShakeOffset

    return screenPosition
end

--#region Module



--#endregion

return Module