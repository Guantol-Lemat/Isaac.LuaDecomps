---@class Decomp.SpawnCommandsUtil
local SpawnCommandsUtil = {}

---@class Decomp.SpawnCommands
---@field entities Decomp.EntitySpawnCommand[]
---@field gridEntities Decomp.GridEntitySpawnCommand[]
---@field outputs Decomp.OutputSpawnCommand[]
---@field rails Decomp.RailSpawnCommand[]

---@class Decomp.EntitySpawnCommand
---@field entityType EntityType | integer
---@field variant integer
---@field subtype integer
---@field seed integer
---@field position Vector
---@field velocity Vector
---@field spawner Entity?
---@field PostSpawn fun(entity: Decomp.EntityObject) | nil

---@class Decomp.GridEntitySpawnCommand
---@field gridIdx integer
---@field type GridEntityType | integer
---@field variant integer
---@field seed integer
---@field varData integer

---@class Decomp.OutputSpawnCommand
---@field variant integer
---@field position Vector

---@class Decomp.RailSpawnCommand
---@field gridIdx integer
---@field variant StbRailVariant

---@param spawnCommands Decomp.SpawnCommands
local function Init(spawnCommands)
    spawnCommands.entities = {}
    spawnCommands.gridEntities = {}
    spawnCommands.outputs = {}
    spawnCommands.rails = {}
end

---@return Decomp.SpawnCommands
local function Create()
    local spawnCommands = {}
    Init(spawnCommands)
    return spawnCommands
end

---@param spawnCommands Decomp.SpawnCommands
---@param type EntityType | integer
---@param variant integer
---@param subtype integer
---@param seed integer
---@param position Vector
---@param velocity Vector
---@param spawner Entity?
---@param PostSpawn fun(entity: Decomp.EntityObject) | nil
local function SpawnEntity(spawnCommands, type, variant, subtype, seed, position, velocity, spawner, PostSpawn)
    table.insert(spawnCommands.entities, {type = type, variant = variant, subtype = subtype, seed = seed, position = position, velocity = velocity, spawner = spawner, PostSpawn = PostSpawn})
end

---@param spawnCommands Decomp.SpawnCommands
---@param gridIdx integer
---@param type GridEntityType | integer
---@param variant integer
---@param seed integer
---@param varData integer
local function SpawnGridEntity(spawnCommands, gridIdx, type, variant, seed, varData)
    table.insert(spawnCommands.gridEntities, {gridIdx = gridIdx, type = type, variant = variant, seed = seed, varData = varData})
end

---@param spawnCommands Decomp.SpawnCommands
---@param variant integer
---@param position Vector
local function AddOutput(spawnCommands, variant, position)
    table.insert(spawnCommands.outputs, {variant = variant, position = position})
end

---@param spawnCommands Decomp.SpawnCommands
---@param gridIdx integer
---@param variant StbRailVariant
local function SetRail(spawnCommands, gridIdx, variant)
    table.insert(spawnCommands.rails, {gridIdx = gridIdx, variant = variant})
end

---@param spawnCommands Decomp.SpawnCommands
---@return Decomp.EntitySpawnCommand[]
local function GetEntitiesSpawnCommands(spawnCommands)
    return spawnCommands.entities
end

---@param spawnCommands Decomp.SpawnCommands
---@return Decomp.GridEntitySpawnCommand[]
local function GetGridEntitiesSpawnCommands(spawnCommands)
    return spawnCommands.gridEntities
end

--#region Module

SpawnCommandsUtil.Create = Create
SpawnCommandsUtil.Init = Init
SpawnCommandsUtil.SpawnEntity = SpawnEntity
SpawnCommandsUtil.SpawnGridEntity = SpawnGridEntity
SpawnCommandsUtil.AddOutput = AddOutput
SpawnCommandsUtil.SetRail = SetRail
SpawnCommandsUtil.GetEntitiesSpawnCommands = GetEntitiesSpawnCommands
SpawnCommandsUtil.GetGridEntitiesSpawnCommands = GetGridEntitiesSpawnCommands

--#endregion

return SpawnCommandsUtil