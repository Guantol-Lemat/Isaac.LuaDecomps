---@class EntityManagerComponent
---@field m_mainEL ELComponent
---@field m_persistentEL ELComponent
---@field m_updateEL ELComponent
---@field m_renderEL ELComponent
---@field m_effectEL ELComponent
---@field m_bufferEL ELComponent
---@field m_bufferTemplateEL ELComponent
---@field m_wispCache ELComponent -- Used as a quick cache for wisps
---@field m_queryCache table<EntityClassificator, ELComponent>
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

---@class ELComponent
---@field data EntityComponent[]
---@field size integer
---@field capacity integer
---@field isSublist boolean

local Module = {}

--#region Module



--#endregion

return Module