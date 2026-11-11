--#region Dependencies

local ops = require("Isaac.Content.Player.TearHitParams.Ops")
local IsaacUtils = require("Isaac.Utils.Common")
local WeaponProperties = require("Isaac.Content.Weapon.Properties")

--#endregion

---@param ctx Player.Blackboard.GetTearHitParams
---@param bonusValue integer
local function PlaydoughCookie_PurpleEffect(ctx, bonusValue)
    ops.set_flags(ctx, IsaacUtils.RandomInt(2) == 0 and TearFlags.TEAR_TURN_HORIZONTAL or TearFlags.TEAR_HOMING)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param bonusValue integer
local function PlaydoughCookie_GreenEffect(ctx, bonusValue)
    ops.set_flags(ctx, TearFlags.TEAR_POISON)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param bonusValue integer
local function PlaydoughCookie_RedEffect(ctx, bonusValue)
    if IsaacUtils.RandomInt(2) ~= 0 then
        ops.damage_multiply(ctx, 2.0)
    elseif bonusValue < 2 then
        ops.set_flags(ctx, TearFlags.TEAR_FREEZE)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param bonusValue integer
local function PlaydoughCookie_YellowEffect(ctx, bonusValue)
    if bonusValue < 3 then
        ops.set_flags(ctx, TearFlags.TEAR_FEAR)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param bonusValue integer
local function PlaydoughCookie_PinkEffect(ctx, bonusValue)
    if bonusValue < 3 then
        ops.set_flags(ctx, TearFlags.TEAR_CHARM)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param bonusValue integer
local function PlaydoughCookie_DarkOrangeEffect(ctx, bonusValue)
    if IsaacUtils.RandomInt(2) ~= 0 and bonusValue <= 2 then
        ops.set_flags(ctx, TearFlags.TEAR_BAIT)
    elseif bonusValue < 4 then
        ops.set_flags(ctx, TearFlags.TEAR_BURN)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param bonusValue integer
local function PlaydoughCookie_LightBlueEffect(ctx, bonusValue)
    if IsaacUtils.RandomInt(2) ~= 0 and bonusValue <= 2 then
        ops.set_flags(ctx, TearFlags.TEAR_SLOW)
    else
        ops.set_flags(ctx, TearFlags.TEAR_ICE)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param bonusValue integer
local function PlaydoughCookie_BlueEffect(ctx, bonusValue)
    if bonusValue < 2 then
        ops.set_flags(ctx, TearFlags.TEAR_SHRINK)
    end
end

local PLAYDOUGH_COOKIE_EFFECTS = {
    [1] = {color = {R = 1.0, G = 0.4, B = 1.2}, fn = PlaydoughCookie_PurpleEffect},
    [2] = {color = {R = 0.4, G = 0.8, B = 0.5}, fn = PlaydoughCookie_GreenEffect},
    [3] = {color = {R = 0.9, G = 0.2, B = 0.2}, fn = PlaydoughCookie_RedEffect},
    [4] = {color = {R = 0.8, G = 0.9, B = 0.1}, fn = PlaydoughCookie_YellowEffect},
    [5] = {color = {R = 1.0, G = 0.4, B = 0.7}, fn = PlaydoughCookie_PinkEffect},
    [6] = {color = {R = 1.0, G = 0.4, B = 0.2}, fn = PlaydoughCookie_DarkOrangeEffect},
    [7] = {color = {R = 0.4, G = 0.7, B = 1.0}, fn = PlaydoughCookie_LightBlueEffect},
    [8] = {color = {R = 0.3, G = 0.4, B = 1.0}, fn = PlaydoughCookie_BlueEffect},
}

local PLAYDOUGH_COOKIE_EFFECTS_DEFAULT = {color = {R = 0.7, G = 0.6, B = 0.4}, fn = function(ctx, bonusValue) end}

---@param ctx Player.Blackboard.GetTearHitParams
local function ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
        local maxEffectIdx = math.max(math.floor(11.0 - ctx.player.m_luck * 0.2), 6)
        local effectIdx = IsaacUtils.RandomInt(maxEffectIdx)

        local bonusChance = math.floor(6.0 - ctx.player.m_luck * 0.5)
        local bonusValue = IsaacUtils.RandomInt(bonusChance)
        local isLaserWeapon = WeaponProperties.IsLaserWeapon(ctx.weaponType)
        bonusValue = not isLaserWeapon and bonusValue or 0

        local effect = PLAYDOUGH_COOKIE_EFFECTS[effectIdx + 1] or PLAYDOUGH_COOKIE_EFFECTS_DEFAULT
        effect.fn(ctx, bonusValue)
        local color = effect.color

        ops.set_colorize(ctx, {R = color.R, G = color.G, B = color.B, A = 1.5})
    end
end

---@class Content.Player.TearHitParams.PlaydoughCookie
local Module = {}

--#region Module

Module.ApplyTearHitParams = ApplyTearHitParams

--#endregion

return Module