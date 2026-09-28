--#region Dependencies

local Engine = require("Engine.Global")
local G = require("Isaac.Global")
local S = require("Isaac.Core.Game.Static")

local IsaacUtils = require("Isaac.Utils.Common")

local IModManager = require("Isaac.Interface.ModManager")
local INetManager = require("Isaac.Interface.NetManager")
local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")
local IRoomTransition = require("Isaac.Interface.RoomTransition")
local IStageTransition = require("Isaac.Interface.StageTransition")
local IConsole = require("Isaac.Interface.Console")
local IDebugRenderer = require("Isaac.Interface.DebugRenderer")
local IPauseScreen = require("Isaac.Interface.PauseScreen")
local IHUD = require("Isaac.Interface.HUD")
local IItemOverlay = require("Isaac.Interface.ItemOverlay")
local IBossOverlay = require("Isaac.Interface.BossOverlay")
local IGameOver = require("Isaac.Interface.GameOver")
local ILeaderboard = require("Isaac.Interface.Leaderboard")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IGenericPrompt = require("Isaac.Interface.GenericPrompt")
local LuaCallbacks = require("LuaEngine.Callbacks")

local Fade = require("Isaac.Core.Manager.Fade")
local OldTV = require("Isaac.Content.GameEffects.Seeds.OldTV")
local Hallucination = require("Isaac.Content.GameEffects.Hallucination")
local Pixelation = require("Isaac.Content.GameEffects.Pixelation")
local Bloom = require("Isaac.Content.GameEffects.Bloom")
local ColorMod = require("Isaac.Content.GameEffects.ColorMod")
local BackwardsPath = require("Isaac.Content.GameEffects.BackwardsPath")

--#endregion

