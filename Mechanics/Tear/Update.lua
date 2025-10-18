--#region Dependencies

local RoomUtils = require("Room.Utils")
local TearUtils = require("Entity.Tear.Utils")
local TearRules = require("Entity.Tear.Rules")

--#endregion

---@class ModuleName
local Module = {}

---@param context Context
---@param tear EntityTearComponent
local function bounce_tear(context, tear)
    local spectralTears = TearUtils.HasAnyTearFlag(tear, TearFlags.TEAR_SPECTRAL)
    tear.m_gridCollisionClass = spectralTears and EntityGridCollisionClass.GRIDCOLL_WALLS or EntityGridCollisionClass.GRIDCOLL_NOPITS

    if not tear.m_collidesWithGrid then
        return
    end

    local velocity = tear.m_velocity
    local collisionPoint = tear.m_position - velocity
    TearRules.DamageGrid(context, tear, collisionPoint)

    velocity:Normalize()
    local speedOnGridCollide = tear.m_velocityOnGridCollide:Length()
    tear.m_velocity = velocity * speedOnGridCollide

    local clearedFlags = TearFlags.TEAR_TRACTOR_BEAM
    local room = context:GetRoom()
    if RoomUtils.IsDungeon(room) then
        clearedFlags = clearedFlags | TearFlags.TEAR_BOUNCE
    end

    TearUtils.ClearTearFlags(tear, clearedFlags)
end

---@param context Context
---@param tear EntityTearComponent
local function Update(context, tear)
    local room = context:GetRoom()
    -- TODO

    local bouncingTear = TearUtils.HasAnyTearFlag(tear, TearFlags.TEAR_BOUNCE | TearFlags.TEAR_BOUNCE_WALLSONLY)
    if bouncingTear and not RoomUtils.IsBeastDungeon(room) then
        bounce_tear(context, tear)
    end

    -- TODO
end

--#region Module

Module.Update = Update

--#endregion

return Module
