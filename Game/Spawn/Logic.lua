---@class GameSpawnLogic
local Module = {}

---@class RoomContext.SpawnGridEntity

---@param myContext GameContext.Spawn
---@param entityType EntityType | integer
---@param variant integer
---@param subtype integer
---@param seed integer
---@param position Vector
---@param velocity Vector
---@param spawner EntityComponent?
---@return EntityComponent
local function Spawn(myContext, entityType, variant, subtype, seed, position, velocity, spawner)
end

---@param myContext RoomContext.SpawnGridEntity
---@param gridIdx integer
---@param gridType GridEntityType | integer
---@param variant integer
---@param seed integer
---@param varData integer
---@return GridEntityComponent
local function SpawnGridEntity(myContext, gridIdx, gridType, variant, seed, varData)
end

--#region Module

Module.Spawn = Spawn
Module.SpawnGridEntity = SpawnGridEntity

--#endregion

return Module