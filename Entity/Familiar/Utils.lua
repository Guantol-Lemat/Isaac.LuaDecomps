--#region Dependencies

local MathUtils = require("General.Math")
local Inventory = require("Entity.Player.Inventory.Inventory")
local EntityListUtils = require("Game.Room.EntityList.Utils")

local Pi = MathUtils.PI

--#endregion

---@class FamiliarUtils
local Module = {}

---@class EntityFamiliar.OrbitData
---@field distance Vector
---@field speed number
---@field guardianSpeedMultiplier number
---@field angleOffset number

local ORBIT_DATA = {
}

---@return EntityFamiliar.OrbitData
local function get_orbit_data(layer)
    return ORBIT_DATA[layer + 1]
end

---@param context FamiliarContext.GetOrbitTarget
---@param familiar EntityFamiliarComponent
---@return EntityComponent
local function GetOrbitTarget(context, familiar)
    local variant = familiar.m_variant
    if variant == FamiliarVariant.BLUE_FLY or variant == FamiliarVariant.WISP then
        local parent = familiar.m_parent.ref
        if parent then
            return parent
        end
    end

    local player = familiar.m_player
    ---@type EntityComponent
    local target = player
    if not Inventory.HasCollectible(context, player, CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES, false) then
        return target
    end

    if not Inventory.HasCollectible(context, player, CollectibleType.COLLECTIBLE_GELLO, false) then
        return target
    end

    local entityList = context.entityList
    local umbilicalBabyList = EntityListUtils.QueryType(entityList, EntityType.ENTITY_FAMILIAR, FamiliarVariant.UMBILICAL_BABY, -1, true, false)

    if umbilicalBabyList.size ~= 0 then
        target = umbilicalBabyList.data[1] -- technically bugged in multiplayer
    end

    return target
end

---@param context FamiliarContext.GetOrbitPosition
---@param familiar EntityFamiliarComponent
---@param position Vector
---@return Vector
local function GetOrbitPosition(context, familiar, position)
    local familiarRead = familiar
    local familiarWrite = familiar
    -- TODO: Duct tape

    local isInterpolation = context.isInterpolation
    local frameCount = context.frameCount

    local angleRadians
    do
        local globalProgress = frameCount
        if isInterpolation then
            globalProgress = globalProgress + 0.5
        end

        local pi = math.pi
        local globalAngleRadians = globalProgress * familiarRead.m_orbitSpeed * (pi / 2)
        angleRadians = familiarRead.m_orbitAngleOffset - globalAngleRadians
        angleRadians = math.fmod(2*pi, angleRadians)
    end

    -- TODO: Variant specific sprite update

    local orbitData = get_orbit_data(familiarRead.m_orbitLayer)
    angleRadians = angleRadians + orbitData.angleOffset

    local cos = math.cos(angleRadians)
    local sin = math.sin(angleRadians)

    local orbitRadii = familiarRead.m_orbitDistance
    return Vector(cos * orbitRadii.X + position.X, sin * orbitRadii.Y + position.Y)
end

--#region Module

Module.GetOrbitTarget = GetOrbitTarget
Module.GetOrbitPosition = GetOrbitPosition

--#endregion

return Module