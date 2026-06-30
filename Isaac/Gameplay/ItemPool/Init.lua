--#region Dependencies

local IModManager = require("Isaac.Interface.ModManager")
local IItemPool = require("Isaac.Interface.ItemPool")
local ISoundEffects = require("Isaac.Interface.SoundEffects")
local IItemConfig = require("Isaac.Interface.ItemConfig")
local Log = require("General.Log")
local RNGUtils = require("General.RNG")

--#endregion

local IPillConfig = IItemConfig.PillEffect

local ONANS_STREAK_BANNED_COLLECTIBLES = {
    CollectibleType.COLLECTIBLE_TECHNOLOGY, CollectibleType.COLLECTIBLE_BRIMSTONE,
    CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE, CollectibleType.COLLECTIBLE_DR_FETUS,
    CollectibleType.COLLECTIBLE_EPIC_FETUS, CollectibleType.COLLECTIBLE_MOMS_KNIFE,
    CollectibleType.COLLECTIBLE_TECH_X, CollectibleType.COLLECTIBLE_MARKED,
    CollectibleType.COLLECTIBLE_MOMS_EYE, CollectibleType.COLLECTIBLE_LOKIS_HORNS,
    CollectibleType.COLLECTIBLE_MONSTROS_LUNG
}

---@param itemPool Component.ItemPool
---@param ctx Context.Common
---@param effectPool (PillEffect | integer)[]
---@param class integer
---@return integer -- index in the effectPool
local function choose_pill_effect_for_color(itemPool, ctx, effectPool, class)
    -- specific class requested
    if class ~= -1 then
        local pillEffects = ctx.manager.m_itemConfig.m_pillEffectList
        for i = 1, #effectPool, 1 do
            local effectId = effectPool[i]
            local pillEffect = pillEffects[effectId]
            if pillEffect.m_effectType == class then
                return i
            end
        end
    end

    local rng = itemPool.m_rng
    local randomEffect = rng:RandomInt(#effectPool) + 1
    return randomEffect
end

---@param itemPool Component.ItemPool
---@param ctx Context.Common
---@param seed integer
---@param xmlPath string
local function Init(itemPool, ctx, seed, xmlPath)
    local manager = ctx.manager
    local game = ctx.game
    local itemConfig = manager.m_itemConfig

    itemPool.m_rng = RNG(seed, 3)
    local rng = itemPool.m_rng

    local trinketSeed = rng:Next()
    itemPool.m_trinketPoolRNG = RNG(trinketSeed, 2)

    itemPool.m_lastPool = ItemPoolType.POOL_TREASURE

    local collectibleList = manager.m_itemConfig.m_collectibleList
    local removedCollectibles = {}
    local blacklistedCollectibles = {}

    for i = 1, #collectibleList, 1 do
        removedCollectibles[i] = false
        blacklistedCollectibles[i] = false
    end

    itemPool.m_removedCollectibles = removedCollectibles
    itemPool.m_blacklistedCollectibles = blacklistedCollectibles
    itemPool.m_trinketPoolItems = {} -- the game just resizes this to the amount of trinkets, however this would make little sense in Lua

    itemPool.m_unusedSpecialItemChance1 = 1.0
    itemPool.m_unusedSpecialItemChance2 = 1.0

    IItemPool.load_pools(itemPool, xmlPath, false)
    IModManager.UpdatePools(manager.m_modManager, ctx)
    IItemPool.shuffle_pools(itemPool)

    if game.m_challenge == Challenge.CHALLENGE_ONANS_STREAK then
        for i = 1, #ONANS_STREAK_BANNED_COLLECTIBLES, 1 do
            IItemPool.RemoveCollectible(itemPool, ctx, ONANS_STREAK_BANNED_COLLECTIBLES[i], false, false)
        end
    end

    IItemPool.ResetTrinkets(itemPool, ctx)

    -- init pill pool
    local pillClass = {
        3, 3, 3, 3,
        -1, 0, 1, 2,
        1, 2, 3, -1,
        -1, -1
    }

    for i = 1, PillColor.NUM_STANDARD_PILLS, 1 do
        itemPool.m_identifiedPillEffects[i] = false
    end

    local pillColors = {}
    for i = 1, PillColor.NUM_STANDARD_PILLS, 1 do
        pillColors[i] = i
    end
    RNGUtils.RandomShuffle(pillColors, rng)
    table.insert(pillColors, PillColor.PILL_GOLD)

    local pillPool = {}
    local pillEffects = itemConfig.m_pillEffectList
    for i = 1, #pillEffects, 1 do
        local pillEffect = pillEffects[i]
        if IPillConfig.IsAvailable(pillEffect, ctx) then
            table.insert(pillPool, i)
            ISoundEffects.Preload(manager.m_sfxManager, ctx, pillEffect.m_announcerVoice)
        end
    end
    RNGUtils.RandomShuffle(pillPool, rng)

    for pillColor = 1, #pillColors, 1 do
        local specificClass = -1
        if pillColor <= PillColor.NUM_STANDARD_PILLS then -- gold pill is not specific
            specificClass = pillClass[pillColor]
        end

        local idx = choose_pill_effect_for_color(itemPool, ctx, pillPool, specificClass)
        local pillEffect = pillPool[idx]
        table.remove(pillPool, idx)

        itemPool.m_pillEffects[pillColor + 1] = pillEffect
    end
    itemPool.m_pillEffects[PillColor.PILL_NULL + 1] = -1

    local cardList = itemConfig.m_cardList
    for i = 1, #cardList, 1 do
        local card = cardList[i]
        ISoundEffects.Preload(manager.m_sfxManager, ctx, card.m_announcerVoice)
    end

    local genesisItems = itemPool.m_genesisItems
    for i = 1, ItemPoolType.NUM_ITEMPOOLS, 1 do
        genesisItems[i] = 0
    end
end

---@class Gameplay.ItemPoolInit
local Module = {}

--#region Module

Module.Init = Init

--#endregion

return Module