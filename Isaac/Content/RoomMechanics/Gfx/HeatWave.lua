--#region Dependencies

local G = require("Isaac.Global")

local IsaacUtils = require("Isaac.Utils.Common")
local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")

local eShaderType = Renderer.ShaderType

--#endregion

---@param room Component.Room
---@return boolean
local function UseGraphics(room)
    return room.m_backdrop.m_type == BackdropType.DUNGEON_BEAST and G.Manager.m_options.m_roomGfx_enabled
end

---@param graphics Engine.GraphicsManager
---@param room Component.Room
---@param surface Engine.Image
local function Render(graphics, room, surface)
    graphics:SetBlendMode_Type(BlendType.NORMAL)
    IsaacUtils.LoadShader(eShaderType.SHADER_HEAT_WAVE)
    local buffer = IsaacUtils.RenderScreenSurface(surface)

    if buffer then
        local imageDimensions = Vector(surface:GetPaddedWidth(), surface:GetPaddedHeight())
        local uvToReferenceScale = imageDimensions / (G.POINTSCALE * 1024.0) -- ratio between image dimensions and the reference coordinate-space
        local originPositionUV = IRoom.WorldToScreenPosition(room, room.m_topLeftBound) * (G.POINTSCALE / imageDimensions)
        local t = (G.Game.m_frameCount % 60) / 60
        local pixelationAmount = IGame.GetPixelationRenderAmount()

        for i = 1, 4, 1 do
            local offset = (i - 1) * 15
            buffer[9 + offset] = uvToReferenceScale.X
            buffer[10 + offset] = uvToReferenceScale.Y
            buffer[11 + offset] = originPositionUV.X
            buffer[12 + offset] = originPositionUV.Y
            buffer[13 + offset] = t
            buffer[14 + offset] = pixelationAmount
        end
    end
end

---@class Content.Room.HeatWaveGfx
local Module = {}

--#region Module

Module.UseGraphics = UseGraphics
Module.Render = Render

--#endregion

return Module