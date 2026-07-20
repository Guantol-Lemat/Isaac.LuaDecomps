--#region Dependencies

local IItemConfig = require("Isaac.Interface.ItemConfig")
local GameEffects = require("Isaac.Interface.Custom.GameEffects")
local Log = require("General.Log")

local IItemConfig_Item = IItemConfig.Item

--#endregion

---@param itemPool Component.ItemPool
---@param ctx Context.Common
local function ResetTrinkets(itemPool, ctx)
    local itemConfig = ctx.manager.m_itemConfig
    local trinkets = itemPool.m_trinketPoolItems

    for i = 1, #trinkets, 1 do
        local trinket = trinkets[i]
        local id = i - 1

        trinket.m_inPool = false
        trinket.m_isAvailable = false
        trinket.m_ID = id

        local config = IItemConfig.GetTrinket(itemConfig, id)
        local obtainableTrinket = config ~= nil
            and config.m_id ~= TrinketType.TRINKET_PERFECTION
            and not GameEffects.BlockTrinket(ctx.game, config)

        if obtainableTrinket then
            ---@cast config Component.ItemConfig.Item
            trinket.m_inPool = true
            trinket.m_isAvailable = IItemConfig_Item.IsAvailable(config, ctx, false)
        end
    end

    local availableTrinkets = 0
    for i = 1, #trinkets, 1 do
        local trinket = trinkets[i]
        if trinket.m_inPool and trinket.m_isAvailable then
            availableTrinkets = availableTrinkets + 1
        end
    end

    itemPool.m_numAvailableTrinkets = availableTrinkets
    if availableTrinkets <= 0 then
        Log.LogMessage(3, "[warn] trinket pool is empty from the start\n")
    end
end

---@class Gameplay.ItemPool.TrinketPool
local Module = {}

--#region Module

Module.ResetTrinkets = ResetTrinkets

--#endregion

return Module