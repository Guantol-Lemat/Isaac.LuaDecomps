--#region Dependencies

local Engine = require("Engine.Global")
local G = require("Isaac.Global")
local C = require("Isaac.Constants")

local MathUtils = require("General.Math")

--#endregion

local function RenderFade(graphics, game)
    if game.m_backwardsPath_fadeProgress <= 0 then
        return
    end

    graphics:SetBlendMode_Type(BlendType.ADDITIVE)

    local dest = DestinationQuad.NewFromRectangle(C.VECTOR_ZERO, G.WIDTH, G.HEIGHT)
    local alpha = MathUtils.Clamp(game.m_backwardsPath_fadeProgress / 90.0, 0.0, 1.0)
    local color = KColor(1.0, 1.0, 1.0, alpha)
    Engine.ShapeRenderer:FillQuad(dest, color)

    graphics:SetBlendMode_Type(BlendType.NORMAL) -- might be an incorrect restore in some cases, but it has no effect.
end

---@class Content.Game.BackwardsPath
local Module = {}

--#region Module

Module.RenderFade = RenderFade

--#endregion

return Module