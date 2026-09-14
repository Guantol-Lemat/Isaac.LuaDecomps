--#region Dependencies

local TableUtils = require("General.Table")
local Enums = require("Isaac.Enums")
local IItemConfig = require("Isaac.Interface.ItemConfig")
local IGame = require("Isaac.Interface.Game")
local ISeeds = require("Isaac.Interface.Seeds")

local IItemConfig_Item = IItemConfig.Item

--#endregion

local eSpecialDailyRuns = Enums.eSpecialDailyRuns

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

---@param game Component.Game
---@param item Component.ItemConfig.Item
---@return boolean
local function BlockItem_Modifier(game, item)
    if IItemConfig_Item.IsCollectible(item) then
        local pastChapter3 = game.m_level.m_stage > LevelStage.STAGE3_2 and not IGame.IsGreedMode(game)
        if pastChapter3 and item.m_id == CollectibleType.COLLECTIBLE_VANISHING_TWIN then
            return true
        end
    end

    return false
end

---This is used in multiple places, make sure that
---changing this doesn't add/remove behavior in some places.
---@param game Component.Game
---@param trinketConfig Component.ItemConfig.Item
---@return boolean
local function BlockTrinket(game, trinketConfig)
    if game.m_challenge == Challenge.CHALLENGE_PICA_RUN then
        return trinketConfig.m_id == TrinketType.TRINKET_BUTTER
    end

    return false
end

---@param game Component.Game
---@param item Component.ItemConfig.Item
---@return boolean
local function BlockItem_Mode(game, item)
    if IItemConfig_Item.IsCollectible(item) then
        local challenge = game.m_challenge
        if (challenge == Challenge.CHALLENGE_ONANS_STREAK or ISeeds.HasSeedEffect(game.m_seeds, SeedEffect.SEED_G_FUEL)) and IMPACTFUL_WEAPON_MODIFIERS[item.m_id] then
            return true
        end

        if game.m_dailyChallenge.m_specialDailyChallenge == eSpecialDailyRuns.G_FUEL_ISAAC_FLAVOURS_LAUNCH and G_FUEL_BLACKLIST[item.m_id] then
            return true
        end
    elseif IItemConfig_Item.IsTrinket(item) then
        return BlockTrinket(game, item)
    end

    return false
end

---@class GameEffects.ItemBlock
local Module = {}

--#region Module

Module.BlockItem_Mode = BlockItem_Mode
Module.BlockItem_Modifier = BlockItem_Modifier
Module.BlockTrinket = BlockTrinket

--#endregion

return Module