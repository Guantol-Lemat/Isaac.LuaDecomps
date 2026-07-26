---@class ScreenUtils
local Module = {}

---@param screen ScreenComponent
---@param position Vector
---@param snapToClosest boolean
---@return Vector
local function GetScreenPosition(screen, position, snapToClosest)
    local x = (screen.m_width - 338.0) * 0.5 + (position.X - 60.0) * 0.65
    local y = (screen.m_height - 182.0) * 0.5 + (position.Y - 140.0) * 0.65

    if snapToClosest then
        local pixelsPerUnit = screen.m_pointScale * screen.m_displayPixelsPerPoint
        x = math.floor(x * pixelsPerUnit + 0.5) / pixelsPerUnit
        y = math.floor(y * pixelsPerUnit + 0.5) / pixelsPerUnit
    end

    return Vector(x, y)
end

--#region Module

Module.GetScreenPosition = GetScreenPosition

--#endregion

return Module
