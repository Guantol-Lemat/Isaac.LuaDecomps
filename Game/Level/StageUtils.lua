--#region Dependencies

local MathUtils = require("General.Math")
local GameUtils = require("Game.Utils")
local LevelUtils = require("Game.Level.Utils")
local XYUtils = require("Game.Level.XYUtils")
local CurseUtils = require("Mechanics.Level.Curse.Utils")
local QuestUtils = require("Mechanics.Game.Quest.Utils")
local PersistentDataUtils = require("Admin.PersistentData.Utils")
local PlayerManagerUtils = require("Game.PlayerManager.Utils")
local RoomConfigUtils = require("Isaac.RoomConfig.Utils")

--#endregion

local PRE_CHAPTER_4_RED_REDEMPTION_TYPES = {
    {StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_AFTERBIRTH, StageType.STAGETYPE_AFTERBIRTH},
    {StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_AFTERBIRTH, StageType.STAGETYPE_AFTERBIRTH, StageType.STAGETYPE_AFTERBIRTH},
    {StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_WOTL, StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_AFTERBIRTH, StageType.STAGETYPE_REPENTANCE},
    {StageType.STAGETYPE_WOTL, StageType.STAGETYPE_WOTL, StageType.STAGETYPE_WOTL, StageType.STAGETYPE_REPENTANCE, StageType.STAGETYPE_REPENTANCE_B},
    {StageType.STAGETYPE_WOTL, StageType.STAGETYPE_WOTL, StageType.STAGETYPE_REPENTANCE, StageType.STAGETYPE_REPENTANCE_B, StageType.STAGETYPE_REPENTANCE_B},
}

local CHAPTER_4_RED_REDEMPTION_TYPES = {
    {StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_AFTERBIRTH},
    {StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_AFTERBIRTH, StageType.STAGETYPE_AFTERBIRTH},
    {StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_AFTERBIRTH, StageType.STAGETYPE_AFTERBIRTH},
    {StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_WOTL, StageType.STAGETYPE_WOTL, StageType.STAGETYPE_WOTL, StageType.STAGETYPE_AFTERBIRTH},
    {StageType.STAGETYPE_WOTL, StageType.STAGETYPE_WOTL, StageType.STAGETYPE_WOTL, StageType.STAGETYPE_WOTL, StageType.STAGETYPE_AFTERBIRTH},
}

---@param level LevelComponent
---@param idx GridRooms | integer
---@return StageType?
local function get_red_redemption_stage_type(level, idx)
    if idx == GridRooms.ROOM_SECRET_EXIT_IDX then
        if level.m_stage == LevelStage.STAGE4_1 then
            return StageType.STAGETYPE_REPENTANCE
        else
            return nil
        end
    end

    if idx < 0 then
        return nil
    end

    -- use same grid idx for big rooms
    if not level.m_isInitializing then
        local roomDesc = LevelUtils.GetRoomByIdx(level, idx, Dimension.CURRENT)
        if roomDesc.m_data then
            idx = roomDesc.m_gridIdx
        end
    end

    local stage = level.m_stage
    if stage > LevelStage.STAGE4_2 then
        return nil
    end

    local isChapter4 = stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2
    if isChapter4 then
        local bossGridIdx = LevelUtils.GetRoomByListIdx(level, level.m_lastBossListIdx).m_gridIdx
        local distance = XYUtils.ManhattanDistanceGridIdx(idx, bossGridIdx)

        if distance < 4 then
            return StageType.STAGETYPE_REPENTANCE
        end
    end

    local localMap = isChapter4 and CHAPTER_4_RED_REDEMPTION_TYPES or PRE_CHAPTER_4_RED_REDEMPTION_TYPES
    local perlinWeightRow = level.m_perlinMap[1][idx + 1] * 5.0
    local perlinWeightColumn = level.m_perlinMap[2][idx + 1] * 5.0

    perlinWeightRow = MathUtils.Clamp(perlinWeightRow, 0, 4.99)
    perlinWeightColumn = MathUtils.Clamp(perlinWeightColumn, 0, 4.99)

    perlinWeightRow = math.floor(perlinWeightRow)
    perlinWeightColumn = math.floor(perlinWeightColumn)

    return localMap[perlinWeightRow + 1][perlinWeightColumn + 1]
end

---@param myContext Context.Game
---@param level LevelComponent
---@param idx GridRooms | integer
---@return StageType | integer
local function GetLocalStageType(myContext, level, idx)
    if myContext.game.m_challenge == Challenge.CHALLENGE_RED_REDEMPTION then
        local override = get_red_redemption_stage_type(level, idx)
        if override then
            return override
        end
    end

    return level.m_stageType
end

---@param myContext Context.Game
---@param level LevelComponent
---@return StbType | integer
local function GetStageID(myContext, level)
    local game = myContext.game
    if game.m_challenge == Challenge.CHALLENGE_RED_REDEMPTION then
        local stageType = GetLocalStageType(myContext, level, level.m_roomIdx)
        return RoomConfigUtils.GetStageID(myContext, level.m_stage, stageType, -1)
    end

    if level.m_dimension == Dimension.DEATH_CERTIFICATE then
        return StbType.HOME
    end

    return RoomConfigUtils.GetStageID(myContext, level.m_stage, level.m_stageType, -1)
end

