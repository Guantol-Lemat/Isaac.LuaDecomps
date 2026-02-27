--#region Dependencies

local TemporaryEffectsFactory = require("Game.TemporaryEffects.Component")
local PlayerCostume = require("Entity.Player.Costume")
local ItemConfigUtils = require("Isaac.ItemConfig.Utils")

--#endregion

local Module = {}

---@param temporaryEffects TemporaryEffectsComponent
---@param collectible CollectibleType | integer
---@return TemporaryEffectComponent?
local function GetCollectibleEffect(temporaryEffects, collectible)
    if temporaryEffects.m_disabled then
        return nil
    end

    local effects = temporaryEffects.m_effects
    for i = 1, #effects, 1 do
        local effect = effects[i]
        local itemConfig = effect.m_item
        local itemType = itemConfig.m_itemType
        if itemConfig.m_id == collectible and (itemType == ItemType.ITEM_PASSIVE or itemType == ItemType.ITEM_ACTIVE or itemType == ItemType.ITEM_FAMILIAR) then
            return effect
        end
    end

    return nil
end

---@param temporaryEffects TemporaryEffectsComponent
---@param trinket TrinketType | integer
---@return TemporaryEffectComponent?
local function GetTrinketEffect(temporaryEffects, trinket)
    if temporaryEffects.m_disabled then
        return nil
    end

    local effects = temporaryEffects.m_effects
    for i = 1, #effects, 1 do
        local effect = effects[i]
        local itemConfig = effect.m_item
        if itemConfig.m_id == trinket and itemConfig.m_itemType == ItemType.ITEM_TRINKET then
            return effect
        end
    end

    return nil
end

---@param temporaryEffects TemporaryEffectsComponent
---@param nullItem NullItemID | integer
---@return TemporaryEffectComponent?
local function GetNullEffect(temporaryEffects, nullItem)
    if temporaryEffects.m_disabled then
        return nil
    end

    local effects = temporaryEffects.m_effects
    for i = 1, #effects, 1 do
        local effect = effects[i]
        local itemConfig = effect.m_item
        if itemConfig.m_id == nullItem and itemConfig.m_itemType == ItemType.ITEM_NULL then
            return effect
        end
    end

    return nil
end

---@param temporaryEffects TemporaryEffectsComponent
---@param collectible CollectibleType | integer
---@return boolean
local function HasCollectibleEffect(temporaryEffects, collectible)
    return GetCollectibleEffect(temporaryEffects, collectible) ~= nil
end

---@param temporaryEffects TemporaryEffectsComponent
---@param trinket TrinketType | integer
---@return boolean
local function HasTrinketEffect(temporaryEffects, trinket)
    return GetTrinketEffect(temporaryEffects, trinket) ~= nil
end

---@param temporaryEffects TemporaryEffectsComponent
---@param nullItem NullItemID | integer
---@return boolean
local function HasNullEffect(temporaryEffects, nullItem)
    return GetNullEffect(temporaryEffects, nullItem) ~= nil
end

---@param myContext Context.Common
---@param temporaryEffects TemporaryEffectsComponent
---@param effect TemporaryEffectComponent
---@param addCostume boolean
---@param count integer
local function AddEffect(myContext, temporaryEffects, effect, addCostume, count)
    if temporaryEffects.m_disabled or count == 0 then
        return
    end

    local effects = temporaryEffects.m_effects
    for i = 1, #effects, 1 do
        local myEffect = effects[i]
        if myEffect.m_item == effect.m_item then
            myEffect.m_count = myEffect.m_count + count
            myEffect.m_cooldown = myEffect.m_cooldown + effect.m_cooldown
            temporaryEffects.m_cacheFlags = temporaryEffects.m_cacheFlags | effect.m_item.m_cacheFlags
            temporaryEffects.m_shouldEvaluateCache_qqq = true
            return
        end
    end

    -- not already in list
    table.insert(effects, TemporaryEffectsFactory.CopyTemporaryEffect(effect))
    local myEffect = effects[#effects]
    myEffect.m_count = count

    if temporaryEffects.m_player and addCostume then
        PlayerCostume.AddCostume(myContext, temporaryEffects.m_player, effect.m_item, false)
    end

    temporaryEffects.m_cacheFlags = temporaryEffects.m_cacheFlags | effect.m_item.m_cacheFlags
    temporaryEffects.m_shouldEvaluateCache_qqq = true
end

---@param myContext Context.Common
---@param temporaryEffects TemporaryEffectsComponent
---@param collectibleId CollectibleType | integer
---@param addCostume boolean
---@param count integer
local function AddCollectibleEffect(myContext, temporaryEffects, collectibleId, addCostume, count)
    local itemConfig = myContext.manager.m_itemConfig
    local config = ItemConfigUtils.GetCollectible(myContext, itemConfig, collectibleId)
    ---@cast config ItemConfigItemComponent
    local effect = TemporaryEffectsFactory.NewTemporaryEffect(config)
    AddEffect(myContext, temporaryEffects, effect, addCostume, count)
end

--#region Module

Module.AddEffect = AddEffect
Module.AddCollectibleEffect = AddCollectibleEffect
Module.GetCollectibleEffect = GetCollectibleEffect
Module.GetTrinketEffect = GetTrinketEffect
Module.GetNullEffect = GetNullEffect
Module.HasCollectibleEffect = HasCollectibleEffect
Module.HasTrinketEffect = HasTrinketEffect
Module.HasNullEffect = HasNullEffect

--#endregion

return Module