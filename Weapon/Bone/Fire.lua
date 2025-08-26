--#region Dependencies

local WeaponRules = require("Weapon.Common.Rules")
local EntityUtils = require("Entity.Common.Utils")
local MathUtils = require("General.Math")
local VectorUtils = require("Math.VectorUtils")

--#endregion

---@class WeaponBoneFire
local Module = {}

local HeadDirectionToShootingInput = {
    [Direction.LEFT] = Vector(-1.0, 0.0),
    [Direction.UP] = Vector(0.0, -1.0),
    [Direction.RIGHT] = Vector(1.0, 0.0),
    [Direction.DOWN] = Vector(0.0, 1.0),
}

local KnivesBaseAngles = {0.0, 180.0, 90.0, -90.0}

---@param weapon WeaponBoneComponent
---@return EntityPlayerComponent?
---@return EntityPlayerComponent?
---@return number
---@return Vector
local function get_owner_data(weapon)
    local playerOwner = nil
    local player = nil
    local shootSpeed = 1.0
    local position = Vector(0, 0)

    local owner = weapon.m_owner
    if owner then
        position = owner.m_position
        if owner.m_type == EntityType.ENTITY_PLAYER then
            player = EntityUtils.ToPlayer(owner)
            playerOwner = player
        elseif owner.m_type == EntityType.ENTITY_FAMILIAR then
            local familiar = EntityUtils.ToFamiliar(owner)
            assert(familiar, "Could not convert familiar ToFamiliar")
            player = familiar.m_player
        end
    end

    if player then
        shootSpeed = player.m_shootSpeed
    end

    return playerOwner, player, shootSpeed, position
end

---@param context Context
---@param weapon WeaponBoneComponent
---@param shootingInput Vector
---@param playerOwner EntityPlayerComponent?
local function get_shooting_input(context, weapon, shootingInput, playerOwner)
    if VectorUtils.Equals(shootingInput, Vector(0, 0)) then
        shootingInput = weapon.m_bufferDirection_qqq
    end

    if VectorUtils.Equals(shootingInput, Vector(0, 0)) and playerOwner then
        local headShootingInput = HeadDirectionToShootingInput[playerOwner.m_headDirection] or Vector(0, 0)
        shootingInput = headShootingInput
    end

    if WeaponRules.IsAxisAligned(context, weapon) then
        shootingInput = VectorUtils.AxisAligned(shootingInput)
    end

    return shootingInput
end

---@param knives EntityKnifeComponent[]
---@param shootingInput Vector
local function update_bone_rotation(knives, shootingInput)
    for i = 1, 4, 1 do
        if not knives[i] then
            goto continue
        end
        local angle = shootingInput:GetAngleDegrees()
        angle = MathUtils.NormalizeAngle(angle + KnivesBaseAngles[i])
        knives[i].m_rotation = angle
        ::continue::
    end

    if not knives[1].m_meleeSwingInputHeld_qqq then
        knives[1].m_rotationOffset = MathUtils.NormalizeAngle(0.0)
    end
end

---@param weapon WeaponBoneComponent
---@param context Context
---@param shootingInput Vector
---@param isShooting boolean
---@param isInterpolationUpdate boolean
local function Fire(weapon, context, shootingInput, isShooting, isInterpolationUpdate)
    local playerOwner, player, shootSpeed, position = get_owner_data(weapon)
    -- TODO
    local mainBone = weapon.m_knives[1] -- it's always assumed this is not nil

    if not mainBone.m_isSwinging and not mainBone.m_isFlying then
        update_bone_rotation(weapon.m_knives, shootingInput)
        -- TODO
    end

    -- TODO
end

--#region Module



--#endregion

return Module