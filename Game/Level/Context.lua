---@class LevelContext
local Module = {}

---@class LevelContext.PlaceRoomContext
---@field mode integer
---@field devilsCrownEffect boolean

---@class LevelContext.GetStageId
---@field mode integer
---@field challenge Challenge | integer

---@class LevelContext.IsNextStageAvailable : LevelContext.GetStageId, QuestContext.IsBackwardsPathEntrance
---@field mode integer
---@field curses LevelCurse | integer
---@field gameStateFlags GameStateFlag | integer
---@field challengeParams ChallengeParamsComponent
---@field inChallenge boolean

---@class LevelContext.IsStageAvailable : InventoryContext.HasCollectible, PersistentDataContext.Unlocked
---@field playerManager PlayerManagerComponent
---@field persistentGameData PersistentDataComponent
---@field mode integer
---@field challengeParams ChallengeParamsComponent
---@field inChallenge boolean
---@field forceUnlock boolean

---@class LevelContext.CanSpawnTrapDoor : LevelContext.IsStageAvailable, LevelContext.IsNextStageAvailable, QuestContext.HasMirrorDimension, QuestContext.IsBackwardsPathEntrance
---@field playerManager PlayerManagerComponent
---@field persistentGameData PersistentDataComponent
---@field mode integer
---@field curses LevelCurse | integer
---@field gameStateFlags GameStateFlag | integer
---@field challenge Challenge | integer
---@field challengeParams ChallengeParamsComponent
---@field inChallenge boolean
---@field forceUnlock boolean

---@param result LevelContext.GetStageId
---@param challenge Challenge | integer
---@param mode integer
---@return LevelContext.GetStageId
local function BuildGetStageIdContext(result, mode, challenge)
    result.challenge = challenge
    result.mode = mode

    return result
end

--#region Module

Module.BuildGetStageId = BuildGetStageIdContext

--#endregion

return Module