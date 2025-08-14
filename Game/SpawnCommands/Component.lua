---@class SpawnCommandsComponentModule
local Module = {}

---@class SpawnCommands
---@field entities EntitySpawnCommand[]
---@field gridEntities GridEntitySpawnCommand[]
---@field outputs OutputSpawnCommand[]
---@field rails RailSpawnCommand[]

---@class EntitySpawnCommand
---@field entityType EntityType | integer
---@field variant integer
---@field subtype integer
---@field seed integer
---@field position Vector
---@field velocity Vector
---@field spawner Entity?
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

---@return SpawnCommands
local function Create()
    local spawnCommands = {}
    spawnCommands.entities = {}
    spawnCommands.gridEntities = {}
    spawnCommands.outputs = {}
    spawnCommands.rails = {}
    return spawnCommands
end

--#region Module

Module.Create = Create

--#endregion

return Module