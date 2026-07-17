--#region Dependencies

local Enums = require("General.Enums")
local VectorUtils = require("General.Math.VectorUtils")

--#endregion

local eEntityRefFlags = Enums.eEntityRefFlags

---@class Component.Entity.EntityRef
---@field m_type EntityType | integer : 0x0
---@field m_variant integer : 0x4
---@field m_spawnerType EntityType | integer : 0x8
---@field m_spawnerVariant integer : 0xc
---@field m_position Vector : 0x10
---@field m_velocity Vector : 0x18
---@field m_flags eEntityRefFlags | integer : 0x20
---@field m_entity Component.Entity? : 0x24

---@param entity Component.Entity?
---@return Component.Entity.EntityRef
local function New(entity)
    if not entity then
        ---@type Component.Entity.EntityRef
        return {
            m_type = EntityType.ENTITY_NULL,
            m_variant = 0,
            m_spawnerType = EntityType.ENTITY_NULL,
            m_spawnerVariant = 0,
            m_position = Vector(0.0, 0.0),
            m_velocity = Vector(0.0, 0.0),
            m_flags = 0,
            m_entity = entity,
        }
    end

    local flags = entity.m_flags
    local charmed = (flags & EntityFlag.FLAG_CHARM ~= 0) and eEntityRefFlags.FLAG_CHARMED or 0
    local friendly = (flags & EntityFlag.FLAG_FRIENDLY ~= 0) and eEntityRefFlags.FLAG_FRIENDLY or 0
    local weakness = (flags & EntityFlag.FLAG_WEAKNESS ~= 0) and eEntityRefFlags.FLAG_WEAKNESS or 0

    ---@type Component.Entity.EntityRef
    return {
        m_type = entity.m_type,
        m_variant = entity.m_variant,
        m_spawnerType = entity.m_spawnerType,
        m_spawnerVariant = entity.m_spawnerVariant,
        m_position = VectorUtils.Copy(entity.m_position),
        m_velocity = VectorUtils.Copy(entity.m_velocity),
        m_flags = charmed | friendly | weakness,
        m_entity = entity,
    }
end

---@class Module.Entity.EntityRefComponent
local Module = {}

--#region Module

Module.New = New

--#endregion

return Module