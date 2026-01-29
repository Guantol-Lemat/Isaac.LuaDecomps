--#region Dependencies

local BitSetUtils = require("General.Bitset")
local SeedsUtils = require("Admin.Seeds.Utils")
local GameUtils = require("Game.Utils")
local PlayerManagerRules = require("Game.PlayerManager.Rules")
local CurseRules = require("Mechanics.Level.Curse.Rules")

--#endregion

---@class LevelRules
local Module = {}

---@param myContext LevelContext.PlaceRoomContext
---@param level LevelComponent
---@param levelGenRoom LevelGeneratorRoomComponent
---@param roomData RoomDataComponent
---@param seed integer
---@return boolean
local function PlaceRoom(myContext, level, levelGenRoom, roomData, seed)
end

---@param context Context
---@param level LevelComponent
---@param stage LevelStage | integer
---@param stageType StageType | integer
local function SetStage(context, level, stage, stageType)
end

---@param context Context
---@param level LevelComponent
---@param curses LevelCurse | integer
---@return boolean
local function HasCurses(context, level, curses)
    local curseBitset = GetCurses(context, level)
    return BitSetUtils.Test(curseBitset, curses)
end

---@param context Context
---@param level LevelComponent
---@param stage LevelStage
---@return LevelStage
local function hook_effective_stage(context, level, stage)
    if HasCurses(context, level, LevelCurse.CURSE_OF_LABYRINTH) then
        stage = stage + 1
    end

    return stage
end

---@param context Context
---@param level LevelComponent
---@return LevelStage
local function GetEffectiveStage(context, level)
    local stage = level.m_stage
    stage = hook_effective_stage(context, level, stage)
    return stage
end

---@param myContext LevelContext.GetStageId
---@param level LevelComponent
---@return StbType | integer
local function GetStageId(myContext, level)
end

---@param context Context
---@param level LevelComponent
---@param sticky boolean
local function ShowName(context, level, sticky)
end

--#region Module

Module.PlaceRoom = PlaceRoom
Module.SetStage = SetStage
Module.GetCurses = GetCurses
Module.HasCurses = HasCurses
Module.GetStageId = GetStageId
Module.GetEffectiveStage = GetEffectiveStage
Module.ShowName = ShowName

--#endregion

return Module