--#region Dependencies

local G = require("Isaac.Global")

local IsaacUtils = require("Isaac.Utils.Common")
local IRoomTransition = require("Isaac.Interface.RoomTransition")
local IStageTransition = require("Isaac.Interface.StageTransition")

local eShaderType = Renderer.ShaderType

--#endregion

---@param game Component.Game
---@return boolean
local function ShouldRender(game)
    if not G.Manager.m_options.m_pixelation_enabled then
        return false
    end

    return (IStageTransition.GetFadeValue(game.m_stageTransition) >= 0.0 and IStageTransition.UsesPixelation(game.m_stageTransition))
        or (IRoomTransition.GetFadeValue(game.m_roomTransition) >= 0.0 and game.m_roomTransition.m_animation == RoomTransitionAnim.PIXELATION)
end

---@param graphics Engine.GraphicsManager
---@param game Component.Game
---@param surface Engine.Image
local function Render(graphics, game, surface)
    graphics:Clear()
    -- no blend mode is set here, leaving whatever was last used
    IsaacUtils.LoadShader(eShaderType.SHADER_PIXELATION)
    local buffer = IsaacUtils.RenderScreenSurface(surface)

    if buffer then
        local fadeValue = math.max(IRoomTransition.GetFadeValue(game.m_roomTransition), IStageTransition.GetFadeValue(game.m_stageTransition))
        local pixelationAmount = math.max(fadeValue * 0.3, 0.0001)

        local width = surface:GetWidth()
        local height = surface:GetHeight()
        local imageWidth = surface:GetPaddedWidth()
        local imageHeight = surface:GetPaddedHeight()

        for i = 1, 4, 1 do
            local offset = (i - 1) * 14
            buffer[9 + offset] = pixelationAmount
            buffer[10 + offset] = width
            buffer[11 + offset] = height
            buffer[12 + offset] = imageWidth
            buffer[13 + offset] = imageHeight
        end
    end
end

---@class Content.Game.Pixelation
local Module = {}

--#region Module

Module.ShouldRender = ShouldRender
Module.Render = Render

--#endregion

return Module