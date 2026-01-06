--#region Dependencies

local MathUtils = require("General.Math")
local LevelUtils = require("Level.Utils")
local PlayerManagerUtils = require("Game.PlayerManager.Utils")

--#endregion

---@class LevelGenerationUtils
local Module = {}

local function normalize_planetarium_chance(chance)
    return MathUtils.Clamp(chance, 0.01, 1.0)
end

---@param myContext LevelGenerationContext.GetPlanetariumChance
---@param level LevelComponent
---@return number
local function GetPlanetariumChance(myContext, level)
    local stage = LevelUtils.IsAltPath(level) and level.m_stage + 1 or level.m_stage

    if stage >= LevelStage.STAGE4_3 then
        return 0.0
    end

    local playerManager = myContext.playerManager

    local telescopeLens = PlayerManagerUtils.AnyoneHasTrinket(myContext, playerManager, TrinketType.TRINKET_TELESCOPE_LENS)
    if (stage >= LevelStage.STAGE4_1 and not telescopeLens) then
        return 0.0
    end

    local chance  = 0.01

    if myContext.planetariumsVisited ~= 0 then
        if telescopeLens then
            chance = chance + 0.09
        end

        return normalize_planetarium_chance(chance)
    end

    local crystalBall = PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_CRYSTAL_BALL)
    local magic8Ball = PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_MAGIC_8_BALL)
    local sausage = PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_SAUSAGE)

    local challengeRoomSets = myContext.challengeParams.m_roomFilter
    local treasureRoomsAllowed = not challengeRoomSets[RoomType.ROOM_TREASURE]

    local treasureRoomsMissed = (stage - 1) - myContext.treasureRoomsVisited
    if treasureRoomsAllowed and treasureRoomsMissed > 0 then
        chance = chance + treasureRoomsMissed * 0.2
        if crystalBall then
            chance = chance + 1.0
        end
    end

    local magic8BallIncrease = magic8Ball and 0.15 or 0.0
    local crystalBallIncrease = crystalBall and 0.15 or 0.0
    local sausageIncrease = sausage and 0.069 or 0.0
    local telescopeLensIncrease = telescopeLens and 0.24 or 0.0

    chance = chance + magic8BallIncrease + crystalBallIncrease + sausageIncrease + telescopeLensIncrease
    return normalize_planetarium_chance(chance)
end

--#region Module

Module.GetPlanetariumChance = GetPlanetariumChance

--#endregion

return Module