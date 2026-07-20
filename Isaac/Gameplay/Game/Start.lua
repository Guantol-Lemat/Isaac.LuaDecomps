--#region Dependencies

local IManager = require("Isaac.Interface.Manager")
local IModManager = require("Isaac.Interface.ModManager")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local IPlayerHUD = require("Isaac.Interface.PlayerHUD")
local IPauseScreen = require("Isaac.Interface.PauseScreen")
local IGame = require("Isaac.Interface.Game")
local ILevel = require("Isaac.Interface.Level")
local IProceduralItemManager = require("Isaac.Interface.ProceduralItemManager")
local IItemPool = require("Isaac.Interface.ItemPool")
local IBossPool = require("Isaac.Interface.BossPool")
local IPlayerManager = require("Isaac.Interface.PlayerManager")
local ISeeds = require("Isaac.Interface.Seeds")
local LuaCallbacks = require("LuaEngine.Callbacks")
local Log = require("General.Log")

--#endregion

---@param game Component.Game
---@param ctx Context.Common
---@param playerType integer
---@param challenge Challenge | integer
---@param seeds Component.Seeds
---@param difficulty Difficulty | integer
local function Start(game, ctx, playerType, challenge, seeds, difficulty)
    local manager = ctx.manager

    game.m_difficulty = difficulty
    game.m_challenge = challenge
    game.m_canDoGameExit = true
    game.m_victoryRun_currentLap = 0
    game.m_isConsoleEnabled_qqq = manager.m_isConsoleEnabled

    IPlayerHUD.LoadGraphics(game.m_hud.m_playerHUD, ctx)

    if seeds.m_startSeed == 0 then
        Log.LogMessage(3, "Start seed is not initialized")
    end

    -- init seeds
    game.m_seeds = ISeeds.Copy(seeds)
    local game_seeds = game.m_seeds

    local game_inChallenge = game.m_challenge ~= Challenge.CHALLENGE_NULL
    if game_inChallenge then
        local challengeParams = IGame.GetChallengeParams(ctx, game)
        local challenge_seedEffects = challengeParams.m_seeds

        game_seeds.m_seedEffects = {}
        for i = 1, challenge_seedEffects, 1 do
            ISeeds.AddSeedEffect(game_seeds, challenge_seedEffects[i])
        end
    end

    local fortuneSeed = ISeeds.GetNextSeed(game_seeds)
    game.m_fortuneRNG = RNG(fortuneSeed, 35)

    local achievementsDisallowed = IGame.AchievementUnlocksDisallowed(ctx, game) or game_inChallenge
    IPersistentGameData.SetReadOnly(manager.m_persistentGameData, achievementsDisallowed)

    local seedString = ISeeds.Seed2String(game_seeds.m_startSeed)
    Log.LogMessage(0, string.format("RNG Start Seed: %s (%u) [New, %d]\n", seedString, game_seeds.m_startSeed, manager.m_currentSaveSlot))

    IProceduralItemManager.Reset(game.m_proceduralItemManager, ctx)

    local itemPool_xml = IModManager.TryRedirectPath(manager.m_modManager, "itempools.xml")
    local itemPool_seed = ISeeds.GetNextSeed(game_seeds)
    IItemPool.Init(game.m_itemPool, ctx, itemPool_seed, itemPool_xml)

    local bossPool_seed = game_seeds.m_startSeed
    IBossPool.Init(game.m_bossPool, ctx, bossPool_seed)

    local playerManager_seed = game_seeds.m_playerSeed
    IPlayerManager.Init(game.m_playerManager, ctx, playerType, playerManager_seed)

    -- init level
    local level = game.m_level
    ILevel.SetNextStage(ctx, level)
    if challenge == Challenge.CHALLENGE_BACKASSWARDS then
        ILevel.SetStage(ctx, level, LevelStage.STAGE6, StageType.STAGETYPE_ORIGINAL)
    end
    ILevel.Init(ctx, level)

    IPlayerManager.InitPostLevelInitStats(game.m_playerManager, ctx)

    IManager.SaveGameState(ctx)

    IPlayerManager.TriggerNewRoom_TemporaryEffects(game.m_playerManager, ctx)

    IGame.Fadein(game, 0.4)

    IPauseScreen.Reset(game.m_pauseScreen, ctx)

    game.m_encounteredBosses = {}

    ILevel.Update(ctx, level)

    LuaCallbacks.PostGameStarted(false)
end

---@class Gameplay.GameStart
local Module = {}

--#region Module

Module.Start = Start

--#endregion

return Module