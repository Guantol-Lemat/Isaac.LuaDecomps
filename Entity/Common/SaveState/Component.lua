---@class EntitySaveStateComponent
---@field type EntityType | integer
---@field variant integer
---@field subtype integer
---@field position Vector
---@field initSeed integer
---@field dropSeed integer

---@class EntitySaveStateComponentUtils
local Module = {}

---@return EntitySaveStateComponent
local function Create()
    ---@type EntitySaveStateComponent
    return {
        type = EntityType.ENTITY_NULL,
        variant = 0,
        subtype = 0,
        position = Vector(0, 0),
        initSeed = 0,
        dropSeed = 0,
    }
end

--#region Module

Module.Create = Create

--#endregion

return Module