--#region Dependencies



--#endregion

---@class TemporaryEffectsUtils
local Module = {}

---@param temporaryEffects TemporaryEffectsComponent
---@param collectible CollectibleType | integer
---@return boolean
local function HasCollectibleEffect(temporaryEffects, collectible)
    if temporaryEffects.m_disabled then
        return false
    end

    local effects = temporaryEffects.m_effects
    for i = 1, #effects, 1 do
        local itemEffect = effects[i].m_item
        local itemType = itemEffect.m_itemType
        if itemEffect.m_id == collectible and (itemType == ItemType.ITEM_PASSIVE or itemType == ItemType.ITEM_ACTIVE or itemType == ItemType.ITEM_FAMILIAR) then
            return true
        end
    end

    return false
end

---@param temporaryEffects TemporaryEffectsComponent
---@param trinket TrinketType | integer
---@return boolean
local function HasTrinketEffect(temporaryEffects, trinket)
    if temporaryEffects.m_disabled then
        return false
    end

    local effects = temporaryEffects.m_effects
    for i = 1, #effects, 1 do
        local itemEffect = effects[i].m_item
        local itemType = itemEffect.m_itemType
        if itemEffect.m_id == trinket and itemType == ItemType.ITEM_TRINKET then
            return true
        end
    end

    return false
end

---@param temporaryEffects TemporaryEffectsComponent
---@param nullItem NullItemID | integer
---@return boolean
local function HasNullEffect(temporaryEffects, nullItem)
    if temporaryEffects.m_disabled then
        return false
    end

    local effects = temporaryEffects.m_effects
    for i = 1, #effects, 1 do
        local itemEffect = effects[i].m_item
        if itemEffect.m_id == nullItem and itemEffect.m_itemType == ItemType.ITEM_NULL then
            return true
        end
    end

    return false
end

--#region Module

Module.HasCollectibleEffect = HasCollectibleEffect
Module.HasTrinketEffect = HasTrinketEffect
Module.HasNullEffect = HasNullEffect

--#endregion

return Module