--#region Dependencies

local Enums = require("General.Enums")
local VectorUtils = require("General.Math.VectorUtils")
local ConsoleUpdate = require("Game.Console.Update")
local HudUpdate = require("Game.HUD.Update")
local ColorModStateUtils = require("Game.FX.ColorModState.Utils")
local GameOverUpdate = require("Game.GameOver.Update")
local LeaderboardUpdate = require("Game.Leaderboard.Update")
local StageTransitionUtils = require("Game.Transition.StageTransition.Utils")
local StageTransitionUpdate = require("Game.Transition.StageTransition.Update")
local RoomTransitionUtils = require("Game.Transition.RoomTransition.Utils")
local RoomTransitionUpdate = require("Game.Transition.RoomTransition.Update")
local MinimapUpdate = require("Game.HUD.Minimap.Logic")
local GenericPromptUtils = require("Game.GenericPrompt.Utils")
local GenericPromptUpdate = require("Game.GenericPrompt.Update")
local PauseScreenUtils = require("Game.PauseScreen.Utils")
local PauseScreenUpdate = require("Game.PauseScreen.Update")
local ItemOverlayUpdate = require("Game.ItemOverlay.Update")
local LevelUpdate = require("Game.Level.Update")

local VectorZero = VectorUtils.VectorZero
local eItemOverlayState = Enums.eItemOverlayState
--#endregion

---@class GameUpdateLogic
local Module = {}

---@param game GameComponent
local function color_modifier_approach(game)
    -- TODO: code approach
end

---@param game GameComponent
local function fadeout_update(game)
    -- TODO: code update
end

---@param game GameComponent
local function Update(game)
    local gameRead = game
    local gameWrite = game

    local consoleOpen = ConsoleUpdate.Update(gameWrite.m_console)
    if consoleOpen then
        return
    end

    HudUpdate.Update(gameWrite.m_hud)

    -- update countdowns
    local bloomCountdown = gameRead.m_bloom_countdown
    if bloomCountdown > 0 then
        gameWrite.m_bloom_countdown = bloomCountdown - 1
    end

    local screenShakeCountdown = gameRead.m_screenShake_countdown
    if screenShakeCountdown > 0 then
        screenShakeCountdown = screenShakeCountdown - 1
        gameWrite.m_screenShake_countdown = screenShakeCountdown
        if screenShakeCountdown == 0 then
            VectorUtils.Assign(gameWrite.m_screenShake_offset, VectorZero)
        end
    end

    local hallucinationCountdown = gameRead.m_hallucination_countdown
    if hallucinationCountdown > 0 then
        gameWrite.m_hallucination_countdown = hallucinationCountdown - 1
    end

    if gameRead.m_colorModifier_approach then
        color_modifier_approach(game)
        if ColorModStateUtils.Equals(gameRead.m_colorModifier_current, gameRead.m_colorModifier_target) then
            gameWrite.m_colorModifier_approach = false
        end
    end

    local lightningStrength = gameRead.m_lightning_strength
    if lightningStrength > 0.0 then
        lightningStrength = lightningStrength <= 0.05 and 0.0 or lightningStrength * 0.75
        gameWrite.m_lightning_strength = lightningStrength
    end

    if gameRead.m_fade_fadeOutValue > 0.0 then
        fadeout_update(game)
        gameRead = gameWrite
    end

    local updateTimeout = gameRead.m_updateTimeout
    if updateTimeout > 0 then
        gameWrite.m_updateTimeout = updateTimeout - 1
        HudUpdate.PostUpdate(gameWrite.m_hud)
        return
    end

    if gameRead.m_gameOver.m_state ~= 0 then
        GameOverUpdate.Update(gameWrite.m_gameOver)
        return
    end

    if gameRead.m_leaderboard.m_state ~= 0 then
        LeaderboardUpdate.Update(gameWrite.m_leaderboard)
        return
    end

    if StageTransitionUtils.IsActive(gameRead.m_stageTransition) then
        StageTransitionUpdate.Update(gameWrite.m_stageTransition)
        HudUpdate.PostUpdate(gameWrite.m_hud)
        return
    end

    if RoomTransitionUtils.IsActive(gameRead.m_roomTransition) then
        RoomTransitionUpdate.Update(gameWrite.m_roomTransition)
        MinimapUpdate.Update(context, gameWrite.m_minimap)
        HudUpdate.PostUpdate(gameWrite.m_hud)
        return
    end

    if gameRead.m_itemOverlay.m_state == eItemOverlayState.INACTIVE and GenericPromptUtils.IsActive(gameRead.m_victoryRun_prompt) then
        local genericPrompt = gameWrite.m_victoryRun_prompt
        GenericPromptUpdate.Update(genericPrompt)

        if genericPrompt.m_submittedSelection == 1 then
            -- start fade out
            gameWrite.m_fade_fadeOutValue = gameRead.m_fade_fadeOutValue + 0.08
            gameWrite.m_fade_speed = 0.08
            gameWrite.m_fade_target = 6
        end

        return
    end

    local itemOverlay = gameWrite.m_itemOverlay
    if itemOverlay.m_state ~= eItemOverlayState.INACTIVE and not PauseScreenUtils.IsActive(gameRead.m_pauseScreen) then
        ItemOverlayUpdate.Update(itemOverlay)
        if itemOverlay.m_state == eItemOverlayState.ACTIVE then
            HudUpdate.PostUpdate(gameWrite.m_hud)
            return
        end
    end

    -- TODO: Update Load Image Fadein

    gameRead = gameWrite
    if gameRead.m_fade_fadeInValue > 0.0 then
        HudUpdate.PostUpdate(gameWrite.m_hud)
        return
    end

    -- TODO: Lost focus Eval

    if PauseScreenUtils.IsActive(gameRead.m_pauseScreen) then
        PauseScreenUpdate.Update(gameWrite.m_pauseScreen)
        -- TODO: EntityList::ClearResults()
        return
    end

    MinimapUpdate.Update(context, gameWrite.m_minimap)
    -- TODO: Update Boss Overlay

    -- TODO: Update Ascent Timer
    -- TODO: Update Death Certificate Leave

    gameWrite.m_timeCounter = gameRead.m_timeCounter + 1
    local frame = gameRead.m_frameCount + 1
    gameWrite.m_frameCount = frame

    if frame % 30 == 0 then
        -- TODO: Hud::SetSecondScreenRefresh(1)
    end

    LevelUpdate.Update(gameWrite.m_level)
    -- TODO: PlayerManager:Update

    -- TODO: Update darkness modifier
    -- TODO: Update Dizzy
    -- TODO: Update Pixelation

    HudUpdate.PostUpdate(gameWrite.m_hud)
    -- TODO: Update Debug Renderer
    -- TODO: LuaCallback:PostUpdate
end

--#region Module

Module.Update = Update

--#endregion

return Module