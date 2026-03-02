--#region Dependencies

local Enums = require("General.Enums")
local TableUtils = require("General.Table")
local Progress = require("Isaac.PersistentGameData.Progress")
local SeedsUtils = require("Admin.Seeds.Utils")
local GameUtils = require("Game.Utils")
local PlayerManagerUtils = require("Game.PlayerManager.Utils")
local ItemConfigUtils = require("Isaac.ItemConfig.Utils")

local eItemFilterFlag = Enums.eItemFilterFlag
local eSpecialDailyRuns = Enums.eSpecialDailyRuns
--#endregion

local IMPACTFUL_WEAPON_MODIFIERS = TableUtils.CreateDictionary({
    CollectibleType.COLLECTIBLE_TECHNOLOGY, CollectibleType.COLLECTIBLE_BRIMSTONE,
    CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE, CollectibleType.COLLECTIBLE_DR_FETUS,
    CollectibleType.COLLECTIBLE_EPIC_FETUS, CollectibleType.COLLECTIBLE_MOMS_KNIFE,
    CollectibleType.COLLECTIBLE_TECHNOLOGY_2, CollectibleType.COLLECTIBLE_TECH_X,
    CollectibleType.COLLECTIBLE_MARKED, CollectibleType.COLLECTIBLE_MOMS_EYE,
    CollectibleType.COLLECTIBLE_LOKIS_HORNS, CollectibleType.COLLECTIBLE_MONSTROS_LUNG,
    CollectibleType.COLLECTIBLE_TRISAGION, CollectibleType.COLLECTIBLE_C_SECTION,
    CollectibleType.COLLECTIBLE_SPIRIT_SWORD,
})

local G_FUEL_BLACKLIST = TableUtils.CreateDictionary({
    CollectibleType.COLLECTIBLE_D6, CollectibleType.COLLECTIBLE_D_INFINITY,
    CollectibleType.COLLECTIBLE_ETERNAL_D6, CollectibleType.COLLECTIBLE_D4,
    CollectibleType.COLLECTIBLE_D100, CollectibleType.COLLECTIBLE_TRISAGION,
    CollectibleType.COLLECTIBLE_CURSED_EYE, CollectibleType.COLLECTIBLE_DEATHS_TOUCH,
    CollectibleType.COLLECTIBLE_CUPIDS_ARROW, CollectibleType.COLLECTIBLE_DEAD_ONION,
    CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT, CollectibleType.COLLECTIBLE_EYE_OF_BELIAL,
    CollectibleType.COLLECTIBLE_BERSERK, CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE,
    CollectibleType.COLLECTIBLE_D7, CollectibleType.COLLECTIBLE_TAURUS,
})