---@param game Component.Game
local function Render(game)
    local graphics = Engine.GraphicsManager

    if game.m_triggerWindowResize then
        IRoomTransition.CreateSurfaces(game.m_roomTransition)
        IRoom.TriggerWindowResize(game.m_level.m_room)

        S.PixelatedSurface = nil
        S.BloomSurface = nil
        S.OldTVSurface = nil
        S.HallucinationSurface = nil
        S.HallucinationSnapshot = nil
        S.ColorModSurface = nil
        IGame.CreateSurfaces(game)

        IConsole.UpdateSize(game.m_console)
        local modManager = G.Manager.m_modManager
        IModManager.DestroySurfaces(modManager)
        IModManager.CreateSurfaces(modManager)

        game.m_triggerWindowResize = false
    end

    local manager = G.Manager
    local room = game.m_level.m_room
    IRoom.PreRender(room)

    if OldTV.ShouldRender(game) then
        IsaacUtils.PushRenderTarget()
        graphics:SetRenderTargetTexture(S.OldTVSurface, true)
    end

    if Hallucination.ShouldRender(game) then
        IsaacUtils.PushRenderTarget()
        graphics:SetRenderTargetTexture(S.HallucinationSurface, true)
    end

    if Pixelation.ShouldRender(game) then
        IsaacUtils.PushRenderTarget()
        graphics:SetRenderTargetTexture(S.PixelatedSurface, true)
    end

    if Bloom.ShouldRender(game) then
        graphics:Clear()
        IsaacUtils.PushRenderTarget()
        graphics:SetRenderTargetTexture(S.BloomSurface, true)
    end

    local doHallucinationSnapshot = Hallucination.ShouldSnapshot(game)
    if doHallucinationSnapshot then
        IsaacUtils.PushRenderTarget()
        graphics:SetRenderTargetTexture(S.HallucinationSnapshot, true)
        Hallucination.NotifySnapshotTaken(game)
    end

    IModManager.PrepareShaders(manager.m_modManager)

    local useColorModifier = ColorMod.ShouldRender(game)
    if useColorModifier then
        IsaacUtils.PushRenderTarget()
        graphics:SetRenderTargetTexture(S.ColorModSurface, true)
    end

    graphics:Clear()
    graphics:SetBlendMode_Type(BlendType.NORMAL)

    if IRoomTransition.IsRendering(game.m_roomTransition) then
        IRoomTransition.Render(game.m_roomTransition)
    else
        IRoom.Render(room)
    end

    LuaCallbacks.PostRender()

    if not doHallucinationSnapshot then
        Hallucination.RenderSnapshot(game)
    end

    if useColorModifier then
        graphics:Present()
        IsaacUtils.PopRenderTarget()
        ColorMod.Render(graphics, game, S.ColorModSurface)
        -- restore blend mode
        graphics:SetBlendMode_Type(BlendType.NORMAL)
    end

    IDebugRenderer.Render(game.m_debugRenderer)
    IHUD.Render(game.m_hud)
    IStageTransition.Render(game.m_stageTransition)
    IItemOverlay.Render(game.m_itemOverlay)
    IBossOverlay.Render(game.m_bossOverlay)

    if IGenericPrompt.IsActive(game.m_victoryRun_prompt) then
        IGenericPrompt.Render(game.m_victoryRun_prompt)
    end

    if game.m_pauseScreen.m_state ~= 0 then
        IPauseScreen.Render(game.m_pauseScreen)
    end

    IGameOver.Render(game.m_gameOver)
    ILeaderboard.Render(game.m_leaderboard)

    IModManager.ApplyShaders(manager.m_modManager)

    if doHallucinationSnapshot then
        graphics:Present()
        IsaacUtils.PopRenderTarget()

        -- forward snapshot
        graphics:Clear()
        graphics:SetBlendMode_Type(BlendType.CONSTANT)
        IsaacUtils.RenderScreenSurface(S.HallucinationSnapshot)
    end

    if Bloom.ShouldRender(game) then
        graphics:Present()
        IsaacUtils.PopRenderTarget()
        Bloom.Render(graphics, game, S.BloomSurface)
    end

    if Pixelation.ShouldRender(game) then
        graphics:Present()
        IsaacUtils.PopRenderTarget()
        Pixelation.Render(graphics, game, S.PixelatedSurface)
    end

    if Hallucination.ShouldRender(game) then
        graphics:Present()
        IsaacUtils.PopRenderTarget()
        Hallucination.Render(graphics, game, S.HallucinationSurface)
    end

    if OldTV.ShouldRender(game) then
        graphics:Present()
        IsaacUtils.PopRenderTarget()
        OldTV.Render(graphics, game, S.OldTVSurface)
    end

    BackwardsPath.RenderFade(graphics, game)

    if game.m_fade_fadeInValue > 0.0 then
        Fade.GameLoad_RenderFadeIn(game.m_fade_fadeInValue)
    elseif game.m_fade_fadeOutValue > 0.0 then
        Fade.MenuReturn_RenderFadeOut(game.m_fade_fadeOutValue)
    end

    if game.m_debugFlags & DebugFlag.PLAYER_ITEM_INFO ~= 0 then
        if #game.m_playerManager.m_players ~= 0 then
            local player = IGame.GetPlayer(game, 0)
            IEntityPlayer.RenderDebugInfo(player, Vector(10.0, 10.0))
        end
    end

    if INetManager.IsNetPlay(manager.m_netManager) and manager.m_netManager.m_desync then
        local font = manager.m_entityTextFont
        local string = "DESYNCED"

        local posX = (G.WIDTH * 0.5) - font:GetStringWidth(string)
        local colorPulse = math.sin(((manager.m_frameCount % 30) / 30 * (2*math.pi)))
        local nonRedColor = colorPulse * 0.15 + 0.15 -- alternate between 0.0 and 0.30
        local color = KColor(1.0, nonRedColor, nonRedColor, 1.0)
        font:DrawStringScaled("DESYNCED", posX, 10.0, 2.0, 2.0, color, 0, true)
    end

    ILuaEngine.DrawDebugMemoryUseage()
    IConsole.Render(game.m_console)
end

---@class Game.Render
local Module = {}

--#region Module

Module.Render = Render

--#endregion

return Module