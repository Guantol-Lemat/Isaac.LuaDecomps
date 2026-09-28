--#region Dependencies

local G = require("Isaac.Global")
local C = require("Isaac.Constants")

local IsaacUtils = require("Isaac.Utils.Common")
local IRoomTransition = require("Isaac.Interface.RoomTransition")

local eShaderType = Renderer.ShaderType

--#endregion

local function ShouldRender(game)
    return not (IRoomTransition.IsRendering(game.m_roomTransition) and IRoomTransition.IsRenderingBossIntro(game.m_roomTransition))
        and G.Manager.m_options.m_colorModifier_enabled
end

---@param graphics Engine.GraphicsManager
---@param game Component.Game
---@param surface Engine.Image
local function Render(graphics, game, surface)
    graphics:Clear()
    graphics:SetBlendMode_Type(BlendType.CONSTANT)
    IsaacUtils.LoadShader(eShaderType.SHADER_COLOR_MOD)

    local source = C.SOURCE_QUAD_FULL
    local dest = DestinationQuad.NewFromRectangle(C.VECTOR_ZERO, G.WIDTH, G.HEIGHT)
    local colorMod = game.m_colorModifier_current
    local color = KColor(colorMod.R, colorMod.G, colorMod.B, 1.0)
    local buffer = surface:Render_SourceDestQuadFlatColor(source, dest, color)

    if buffer then
        local alpha = colorMod.A
        local brightness = colorMod.brightness
        local contrast = colorMod.contrast

        for i = 1, 4, 1 do
            local offset = (i - 1) * 12
            buffer[9 + offset] = alpha
            buffer[10 + offset] = brightness
            buffer[11 + offset] = contrast
        end
    end
end

---@class Content.Game.ColorMod
local Module = {}

--#region Module

Module.ShouldRender = ShouldRender
Module.Render = Render

--#endregion

return Module