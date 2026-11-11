--#region Dependencies

local Constants = require("Isaac.Constants")
local IsaacUtils = require("Isaac.Utils.Common")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local ITemporaryEffects = require("Isaac.Interface.TemporaryEffects")

--#endregion

local BITSET_ZERO = Constants.BITSET_ZERO

---@class Content.Player.TearHitParams.Ops
local Ops = {}

---@param ctx Player.Blackboard.GetTearHitParams
---@param playerType PlayerType | integer
---@return boolean
function Ops.is_player_type(ctx, playerType)
    return ctx.player.m_playerType == playerType
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param babyType BabySubType | integer
---@return boolean
function Ops.is_baby_type(ctx, babyType)
    local player = ctx.player
    return player.m_variant == PlayerVariant.CO_OP_BABY and player.m_babySkin == babyType
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param collectible CollectibleType | integer
---@return boolean
function Ops.has_collectible(ctx, collectible)
    return IEntityPlayer.HasCollectible(ctx.player, collectible, false)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param collectible CollectibleType | integer
---@return boolean
function Ops.has_collectible_or_effect(ctx, collectible)
    local player = ctx.player
    return IEntityPlayer.HasCollectible(player, collectible, false)
        or ITemporaryEffects.HasCollectibleEffect(player.m_temporaryEffects, collectible)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param collectible CollectibleType | integer
---@return boolean
function Ops.has_zodiac_collectible(ctx, collectible)
    local player = ctx.player
    return IEntityPlayer.HasCollectible(player, collectible, false)
        or IEntityPlayer.GetZodiacEffect(player) == collectible
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param trinket TrinketType | integer
---@return boolean
function Ops.has_trinket(ctx, trinket)
    return IEntityPlayer.HasTrinket(ctx.player, trinket, false)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param collectible CollectibleType | integer
---@return boolean
function Ops.has_collectible_effect(ctx, collectible)
    return ITemporaryEffects.HasCollectibleEffect(ctx.player.m_temporaryEffects, collectible)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param trinket TrinketType | integer
---@return boolean
function Ops.has_trinket_effect(ctx, trinket)
    return ITemporaryEffects.HasTrinketEffect(ctx.player.m_temporaryEffects, trinket)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param effect NullItemID | integer
---@return boolean
function Ops.has_null_effect(ctx, effect)
    return ITemporaryEffects.HasNullEffect(ctx.player.m_temporaryEffects, effect)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param variant TearVariant | integer
---@return boolean
function Ops.is_tear_variant(ctx, variant)
    return ctx.tearParams.tearVariant == variant
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param variants (TearVariant | integer)[]
---@return boolean
function Ops.is_any_tear_variant(ctx, variants)
    local tearVariant = ctx.tearParams.tearVariant
    for i = 1, #variants, 1 do
        if tearVariant == variants[i] then
            return true
        end
    end

    return false
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param flags TearFlags | integer
---@return boolean
function Ops.has_flags(ctx, flags)
    return (ctx.tearParams.tearFlags & flags) ~= BITSET_ZERO
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param weapon WeaponType | integer
---@return boolean
function Ops.is_weapon_type(ctx, weapon)
    return ctx.weaponType == weapon
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param weapons (WeaponType | integer)[]
---@return boolean
function Ops.is_any_weapon_type(ctx, weapons)
    local weaponType = ctx.weaponType
    for i = 1, #weapons, 1 do
        if weaponType == weapons[i] then
            return true
        end
    end

    return false
end

---@param numerator integer
---@param denominator integer
---@return boolean
function Ops.static_chance(numerator, denominator)
    return IsaacUtils.RandomInt(denominator) < numerator
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param numerator integer
---@param max integer
---@param min integer
---@param step number
---@return boolean
function Ops.luck_based_chance(ctx, numerator, max, min, step)
    local chance = math.max(max - math.floor(ctx.player.m_luck * step), min)
    return IsaacUtils.RandomInt(chance) < numerator
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param value number
function Ops.damage_add(ctx, value)
    local tearParams = ctx.tearParams
    tearParams.tearDamage = tearParams.tearDamage + value
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param multi number
function Ops.damage_multiply(ctx, multi)
    local tearParams = ctx.tearParams
    tearParams.tearDamage = tearParams.tearDamage * multi
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param multi number
function Ops.base_damage_multiply(ctx, multi)
    local tearParams = ctx.tearParams
    tearParams.tearDamage = math.max(tearParams.tearDamage, ctx.baseDamage * multi)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param multi number
function Ops.scale_multiply(ctx, multi)
    local tearParams = ctx.tearParams
    tearParams.tearScale = tearParams.tearScale * multi
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param multi number
function Ops.speed_multiply(ctx, multi)
    local tearParams = ctx.tearParams
    tearParams.speed = tearParams.speed * multi
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param value number
function Ops.tear_height_add(ctx, value)
    local tearParams = ctx.tearParams
    tearParams.tearHeight = tearParams.tearHeight + value
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param multi number
function Ops.tear_height_multiply(ctx, multi)
    local tearParams = ctx.tearParams
    tearParams.tearHeight = tearParams.tearHeight * multi
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param flags TearFlags | integer
function Ops.set_flags(ctx, flags)
    local tearParams = ctx.tearParams
    tearParams.tearFlags = tearParams.tearFlags | flags
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param variant TearVariant | integer
function Ops.set_tear_variant(ctx, variant)
    ctx.tearParams.tearVariant = variant
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param color Isaac.VarColor
function Ops.set_color(ctx, color)
    local tearColor = ctx.tearParams.tearColor
    local tint = color.tint
    local offset = color.offset
    local colorize = color.colorize

    if tint then
        tearColor:SetTint(tint.R, tint.G, tint.B, tint.A)
    end

    if offset then
        tearColor:SetOffset(offset.R, offset.G, offset.B)
    end

    if colorize then
        tearColor:SetColorize(colorize.R, colorize.G, colorize.B, colorize.A)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param tint Isaac.Color.Tint
function Ops.set_tint(ctx, tint)
    ctx.tearParams.tearColor:SetTint(tint.R, tint.G, tint.B, tint.A)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param offset Isaac.Color.Offset
function Ops.set_color_offset(ctx, offset)
    ctx.tearParams.tearColor:SetOffset(offset.R, offset.G, offset.B)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param colorize Isaac.Color.Colorize
function Ops.set_colorize(ctx, colorize)
    ctx.tearParams.tearColor:SetColorize(colorize.R, colorize.G, colorize.B, colorize.A)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param multi number
function Ops.knockback_multiply(ctx, multi)
    ctx.tearParams.knockback = ctx.tearParams.knockback * multi
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param value number
function Ops.set_height(ctx, value)
    ctx.tearParams.height = value
end

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
function Ops.is_left_eye(ctx)
    return ctx.leftEyeBonus
end

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
function Ops.is_right_eye(ctx)
    return ctx.rightEyeBonus
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param value boolean
function Ops.set_blood_tears(ctx, value)
    ctx.isBloodTear = value
end

return Ops