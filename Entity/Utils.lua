--#region Dependencies

local GameUtils = require("Game.Utils")

--#endregion

---@class EntityUtils
local Module = {}

---@param myContext Context.Game
---@param entity EntityComponent
local function GetFrameCount(myContext, entity)
    return myContext.game.m_frameCount - entity.m_spawnFrame
end

---@param myContext Context.Common
---@param entity EntityComponent
---@param interval integer
---@param offset integer
---@return boolean
local function IsFrame(myContext, entity, interval, offset)
    local game = myContext.game
    if (entity.m_flags & EntityFlag.FLAG_INTERPOLATION_UPDATE) ~= 0 or GameUtils.IsPaused(myContext, game) then
        return false
    end

    return (game.m_frameCount + offset) % interval == 0
end

---@param myContext Context.Common
---@param entity EntityComponent
---@param interval number
---@param offset number
---@return boolean
local function IsTimeScaledFrame(myContext, entity, interval, offset)
    local game = myContext.game
    if (entity.m_flags & EntityFlag.FLAG_INTERPOLATION_UPDATE) ~= 0 or GameUtils.IsPaused(myContext, game) then
        return false
    end

    -- how many times did the interval pass between now and the last update
    local frameDelta = math.floor((offset + entity.m_localFrame) / interval) - math.floor((offset + entity.m_lastLocalFrame) / interval)
    return frameDelta > 0
end

---@param entity EntityComponent
---@param flags integer | EntityFlag
---@return boolean
local function HasFlags(entity, flags)
    return (entity.m_flags & flags) == flags
end

---@param entity EntityComponent
---@param flags integer | EntityFlag
---@return boolean
local function HasAnyFlag(entity, flags)
    return (entity.m_flags & flags) ~= 0
end

---@param entity EntityComponent
---@param flags integer | EntityFlag
local function AddFlags(entity, flags)
    entity.m_flags = entity.m_flags | flags
end

---@param entity EntityComponent
---@param flags integer | EntityFlag
local function ClearFlags(entity, flags)
    entity.m_flags = entity.m_flags & ~flags
end

---@param entity EntityComponent
---@param tags EntityTag | integer
---@return boolean
local function HasConfigTags(entity, tags)
    return (entity.m_config.tags & tags) == tags
end

---@param entity EntityComponent
---@param tags EntityTag | integer
---@return boolean
local function HasAnyConfigTags(entity, tags)
    return (entity.m_config.tags & tags) ~= 0
end

---@param entity EntityComponent
---@param target EntityComponent?
local function SetTarget(entity, target)
end

---@param entity EntityComponent
---@param parent EntityComponent?
local function SetParent(entity, parent)
end

---@param entity EntityComponent
---@param child EntityComponent?
local function SetChild(entity, child)
end

---@param entity EntityComponent
---@return EntityComponent
local function GetLastParent(entity)
    local lastParent = entity
    local parent = entity.m_parent.ref

    while parent ~= nil do
        lastParent = parent
        parent = lastParent.m_parent.ref
    end

    return lastParent
end

---@param entity EntityComponent
---@return EntityComponent
local function GetLastSpawner(entity)
    local lastSpawner = entity
    local spawner = entity.m_spawnerEntity.ref

    while spawner ~= nil do
        lastSpawner = spawner
        spawner = lastSpawner.m_spawnerEntity.ref
    end

    return lastSpawner
end

---@param entityPtr EntityPtrComponent
---@param newRef EntityComponent?
local function SetEntityReference(entityPtr, newRef)
    local currentRef = entityPtr.ref
    if currentRef then
        currentRef.m_backPointers[entityPtr] = nil
    end

    entityPtr.ref = newRef

    if newRef then
        newRef.m_backPointers[entityPtr] = true
    end
end

---@param entity EntityComponent
---@param velocity Vector
---@param ignoreTimescale boolean
local function AddVelocity(entity, velocity, ignoreTimescale)
    local friction = entity.m_friction
    if friction == 0.0 then
        return
    end

    local timeScale = not ignoreTimescale and entity.m_timeScale or 1.0
    entity.m_velocity = entity.m_velocity + (timeScale * velocity) / friction
end

---@param vector Vector
---@return Direction
local function GetMovementDirection(vector)
end

---@param entity EntityComponent
---@return Direction
local function GetVelocityDirection(entity)
    return GetMovementDirection(entity.m_velocity)
end

---@param entity EntityComponent
---@param size number
---@param sizeMulti Vector
---@param numGridCollisionPoints integer
local function SetSize(entity, size, sizeMulti, numGridCollisionPoints)
end

---@param entity EntityComponent
---@return boolean
local function IsEnemy(entity)
    local type = entity.m_type
    return 10 <= type and type < 1000
end

---@param entity EntityComponent
---@return boolean
local function IsVulnerableEnemy(entity)
end

---@param entity EntityComponent
---@return boolean
local function DoesEntityShareStatus(entity)
end

---@param entity EntityComponent
---@return EntityComponent
local function GetStatusEffectTarget(entity)
end

--#region Module

Module.GetFrameCount = GetFrameCount
Module.IsFrame = IsFrame
Module.IsTimeScaledFrame = IsTimeScaledFrame
Module.HasFlags = HasFlags
Module.HasAnyFlag = HasAnyFlag
Module.AddFlags = AddFlags
Module.ClearFlags = ClearFlags
Module.HasConfigTags = HasConfigTags
Module.HasAnyConfigTags = HasAnyConfigTags
Module.SetEntityReference = SetEntityReference
Module.SetTarget = SetTarget
Module.SetParent = SetParent
Module.SetChild = SetChild
Module.GetLastParent = GetLastParent
Module.GetLastSpawner = GetLastSpawner
Module.AddVelocity = AddVelocity
Module.GetMovementDirection = GetMovementDirection
Module.GetVelocityDirection = GetVelocityDirection
Module.SetSize = SetSize
Module.IsEnemy = IsEnemy
Module.IsVulnerableEnemy = IsVulnerableEnemy
Module.DoesEntityShareStatus = DoesEntityShareStatus
Module.GetStatusEffectTarget = GetStatusEffectTarget

--#endregion

return Module