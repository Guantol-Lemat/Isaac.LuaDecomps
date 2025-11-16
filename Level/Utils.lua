--#region Dependencies

local GameUtils = require("Game.Utils")
local QuestUtils = require("Mechanics.Game.Quest.Utils")
local PersistentDataUtils = require("Admin.PersistentData.Utils")
local PlayerManagerUtils = require("Game.PlayerManager.Utils")

--#endregion

---@class LevelUtils
local Module = {}

---@param coordinates XYComponent
local function ToRoomIdx(coordinates)
    local x = coordinates.x
    local y = coordinates.y

    if (0 <= x and x < 13) and (0 <= y and y < 13) then
        return y * 13 + x
    end

    return -1
end

---@param level LevelComponent
---@return boolean
local function IsAltPath(level)
end

---@param stage LevelStage | integer
---@param stageType StageType | integer
local function GetFloor(stage, stageType)
    if stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B then
        return stage + 1
    end

    return stage
end

---@param level LevelComponent
---@return RoomDescriptorComponent
local function GetCurrentRoomDesc(level)
    return level.m_room.m_roomDescriptor
end

---@param level LevelComponent
local function reset_room_list(level)

end

---@param level LevelComponent
local function reset_dimension_lookup(level)
    local dimensionLookup = level.m_dimensionLookups

    for i = 1, GridRooms.MAX_GRID_ROOMS, 1 do
        local dimension = i // 169
        local gridIdx = i // 3

        dimensionLookup[dimension + 1][gridIdx + 1] = -1
    end
end

---@param level LevelComponent
---@param idx GridRooms | integer
---@param dimension Dimension | integer
---@return RoomDescriptorComponent?
local function get_dimension_room_by_idx(level, idx, dimension)
    local roomListIdx = level.m_dimensionLookups[dimension][idx]
    if roomListIdx == -1 then
        return
    end

    return level.m_roomList[roomListIdx]
end

---@param level LevelComponent
---@param idx GridRooms | integer
---@param dimension Dimension | integer
---@return RoomDescriptorComponent?
local function GetRoomByIdx(level, idx, dimension)
    if dimension == Dimension.CURRENT then
        dimension = level.m_dimension
    end

    if dimension >= 3 then
        return
    end

    if idx == GridRooms.ROOM_MIRROR_IDX then
        idx = level.m_roomIdx
        if idx < 0 then
            return nil
        end

        dimension = dimension == Dimension.NORMAL and Dimension.MIRROR or Dimension.NORMAL
        return get_dimension_room_by_idx(level, idx, dimension)
    end

    if idx == GridRooms.ROOM_MINESHAFT_IDX then
        if dimension == Dimension.NORMAL then
            return get_dimension_room_by_idx(level, 162, Dimension.MINESHAFT)
        end

        local roomList = level.m_roomList
        local roomCount = level.m_roomCount

        for i = 1, roomCount, 1 do
            local room = roomList[i]
            local data = room.m_data

            ---@cast data RoomDataComponent
            if room.m_dimension == Dimension.NORMAL and data.m_type == RoomType.ROOM_DEFAULT and data.m_subtype == RoomSubType.MINES_MINESHAFT_ENTRANCE then
                return room
            end
        end

        return nil
    end

    local offgridIdx = -idx -1
    if (0 <= offgridIdx and offgridIdx < GridRooms.NUM_OFF_GRID_ROOMS) then
        return level.m_roomList[offgridIdx + GridRooms.MAX_GRID_ROOMS]
    end

    if (0 <= idx and idx < 169) then
        return get_dimension_room_by_idx(level, idx, dimension)
    end

    return nil
end

---@param myContext LevelContext.GetStageId
---@param level LevelComponent
---@return StbType | integer
local function GetStageID(myContext, level)
end

---@param myContext LevelContext.IsNextStageAvailable
---@param level LevelComponent
---@return boolean
local function IsNextStageAvailable(myContext, level)
    local StageIdContext = myContext
    local localStageId = GetStageID(StageIdContext, level)

    if localStageId == StbType.ASCENT then
        return false
    end

    local BackwardsPathEntranceContext = myContext
    if QuestUtils.IsBackwardsPathEntrance(BackwardsPathEntranceContext, level) then
        return false
    end

    local stage = level.m_stage
    if (stage == LevelStage.STAGE6 or stage == LevelStage.STAGE7 or stage == LevelStage.STAGE8 or (myContext.mode == 1 and stage == LevelStage.STAGE7_GREED)) then
        return false
    end

    local effectiveStage = stage
    if (myContext.curses & LevelCurse.CURSE_OF_LABYRINTH) ~= 0 and (stage % 2 == 1 and stage < LevelStage.STAGE4_3) then
        effectiveStage = stage + 1
    end

    if effectiveStage == LevelStage.STAGE4_2 and IsAltPath(level) then
        return false
    end

    if myContext.inChallenge and myContext.challengeParams.m_endStage <= effectiveStage then
        return false
    end

    return true
