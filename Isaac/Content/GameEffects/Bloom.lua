--#region Dependencies

local G = require("Isaac.Global")

local IsaacUtils = require("Isaac.Utils.Common")

local eShaderType = Renderer.ShaderType

--#endregion

---@param game Component.Game
---@return boolean
local function ShouldRender(game)
    return game.m_bloom_countdown > 0 and G.Manager.m_options.m_bloom_enabled
end

---@param graphics Engine.GraphicsManager
---@param game Component.Game
---@param surface Engine.Image
local function Render(graphics, game, surface)
    graphics:Clear()
    graphics:SetBlendMode_Type(BlendType.CONSTANT)
    IsaacUtils.LoadShader(eShaderType.SHADER_BLOOM)
    local buffer = IsaacUtils.RenderScreenSurface(surface)

    if buffer then
        local halfDuration = game.m_bloom_duration * 0.5
        local t = 1.0 - ((math.abs(game.m_bloom_countdown - halfDuration)) / halfDuration)
        local bloom = math.sin((t * 0.5) * math.pi) * game.m_bloom_strength

        local ratioX = 2.0 / surface:GetPaddedWidth()
        local ratioY = 2.0 / surface:GetPaddedHeight()


        for i = 1, 4, 1 do
            local offset = (i - 1) * 12
            buffer[9 + offset] = bloom
            buffer[10 + offset] = ratioX
            buffer[11 + offset] = ratioY
        end
    end
end

---@class Content.Game.Bloom
local Module = {}

--#region Module

Module.ShouldRender = ShouldRender
Module.Render = Render

--#endregion

return Module