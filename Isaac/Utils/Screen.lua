--#region Dependencies



--#endregion

---@class IsaacScreen
local Module = {}

local s_width = 0
local s_height = 0
local s_pointScale = 2.0
local s_displayPixelsPerPoint = 1.0

local WORLD_VIEWPORT_SIZE = Vector(338.0, 182, 0)
local WORLD_RENDER_ORIGIN = Vector(60.0, 140.0)
local WORLD_TO_SCREEN_SCALE = 0.65

---@param position Vector
---@param snapToClosest boolean
---@return Vector
local function GetRenderPosition(position, snapToClosest)
    local screenSize = Vector(s_width, s_height)
    local renderPosition = (position - WORLD_RENDER_ORIGIN) * WORLD_TO_SCREEN_SCALE
    local uiViewport_topLeft = (screenSize - WORLD_VIEWPORT_SIZE) * 0.5

    -- Translate camera relative render position to viewport relative render position
    renderPosition = renderPosition + uiViewport_topLeft

    if snapToClosest then
        local pixelsPerUnit = s_pointScale * s_displayPixelsPerPoint
        local x, y = renderPosition.X, renderPosition.Y
        x = math.floor(x * pixelsPerUnit + 0.5) / pixelsPerUnit
        y = math.floor(y * pixelsPerUnit + 0.5) / pixelsPerUnit

        renderPosition = Vector(x, y)
    end

    return renderPosition
end

--#region Module

Module.GetRenderPosition = GetRenderPosition

--#endregion

return Module
