--#region Dependencies

local ops = require("Isaac.Content.Player.TearHitParams.Ops")
local ColorUtils = require("General.VanillaAPI.Color")

--#endregion

---@param ctx Player.Blackboard.GetTearHitParams
local function BloodBaby_BlackTearEffects(ctx)
    ops.set_tear_variant(ctx, TearVariant.DARK_MATTER)
    ops.damage_multiply(ctx, 1.25)
    ops.scale_multiply(ctx, 1.1)
    ops.set_flags(ctx, TearFlags.TEAR_DARK_MATTER)

    if ops.luck_based_chance(ctx, 1, 5, 1, 0.1) then
        ops.set_flags(ctx, TearFlags.TEAR_FEAR)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
local function BloodBaby_EternalTearEffects(ctx)
    ops.damage_multiply(ctx, 1.5)
    ops.scale_multiply(ctx, 1.3)
    ops.set_flags(ctx, TearFlags.TEAR_HOMING)
end

---@param ctx Player.Blackboard.GetTearHitParams
local function BloodBaby_GoldTearEffects(ctx)
    if ops.luck_based_chance(ctx, 1, 9, 3, 0.25) then
        ops.set_flags(ctx, TearFlags.TEAR_MIDAS)
    end

    ColorUtils.MultiplyCompound(ctx.tearParams.tearColor, Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 2.0, 1.0, 0.0, 1.0))
end

---@param ctx Player.Blackboard.GetTearHitParams
local function BloodBaby_BoneTearEffects(ctx)
    ops.set_flags(ctx, TearFlags.TEAR_BONE)
    ops.set_tear_variant(ctx, TearVariant.BONE)
end

---@param ctx Player.Blackboard.GetTearHitParams
local function BloodBaby_RottenTearEffects(ctx)
    ops.set_flags(ctx, TearFlags.TEAR_MULLIGAN)
end

local BLOOD_BABY_SUBTYPE = {
    [BloodClotSubtype.BLACK] = BloodBaby_BlackTearEffects,
    [BloodClotSubtype.ETERNAL] = BloodBaby_EternalTearEffects,
    [BloodClotSubtype.GOLD] = BloodBaby_GoldTearEffects,
    [BloodClotSubtype.BONE] = BloodBaby_BoneTearEffects,
    [BloodClotSubtype.ROTTEN] = BloodBaby_RottenTearEffects,
}

---@param ctx Player.Blackboard.GetTearHitParams
local function ApplyTearHitParams(ctx)
    local familiar = ctx.familiar
    if familiar and familiar.m_variant == FamiliarVariant.BLOOD_BABY then
        local fn = BLOOD_BABY_SUBTYPE[familiar.m_subtype]
        if fn then
            fn(ctx)
        end
    end
end

---@class Content.Player.TearHitParams.BloodBaby
local Module = {}

--#region Module

Module.ApplyTearHitParams = ApplyTearHitParams

--#endregion

return Module