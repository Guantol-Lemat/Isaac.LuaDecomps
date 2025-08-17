--#region Dependencies

local EntityUtils = require("Entity.Common.Utils")
local RoomUtils = require("Room.Utils")

--#endregion

---@class EntityUpdate
local Module = {}

---@param context Context
---@param entity EntityComponent
local function interpolate_grid_collide(context, entity)
    if entity.m_type == EntityType.ENTITY_PLAYER then
        --PlayerCollideWithGrid(context, entity, true)
    else
        --CollideWithGrid(context, entity, true)
    end
end

---@param entity EntityComponent
---@param context Context
local function Interpolate(entity, context)
    if EntityUtils.HasFlags(entity, EntityFlag.FLAG_NO_INTERPOLATE) then
        EntityUtils.ClearFlags(entity, EntityFlag.FLAG_NO_INTERPOLATE)
        return
    end

    entity.m_preInterpolatePosition = entity.m_position
    entity.m_interpolated = true

    entity.m_position = entity.m_position + (entity.m_friction * entity.m_velocity * entity.m_timescale * 0.5)
    interpolate_grid_collide(context, entity)

    -- This should absolutely be in a Player::Interpolate, but to keep consistency with vanilla it will be left here
    if entity.m_type == EntityType.ENTITY_PLAYER and entity.m_variant == PlayerVariant.CO_OP_BABY then
        entity.m_position = RoomUtils.GetClampedPosition(context:GetRoom(), entity.m_position, entity.m_size)
        -- something with position offset
    end
end

--#region Module

Module.Interpolate = Interpolate

--#endregion

return Module