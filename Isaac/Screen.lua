--#region Dependencies



--#endregion

---@class IsaacScreen
local Module = {}

local s_width = 0
local s_height = 0
local s_pointScale = 2.0
local s_displayPixelsPerPoint = 1.0

local function GetRenderPosition(position, snapToClosest)
    local x = (s_width - 338.0) * 0.5 + (position.X - 60.0) * 0.65
    local y = (s_height - 182.0) * 0.5 + (position.Y - 140.0) * 0.65

    if snapToClosest then
        local pixelsPerUnit = s_pointScale * s_displayPixelsPerPoint
        x = math.floor(x * pixelsPerUnit + 0.5) / pixelsPerUnit
        y = math.floor(y * pixelsPerUnit + 0.5) / pixelsPerUnit
    end

    return Vector(x, y)
end

--#region Module

Module.GetRenderPosition = GetRenderPosition

--#endregion

return Module
