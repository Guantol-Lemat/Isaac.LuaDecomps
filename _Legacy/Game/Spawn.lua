---@class GameSpawnLogic
local Module = {}

---@class RoomContext.SpawnGridEntity

---@param myContext Context.Common
---@param game Component.Game
---@param entityType EntityType | integer
---@param variant integer
---@param subtype integer
---@param seed integer
---@param position Vector
---@param velocity Vector
---@param spawner Component.Entity?
---@return Component.Entity
local function Spawn(myContext, game, entityType, variant, subtype, seed, position, velocity, spawner)
end

---@param myContext Context.Common
---@param room Component.Room
---@param gridIdx integer
---@param gridType GridEntityType | integer
---@param variant integer
---@param seed integer
---@param varData integer
---@return Component.GridEntity
local function SpawnGridEntity(myContext, room, gridIdx, gridType, variant, seed, varData)
end

--#region Module

Module.Spawn = Spawn
Module.SpawnGridEntity = SpawnGridEntity

--#endregion

return Module