---@param myContext Context.Common
---@param item ItemConfigItemComponent
---@param flags eItemFilterFlag | integer
local function IsAvailable(myContext, item, flags)
    if item.m_hidden then
        return false
    end

    local isaac = myContext.manager
    if (flags & eItemFilterFlag.ITEM_FILTER) ~= 0 then
        local itemFilters = isaac.m_itemConfig.m_itemFilter
        for i = 1, #itemFilters, 1 do
            if not itemFilters[i](myContext, item) then
                return false
            end
        end
    end

    local game = myContext.game
    local tags = item.m_tags

    if (flags & eItemFilterFlag.MODE_BLACKLIST) ~= 0 then
        if ItemConfigUtils.IsCollectible(item) then
            local challenge = game.m_challenge
            if (challenge == Challenge.CHALLENGE_ONANS_STREAK or SeedsUtils.HasSeedEffect(game.m_seeds, SeedEffect.SEED_G_FUEL)) and IMPACTFUL_WEAPON_MODIFIERS[item.m_id] then
                return false
            end

            if game.m_dailyChallenge.m_specialDailyChallenge == eSpecialDailyRuns.G_FUEL_ISAAC_FLAVOURS_LAUNCH and G_FUEL_BLACKLIST[item.m_id] then
                return false
            end
        elseif ItemConfigUtils.IsTrinket(item) then
            local challenge = game.m_challenge
            if challenge == Challenge.CHALLENGE_PICA_RUN and item.m_id == TrinketType.TRINKET_BUTTER then
                return false
            end
        end

        if game.m_challenge ~= Challenge.CHALLENGE_NULL and (tags & ItemConfig.TAG_NO_CHALLENGE) ~= 0 then
            return false
        end

        if game.m_dailyChallenge.m_id ~= 0 and (tags & ItemConfig.TAG_NO_DAILY) ~= 0 then
            return false
        end

        if GameUtils.IsGreedMode(game) and (tags & ItemConfig.TAG_NO_GREED) ~= 0 then
            return false
        end
    end

    if (flags & eItemFilterFlag.CHECK_MODIFIERS) ~= 0 then
        local isCollectible = ItemConfigUtils.IsCollectible(item)
        if isCollectible and item.m_id == CollectibleType.COLLECTIBLE_VANISHING_TWIN and not GameUtils.IsGreedMode(game) and game.m_level.m_stage >= LevelStage.STAGE4_1 then
            return false
        end

        local playerManger = game.m_playerManager
        local keeper = PlayerManagerUtils.AnyoneIsPlayerType(playerManger, PlayerType.PLAYER_KEEPER) or PlayerManagerUtils.AnyoneIsPlayerType(playerManger, PlayerType.PLAYER_KEEPER_B)
        if keeper and (tags & ItemConfig.TAG_NO_KEEPER) ~= 0 then
            return false
        end

        local lostBr = PlayerManagerUtils.AnyoneHasBirthright(myContext, playerManger, PlayerType.PLAYER_THELOST)
        if lostBr and (tags & ItemConfig.TAG_NO_LOST_BR) ~= 0 then
            return false
        end

        if isCollectible then
            if PlayerManagerUtils.AnyoneIsPlayerType(playerManger, PlayerType.PLAYER_THELOST_B) then
                if (tags & ItemConfig.TAG_OFFENSIVE) ~= 0 then
                    return false
                end

                if item.m_quality < 2 then
                    local startSeed = game.m_seeds.m_startSeed
                    local idOffset = isCollectible and 0 or 1000
                    local seedOffset = idOffset + startSeed

                    if item.m_id + seedOffset == 0 then
                        seedOffset = 1
                    end

                    local uniqueSeed = item.m_id + seedOffset
                    local rng = RNG(uniqueSeed, 18)

                    if rng:RandomInt(5) == 0 then
                        return false
                    end
                end
            end

            if PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManger, CollectibleType.COLLECTIBLE_SACRED_ORB) then
                local quality = item.m_quality
                if quality < 2 then
                    return false
                end

                if quality == 2 then
                    local startSeed = game.m_seeds.m_startSeed
                    local idOffset = isCollectible and 0 or 1000
                    local seedOffset = idOffset + startSeed

                    if item.m_id + seedOffset == 0 then
                        seedOffset = 1
                    end

                    local uniqueSeed = item.m_id + seedOffset
                    local rng = RNG(uniqueSeed, 19)

                    if rng:RandomInt(3) == 0 then
                        return false
                    end
                end
            end

            if PlayerManagerUtils.GetTrinketMultiplier(myContext, playerManger, TrinketType.TRINKET_NO) >= 2 and item.m_quality == 0 then
                return false
            end
        end
    end

    if (flags & eItemFilterFlag.CHECK_ACHIEVEMENT) ~= 0 then
        if item.m_achievementID > -1 and not Progress.Unlocked(myContext, isaac.m_persistentGameData, item.m_achievementID) then
            return false
        end
    end

    return true
end

local Module = {}

--#region Module

Module.IsAvailable = IsAvailable

--#endregion

return Module