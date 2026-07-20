---@class Component.ItemPool
---@field m_seed integer : 0x0
---@field m_pools Component.ItemPool.Pool[] [31] : 0x4
---@field m_lastPool ItemPoolType | integer : 0x650
---@field m_rng RNG : 0x654
---@field m_trinketPoolRNG RNG : 0x664
---@field m_unusedSpecialItemChance1 number : 0x674
---@field m_unusedSpecialItemChance2 number : 0x678
---@field m_removedCollectibles boolean[] : 0x67c
---@field m_blacklistedCollectibles boolean[] : 0x68c
---@field m_trinketPoolItems Component.ItemPool.TrinketPoolItem[] : 0x78c
---@field m_numAvailableTrinkets integer : 0x798
---@field m_pillEffects integer[] [15] : 0x79c
---@field m_identifiedPillEffects boolean[] [15] : 0x7d8
---@field m_genesisItems integer[] [31] : 0x7e8

---@class Component.ItemPool.Pool
---@field m_totalWeight number : 0x0
---@field m_itemList Component.ItemPool.PoolItem[] : 0x4
---@field m_rng1 RNG : 0x10
---@field m_rng2 RNG : 0x20
---@field m_bibleUpgrade integer : 0x30

---@class Component.ItemPool.PoolItem
---@field m_itemID integer : 0x0
---@field m_initialWeight number : 0x4
---@field m_weight number : 0x8
---@field m_decreaseBy number : 0xc
---@field m_removeOn number : 0x10
---@field m_isUnlocked boolean : 0x14
---@field m_isSpecial boolean : 0x15

---@class Component.ItemPool.TrinketPoolItem
---@field m_ID TrinketType | integer : 0x0
---@field m_inPool boolean : 0x4
---@field m_isAvailable boolean : 0x5

---@return Component.ItemPool.TrinketPoolItem
local function TrinketPoolItem_New()
    ---@type Component.ItemPool.TrinketPoolItem
    return {
        m_ID = 0,
        m_inPool = false,
        m_isAvailable = false
    }
end

---@class Module.ItemPoolComponent
local Module = {}

--#region Module

Module.TrinketPoolItem_New = TrinketPoolItem_New

--#endregion

return Module