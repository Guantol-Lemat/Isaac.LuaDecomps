--#region Dependencies

local G = require("Isaac.Global")

local IsaacUtils = require("Isaac.Utils.Common")
local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")

local eShaderType = Renderer.ShaderType

--#endregion

---@param game Component.Game
---@return boolean
local function UseGraphics(game)
    return game.m_dizzy_intensity > 0.0
end

---@param graphics Engine.GraphicsManager
---@param room Component.Room
---@param surface Engine.Image
local function Render(graphics, room, surface)
    local manager = G.Manager
    local game = G.Game
    graphics:SetBlendMode_Type(BlendType.NORMAL)
    IsaacUtils.LoadShader(eShaderType.SHADER_DIZZY)

    local buffer = IsaacUtils.RenderScreenSurface(surface)
    if buffer then
        local imageDimensions = Vector(surface:GetPaddedWidth(), surface:GetPaddedHeight())
        local imageRatio = Vector(surface:GetWidth(), surface:GetHeight()) / imageDimensions
        local uvToReferenceScale = imageDimensions / (G.POINTSCALE * 1024.0) -- ratio between image dimensions and the reference coordinate-space
        local roomTopLeft = (IRoom.WorldToScreenPosition(room, room.m_topLeftBound) * G.POINTSCALE) / imageDimensions

        local interpolationFrame = IGame.IsPaused(game) and 0 or (manager.m_frameCount + 1) % 2
        local amount = (((game.m_frameCount % 600) * 2) + interpolationFrame) / 120.0
        local dizzyIntensity = game.m_dizzy_intensity
        local pixelation = IGame.GetPixelationRenderAmount()

        for i = 1, 4, 1 do
            local offset = (i - 1) * 18
            buffer[9 + offset] = imageRatio.X
            buffer[10 + offset] = imageRatio.Y
            buffer[11 + offset] = uvToReferenceScale.X
            buffer[12 + offset] = uvToReferenceScale.Y
            buffer[13 + offset] = roomTopLeft.X
            buffer[14 + offset] = roomTopLeft.Y
            buffer[15 + offset] = amount
            buffer[16 + offset] = dizzyIntensity
            buffer[17 + offset] = pixelation
        end
    end
end

---@class Content.Room.DizzyGfx
local Module = {}

--#region Module

Module.UseGraphics = UseGraphics
Module.Render = Render

--#endregion

return Module