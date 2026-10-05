--#region Dependencies

local G = require("Isaac.Global")
local C = require("Isaac.Constants")

local IsaacUtils = require("Isaac.Utils.Common")
local ColorUtils = require("General.VanillaAPI.Color")
local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")

local eShaderType = Renderer.ShaderType

--#endregion

---@param graphics Engine.GraphicsManager
---@param room Component.Room
---@param surface Engine.Image
local function Render(graphics, room, surface)
    local manager = G.Manager
    local game = G.Game

    graphics:SetBlendMode_Type(BlendType.NORMAL)
    local source = SourceQuad.NewFromBounds(Vector(1.0, 0.0), Vector(0.0, 1.0), true)
    local dest = DestinationQuad.NewFromRectangle(C.VECTOR_ZERO, G.WIDTH, G.HEIGHT)

    if not G.Manager.m_options.m_roomGfx_enabled then
        IsaacUtils.LoadShader(eShaderType.SHADER_COLOR_OFFSET)
        local buffer = surface:Render_SourceDestQuadFlatColor(source, dest, C.COLOR_WHITE)
        if buffer then
            ColorUtils.FillVertices(C.COLOR_MOD_DEFAULT, buffer, surface)
        end

        return
    end

    IsaacUtils.LoadShader(eShaderType.SHADER_MIRROR)
    local buffer = surface:Render_SourceDestQuadFlatColor(source, dest, C.COLOR_WHITE)
    if buffer then
        local imageDimensions = Vector(surface:GetPaddedWidth(), surface:GetPaddedHeight())
        local imageRatio = Vector(surface:GetWidth(), surface:GetHeight()) / imageDimensions
        local uvToReferenceScale = imageDimensions / (G.POINTSCALE * 1024.0) -- ratio between image dimensions and the reference coordinate-space
        local roomTopLeft = (IRoom.WorldToScreenPosition(room, room.m_topLeftBound) * G.POINTSCALE) / imageDimensions

        local interpolationFrame = IGame.IsPaused(game) and 0 or (manager.m_frameCount + 1) % 2
        local amount = (((game.m_frameCount % 600) * 2) + interpolationFrame) / 120.0
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
            buffer[16 + offset] = 0.0
            buffer[17 + offset] = pixelation
        end
    end
end

---@class Content.Room.Mirror
local Module = {}

--#region Module

Module.Render = Render

--#endregion

return Module