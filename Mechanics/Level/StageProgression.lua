--#region Dependencies

local GameUtils = require("Game.Utils")
local LevelRules = require("Level.Rules")
local SeedsUtils = require("Seeds.Utils")
local PersistentDataRules = require("PersistentData.Rules")
local BackwardsPathRules = require("Level.BackwardsPath.Rules")

--#endregion

---@class LevelStageProgression
local Module = {}

---@alias LevelStageProgression._SWITCH_NormalProgression fun(context: Context, stageType: StageType): LevelStage, StageType
---@alias LevelStageProgression._SWITCH_GreedModeProgression fun(context: Context): LevelStage
---@alias LevelStageProgression._SWITCH_BackasswardsProgression fun(context: Context): LevelStage

---@type table<LevelStage | "default", LevelStageProgression._SWITCH_NormalProgression>
local switch_NormalProgression = {
    [LevelStage.STAGE_NULL] = function (_, stageType) return LevelStage.STAGE1_1, stageType end,
    [LevelStage.STAGE1_1] = function (_, stageType) return LevelStage.STAGE1_2, stageType end,
    [LevelStage.STAGE1_2] = function (_, stageType) return LevelStage.STAGE2_1, stageType end,
    [LevelStage.STAGE2_1] = function (_, stageType) return LevelStage.STAGE2_2, stageType end,
    [LevelStage.STAGE2_2] = function (_, stageType) return LevelStage.STAGE3_1, stageType end,
    [LevelStage.STAGE3_1] = function (_, stageType) return LevelStage.STAGE3_2, stageType end,
    [LevelStage.STAGE3_2] = function (_, stageType) return LevelStage.STAGE4_1, stageType end,
    [LevelStage.STAGE4_1] = function (_, stageType) return LevelStage.STAGE4_2, stageType end,
    [LevelStage.STAGE4_2] = function (_, stageType)
        if stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B then
            return LevelStage.STAGE5, stageType
        end

        return LevelStage.STAGE4_2, stageType
    end,
    [LevelStage.STAGE4_3] = function (_, stageType)
        if stageType == StageType.STAGETYPE_REPENTANCE then
            return LevelStage.STAGE8, StageType.STAGETYPE_ORIGINAL
        end

        return LevelStage.STAGE5, stageType
    end,
    [LevelStage.STAGE5] = function (_, stageType) return LevelStage.STAGE6, stageType end,
    [LevelStage.STAGE6] = function (_, stageType) return LevelStage.STAGE6, stageType end,
    [LevelStage.STAGE7] = function (_, stageType) return LevelStage.STAGE7, stageType end,
    [LevelStage.STAGE8] = function (_, stageType) return LevelStage.STAGE8, stageType end,
    default = function (context, stageType)
        context:LogMessage(3, "Wrong Stage")
        return LevelStage.STAGE_NULL, stageType
    end
}

---@type table<LevelStage | "default", LevelStageProgression._SWITCH_BackasswardsProgression>
local switch_BackasswardsProgression = {
    [LevelStage.STAGE_NULL] = function () return LevelStage.STAGE6 end,
    [LevelStage.STAGE6] = function () return LevelStage.STAGE5 end,
    [LevelStage.STAGE5] = function () return LevelStage.STAGE4_2 end,
    [LevelStage.STAGE4_2] = function () return LevelStage.STAGE4_1 end,
    [LevelStage.STAGE4_1] = function () return LevelStage.STAGE3_2 end,
    [LevelStage.STAGE3_2] = function () return LevelStage.STAGE3_1 end,
    [LevelStage.STAGE3_1] = function () return LevelStage.STAGE2_2 end,
    [LevelStage.STAGE2_2] = function () return LevelStage.STAGE2_1 end,
    [LevelStage.STAGE2_1] = function () return LevelStage.STAGE1_2 end,
    [LevelStage.STAGE1_2] = function () return LevelStage.STAGE1_1 end,
    [LevelStage.STAGE1_1] = function () return LevelStage.STAGE1_1 end,
    default = function (context)
        context:LogMessage(3, "Wrong Stage")
        return LevelStage.STAGE_NULL
    end
}

