--#region Dependencies

local Globals = require("Isaac.Global")
local Enums = require("General.Enums")
local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local INetManager = require("Isaac.Interface.NetManager")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local ISeeds = require("Isaac.Interface.Seeds")
local INightmareScene = require("Isaac.Interface.NightmareScene")
local IsaacUtils = require("Isaac.Utils.Common")

--#endregion

local eState = Enums.eState

---@param manager Component.Manager
---@param ctx Context.Common
local function start_game(manager, ctx)
    if manager.m_networkPlay then
        local initState = nil
        if manager.m_canContinue then
            manager.m_canContinue = false
            initState = manager.m_gameState
        end

        local seeds = ISeeds.Copy(manager.m_startSeeds)
        IGame.NetStart(ctx, manager.field_0x1ea808, manager.m_startChallenge, seeds, initState)
        return
    end

    if manager.m_canContinue then
        local savedState = manager.m_gameState
        manager.m_startPlayerType = savedState.m_startPlayerType
        manager.m_startChallenge = savedState.m_challenge
        manager.m_startDifficulty = savedState.m_difficulty

        manager.m_canContinue = false

        manager.m_startSeeds = ISeeds.Copy(savedState.m_seeds)
        IGame.StartFromSavedState(ctx.game, ctx, savedState)
        return
    end

    if manager.m_startingFromRerun_qqq then
        local rerunState = manager.m_gameState
        manager.m_startPlayerType = rerunState.m_startPlayerType
        manager.m_startChallenge = rerunState.m_challenge
        manager.m_startDifficulty = rerunState.m_difficulty

        manager.m_startingFromRerun_qqq = false

        manager.m_startSeeds = ISeeds.Copy(rerunState.m_seeds)
        IGame.StartFromRerunState(ctx, ctx.game, rerunState)
        return
    end

    local dailyChallenge = manager.m_dailyChallenge
    local startingDailyRun = dailyChallenge.m_id ~= 0
    if startingDailyRun then
        manager.m_startPlayerType = dailyChallenge.m_challengeParams.m_playerType
        IGame.StartDailyChallenge(ctx, ctx.game, dailyChallenge)
        return
    end

    if manager.m_debugStart then
        IGame.StartDebug(ctx, ctx.game, manager.m_debugStart_levelStage, manager.m_debugStart_stageType, manager.m_startDifficulty, manager.m_debugStart_roomPath)
        return
    end

    local seeds = ISeeds.Copy(manager.m_startSeeds)
    IGame.Start(ctx, ctx.game, manager.m_startPlayerType, manager.m_startChallenge, seeds, manager.m_startDifficulty)
end

---@param manager Component.Manager
local function ExecuteStartGame(manager)
    if not manager.m_startingGame then
        return
    end

    -- make it so that start happens on an even frame
    if (manager.m_frameCount % 2) ~= 0 then
        manager.m_frameCount = manager.m_frameCount + 1
    end

    local ctx = {
        manager = manager,
        game = Globals.Game
    }

    IManager.cleanup_current_state(ctx, manager)

    -- create game if this has not already been done
    if not Globals.Game then
        Globals.Game = IGame.New(ctx)
        ctx.game = Globals.Game
        IGame.Init(ctx, ctx.game)
    end

    if IManager.IsNetPlay(manager) then
        INetManager.Reset(manager.m_netManager, false)
    elseif manager.m_networkPlay then -- is network play but we were not in netplay
        IPersistentGameData.prepare_net_start(manager.m_persistentGameData)
    end

    local seeds = manager.m_startSeeds
    if manager.m_networkPlay and seeds.m_gameStartSeed ~= 0 then
        IsaacUtils.InitRandom(seeds.m_gameStartSeed)
    end

    manager.m_state = eState.STATE_GAME
    local nightmare = manager.m_nightmareScene
    for i = 1, 14, 1 do
        nightmare.m_progressBar_stageFrame[i] = 17
    end
    INightmareScene.Reset(nightmare)

    start_game(manager, ctx)

    -- make it so that start happens on an even frame AGAIN
    if (manager.m_frameCount % 2) ~= 0 then
        manager.m_frameCount = manager.m_frameCount + 1
    end

    manager.m_startingGame = false
    manager.m_shouldSave = true
    manager.m_lossRecorded_qqq = false
end

---@class Isaac.StateSetup
local Module = {}

--#region Module

Module.ExecuteStartGame = ExecuteStartGame

--#endregion

return Module