--#region Dependencies

local ops = require("Isaac.Content.Player.TearHitParams.Ops")
local Constants = require("Isaac.Constants")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local ColorUtils = require("General.VanillaAPI.Color")

--#endregion

---@param ctx Player.Blackboard.GetTearHitParams
local function GFuel_BuckshotEffect(ctx)
    ops.set_flags(ctx, TearFlags.TEAR_BOUNCE_WALLSONLY | TearFlags.TEAR_DECELERATE)
end

---@param ctx Player.Blackboard.GetTearHitParams
local function GFuel_SlugShotgunEffect(ctx)
    ops.scale_multiply(ctx, 2.0)
    ops.damage_multiply(ctx, 4.0)
    ops.set_flags(ctx, TearFlags.TEAR_BOUNCE_WALLSONLY | TearFlags.TEAR_DECELERATE)
end

---@param ctx Player.Blackboard.GetTearHitParams
local function GFuel_MinigunEffect(ctx)
    ops.damage_multiply(ctx, 0.6)
end

---@param ctx Player.Blackboard.GetTearHitParams
local function GFuel_RocketLauncherEffect(ctx)
    ops.damage_multiply(ctx, 4.0)
    ops.set_flags(ctx, TearFlags.TEAR_ACCELERATE | TearFlags.TEAR_EXPLOSIVE)
    ops.set_tear_variant(ctx, TearVariant.NAIL_BLOOD)
end

local G_FUEL_WEAPON_EFFECTS = {
    [2] = GFuel_BuckshotEffect,
    [3] = GFuel_SlugShotgunEffect,
    [4] = GFuel_MinigunEffect,
    [5] = GFuel_RocketLauncherEffect,
}


local function ApplyTearHitParams(ctx)
    local gFuelWeapon = IEntityPlayer.GetGFuelWeaponType(ctx.player)
    if gFuelWeapon ~= -1 then
        ops.set_tear_variant(ctx, TearVariant.NAIL)
        local height = math.max(ctx.tearParams.height)
        ops.set_height(ctx, height)

        local colorMod = ColorUtils.ApplyColorMod(Constants.COLOR_WHITE, ctx.player.m_laserColor)
        local color = { tint = { R = colorMod.Red, G = colorMod.Green, B = colorMod.Blue, A = colorMod.Alpha}, offset = { R = 0.0, G = 0.0, B = 0.0 }, colorize = { R = 0.0, G = 0.0, B = 0.0, A = 0.0 } }
        ops.set_color(ctx, color)
    end

    local fn = G_FUEL_WEAPON_EFFECTS[gFuelWeapon]
    if fn then
        fn(ctx)
    end
end

---@class Content.Player.TearHitParams.GFuel
local Module = {}

--#region Module

Module.ApplyTearHitParams = ApplyTearHitParams

--#endregion

return Module