---@type table<LevelStage | "default", LevelStageProgression._SWITCH_GreedModeProgression>
local switch_GreedStageProgression = {
    [LevelStage.STAGE_NULL] = function () return LevelStage.STAGE1_GREED end,
    [LevelStage.STAGE1_GREED] = function () return LevelStage.STAGE2_GREED end,
    [LevelStage.STAGE2_GREED] = function () return LevelStage.STAGE3_GREED end,
    [LevelStage.STAGE3_GREED] = function () return LevelStage.STAGE4_GREED end,
    [LevelStage.STAGE4_GREED] = function () return LevelStage.STAGE5_GREED end,
    [LevelStage.STAGE5_GREED] = function () return LevelStage.STAGE6_GREED end,
    [LevelStage.STAGE6_GREED] = function () return LevelStage.STAGE7_GREED end,
    [LevelStage.STAGE7_GREED] = function () return LevelStage.STAGE7_GREED end,
    default = function (context)
        context:LogMessage(3, "Wrong Stage (Greed Mode)")
        return LevelStage.STAGE_NULL
    end
}

---@param persistentData PersistentDataComponent
---@param stage LevelStage
---@return boolean
local function is_wotl_available(context, persistentData, stage)
    if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.CELLAR)
    elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.CATACOMBS)
    elseif stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.NECROPOLIS)
    elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 then
        return true
    end

    return false
end

---@param persistentData PersistentDataComponent
---@param stage LevelStage
---@return boolean
local function is_afterbirth_available(context, persistentData, stage)
    if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.BURNING_BASEMENT)
    elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.FLOODED_CAVES)
    elseif stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.DANK_DEPTHS)
    elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.SCARRED_WOMB)
    end

    return false
end

---@param persistentData PersistentDataComponent
---@param stage LevelStage
---@return boolean
local function is_repentance_b_available(context, persistentData, stage)
    if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.DROSS)
    elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.ASHPIT)
    elseif stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.GEHENNA)
    end

    return false
end

---@param persistentData PersistentDataComponent
---@param stage LevelStage
---@return boolean
local function is_wotl_available_greed(context, persistentData, stage)
    if stage == LevelStage.STAGE1_GREED then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.CELLAR)
    elseif stage == LevelStage.STAGE2_GREED then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.CATACOMBS)
    elseif stage == LevelStage.STAGE3_GREED then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.NECROPOLIS)
    elseif stage == LevelStage.STAGE4_GREED then
        return true
    end

    return false
end

---@param persistentData PersistentDataComponent
---@param stage LevelStage
---@return boolean
local function is_afterbirth_available_greed(context, persistentData, stage)
    if stage == LevelStage.STAGE1_GREED then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.BURNING_BASEMENT)
    elseif stage == LevelStage.STAGE2_GREED then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.FLOODED_CAVES)
    elseif stage == LevelStage.STAGE3_GREED then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.DANK_DEPTHS)
    elseif stage == LevelStage.STAGE4_GREED then
        return PersistentDataRules.IsUnlocked(context, persistentData, Achievement.SCARRED_WOMB)
    end

    return false
end

