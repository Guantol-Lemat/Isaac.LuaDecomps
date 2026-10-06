--#region Dependencies

local G = require("Isaac.Global")

local ILevel = require("Isaac.Interface.Level")
local IRoom = require("Isaac.Interface.Room")
local ITemporaryEffects = require("Isaac.Interface.TemporaryEffects")

--#endregion

---@param room Component.Room
---@return boolean
local function IsAbandonedMineshaft(room)
    local level = G.Game.m_level
    return ILevel.HasAbandonedMineshaft(level) and level.m_dimension == Dimension.MINESHAFT
end

---@param room Component.Room
---@return number
local function GetDarknessIntensity(room)
    local game = G.Game

    local darknessIntensity = game.m_targetDarkness * game.m_darknessModifier
    if (ILevel.GetCurses(game.m_level) & LevelCurse.CURSE_OF_DARKNESS) ~= 0 then
        darknessIntensity = 1.0
    end

    local isDarkRoom = (room.m_type == RoomType.ROOM_SUPERSECRET or room.m_type == RoomType.ROOM_ULTRASECRET)
        or IsAbandonedMineshaft(room)
        or IRoom.IsBackwardsPathEntrance(room)
    if isDarkRoom then
        darknessIntensity = math.min(darknessIntensity + 0.6, 1.0)
     end

    if (game.m_level.m_stage == LevelStage.STAGE8 and game.m_level.m_stageType == StageType.STAGETYPE_WOTL)
        and (room.m_roomDescriptor.m_flags & RoomDescriptor.FLAG_SACRIFICE_DONE) == 0 then
        darknessIntensity = 1.0
    end

    darknessIntensity = darknessIntensity - game.m_lightning_strength
    darknessIntensity = math.max(darknessIntensity, 0.0)

    return darknessIntensity
end

---@param room Component.Room
---@return boolean
local function HasTexturedPit(room)
    return room.m_backdrop.m_type == BackdropType.MINES and (room.m_roomDescriptor.m_flags & RoomDescriptor.FLAG_HAS_WATER) ~= 0
end

---@param room Component.Room
---@return boolean
local function IsGlitchRendering(room)
    return ITemporaryEffects.HasCollectibleEffect(room.m_temporaryEffects, CollectibleType.COLLECTIBLE_DATAMINER)
end

---@class Content.Room.Properties
local Module = {}

--#region Module

Module.IsAbandonedMineshaft = IsAbandonedMineshaft
Module.GetDarknessIntensity = GetDarknessIntensity
Module.HasTexturedPit = HasTexturedPit
Module.IsGlitchRendering = IsGlitchRendering

--#endregion

return Module