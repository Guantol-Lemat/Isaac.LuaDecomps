--#region Dependencies

local GameUtils = require("Game.Utils")
local LevelUtils = require("Game.Level.Utils")
local CurseUtils = require("Mechanics.Level.Curse.Utils")

--#endregion

---@class QuestUtils
local Module = {}

---@param myContext Context.Game
---@param level LevelComponent
---@return boolean
local function IsBackwardsPath(myContext, level)
    local game = myContext.game
    if GameUtils.IsGreedMode(game) then
        return false
    end

    if (game.m_gameStateFlags & GameStateFlag.STATE_BACKWARDS_PATH) == 0 then
        return false
    end

    if not (LevelStage.STAGE1_1 <= level.m_stage and level.m_stage <= LevelStage.STAGE3_2) then
        return false
    end

    return true
end

---@param myContext Context.Game
---@param level LevelComponent
---@return boolean
local function HasMirrorDimension(myContext, level)
    if IsBackwardsPath(myContext, level) then
        return false
    end

    if not LevelUtils.IsAltPath(level) then
        return false
    end

    local stage = level.m_stage
    return stage == LevelStage.STAGE1_2 or (stage == LevelStage.STAGE1_1 and (CurseUtils.GetCurses(myContext, level) & LevelCurse.CURSE_OF_LABYRINTH) ~= 0)
end

---@param myContext Context.Game
---@param level LevelComponent
---@return boolean
local function IsMirrorWorld(myContext, level)
    return level.m_dimension == Dimension.KNIFE_PUZZLE and HasMirrorDimension(myContext, level)
end

---@param myContext Context.Game
---@param level LevelComponent
---@return boolean
local function HasAbandonedMineshaft(myContext, level)
    if IsBackwardsPath(myContext, level) then
        return false
    end

    if not LevelUtils.IsAltPath(level) then
        return false
    end

    local stage = level.m_stage
    return stage == LevelStage.STAGE2_2 or (stage == LevelStage.STAGE2_1 and (CurseUtils.GetCurses(myContext, level) & LevelCurse.CURSE_OF_LABYRINTH) ~= 0)
end

---@param myContext Context.Game
---@param level LevelComponent
---@return boolean
local function IsAbandonedMineshaft(myContext, level)
    return level.m_dimension == Dimension.MINESHAFT and HasAbandonedMineshaft(myContext, level)
end

---@param myContext Context.Game
---@param level LevelComponent
---@return boolean
local function HasPhotoDoor(myContext, level)
    if IsBackwardsPath(myContext, level) then
        return false
    end

    if LevelUtils.IsAltPath(level) then
        return false
    end

    local stage = level.m_stage
    return stage == LevelStage.STAGE3_2 or (stage == LevelStage.STAGE3_1 and (CurseUtils.GetCurses(myContext, level) & LevelCurse.CURSE_OF_LABYRINTH) ~= 0)
end

---@param myContext Context.Game
---@param level LevelComponent
---@return boolean
local function IsBackwardsPathEntrance(myContext, level)
    if IsBackwardsPath(myContext, level) then
        return false
    end

    if not LevelUtils.IsAltPath(level) then
        return false
    end

    local stage = level.m_stage
    if not (stage == LevelStage.STAGE3_2 or (stage == LevelStage.STAGE3_1 and (CurseUtils.GetCurses(myContext, level) & LevelCurse.CURSE_OF_LABYRINTH) ~= 0)) then
        return false
    end

    return (myContext.game.m_gameStateFlags & GameStateFlag.STATE_BACKWARDS_PATH_INIT) ~= 0
end

---@param myContext Context.Game
---@param room RoomComponent
---@param level LevelComponent
---@return boolean
local function IsRoomBackwardsPathEntrance(myContext, room, level)
    if room.m_type ~= RoomType.ROOM_BOSS then
        return false
    end

    if room.m_roomDescriptor.m_data.m_subtype ~= BossType.MOM_MAUSOLEUM then
        return false
    end

    return IsBackwardsPathEntrance(myContext, level)
end

--#region Module

Module.HasMirrorDimension = HasMirrorDimension
Module.HasAbandonedMineshaft = HasAbandonedMineshaft
Module.HasPhotoDoor = HasPhotoDoor
Module.IsBackwardsPathEntrance = IsBackwardsPathEntrance
Module.IsBackwardsPath = IsBackwardsPath
Module.IsMirrorWorld = IsMirrorWorld
Module.IsAbandonedMineshaft = IsAbandonedMineshaft
Module.IsRoomBackwardsPathEntrance = IsRoomBackwardsPathEntrance

--#endregion

return Module