---@class Decomp.Class.EntityProjectile
local Class_Projectile = {}

local Lib = {
    Math = require("Lib.Math")
}

---@class Decomp.Object.EntityProjectile : Decomp.EntityProjectileObject, Decomp.Object.Entity
---@field _API Decomp.IGlobalAPI
---@field _ENV Decomp.EnvironmentObject
---@field _Object EntityProjectile
---@field m_Height number
---@field m_FallingSpeed number
---@field m_FallingAcceleration number
---@field m_ProjectileFlags ProjectileFlags

local s_NoGridCollisionFlags = ProjectileFlags.GHOST | ProjectileFlags.ORBIT_CW | ProjectileFlags.ORBIT_CCW | ProjectileFlags.NO_WALL_COLLIDE | ProjectileFlags.CONTINUUM | ProjectileFlags.BOUNCE

local function get_render_height(height, fallingAcceleration)
    if fallingAcceleration >= 0.0 then
        return height
    end

    local t = height + 8.5
    t = math.max(t, 0.0)
    return (height * 0.5 - 15.0) + t * t
end

---@param height number
---@param projectileFlags ProjectileFlags
---@param roomType RoomType
---@return EntityCollisionClass?
local function get_new_entity_collision_class(height, projectileFlags, roomType)
    if height >= -50.0 or roomType == RoomType.ROOM_DUNGEON then
        return EntityCollisionClass.ENTCOLL_ALL
    end

    if (projectileFlags & ProjectileFlags.ANY_HEIGHT_ENTITY_HIT) == 0 then
        return EntityCollisionClass.ENTCOLL_NONE
    end
end

---@param height number
---@param projectileFlags ProjectileFlags
---@param roomType RoomType
---@return GridCollisionClass?
local function get_new_grid_collision_class(height, projectileFlags, roomType)
    if not (height >= -50.0 or roomType == RoomType.ROOM_DUNGEON) then
        return
    end

    if (projectileFlags & s_NoGridCollisionFlags) ~= 0 then
        return GridCollisionClass.COLLISION_NONE
    end

    return GridCollisionClass.COLLISION_WALL
end

---@param projectile Decomp.Object.EntityProjectile
local function UpdateHeight(projectile)
    local api = projectile._API
    local game = api.Environment.GetGame(projectile._ENV)
    local room = api.Game.GetRoom(game)
    local roomType = api.Room.GetRoomType(room)

    if roomType == RoomType.ROOM_DUNGEON then
        projectile.m_PositionOffset.Y = -15.0
        projectile.m_Height = math.min(projectile.m_Height, -5.1)
    else
        projectile.m_PositionOffset.Y = get_render_height(projectile.m_Height, projectile.m_FallingAcceleration)
    end

    projectile.m_GridCollisionClass = get_new_grid_collision_class(projectile.m_Height, projectile.m_ProjectileFlags, roomType) or projectile.m_GridCollisionClass
    projectile.m_EntityCollisionClass = get_new_entity_collision_class(projectile.m_Height, projectile.m_ProjectileFlags, roomType) or projectile.m_EntityCollisionClass

    if (projectile.m_EntityFlags & EntityFlag.FLAG_FREEZE) ~= 0 then
        projectile.m_EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end

    if api.Room.IsBeastRoom(room) then
        projectile.m_GridCollisionClass = GridCollisionClass.COLLISION_NONE
    end
end

---@param projectile Decomp.Object.EntityProjectile
local function should_projectile_die(projectile)
    return projectile.m_Height > -5.0 or projectile.m_CollidesWithGrid
end

---@param projectile Decomp.Object.EntityProjectile
local function get_new_falling_speed(projectile)
    local timescale = projectile.m_Timescale
    local dampingFactor = Lib.Math.TimeScaledFriction(0.9, timescale) -- Lose 10% of the speed
    local baseFallRate = 0.1

    return timescale * projectile.m_FallingAcceleration + timescale * baseFallRate + dampingFactor * projectile.m_FallingSpeed
end

---@param projectile Decomp.Object.EntityProjectile
local function get_new_height(projectile)
    return projectile.m_Timescale * projectile.m_FallingSpeed + projectile.m_Height
end