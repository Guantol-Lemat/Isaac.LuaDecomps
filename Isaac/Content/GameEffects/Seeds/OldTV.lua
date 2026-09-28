--#region Dependencies

local IsaacUtils = require("Isaac.Utils.Common")
local ISeeds = require("Isaac.Interface.Seeds")

local eShaderType = Renderer.ShaderType

--#endregion

---@param game Component.Game
---@return boolean
local function ShouldRender(game)
    return ISeeds.HasSeedEffect(game.m_seeds, SeedEffect.SEED_OLD_TV)
end

---@param graphics Engine.GraphicsManager
---@param game Component.Game
---@param surface Engine.Image
local function Render(graphics, game, surface)
    graphics:Clear()
    graphics:SetBlendMode_Type(BlendType.CONSTANT)
    IsaacUtils.LoadShader(eShaderType.SHADER_OLDTV)
    local buffer = IsaacUtils.RenderScreenSurface(surface)

    if buffer then
        local amount = game.m_frameCount * 0.05

        local width = surface:GetWidth()
        local height = surface:GetHeight()
        local imageWidth = surface:GetPaddedWidth()
        local imageHeight = surface:GetPaddedHeight()

        for i = 1, 4, 1 do
            local offset = (i - 1) * 11
            buffer[5 + offset] = amount
            buffer[7 + offset] = width
            buffer[8 + offset] = height
            buffer[9 + offset] = imageWidth
            buffer[10 + offset] = imageHeight
        end
    end
end

---@class Content.Game.OldTV
local Module = {}

--#region Module

Module.ShouldRender = ShouldRender
Module.Render = Render

--#endregion

return Module