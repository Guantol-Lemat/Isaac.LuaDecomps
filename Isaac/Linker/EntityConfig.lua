---@class Interface.EntityConfig
local Interface = require("Isaac.Interface.EntityConfig")

--#region Stub

local Stub = {}

---@param entityConfig Component.EntityConfig
---@return Component.EntityConfig.PokeyMansPoolEntry[]
function Stub.GetPokeyMansPool(entityConfig) end

---@param entityConfig Component.EntityConfig
function Stub.destructor(entityConfig) end

---@param entityConfig Component.EntityConfig
---@param param_1 Component.EntityConfig.Entity[]
---@param param_2 EntityType | integer
---@return Component.EntityConfig.Entity[]
function Stub.GetEntityVariants(entityConfig, param_1, param_2) end

---@param entityConfig Component.EntityConfig
---@param id EntityType | integer
---@param variant integer
---@param subtype integer
---@return Component.EntityConfig.Entity
function Stub.GetEntity(entityConfig, id, variant, subtype) end

---@param entityConfig Component.EntityConfig
---@param type EntityType | integer
---@param var integer
---@return Component.EntityConfig.Bestiary
function Stub.GetBestiaryConfig(entityConfig, type, var) end

---@param ctx Context.Common
---@param entityConfig Component.EntityConfig
---@param xmlpath string
---@param modentry Component.ModEntry
function Stub.Load(ctx, entityConfig, xmlpath, modentry) end

---@param ctx Context.Common
---@param entityConfig Component.EntityConfig
---@param xmlpath string
---@param modentry Component.ModEntry
function Stub.Load(ctx, entityConfig, xmlpath, modentry) end

---@param path string
function Stub.LoadBossColors(path) end

---@param entityConfig Component.EntityConfig
---@param xmlpath string
---@param modentry Component.ModEntry
function Stub.LoadPlayers(entityConfig, xmlpath, modentry) end

---@param ctx Context.Common
---@param entityConfig Component.EntityConfig
---@param config Component.EntityConfig.Entity
function Stub.Preload(ctx, entityConfig, config) end

---@param entityConfig Component.EntityConfig
---@return unknown
function Stub.Unload(entityConfig) end

---@param entityConfig Component.EntityConfig
---@param id PlayerType | integer
---@return Component.EntityConfig.Player?
function Stub.GetPlayer(entityConfig, id) end

---@param entityConfig Component.EntityConfig
---@param xmlpath string
function Stub.LoadBabies(entityConfig, xmlpath) end

---@param entityConfig Component.EntityConfig
---@param filepath string
function Stub.LoadBosses(entityConfig, filepath) end

---@param entityConfig Component.EntityConfig
---@param bossID BossType | integer
---@return Component.EntityConfig.Boss
function Stub.GetBoss(entityConfig, bossID) end

---@param ctx Context.Common
---@param entityConfig Component.EntityConfig
function Stub.PostLoadMods(ctx, entityConfig) end

--#endregion

Interface.GetPokeyMansPool = Stub.GetPokeyMansPool
Interface.destructor = Stub.destructor
Interface.GetEntityVariants = Stub.GetEntityVariants
Interface.GetEntity = Stub.GetEntity
Interface.GetBestiaryConfig = Stub.GetBestiaryConfig
Interface.Load = Stub.Load
Interface.Load = Stub.Load
Interface.LoadBossColors = Stub.LoadBossColors
Interface.LoadPlayers = Stub.LoadPlayers
Interface.Preload = Stub.Preload
Interface.Unload = Stub.Unload
Interface.GetPlayer = Stub.GetPlayer
Interface.LoadBabies = Stub.LoadBabies
Interface.LoadBosses = Stub.LoadBosses
Interface.GetBoss = Stub.GetBoss
Interface.PostLoadMods = Stub.PostLoadMods