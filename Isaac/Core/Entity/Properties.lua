--#region Dependencies

local G = require("Isaac.Global")

local MathUtils = require("General.Math")
local TableUtils = require("General.Table")
local VectorUtils = require("General.Math.VectorUtils")
local IRoom = require("Isaac.Interface.Room")
local WaterClipInfo = require("Isaac.Content.Entity.Properties.WaterClipInfo")

--#endregion

---@param entity Component.Entity
---@return boolean
local function IsEnemy(entity)
    local entType = entity.m_type
    return 10 <= entType and entType < 1000
end

local FLYING_COLLISION_CLASS = TableUtils.CreateDictionary({
    EntityGridCollisionClass.GRIDCOLL_NONE, EntityGridCollisionClass.GRIDCOLL_WALLS,
    EntityGridCollisionClass.GRIDCOLL_WALLS_X, EntityGridCollisionClass.GRIDCOLL_WALLS_Y,
})

---@param entity Component.Entity
---@return boolean
local function IsFlying(entity)
    return FLYING_COLLISION_CLASS[entity.m_gridCollisionClass] ~= nil
end

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

---@param entity Component.Entity
---@return integer
local function GetRenderZ(entity)
    local sortingLayer = entity.m_sortingLayer

    if sortingLayer == SortingLayer.SORTING_BACKGROUND then
        local renderZ = entity.m_renderZOffset + 100 + (entity.m_index % 1024)
        renderZ = MathUtils.Clamp(renderZ, 0, 4999)
        return renderZ
    end

    if sortingLayer == SortingLayer.SORTING_DOOR then
        local renderZ = entity.m_renderZOffset + 5100 + (entity.m_index % 1024)
        renderZ = MathUtils.Clamp(renderZ, 5000, 9999)
        return renderZ
    end

    if IRoom.IsDungeon(G.Game.m_level.m_room) then
        local renderZ = entity.m_renderZOffset + 10030 + (entity.m_index % 1024)
        renderZ = math.max(renderZ, 10000)
        return renderZ
    end

    -- sorting layer normal
    local renderZMod = math.floor((entity.m_depthOffset + entity.m_position.Y) * 100.0 + 10030.0 + 0.5)
    renderZMod = math.max(renderZMod, 10000)
    local renderZ = entity.m_renderZOffset + renderZMod
    renderZ = math.max(renderZ, 10000)
    return renderZ
end

---@class Gameplay.Entity.Properties
local Module = {}

--#region Module

Module.IsEnemy = IsEnemy
Module.IsFlying = IsFlying
Module.SetSize = SetSize
Module.GetRenderZ = GetRenderZ
Module.GetWaterClipInfo = WaterClipInfo.GetWaterClipInfo

--#endregion

return Module