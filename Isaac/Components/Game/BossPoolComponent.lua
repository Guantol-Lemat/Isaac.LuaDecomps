---@class Component.BossPool
---@field m_pools Component.BossPool.Pool[] [37] : 0x0
---@field m_removedBosses boolean[] : 0x8ac
---@field m_levelBlacklist boolean[] : 0x8bc

---@class Component.BossPool.Pool
---@field m_name string : 0x0
---@field m_bosses Component.BossPool.Pool.Boss[] : 0x18
---@field m_totalWeight number : 0x24
---@field m_rng RNG : 0x28
---@field m_doubleTroubleRoomVariantStart integer : 0x38

---@class Component.BossPool.Pool.Boss
---@field m_id BossType | integer : 0x0
---@field m_initialWeight number : 0x4
---@field m_weight number : 0x8
---@field m_achievementID Achievement | integer : 0xc
---@field m_roomVariantStart integer : 0x10
