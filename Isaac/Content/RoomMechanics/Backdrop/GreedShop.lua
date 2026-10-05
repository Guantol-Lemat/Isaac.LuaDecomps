--#region Dependencies

local Engine = require("Engine.Global")
local G = require("Isaac.Global")

--#endregion

local COLOR_GREED_SHOP_FLOOR = KColor(71/255, 42/255, 26/255, 1.0)

---@param room Component.Room
local function RenderFloorColor(room)
    local topLeft = G.Game.m_screenShake_offset + room.m_renderSurfaceTopLeft + room.m_renderScrollOffset + 52.0
    local bottomRight = (Vector(room.m_gridWidth, room.m_gridHeight) - 2.0) * 26.0
    local dest = DestinationQuad.NewFromBounds(topLeft, bottomRight)
    local color = COLOR_GREED_SHOP_FLOOR
    Engine.ShapeRenderer:FillQuad(dest, color)
end

---@class Content.Room.Backdrop.GreedShop
local Module = {}

--#region Module

Module.RenderFloorColor = RenderFloorColor

--#endregion

return Module