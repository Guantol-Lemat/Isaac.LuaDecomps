--#region Dependencies

local VectorUtils = require("General.Math.VectorUtils")

--#endregion

---@param entity Component.Entity
---@param size number
---@param sizeMulti Vector
---@param numGridCollisionPoints integer
local function SetSize(entity, size, sizeMulti, numGridCollisionPoints)
    if VectorUtils.Equals(sizeMulti, Vector(-1.0, -1.0)) then -- default size multi
        sizeMulti = entity.m_config.collisionRadiusMulti
    end

    if numGridCollisionPoints == -1 then
        numGridCollisionPoints = entity.m_config.gridCollisionPoints
    end

    -- numGridCollisionPoints is not checked, meaning that changing just the
    -- number of grid collision points is impossible
    local isUnchanged = entity.m_size == size
        and VectorUtils.Equals(entity.m_sizeMulti, sizeMulti)

    if isUnchanged then
        return
    end

    entity.m_size = size
    VectorUtils.Assign(entity.m_sizeMulti, sizeMulti)
    entity.m_gridCollisionPoints = {}
    local gridCollisionPoints = entity.m_gridCollisionPoints

    -- insert even grid points
    for i = 0, numGridCollisionPoints - 1, 2 do
        local angle = (i / numGridCollisionPoints) * (2.0 * math.pi)
        local radiusX = (size * sizeMulti.X) * math.cos(angle)
        local radiusY = (size * sizeMulti.Y) * math.sin(angle)

        table.insert(gridCollisionPoints, Vector(radiusX, radiusY))
    end

    -- insert odd grid points
    for i = 1, numGridCollisionPoints - 1, 2 do
        local angle = (i / numGridCollisionPoints) * (2.0 * math.pi)
        local radiusX = (size * sizeMulti.X) * math.cos(angle)
        local radiusY = (size * sizeMulti.Y) * math.sin(angle)

        table.insert(gridCollisionPoints, Vector(radiusX, radiusY))
    end
end

---@class Gameplay.Entity.Data
local Module = {}

--#region Module

Module.SetSize = SetSize

--#endregion

return Module