---@param context Context
---@param level LevelComponent
local function get_next_stage(context, level)
    local game = context:GetGame()
    local stage = level.m_stage
    local stageType = level.m_stageType
    local isAltPath = stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B
    local IsBackwardsPath = BackwardsPathRules.IsBackwardsPath(game, level)

    if IsBackwardsPath then
        if isAltPath then
            stage = stage + 1
        end

        if stage == LevelStage.STAGE1_1 then
            return LevelStage.STAGE8, stageType
        end

        local previousStage = stage - 1
        if game.m_backwardsStageDesc[stage - 2].isXL then
            previousStage = stage - 2
        end

        local backwardsStageDesc = game.m_backwardsStageDesc[previousStage]
        local previousStageType = backwardsStageDesc.stageType

        if previousStageType == StageType.STAGETYPE_REPENTANCE or previousStageType == StageType.STAGETYPE_REPENTANCE_B then
            return previousStage - 1, StageType.STAGETYPE_REPENTANCE
        end

        return previousStage, StageType.STAGETYPE_ORIGINAL
    end

    local newStage = LevelStage.STAGE_NULL
    local newStageType = StageType.STAGETYPE_ORIGINAL

    if GameUtils.IsGreedMode(game) then
        ---@type LevelStageProgression._SWITCH_GreedModeProgression
        local getNextStage = switch_GreedStageProgression[stage] or switch_GreedStageProgression.default
        newStage = getNextStage(context)
        newStageType = StageType.STAGETYPE_ORIGINAL
    else
        ---@type LevelStageProgression._SWITCH_NormalProgression
        local getNextStage = switch_NormalProgression[stage] or switch_NormalProgression.default
        newStage, newStageType = getNextStage(context, stageType)

        if game.m_challenge == Challenge.CHALLENGE_BACKASSWARDS then
            ---@type LevelStageProgression._SWITCH_BackasswardsProgression
            getNextStage = switch_BackasswardsProgression[stage] or switch_BackasswardsProgression.default
            newStage = getNextStage(context)
        end
    end

    local curses = LevelRules.GetCurses(context, level)
    local isFirstChapterFloor = stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE4_1

    if ((curses & LevelCurse.CURSE_OF_LABYRINTH) ~= 0 or game.m_challenge == Challenge.CHALLENGE_RED_REDEMPTION) and isFirstChapterFloor then
        newStage = newStage + 1
        if stage == LevelStage.STAGE4_1 then
            newStage = newStage + 1
        end
    end

    if GameUtils.IsGreedMode(game) then
        local seeds = context:GetSeeds()
        local seed = seeds.m_stageSeeds[newStage]
        local persistentGameData = context:GetPersistentGameData()

        if (seed % 2) == 0 and is_wotl_available_greed(context, persistentGameData, newStage) then
            newStageType = StageType.STAGETYPE_WOTL
        else
            newStageType = StageType.STAGETYPE_ORIGINAL
        end

        if (seed % 3) == 0 and is_afterbirth_available_greed(context, persistentGameData, newStage) then
            newStageType = StageType.STAGETYPE_AFTERBIRTH
        end

        return newStage, newStageType
    end

    if newStage == LevelStage.STAGE8 then
        return newStage, newStageType
    end

    local secretPath = (game.m_gameStateFlags &  (1 << GameStateFlag.STATE_SECRET_PATH)) ~= 0
    if secretPath or ((curses & LevelCurse.CURSE_OF_LABYRINTH) == 0 and (isAltPath and isFirstChapterFloor)) then
        if not isAltPath then -- going from non alt path to alt path
            newStage = math.max(newStage - 1, LevelStage.STAGE1_1)
        end

        local seeds = context:GetSeeds()
        local seed = seeds.m_stageSeeds[newStage + 1]
        local persistentGameData = context:GetPersistentGameData()

        if (seed & 2) == 0 and is_repentance_b_available(context, persistentGameData, newStage) then
            newStageType = StageType.STAGETYPE_REPENTANCE_B
        else
            newStageType = StageType.STAGETYPE_REPENTANCE
        end
    else
        if isAltPath and not IsBackwardsPath then -- moving from alt path to non alt path
            newStage = newStage + 1
        end

        local seeds = context:GetSeeds()
        local seed = seeds.m_stageSeeds[newStage]
        local persistentGameData = context:GetPersistentGameData()

        if (seed % 2) == 0 and is_wotl_available(context, persistentGameData, newStage) then
            newStageType = StageType.STAGETYPE_WOTL
        else
            newStageType = StageType.STAGETYPE_ORIGINAL
        end

        if (seed % 3) == 0 and is_afterbirth_available(context, persistentGameData, newStage) then
            newStageType = StageType.STAGETYPE_AFTERBIRTH
        end

        if SeedsUtils.HasSeedEffect(seeds, SeedEffect.SEED_G_FUEL) and (newStage == LevelStage.STAGE2_1 or newStage == LevelStage.STAGE2_2) then
            newStageType = StageType.STAGETYPE_AFTERBIRTH
        end
    end

    if newStage < LevelStage.STAGE5 then
        game.m_gameStateFlags = game.m_gameStateFlags & ~(1 << GameStateFlag.STATE_HEAVEN_PATH)
        return newStage, newStageType
    end

    if newStage == LevelStage.STAGE5 then
        local room = context:GetRoom()
        if room.m_gridIdx == GridRooms.ROOM_BLUE_WOOM_IDX then
            return LevelStage.STAGE4_3, StageType.STAGETYPE_ORIGINAL
        end

        if room.m_gridIdx == GridRooms.ROOM_THE_VOID_IDX then
            return LevelStage.STAGE7, StageType.STAGETYPE_ORIGINAL
        end

        newStageType = StageType.STAGETYPE_ORIGINAL
        if (game.m_gameStateFlags & (1 << GameStateFlag.STATE_HEAVEN_PATH)) == 0 and game.m_challenge ~= Challenge.CHALLENGE_BACKASSWARDS then
            newStageType = StageType.STAGETYPE_WOTL
        end

        return LevelStage.STAGE5, newStageType
    end

    if newStage == LevelStage.STAGE6 then
        return LevelStage.STAGE6, level.m_stageType
    end

    return newStage, newStageType
end

---@param context Context
---@param level LevelComponent
local function SetNextStage(context, level)
    local stage, stageType = get_next_stage(context, level)
    LevelRules.SetStage(context, level, stage, stageType)
end

--#region Module

Module.SetNextStage = SetNextStage

--#endregion

return Module