---@param myContext Context.Common
---@param level LevelComponent
---@return boolean
local function IsNextStageAvailable(myContext, level)
    local game = myContext.game
    local StageIdContext = myContext
    local localStageId = GetStageID(StageIdContext, level)

    if localStageId == StbType.ASCENT then
        return false
    end

    if QuestUtils.IsBackwardsPathEntrance(myContext, level) then
        return false
    end

    local stage = level.m_stage
    if (stage == LevelStage.STAGE6 or stage == LevelStage.STAGE7 or stage == LevelStage.STAGE8 or (GameUtils.IsGreedMode(game) and stage == LevelStage.STAGE7_GREED)) then
        return false
    end

    local effectiveStage = stage
    local curses = CurseUtils.GetCurses(myContext, level)
    if (curses & LevelCurse.CURSE_OF_LABYRINTH) ~= 0 and (stage % 2 == 1 and stage < LevelStage.STAGE4_3) then
        effectiveStage = stage + 1
    end

    if effectiveStage == LevelStage.STAGE4_2 and LevelUtils.IsAltPath(level) then
        return false
    end

    if GameUtils.InChallenge(game) and GameUtils.GetChallengeParams(myContext, game).m_endStage <= effectiveStage then
        return false
    end

    return true
end

---@param myContext Context.Common
---@param stage LevelStage | integer
---@param moralPath StageType | integer -- only used if stage is LevelStage.STAGE5 or LevelStage.STAGE6
local function IsStageAvailable(myContext, stage, moralPath)
    local game = myContext.game
    if GameUtils.IsGreedMode(game) then
        return stage <= LevelStage.STAGE7_GREED
    end

    local endStage = LevelStage.STAGE7
    if GameUtils.InChallenge(game) or not PersistentDataUtils.Unlocked(myContext, myContext.manager.m_persistentGameData, Achievement.VOID_FLOOR) then
        endStage = LevelStage.STAGE6
    end

    local challengeParams = GameUtils.GetChallengeParams(myContext, game)
    local challengeAltersEndStage = challengeParams.m_altersEndStage
    local challengeForcedPath = challengeParams.m_isAltPath and StageType.STAGETYPE_WOTL or StageType.STAGETYPE_ORIGINAL

    local splitPath = (stage == LevelStage.STAGE5 or stage == LevelStage.STAGE6)

    if splitPath then
        if challengeAltersEndStage and challengeForcedPath ~= moralPath then
            return false
        end

        if moralPath == StageType.STAGETYPE_WOTL then -- heaven
            local playerManager = game.m_playerManager
            local brokenShovel1 = PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_1)
            local momsShovel = PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_MOMS_SHOVEL)

            local forcedToHell = brokenShovel1 or momsShovel
            if forcedToHell and not challengeAltersEndStage then
                return false
            end
        end
    end

    if challengeAltersEndStage and challengeParams.m_endStage ~= LevelStage.STAGE_NULL then
        endStage = challengeParams.m_endStage
    end

    return stage <= endStage
end

---@param challenge Challenge | integer
---@param challengeParams ChallengeParamsComponent
---@param level LevelComponent
---@param effectiveStage LevelStage | integer
local function TrapDoorHindersChallenge(challenge, challengeParams, level, effectiveStage)
    if not challengeParams.m_isSecretPath then
        return false
    end

    if challenge == Challenge.CHALLENGE_RED_REDEMPTION then
        return false
    end

    -- Next stage is forced alt path, so trapdoor leads to secret path
    if LevelUtils.IsAltPath(level) and (effectiveStage % 2 == 1 and effectiveStage < LevelStage.STAGE4_3) then
        return false
    end

    if level.m_roomIdx == GridRooms.ROOM_SECRET_EXIT_IDX then
        return false
    end

    return true
end

---@param myContext Context.Common
---@param level LevelComponent
---@return boolean
local function CanSpawnTrapDoor(myContext, level)
    if QuestUtils.IsMirrorWorld(myContext, level) then
        return false
    end

    if not level.m_isInitializing and QuestUtils.IsRoomBackwardsPathEntrance(myContext, level.m_room, level) then
        return false
    end

    local game = myContext.game
    local gameStateFlags = game.m_gameStateFlags
    if (LevelStage.STAGE1_1 <= level.m_stage and level.m_stage <= LevelStage.STAGE3_2) and (gameStateFlags & GameStateFlag.STATE_BACKWARDS_PATH) ~= 0 then
        return false
    end

    local stage = level.m_stage
    local curses = CurseUtils.GetCurses(myContext, level)
    local challenge = game.m_challenge
    local challengeParams = GameUtils.GetChallengeParams(myContext, game)
    local effectiveStage = (curses & LevelCurse.CURSE_OF_LABYRINTH) ~= 0 and stage + 1 or stage
    if TrapDoorHindersChallenge(challenge, challengeParams, level, effectiveStage) then
        return false
    end

    local NextStageContext = myContext
    local nextStageAvailable = IsNextStageAvailable(NextStageContext, level)

    if not nextStageAvailable then
        return false
    end

    if not GameUtils.IsGreedMode(game) then
        -- trapdoor to devil is not available
        if stage == LevelStage.STAGE4_2 and not IsStageAvailable(myContext, LevelStage.STAGE5, StageType.STAGETYPE_ORIGINAL) then
            return false
        end

        -- next stage does not use trapdoor
        if stage > LevelStage.STAGE4_2 then
            return false
        end
    end

    return true
end

local Module = {}

--#region Module

Module.GetStageID = GetStageID
Module.GetLocalStageType = GetLocalStageType
Module.IsNextStageAvailable = IsNextStageAvailable
Module.IsStageAvailable = IsStageAvailable
Module.TrapDoorHindersChallenge = TrapDoorHindersChallenge
Module.CanSpawnTrapDoor = CanSpawnTrapDoor

--#endregion

return Module