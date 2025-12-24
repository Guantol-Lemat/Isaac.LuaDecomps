---@class EntityConfigComponent
---@field m_map table<integer, EntityConfig.EntityComponent?>

---@class EntityConfig.EntityComponent
---@field id integer
---@field variant integer
---@field subtype integer
---@field name string
---@field shadowSize number
---@field collisionDamage number
---@field isBoss boolean
---@field bossID integer
---@field isChampion boolean
---@field collisionRadius number
---@field collisionRadiusMulti Vector
---@field mass number
---@field gridCollisionPoints integer
---@field friction number
---@field baseHP number
---@field stageHP number
---@field canShutDoors boolean
---@field gibsAmount integer
---@field gibFlags integer
---@field portrait integer
---@field bossColors EntityConfig.BossColorComponent[]
---@field anm2Path string
---@field preload EntityConfig.PreloadComponent[]
---@field sfx integer[]
---@field devolve EntityConfig.DevolveComponent[]
---@field preloadDone boolean
---@field gridCollisionClass string
---@field rerollable boolean
---@field hasFloorAlts boolean
---@field collisionInterval integer
---@field shieldStrength number
---@field shieldFrames number
---@field inBestiary boolean
---@field bestiaryEntry EntityConfig.BestiaryComponent
---@field modEntry ModEntryComponent?
---@field hasPortrait boolean

---@class EntityConfig.BossColorComponent

---@class EntityConfig.PreloadComponent

---@class EntityConfig.DevolveComponent

---@class EntityConfig.BestiaryComponent