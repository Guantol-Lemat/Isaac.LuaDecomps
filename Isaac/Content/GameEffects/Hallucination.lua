--#region Dependencies

local G = require("Isaac.Global")
local S = require("Isaac.Core.Game.Static")
local C = require("Isaac.Constants")

local IsaacUtils = require("Isaac.Utils.Common")
local ColorUtils = require("General.VanillaAPI.Color")
local IRoom = require("Isaac.Interface.Room")

local eShaderType = Renderer.ShaderType

--#endregion

---@param game Component.Game
---@return boolean
local function ShouldRender(game)
    return game.m_hallucination_countdown > 0
end

---@param graphics Engine.GraphicsManager
---@param game Component.Game
---@param surface Engine.Image
local function Render(graphics, game, surface)
    graphics:Clear()
    graphics:SetBlendMode_Type(BlendType.CONSTANT)
    IsaacUtils.LoadShader(eShaderType.SHADER_HALLUCINATION)
    local buffer = IsaacUtils.RenderScreenSurface(surface)

    local amount = 1.0
    if game.m_hallucination_duration - game.m_hallucination_countdown < 10 then -- first 10 frames
        amount = (game.m_hallucination_duration - game.m_hallucination_countdown) / 10
    elseif game.m_hallucination_countdown < 10 then
        amount = game.m_hallucination_countdown / 10
    end

    if buffer then
        local width = surface:GetWidth()
        local height = surface:GetHeight()
        local imageWidth = surface:GetPaddedWidth()
        local imageHeight = surface:GetPaddedHeight()
        for i = 1, 4, 1 do
            local offset = (i - 1) * 10
            buffer[5 + offset] = amount
            buffer[6 + offset] = width
            buffer[7 + offset] = height
            buffer[8 + offset] = imageWidth
            buffer[9 + offset] = imageHeight
        end
    end

    local noiseAlpha = 1.0 - amount
    if noiseAlpha > 0.0 then -- render noise
        IsaacUtils.LoadShader(eShaderType.SHADER_COLOR_OFFSET)
        local noiseImage = game.m_noiseImage
        local imageWidth = noiseImage:GetWidth()
        local imageHeight = noiseImage:GetHeight()
        local frameCount = G.Manager.m_frameCount % 4
        local flipX = frameCount == 1 or frameCount == 3
        local flipY = frameCount == 2 or frameCount == 3

        local topX = flipX and imageWidth or 0.0
        local bottomX = flipX and 0.0 or imageWidth
        local topY = flipY and imageHeight or 0.0
        local bottomY = flipY and 0.0 or imageHeight

        local noiseSource = SourceQuad.NewFromBounds(Vector(topX, topY), Vector(bottomX, bottomY), false)
        local noiseDest = SourceQuad.NewFromRectangle(C.VECTOR_ZERO, G.WIDTH, G.HEIGHT)
        local noiseColor = KColor(1.0, 1.0, 1.0, noiseAlpha)
        local noiseBuffer = noiseImage:Render_SourceDestQuadFlatColor(noiseSource, noiseDest, noiseColor)
        if noiseBuffer then
            ColorUtils.FillVertices(C.COLOR_MOD_DEFAULT, noiseBuffer, noiseImage)
        end
    end
end

---@param game Component.Game
---@return boolean
local function ShouldSnapshot(game)
    if game.m_hallucination_snapshotState == -1 then
        return true
    end

    local room = game.m_level.m_room
    if IRoom.GetFrameCount(room) ~= 30 then
        return false
    end

    local rng = RNG(room.m_roomDescriptor.m_spawnSeed, 61)
    return rng:RandomInt(3) == 0 or game.m_hallucination_snapshotState == 0
end

---@param game Component.Game
local function NotifySnapshotTaken(game)
    game.m_hallucination_snapshotState = 1
end

---@param game Component.Game
local function RenderSnapshot(game)
    local snapshot = S.HallucinationSnapshot
    local renderingHallucination = game.m_hallucination_countdown > math.max(game.m_hallucination_duration - 20, 0) -- first 20 frames
    if not renderingHallucination or snapshot == nil then
        return
    end

    local t = ((game.m_hallucination_countdown - game.m_hallucination_duration) + 20) / 20 -- technically doesn't work well if duration is < 20
    local alpha = math.sin(t * math.pi) * 0.5

    local source = C.SOURCE_QUAD_FULL
    local dest = DestinationQuad.NewFromRectangle(C.VECTOR_ZERO, G.WIDTH, G.HEIGHT)
    local color = KColor(1.0, 1.0, 1.0, alpha)
    snapshot:Render_SourceDestQuadFlatColor(source, dest, color)
end

---@class Content.Game.Hallucination
local Module = {}

--#region Module

Module.ShouldRender = ShouldRender
Module.ShouldSnapshot = ShouldSnapshot
Module.NotifySnapshotTaken = NotifySnapshotTaken
Module.Render = Render
Module.RenderSnapshot = RenderSnapshot

--#endregion

return Module