end

---@param myContext LevelContext.IsStageAvailable
---@param stage LevelStage | integer
---@param moralPath StageType | integer -- only used if stage is LevelStage.STAGE5 or LevelStage.STAGE6
local function IsStageAvailable(myContext, stage, moralPath)
    if myContext.mode == 1 then
        return stage <= LevelStage.STAGE7_GREED
    end

    local endStage = LevelStage.STAGE7
    if myContext.inChallenge or not PersistentDataUtils.Unlocked(myContext, myContext.persistentGameData, Achievement.VOID_FLOOR) then
        endStage = LevelStage.STAGE6
    end

    local challengeParams = myContext.challengeParams
    local challengeAltersEndStage = challengeParams.m_altersEndStage
    local challengeForcedPath = challengeParams.m_isAltPath and StageType.STAGETYPE_WOTL or StageType.STAGETYPE_ORIGINAL

    local splitPath = (stage == LevelStage.STAGE5 or stage == LevelStage.STAGE6)

    if splitPath then
        if challengeAltersEndStage and challengeForcedPath ~= moralPath then
            return false
        end

        if moralPath == StageType.STAGETYPE_WOTL then -- heaven
            local playerManager = myContext.playerManager
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
local function trapdoor_hinders_challenge(challenge, challengeParams, level, effectiveStage)
    if not challengeParams.m_isSecretPath then
        return false
    end

    if challenge == Challenge.CHALLENGE_RED_REDEMPTION then
        return false
    end

    -- Next stage is forced alt path, so trapdoor leads to secret path
    if IsAltPath(level) and (effectiveStage % 2 == 1 and effectiveStage < LevelStage.STAGE4_3) then
        return false
    end

    if level.m_roomIdx == GridRooms.ROOM_SECRET_EXIT_IDX then
        return false
    end

    return true
end

---@param myContext LevelContext.CanSpawnTrapDoor
---@param level LevelComponent
---@return boolean
local function CanSpawnTrapDoor(myContext, level)
    local curses = myContext.curses
    local mode = myContext.mode
    local gameStateFlags = myContext.gameStateFlags

    local MirrorContext = myContext
    if QuestUtils.IsMirrorWorld(MirrorContext, level) then
        return false
    end

    local BackwardsPathEntranceContext = myContext
    if not level.m_isInitializing and QuestUtils.IsRoomBackwardsPathEntrance(BackwardsPathEntranceContext, level.m_room, level) then
        return false
    end

    if (LevelStage.STAGE1_1 <= level.m_stage and level.m_stage <= LevelStage.STAGE3_2) and (gameStateFlags & GameStateFlag.STATE_BACKWARDS_PATH) ~= 0 then
        return false
    end

    local stage = level.m_stage
    local effectiveStage = (curses & LevelCurse.CURSE_OF_LABYRINTH) ~= 0 and stage + 1 or stage
    if trapdoor_hinders_challenge(myContext.challenge, myContext.challengeParams, level, effectiveStage) then
        return false
    end

    local NextStageContext = myContext
    local nextStageAvailable = IsNextStageAvailable(NextStageContext, level)

    if not nextStageAvailable then
        return false
    end

    if mode ~= 1 then
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

--#region Module

Module.ToRoomIdx = ToRoomIdx
Module.IsAltPath = IsAltPath
Module.GetFloor = GetFloor
Module.GetCurrentRoomDesc = GetCurrentRoomDesc
Module.reset_room_list = reset_room_list
Module.reset_dimension_lookup = reset_dimension_lookup
Module.GetRoomByIdx = GetRoomByIdx
Module.GetStageID = GetStageID
Module.IsNextStageAvailable = IsNextStageAvailable
Module.IsStageAvailable = IsStageAvailable
Module.CanSpawnTrapDoor = CanSpawnTrapDoor

--#endregion

return Module