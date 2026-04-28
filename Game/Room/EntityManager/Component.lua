---@class EntityManagerComponent
---@field m_mainEL Component.EL
---@field m_persistentEL Component.EL
---@field m_updateEL Component.EL
---@field m_renderEL Component.EL
---@field m_effectEL Component.EL
---@field m_bufferEL Component.EL
---@field m_bufferTemplateEL Component.EL
---@field m_wispCache Component.EL -- Used as a quick cache for wisps
---@field m_queryCache table<EntityClassificator, Component.EL>
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

---@alias Component.EL EntityComponent[]

local Module = {}

--#region Module



--#endregion

return Module