--#region Dependencies

local IItemConfig = require("Isaac.Interface.ItemConfig")
local IPlayerManager = require("Isaac.Interface.PlayerManager")

local IItemConfig_Item = IItemConfig.Item

--#endregion

---@param playerManager Component.PlayerManager
---@param item Component.ItemConfig.Item
---@return boolean
local function NoKeeperBlock(playerManager, item)
    local isKeeper = IPlayerManager.AnyoneIsPlayerType(playerManager, PlayerType.PLAYER_KEEPER)
        or IPlayerManager.AnyoneIsPlayerType(playerManager, PlayerType.PLAYER_KEEPER_B)

    return isKeeper and (item.m_tags & ItemConfig.TAG_NO_KEEPER) ~= 0
end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param item Component.ItemConfig.Item
---@return boolean
local function NoLostBrBlock(playerManager, ctx, item)
    local lostBr = IPlayerManager.AnyoneHasBirthright(playerManager, ctx, PlayerType.PLAYER_THELOST)

    return lostBr and (item.m_tags & ItemConfig.TAG_NO_LOST_BR) ~= 0
end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param item Component.ItemConfig.Item
---@return boolean
local function LostB_BlockItem(playerManager, ctx, item)
    local isCollectible = IItemConfig_Item.IsCollectible(item)
    if not isCollectible then
        return false
    end

    local lostB = IPlayerManager.AnyoneIsPlayerType(playerManager, PlayerType.PLAYER_THELOST_B)
    if not lostB then
        return false
    end

    if (item.m_tags & ItemConfig.TAG_OFFENSIVE) ~= 0 then
        return false
    end

    -- better items
    if item.m_quality < 2 then
        local startSeed = ctx.game.m_seeds.m_startSeed
        local idOffset = isCollectible and 0 or 1000
        local seedOffset = idOffset + startSeed

        if item.m_id + seedOffset == 0 then
            seedOffset = 1
        end

        local uniqueSeed = item.m_id + seedOffset
        local rng = RNG(uniqueSeed, 18)

        if rng:RandomInt(5) == 0 then
            return true
        end
    end

    return false
end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param item Component.ItemConfig.Item
---@return boolean
local function SacredOrb_BlockItem(playerManager, ctx, item)
    local isCollectible = IItemConfig_Item.IsCollectible(item)
    if not isCollectible then
        return false
    end

    local sacredOrb = IPlayerManager.AnyoneHasCollectible(playerManager, ctx, CollectibleType.COLLECTIBLE_SACRED_ORB)
    if not sacredOrb then
        return false
    end

    local quality = item.m_quality
    if quality < 2 then
        return false
    end

    if quality == 2 then
        local startSeed = ctx.game.m_seeds.m_startSeed
        local idOffset = isCollectible and 0 or 1000
        local seedOffset = idOffset + startSeed

        if item.m_id + seedOffset == 0 then
            seedOffset = 1
        end

        local uniqueSeed = item.m_id + seedOffset
        local rng = RNG(uniqueSeed, 19)

        if rng:RandomInt(3) == 0 then
            return true
        end
    end

    return false
end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param item Component.ItemConfig.Item
---@return boolean
local function No_BlockItem(playerManager, ctx, item)
    local isCollectible = IItemConfig_Item.IsCollectible(item)
    if not isCollectible then
        return false
    end

    local goldNo = IPlayerManager.GetTrinketMultiplier(playerManager, ctx, TrinketType.TRINKET_NO) >= 2
    if goldNo and item.m_quality == 0 then
        return true
    end

    return false
end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param item Component.ItemConfig.Item
---@return boolean
local function BlockItem(playerManager, ctx, item)
    return NoKeeperBlock(playerManager, item)
        or NoLostBrBlock(playerManager, ctx, item)
        or LostB_BlockItem(playerManager, ctx, item)
        or SacredOrb_BlockItem(playerManager, ctx, item)
        or No_BlockItem(playerManager, ctx, item)
end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param card Component.ItemConfig.Card
---@return boolean
local function BlockCard(playerManager, ctx, card)
    local jacob = IPlayerManager.AnyoneIsPlayerType(playerManager, PlayerType.PLAYER_JACOB)
    if jacob then
        return card.m_id == Card.CARD_SUICIDE_KING
    end

    return false
end

---@class PlayerEffects.BlockItem
local Module = {}

--#region Module

Module.BlockItem = BlockItem
Module.BlockCard = BlockCard

--#endregion

return Module