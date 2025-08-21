---@class SpawnCommands
local Module = {}

---@class EntitySpawnCommand
---@field entityType EntityType | integer
---@field variant integer
---@field subtype integer
---@field seed integer
---@field position Vector
---@field velocity Vector
---@field spawner EntityComponent?
---@field PostSpawn fun(entity: EntityComponent) | nil

---@class GridEntitySpawnCommand
---@field gridIdx integer
---@field type GridEntityType | integer
---@field variant integer
---@field seed integer
---@field varData integer

---@class OutputSpawnCommand
---@field variant integer
---@field position Vector

---@class RailSpawnCommand
---@field gridIdx integer
---@field variant StbRailVariant

---@param type EntityType | integer
---@param variant integer
---@param subtype integer
---@param seed integer
---@param position Vector
---@param velocity Vector
---@param spawner EntityComponent?
---@param PostSpawn fun(entity: EntityComponent) | nil
---@return EntitySpawnCommand
local function CreateEntity(type, variant, subtype, seed, position, velocity, spawner, PostSpawn)
    return {type = type, variant = variant, subtype = subtype, seed = seed, position = position, velocity = velocity, spawner = spawner, PostSpawn = PostSpawn}
end

---@param gridIdx integer
---@param type GridEntityType | integer
---@param variant integer
---@param seed integer
---@param varData integer
---@return GridEntitySpawnCommand
local function CreateGridEntity(gridIdx, type, variant, seed, varData)
    return {gridIdx = gridIdx, type = type, variant = variant, seed = seed, varData = varData}
end

---@param variant integer
---@param position Vector
---@return OutputSpawnCommand
local function CreateOutput(variant, position)
    return {variant = variant, position = position}
end

---@param gridIdx integer
---@param variant StbRailVariant
---@return RailSpawnCommand
local function CreateRail(gridIdx, variant)
    return {gridIdx = gridIdx, variant = variant}
end

--#region Module

Module.CreateEntity = CreateEntity
Module.CreateGridEntity = CreateGridEntity
Module.CreateOutput = CreateOutput
Module.CreateRail = CreateRail

--#endregion

return Module