---@class GameSpawnLogic
local Module = {}

---@param context Context
---@param entityType EntityType | integer
---@param variant integer
---@param subtype integer
---@param seed integer
---@param position Vector
---@param velocity Vector
---@param spawner EntityComponent?
---@return EntityComponent
local function Spawn(context, entityType, variant, subtype, seed, position, velocity, spawner)
end

--#region Module

Module.Spawn = Spawn

--#endregion

return Module