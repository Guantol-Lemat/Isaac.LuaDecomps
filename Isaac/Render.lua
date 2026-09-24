--#region Dependencies

local Engine = require("Engine.Global")

local G = require("Isaac.Global")
local S = require("Isaac.Core.Manager.Static")
local Enums = require("Isaac.Enums")
local IsaacUtils = require("Isaac.Utils.Common")
local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local IMenuManager = require("Isaac.Interface.MenuManager")
local IModManager = require("Isaac.Interface.ModManager")
local INightmareScene  = require("Isaac.Interface.NightmareScene")
local ICutscene = require("Isaac.Interface.Cutscene")
local IAchievementOverlay = require("Isaac.Interface.AchievementOverlay")

local eState = Enums.eState
local ShaderType = Renderer.ShaderType

--#endregion

local COLOR_WHITE = KColor(1, 1, 1, 1)
local VECTOR_ZERO = Vector(0, 0)

---@alias Isaac.Switch.RenderState fun(manager: Component.Manager)

---@type Isaac.Switch.RenderState
local switch_RenderState_default = function() end

---@type table<eState, Isaac.Switch.RenderState>
local switch_RenderState = {
    [eState.STATE_MENU] = function (manager)
        IMenuManager.Render(G.MenuManager)
    end,
    [eState.STATE_GAME] = function (manager)
        IGame.Render(G.Game)
    end,
    [eState.STATE_CUTSCENE] = function (manager)
        ICutscene.Render(manager.m_cutsceneManager)
    end,
    [4] = switch_RenderState_default,
    [eState.STATE_NIGHTMARE] = function (manager)
        INightmareScene.Render(manager.m_nightmareScene)
    end
}

---@param manager Component.Manager
---@param graphics Engine.GraphicsManager
local function ColorCorrection_apply(manager, graphics)
    graphics:Clear()
    IsaacUtils.LoadShader(ShaderType.SHADER_COLOR_CORRECTION)
    local source = SourceQuad(Vector(0, 0), Vector(0, 1), Vector(1, 0), Vector(1, 1), true)
    local dest = DestinationQuad.NewFromRectangle(Vector(0, 0), G.WIDTH, G.HEIGHT)
    local buffer = S.ColorCorrectionSurface:Render_SourceDestQuadFlatColor(source, dest, COLOR_WHITE)

    if buffer then
        local gamma = manager.m_options.m_gamma
        local exposure = manager.m_options.m_exposure

        for i = 1, 4, 1 do
            local offset = (i - 1) * 7
            buffer[5 + offset] = exposure
            buffer[6 + offset] = gamma
        end
    end
end

---@param manager Component.Manager
---@param graphics Engine.GraphicsManager
local function HQX4_apply(manager, graphics)
    graphics:Clear()
    graphics:SetBlendMode_Type(BlendType.NORMAL)
    IsaacUtils.LoadShader(ShaderType.SHADER_HQ4X)
    local source = SourceQuad(Vector(0, 0), Vector(0, 1), Vector(1, 0), Vector(1, 1), true)
    local dest = DestinationQuad.NewFromRectangle(Vector(0, 0), G.WIDTH, G.HEIGHT)
    local buffer = S.HQX4Surface:Render_SourceDestQuadFlatColor(source, dest, COLOR_WHITE)

    if buffer then
        local imageWidth = S.HQX4Surface:GetPaddedWidth()
        local imageHeight = S.HQX4Surface:GetPaddedHeight()
        local pow2 = G.DISPLAYPIXELSPERPOINT * G.POINTSCALE * 0.5

        for i = 1, 4, 1 do
            local offset = (i - 1) * 8
            buffer[5 + offset] = imageWidth
            buffer[6 + offset] = imageHeight
            buffer[7 + offset] = pow2
        end
    end
end

---@param manager Component.Manager
---@param graphics Engine.GraphicsManager
local function RenderSurface_apply(manager, graphics)
    graphics:Clear()
    graphics:SetBlendMode_Type(BlendType.CONSTANT)
    local source = SourceQuad(Vector(0, 0), Vector(0, 1), Vector(1, 0), Vector(1, 1), true)
    local dest = DestinationQuad.NewFromRectangle(Vector(0, 0), G.WIDTH, G.HEIGHT)
    local buffer = S.RenderSurface:Render_SourceDestQuadFlatColor(source, dest, COLOR_WHITE)
end

---@param manager Component.Manager
local function render_game_state(manager)
    local modManager = manager.m_modManager
    if modManager.m_isLoading then
        IModManager.RenderLoadingScreen(modManager)
        return
    end

    local state = manager.m_state
    local switch = switch_RenderState[manager.m_state] or switch_RenderState_default
    switch(manager)

    IAchievementOverlay.Render(manager.m_achievementOverlay)

    -- render mouse cursor
    local renderCursor = manager.m_options.m_mouseControls_enabled
        and (state == eState.STATE_GAME or state == eState.STATE_MENU)
        and manager.m_cursor_hideCountdown > 0
    if renderCursor then
        local graphics = Engine.GraphicsManager
        local screenPixelScale = Vector(G.WIDTH / graphics:GetWindowWidth(), G.HEIGHT / graphics:GetWindowHeight())
        local position = screenPixelScale * manager.m_cursor_position
        manager.m_cursor_sprite:Render(position, VECTOR_ZERO, VECTOR_ZERO)
    end
end

---@param manager Component.Manager
local function Render(manager)
    local graphics = Engine.GraphicsManager
    if manager.m_frameCount % 2 == 0 and not manager.m_options.m_interpolation_enabled then
        return
    end

    -- trigger window resize
    if manager.m_triggerWindowResize then
        S.HQX4Surface = nil
        S.XBRZSurface = nil
        S.RenderSurface = nil
        S.ColorCorrectionSurface = nil

        IManager.create_surfaces(manager)

        if graphics:IsFullScreenRendering() then
            manager.m_options.m_windowWidth = graphics:GetWindowedWidth()
            manager.m_options.m_windowHeight = graphics:GetWindowedHeight()
        end

        manager.m_triggerWindowResize = false
    end

    graphics:SetRenderTargetScreen()

    local useRenderSurface = manager.m_state ~= eState.STATE_CUTSCENE and graphics:GetFrameBufferWidth() ~= G.RENDER_WIDTH
    if useRenderSurface then
        IsaacUtils.PushRenderTarget()
        graphics:SetRenderTargetTexture(S.RenderSurface, true)
    end

    local applyFilter = ((manager.m_options.m_filter_active) and (manager.m_options.m_filter_enabled))
        and not ICutscene.IsPlayingVideo(manager.m_cutsceneManager)
    if applyFilter then
        IsaacUtils.PushRenderTarget()
        graphics:SetRenderTargetTexture(S.HQX4Surface, true)
    end

    if manager.m_options.m_colorCorrection_enabled then
        IsaacUtils.PushRenderTarget()
        graphics:SetRenderTargetTexture(S.ColorCorrectionSurface, true)
    end

    render_game_state(manager)

    if manager.m_options.m_colorCorrection_enabled then
        graphics:Present()
        IsaacUtils.PopRenderTarget()
        ColorCorrection_apply(manager, graphics)
    end

    if applyFilter then
        graphics:Present()
        IsaacUtils.PopRenderTarget()
        HQX4_apply(manager, graphics)
    end

    if useRenderSurface then
        graphics:Present()
        IsaacUtils.PopRenderTarget()
        RenderSurface_apply(manager, graphics)
    end

    graphics:Present()
end

---@class Isaac.Render
local Module = {}

--#region Module

Module.Render = Render

--#endregion

return Module