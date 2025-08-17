--#region Dependencies

local EntityUpdate = require("Entity.Common.Update")

--#endregion

---@class EntityFamiliarUpdate
local Module = {}

---@param context Context
---@param entity EntityFamiliarComponent
local function hook_pre_interpolate(context, entity)
    -- lil brimstone interpolate
    -- incubus interpolate
    -- damocles interpolate
    -- blood baby interpolate
end

---@param context Context
---@param entity EntityFamiliarComponent
local function hook_post_interpolate(context, entity)
    -- decap attack interpolate
end

---@param entity EntityFamiliarComponent
---@param context Context
local function Interpolate(entity, context)
    hook_pre_interpolate(context, entity)
    -- update orbit angle
    EntityUpdate.Interpolate(entity, context)
    hook_post_interpolate(context, entity)
end

--#region Module

Module.Interpolate = Interpolate

--#endregion

return Module