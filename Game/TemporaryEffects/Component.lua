---@class TemporaryEffectsComponent
---@field m_cacheFlags CacheFlag | integer : 0x0
---@field m_effects TemporaryEffectComponent[] : 0x4
---@field m_shouldEvaluateCache_qqq boolean : 0x10
---@field m_disabled boolean : 0x11
---@field m_player EntityPlayerComponent : 0x14

---@class TemporaryEffectComponent
---@field m_item ItemConfigItemComponent : 0x0
---@field m_count integer : 0x4
---@field m_cooldown integer : 0x8

---@param itemConfig ItemConfigItemComponent
---@return TemporaryEffectComponent
local function NewTemporaryEffect(itemConfig)
    ---@type TemporaryEffectComponent
    return {
        m_item = itemConfig,
        m_count = 0,
        m_cooldown = itemConfig.m_maxCooldown,
    }
end

---@param effect TemporaryEffectComponent
---@return TemporaryEffectComponent
local function CopyTemporaryEffect(effect)
    ---@type TemporaryEffectComponent
    return {
        m_item = effect.m_item,
        m_count = effect.m_count,
        m_cooldown = effect.m_cooldown,
    }
end

local Module = {}

--#region Module

Module.NewTemporaryEffect = NewTemporaryEffect
Module.CopyTemporaryEffect = CopyTemporaryEffect

--#endregion

return Module