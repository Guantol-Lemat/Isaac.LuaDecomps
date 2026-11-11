--#region Dependencies

local ops = require("Isaac.Content.Player.TearHitParams.Ops")
local IsaacUtils = require("Isaac.Utils.Common")
local WeaponProperties = require("Isaac.Content.Weapon.Properties")

--#endregion

local ALMOND_MILK_EFFECTS = {
    [1] = TearFlags.TEAR_FLAT,
    [2] = TearFlags.TEAR_SQUARE,
    [3] = TearFlags.TEAR_SPIRAL,
    [4] = TearFlags.TEAR_WIGGLE,
    [5] = TearFlags.TEAR_ORBIT,
    [6] = TearFlags.TEAR_PULSE,
    [7] = TearFlags.TEAR_BOOMERANG,
    [8] = TearFlags.TEAR_HOMING,
    [9] = TearFlags.TEAR_BOUNCE,
    [10] = TearFlags.TEAR_ORBIT_ADVANCED,
    [11] = TearFlags.TEAR_TURN_HORIZONTAL,
    [12] = TearFlags.TEAR_BIG_SPIRAL,
}

local ALMOND_MILK_LASER_EFFECTS = {
    [1] = TearFlags.TEAR_SQUARE,
    [2] = TearFlags.TEAR_WIGGLE,
    [3] = TearFlags.TEAR_ORBIT,
    [4] = TearFlags.TEAR_HOMING,
    [5] = TearFlags.TEAR_BOOMERANG,
    [6] = TearFlags.TEAR_SPIRAL
}

---@param ctx Player.Blackboard.GetTearHitParams
local function ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_ALMOND_MILK) then
        local random = IsaacUtils.RandomFloat()
        local numFlags = 0.05 > random and 4
            or 0.1 > random and 3
            or 0.3 > random and 2
            or 0.8 > random and 1
            or 0

        local laserGroup = WeaponProperties.IsLaserWeapon(ctx.weaponType)
        if laserGroup then
            numFlags = math.min(numFlags, 1)
        end

        if laserGroup then
            for i = 1, numFlags, 1 do
                local flag = ALMOND_MILK_LASER_EFFECTS[IsaacUtils.RandomInt(#ALMOND_MILK_LASER_EFFECTS) + 1]
                ops.set_flags(ctx, flag)
            end
        else
            for i = 1, numFlags, 1 do
                local flag = ALMOND_MILK_EFFECTS[IsaacUtils.RandomInt(#ALMOND_MILK_EFFECTS) + 1]
                ops.set_flags(ctx, flag)
            end
        end
    end
end

---@class Content.Player.TearHitParams.AlmondMilk
local Module = {}

--#region Module

Module.ApplyTearHitParams = ApplyTearHitParams

--#endregion

return Module