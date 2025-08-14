---@param spawnCommands SpawnCommands
---@param type EntityType | integer
---@param variant integer
---@param subtype integer
---@param seed integer
---@param position Vector
---@param velocity Vector
---@param spawner Entity?
---@param PostSpawn fun(entity: EntityComponent) | nil
local function SpawnEntity(spawnCommands, type, variant, subtype, seed, position, velocity, spawner, PostSpawn)
    table.insert(spawnCommands.entities, {type = type, variant = variant, subtype = subtype, seed = seed, position = position, velocity = velocity, spawner = spawner, PostSpawn = PostSpawn})
end

---@param spawnCommands SpawnCommands
---@param gridIdx integer
---@param type GridEntityType | integer
---@param variant integer
---@param seed integer
---@param varData integer
local function SpawnGridEntity(spawnCommands, gridIdx, type, variant, seed, varData)
    table.insert(spawnCommands.gridEntities, {gridIdx = gridIdx, type = type, variant = variant, seed = seed, varData = varData})
end

---@param spawnCommands SpawnCommands
---@param variant integer
---@param position Vector
local function AddOutput(spawnCommands, variant, position)
    table.insert(spawnCommands.outputs, {variant = variant, position = position})
end

---@param spawnCommands SpawnCommands
---@param gridIdx integer
---@param variant StbRailVariant
local function SetRail(spawnCommands, gridIdx, variant)
    table.insert(spawnCommands.rails, {gridIdx = gridIdx, variant = variant})
end