--#region Dependencies

local Enums = require("General.Enums")

local eState = Enums.eState
--#endregion

---@class PersistentDataContext.RecordPlayerCompletion
---@field playerManager PlayerManagerComponent
---@field persistentGameData PersistentDataComponent

---@param persistentGameData PersistentDataComponent
---@param achievement Achievement | integer
local function TryUnlock(persistentGameData, achievement)
end

---@param myContext Context.Common
---@param persistentGameData PersistentDataComponent
---@param achievement Achievement | integer
---@return boolean
local function Unlocked(myContext, persistentGameData, achievement)
    if achievement == -2 then
        return false
    end

    if achievement < 0 then
        return true
    end

    if achievement > 637 then
        return false
    end

    if achievement == 0 or persistentGameData.m_achievements[achievement] then
        return true
    end

    local isaac = myContext.manager
    local game = myContext.game

    local forceUnlock = isaac.m_state == eState.STATE_GAME and (game.m_dailyChallenge.m_id ~= 0 or game.m_isDebug)
    return forceUnlock
end

---@param persistentGameData PersistentDataComponent
---@param event EventCounter | integer
---@param value integer
local function IncreaseEventCounter(persistentGameData, event, value)
end

---@param persistentGameData PersistentDataComponent
---@param event EventCounter | integer
---@return integer
local function GetEventCounter(persistentGameData, event)
    return persistentGameData.m_eventCounters[event + 1]
end

---@param myContext PersistentDataContext.RecordPlayerCompletion
---@param completionType CompletionType | integer
local function RecordPlayerCompletion(myContext, completionType)
end

---@param persistentGameData PersistentDataComponent
---@param bossId BossType | integer
local function AddBoss(persistentGameData, bossId)
end

---@param persistentGameData PersistentDataComponent
---@param stage LevelStage
local function AddStageCompleted(persistentGameData, stage)
    if persistentGameData.m_readOnly then
        return
    end

    persistentGameData.m_changesMade = true

    local completionList = persistentGameData.m_timesStageCompleted
    completionList[stage + 1] = completionList[stage + 1] + 1

    if completionList[LevelStage.STAGE1_2 + 1] >= 40 then
        TryUnlock(persistentGameData, Achievement.STEVEN)
    end

    if completionList[LevelStage.STAGE2_2 + 1] >= 30 then
        TryUnlock(persistentGameData, Achievement.CHAD)
    end

    if completionList[LevelStage.STAGE3_2 + 1] >= 20 then
        TryUnlock(persistentGameData, Achievement.GISH)
    end
end

local Module = {}

--#region Module

Module.TryUnlock = TryUnlock
Module.Unlocked = Unlocked
Module.IncreaseEventCounter = IncreaseEventCounter
Module.GetEventCounter = GetEventCounter
Module.RecordPlayerCompletion = RecordPlayerCompletion
Module.AddBoss = AddBoss
Module.AddStageCompleted = AddStageCompleted

--#endregion

return Module