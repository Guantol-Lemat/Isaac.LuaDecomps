--#region Dependencies

local Enums = require("Isaac.Enums")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local IGame = require("Isaac.Interface.Game")
local GameEffects = require("Isaac.Interface.Custom.GameEffects")
local PlayerEffects = require("Isaac.Interface.Custom.PlayerEffects")

--#endregion

local eItemIsAvailableFlag = Enums.eItemIsAvailableFlag

---@param item Component.ItemConfig.Item
---@param ctx Context.Common
---@param flags eItemIsAvailableFlag | integer
local function Item_IsAvailableEx(item, ctx, flags)
    if item.m_hidden then
        return false
    end

    local manager = ctx.manager
    if (flags & eItemIsAvailableFlag.ITEM_FILTER) ~= 0 then
        local itemFilters = manager.m_itemConfig.m_itemFilter
        for i = 1, #itemFilters, 1 do
            if not itemFilters[i](ctx, item) then
                return false
            end
        end
    end

    local game = ctx.game
    local tags = item.m_tags

    if (flags & eItemIsAvailableFlag.MODE_BLACKLIST) ~= 0 then
        if GameEffects.BlockItem_Mode(game, item) then
            return false
        end

        local inChallenge = game.m_challenge ~= Challenge.CHALLENGE_NULL
        if inChallenge and (tags & ItemConfig.TAG_NO_CHALLENGE) ~= 0 then
            return false
        end

        local inDaily = game.m_dailyChallenge.m_id ~= 0
        if inDaily and (tags & ItemConfig.TAG_NO_DAILY) ~= 0 then
            return false
        end

        if IGame.IsGreedMode(game) and (tags & ItemConfig.TAG_NO_GREED) ~= 0 then
            return false
        end
    end

    if (flags & eItemIsAvailableFlag.CHECK_MODIFIERS) ~= 0 then
        local block = GameEffects.BlockItem_Modifier(game, item)
            or PlayerEffects.BlockItem(game.m_playerManager, ctx, item)

        if block then
            return false
        end
    end

    if (flags & eItemIsAvailableFlag.CHECK_ACHIEVEMENT) ~= 0 then
        local achievement = item.m_achievementID
        local isLocked = achievement > -1

        if isLocked and not IPersistentGameData.Unlocked(ctx.manager.m_persistentGameData, ctx, achievement) then
            return false
        end
    end

    return true
end

local FLAGS_NO_UNLOCK = eItemIsAvailableFlag.ALL & ~eItemIsAvailableFlag.CHECK_ACHIEVEMENT

---@param item Component.ItemConfig.Item
---@param ctx Context.Common
---@param ignoreUnlock boolean
---@return boolean
local function Item_IsAvailable(item, ctx, ignoreUnlock)
    local flags = ignoreUnlock and FLAGS_NO_UNLOCK or eItemIsAvailableFlag.ALL
    return Item_IsAvailableEx(item, ctx, flags)
end

---@param cardConfig Component.ItemConfig.Card
---@param ctx Context.Common
local function Card_IsAvailable(cardConfig, ctx)
    if not cardConfig.m_greedModeAllowed and IGame.IsGreedMode(ctx.game) then
        return false
    end

    if PlayerEffects.BlockCard(ctx.game.m_playerManager, ctx, cardConfig) then
        return false
    end

    local achievement = cardConfig.m_achievementId
    local isLocked = achievement > -1

    if isLocked and not IPersistentGameData.Unlocked(ctx.manager.m_persistentGameData, ctx, achievement) then
        return false
    end

    return true
end

---@param pillConfig Component.ItemConfig.PillEffect
---@param ctx Context.Common
local function PillEffect_IsAvailable(pillConfig, ctx)
    if not pillConfig.m_greedModeAllowed and IGame.IsGreedMode(ctx.game) then
        return false
    end

    local achievement = pillConfig.m_achievementId
    local isLocked = achievement > -1

    if isLocked and not IPersistentGameData.Unlocked(ctx.manager.m_persistentGameData, ctx, achievement) then
        return false
    end

    return true
end

---@class Gameplay.ItemConfig.Available
local Module = {}

--#region Module

Module.Item_IsAvailable = Item_IsAvailable
Module.Item_IsAvailableEx = Item_IsAvailableEx
Module.Card_IsAvailable = Card_IsAvailable
Module.PillEffect_IsAvailable = PillEffect_IsAvailable

--#endregion

return Module