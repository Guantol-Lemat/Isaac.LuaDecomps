---@class Component.EntityList
---@field m_mainEL Component.EntityList.EL
---@field m_persistentEL Component.EntityList.EL
---@field m_updateEL Component.EntityList.EL
---@field m_renderEL Component.EntityList.EL
---@field m_effectEL Component.EntityList.EL
---@field m_bufferEL Component.EntityList.EL
---@field m_bufferTemplateEL Component.EntityList.EL
---@field m_wispCache Component.EntityList.EL -- Used as a quick cache for wisps
---@field m_queryCache table<EntityClassificator, Component.EntityList.EL>
---@field m_addedEnemies integer -- number of enemies added this frame
---@field m_aliveEnemyCount integer
---@field m_addedBosses integer -- number of bosses added this frame
---@field m_aliveBossCount integer
---@field m_maxBossBarHealth number
---@field m_enemyDamageInflicted number
---@field m_entityBaited boolean

---@class EntityClassificator
---@field type EntityType | integer
---@field variant integer
---@field subType integer

---@alias Component.EntityList.EL Component.Entity[]

local Module = {}

--#region Module



--#endregion

return Module