--#region Dependencies

local IManager = require("Isaac.Interface.Manager")
local IItemConfig = require("Isaac.Interface.ItemConfig")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")

--#endregion

local SOUND_WISP_SPAWN = SoundEffect.SOUND_CANDLE_LIGHT

---@param player Component.Entity.Player
---@param ctx Context.Common
---@param beggar Component.Entity.Slot
local function BethsEssence_OnBeggarPay(player, ctx, beggar)
    if not IEntityPlayer.HasTrinket(ctx, player, TrinketType.TRINKET_BETHS_ESSENCE, false) then
        return
    end

    local rng = IEntityPlayer.GetTrinketRNG(player, TrinketType.TRINKET_BETHS_ESSENCE)
    local triggered = rng:RandomInt(4) == 0

    if not triggered then
        return
    end

    local itemConfig = ctx.manager.m_itemConfig
    local collectibles = itemConfig.m_collectibleList
    local collectible = rng:RandomInt(#collectibles - 1) + 1

    local collectibleConfig = IItemConfig.GetCollectible(itemConfig, ctx, collectible)
    local isValidWisp = collectibleConfig
        and IItemConfig.IsValidCollectible(ctx, collectible)
        and collectibleConfig.m_itemType == ItemType.ITEM_ACTIVE
        and collectibleConfig.m_wispConfig
        and collectibleConfig.m_wispConfig.m_count > 0

    if not isValidWisp then
        collectibleConfig = IItemConfig.GetCollectible(itemConfig, ctx, CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)
    end

    ---@cast collectibleConfig Component.ItemConfig.Item
    IEntityPlayer.AddWisp(ctx, player, collectibleConfig.m_id, beggar.m_position, true, false)
    IManager.PlaySound(ctx, SOUND_WISP_SPAWN, 1.0, 2, false, 1.0)
end

---@class PlayerEffects.WispAdd
local Module = {}

--#region Module

Module.BethsEssence_OnBeggarPay = BethsEssence_OnBeggarPay

--#endregion

return Module