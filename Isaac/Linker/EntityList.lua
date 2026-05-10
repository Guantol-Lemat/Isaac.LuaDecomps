---@class Interface.EntityList
local Interface = require("Isaac.Interface.EntityList")

--#region Stub

local Stub = {}

---@param ctx Context.Common
---@return Component.EntityList
function Stub.Constructor(ctx) end

---@param entityList Component.EntityList
function Stub.destructor(entityList) end

---@param ctx Context.Common
---@param entityList Component.EntityList
function Stub.Reset(ctx, entityList) end

---@param entityList Component.EntityList
---@param Entity Component.Entity
function Stub.Add(entityList, Entity) end

---@param entityList Component.EntityList
---@param Entity Component.Entity
function Stub.CountEntity(entityList, Entity) end

---@param ctx Context.Common
---@param entityList Component.EntityList
---@param isTransition boolean
function Stub.Update(ctx, entityList, isTransition) end

---@param ctx Context.Common
---@param entityList Component.EntityList
function Stub.rendersort(ctx, entityList) end

---@param ctx Context.Common
---@param entityList Component.EntityList
---@param zOffset integer
---@param renderOffset Vector
function Stub.RenderSlice(ctx, entityList, zOffset, renderOffset) end

---@param ctx Context.Common
---@param entityList Component.EntityList
---@param offset Vector
function Stub.RenderShadows(ctx, entityList, offset) end

---@param ctx Context.Common
---@param entityList Component.EntityList
function Stub.collide(ctx, entityList) end

---@param ctx Context.Common
---@param entityList Component.EntityList
---@param Position Vector
---@param Radius number
---@param Partitions EntityPartition | integer
---@return Component.EntityList.EL
function Stub.QueryRadius(ctx, entityList, Position, Radius, Partitions) end

---@param ctx Context.Common
---@param entityList Component.EntityList
---@param capsule Component.Capsule
---@param Partitions EntityPartition | integer
---@return Component.EntityList.EL
function Stub.QueryCapsule(ctx, entityList, capsule, Partitions) end

---@param entityList Component.EntityList
---@param Type EntityType | integer
---@param Variant integer
---@param Subtype integer
---@param Cache boolean
---@param ignoreFriendly boolean
---@return Component.EntityList.EL
function Stub.QueryType(entityList, Type, Variant, Subtype, Cache, ignoreFriendly) end

---@param entityList Component.EntityList
---@param entity Component.Entity
function Stub.MakePersistent(entityList, entity) end

---@param entityList Component.EntityList
---@param type EntityType | integer
---@param var integer
---@param subtype integer
function Stub.RemoveFromQueryCache(entityList, type, var, subtype) end

---@param entityList Component.EntityList
---@param type EntityType | integer
---@param variant integer
---@param subtype integer
---@return integer
function Stub.CountType(entityList, type, variant, subtype) end

---@param entityList Component.EntityList
---@param subtype CollectibleType | integer
---@return integer
function Stub.CountWisps(entityList, subtype) end

---@param entityList Component.EntityList
---@param spawner Component.Entity
---@param type EntityType | integer
---@param variant integer
---@param subtype integer
---@return integer
function Stub.CountSpawned(entityList, spawner, type, variant, subtype) end

---@param entityList Component.EntityList
---@return integer
function Stub.GetAliveEnemiesCount(entityList) end

---@param entityList Component.EntityList
function Stub.DiscountEntity(entityList) end

--endregion

Interface.Constructor = Stub.Constructor
Interface.destructor = Stub.destructor
Interface.Reset = Stub.Reset
Interface.Add = Stub.Add
Interface.CountEntity = Stub.CountEntity
Interface.Update = Stub.Update
Interface.rendersort = Stub.rendersort
Interface.RenderSlice = Stub.RenderSlice
Interface.RenderShadows = Stub.RenderShadows
Interface.collide = Stub.collide
Interface.QueryRadius = Stub.QueryRadius
Interface.QueryCapsule = Stub.QueryCapsule
Interface.QueryType = Stub.QueryType
Interface.MakePersistent = Stub.MakePersistent
Interface.RemoveFromQueryCache = Stub.RemoveFromQueryCache
Interface.CountType = Stub.CountType
Interface.CountWisps = Stub.CountWisps
Interface.CountSpawned = Stub.CountSpawned
Interface.GetAliveEnemiesCount = Stub.GetAliveEnemiesCount
Interface.DiscountEntity = Stub.DiscountEntity