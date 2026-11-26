--#region Dependencies

local G = require("Isaac.Global")

local MathUtils = require("General.Math")
local TableUtils = require("General.Table")
local VectorUtils = require("General.Math.VectorUtils")
local IsaacUtils = require("Isaac.Utils.Common")
local IRoom = require("Isaac.Interface.Room")
local WaterClipInfo = require("Isaac.Content.Entity.Properties.WaterClipInfo")

--#endregion

---@param entity Component.Entity
---@return Vector
local function GetSpriteScale(entity)
    return entity.m_sprite.m_scale
end

---@param entity Component.Entity
---@param value Vector
local function SetSpriteScale(entity, value)
    entity.m_sprite.m_scale = VectorUtils.Copy(value)
end

---@param entity Component.Entity
---@param value Vector
local function SetSpriteOffset(entity, value)
    entity.m_sprite.m_offset = VectorUtils.Copy(value)
end

---@param entity Component.Entity
---@return boolean
local function GetFlipX(entity)
    return entity.m_sprite.m_flipX
end

---@param entity Component.Entity
---@param value number
local function SetSpriteRotation(entity, value)
    entity.m_sprite.m_rotation = value
end

---@param entity Component.Entity
---@return integer
local function GetDropSeed(entity)
    return entity.m_dropRNG:GetSeed()
end

---@param entity Component.Entity
---@return BossType | integer
local function GetBossID(entity)
    return entity.m_config.bossID
end

---@param entity Component.Entity
---@return boolean
local function HasMinecart(entity)
    return entity.m_minecart ~= nil
end

---@param entity Component.Entity
---@return boolean
local function HasMortalDamage(entity)
    return entity.m_health <= entity.m_damage_damageTaken
end

---@param entity Component.Entity
---@return boolean
local function HasFullHealth(entity)
    return entity.m_health >= entity.m_maxHealth
end

---@param entity Component.Entity
---@return integer
local function GetFrameCount(entity)
    return g_Game.m_frameCount - entity.m_spawnFrame
end

---@param entity Component.Entity
---@return integer
local function GetFrameDelta(entity)
    return math.floor(entity.m_localFrame) - math.floor(entity.m_lastLocalFrame)
end

---@param entity Component.Entity
---@return boolean
local function IsFriendly(entity)
    return (entity.m_flags & EntityFlag.FLAG_FRIENDLY) ~= 0
end

---@param entity Component.Entity
---@return boolean
local function CanOverwrite(entity)
    return (entity.m_flags & EntityFlag.FLAG_DONT_OVERWRITE) == 0
end

---@param entity Component.Entity
local function Die(entity)
    entity.m_isDead = true
end

---@param entity Component.Entity
---@param value number
local function MultiplyFriction(entity, value)
    entity.m_friction = entity.m_friction * value
end

---@param entity Component.Entity
---@return boolean
local function CanDevolve(entity)
    return #entity.m_config.devolve > 0
end

---@param entity Component.Entity
---@return Component.Entity
local function GetLastParent(entity)
    local lastParent = entity
    local parent = lastParent.m_parent.ref
    while parent ~= nil do
        lastParent = parent
        parent = lastParent.m_parent.ref
    end

    return lastParent
end

---@param entity Component.Entity
---@return boolean
local function ShouldRender(entity)
    return entity.m_exists and entity.m_visible
end

---@param entity Component.Entity
---@param offset Vector
local function InitScreenPosition(entity, offset)
    entity.m_screenPosition = IsaacUtils.GetRenderPosition(entity.m_position + entity.m_positionOffset, true) + offset
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
Module.ShouldRender = ShouldRender

--#endregion

return Module