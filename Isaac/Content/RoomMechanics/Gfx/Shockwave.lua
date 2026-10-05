--#region Dependencies

local G = require("Isaac.Global")
local C = require("Isaac.Constants")
local S = require("Isaac.Core.Room.Static")

local IsaacUtils = require("Isaac.Utils.Common")
local ColorUtils = require("General.VanillaAPI.Color")
local IBlendMode = require("Engine.Interface.BlendMode")
local IRoom = require("Isaac.Interface.Room")

local GreedShopBackdrop = require("Isaac.Content.RoomMechanics.Backdrop.GreedShop")

local eShaderType = Renderer.ShaderType

--#endregion

local ANIMATION_IDLE = "Idle"

---@param room Component.Room
---@return boolean
local function IsActive(room)
    return (room.m_shockwaveParams[1].m_progress < room.m_shockwaveParams[1].m_duration)
        or (room.m_shockwaveParams[2].m_progress < room.m_shockwaveParams[2].m_duration)
end

---@param room Component.Room
---@return boolean
local function UseGraphics(room)
    if not G.Manager.m_options.m_shockwave_enabled then
        return false
    end

    return IsActive(room)
end

---@param room Component.Room
---@return boolean
local function should_render_radial(room)
    return (room.m_backdrop.m_type == BackdropType.MEGA_SATAN or room.m_backdrop.m_type == BackdropType.GREED_SHOP)
end

---@param room Component.Room
---@param params Component.ShockwaveParams
local function render_radial(room, params)
    local sprite = room.m_shockwaveRadialANM2
    local animation = sprite:GetAnimationData(ANIMATION_IDLE)
    ---@cast animation AnimationData
    local frameNum = animation:GetLength() * (params.m_progress / params.m_duration)
    sprite:SetFrame(ANIMATION_IDLE, math.floor(frameNum))

    local position = IsaacUtils.GetRenderPosition(params.m_center, true) + room.m_renderScrollOffset
    sprite:Render(position, C.VECTOR_ZERO, C.VECTOR_ZERO)
end

---@param graphics Engine.GraphicsManager
---@param room Component.Room
local function rerender_floor_color(graphics, room)
    local manager = G.Manager

    if room.m_backdrop.m_type == BackdropType.GREED_SHOP then
        GreedShopBackdrop.RenderFloorColor(room)

        -- reapply lighting
        if manager.m_options.m_lighting_enabled then
            local restoreBlend = graphics:GetBlendMode()
            graphics:SetBlendMode(IBlendMode.New(BlendFactor.DST_COLOR, BlendFactor.ONE_MINUS_SRC_ALPHA, BlendFactor.DST_ALPHA, BlendFactor.ONE_MINUS_SRC_ALPHA))
            local alpha = IRoom.GetLightingAlpha(room)
            local lightSurface = S.LightOverlaySurface

            local lightingDest = DestinationQuad.NewFromRectangle(C.VECTOR_ZERO, G.WIDTH, G.HEIGHT)
            local lightingColor = KColor(alpha, alpha, alpha, alpha)
            local buffer = lightSurface:Render_DestQuadFlatColor(lightingDest, lightingColor)
            ColorUtils.FillVertices(C.COLOR_MOD_DEFAULT, buffer, lightSurface)

            graphics:SetBlendMode(restoreBlend)
        end
    end
end

---@param room Component.Room
local function RenderDisabled(room)
    for i = 1, 2, 1 do
        local params = room.m_shockwaveParams[i]
        local renderShockwaveRadial = params.m_progress < params.m_duration
            and should_render_radial(room)
            and not IRoom.IsClear(room)

        if renderShockwaveRadial then
            render_radial(room, params)
        end
    end
end

---@param graphics Engine.GraphicsManager
---@param room Component.Room
---@param surface Engine.Image
local function Render(graphics, room, surface)
    local manager = G.Manager

    graphics:Clear()
    graphics:SetBlendMode_Type(BlendType.NORMAL)

    rerender_floor_color(graphics, room)

    if not IRoom.IsClear(room) then
        for i = 1, 2, 1 do
            local params = room.m_shockwaveParams[i]
            if params.m_progress < params.m_duration and should_render_radial(room) then
                render_radial(room, params)
            end
        end
    end

    IsaacUtils.LoadShader(eShaderType.SHADER_SHOCKWAVE)
    local buffer = IsaacUtils.RenderScreenSurface(surface)

    if buffer then
        local shockwaveParams = {}
        for i = 1, 2, 1 do
            local params = room.m_shockwaveParams[i]

            local center = Vector(-150.0, 0.0) -- high enough value to prevent the shockwave from having an effect
            if params.m_progress < params.m_duration then
                center = IRoom.GetScreenUVPos(room, params.m_center, surface)
            end

            local t = params.m_progress / params.m_duration
            local distortionStrength = ((1.0 - (t ^ 0.4)) * params.m_distortionStrength)

            local radius = params.m_radius
            if room.m_interpolatedPositions then
                radius = radius + params.m_radiusSpeed * 0.5
            end

            shockwaveParams[i] = {
                center = center,
                distortionStrength = distortionStrength,
                radius = radius,
            }
        end

        local shockwave0 = shockwaveParams[1]
        local shockwave1 = shockwaveParams[2]

        local imageDimensions = Vector(surface:GetPaddedWidth(), surface:GetPaddedHeight())
        local uvToShockwaveScale = (Vector(676.0, 364.0) / Vector(1024.0, 1024.0)) / ((G.POINTSCALE * Vector(520.0, 280.0)) / imageDimensions)

        for i = 1, 4, 1 do
            local offset = (i - 1) * 19

            buffer[9 + offset] = shockwave0.center.X
            buffer[10 + offset] = shockwave0.center.Y
            buffer[11 + offset] = shockwave0.radius
            buffer[12 + offset] = shockwave0.distortionStrength
            buffer[13 + offset] = shockwave1.uvPos.X
            buffer[14 + offset] = shockwave1.uvPos.Y
            buffer[15 + offset] = shockwave1.radius
            buffer[16 + offset] = shockwave1.distortionStrength
            buffer[17 + offset] = uvToShockwaveScale.X
            buffer[18 + offset] = uvToShockwaveScale.Y
        end
    end

    graphics:SetBlendMode_Type(BlendType.NORMAL)
end

---@class Content.Room.ShockwaveGfx
local Module = {}

--#region Module

Module.IsActive = IsActive
Module.UseGraphics = UseGraphics
Module.RenderDisabled = RenderDisabled
Module.Render = Render

--#endregion

return Module