--#region Dependencies

local MathUtils = require("General.Math")
local IsaacUtils = require("Isaac.Utils.Common")
local Constants = require("Isaac.Constants")
local BitSet128Utils = require("General.VanillaAPI.BitSet128")
local ColorUtils = require("General.VanillaAPI.Color")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local ITemporaryEffects = require("Isaac.Interface.TemporaryEffects")
local PlayerProperties = require("Isaac.Content.Player.Properties.Misc")

local ITearParams = IEntityPlayer.TearParams

--#endregion

---@class Player.Blackboard.GetTearHitParams
---@field tearParams Component.Entity.Player.TearParams
---@field player Component.Entity.Player
---@field familiar Component.Entity.Familiar?
---@field weaponType WeaponType | integer
---@field leftEyeBonus boolean
---@field rightEyeBonus boolean
---@field isBloodTear boolean
---@field baseDamage number

local BITSET_ZERO = Constants.BITSET_ZERO

local COLOR_BABY_BENDER = Color(0.4, 0.15, 0.38, 1.0, 55/255, 5/255, 95/255)
local COLOR_POISON = Color(0.5, 0.97, 0.5, 1.0, 0.0, 0.0, 0.0)
local COLOR_PUSH_PIN = Color(1.5, 2.0, 2.0, 0.5, 0.0, 0.0, 0.0)
local COLOR_MOMS_CONTACT = Color(1.25, 0.05, 0.15, 1.0, 0.0, 0.0, 0.0)
local COLOR_SPIDER_BITE = Color(2.0, 2.0, 2.0, 1.0, 50/255, 50/255, 50/255)
local COLOR_GISH_SLOW = Color(0.15, 0.15, 0.15, 1.0, 0.0, 0.0, 0.0)
local COLOR_COMMON_COLD = Color(0.4, 0.97, 0.5, 1.0, 0.0, 0.0, 0.0)
local COLOR_MOMS_EYESHADOW = Color(1.0, 0.0, 1.0, 1.0, 50/255, 0.0, 0.0)
local COLOR_IRON_BAR = Color(0.5, 0.5, 0.5, 1.0, 0.0, 0.0, 0.0)
local COLOR_ABADDON = Color(100/255, 100/255, 100/255, 1.0, 0.0, 0.0, 0.0)
local COLOR_MOMS_PERFUME = Color(1.0, 1.0, 116/255, 1.0, 43/255, 37/255, 0.0)
local COLOR_BABY_BEGOTTEN = Constants.COLOR_MOD_BLACK
local COLOR_ACID = Color(1.0, 1.0, 0.1, 1.0)
local COLOR_BLOOD_CLOT = Constants.COLOR_MOD_RED
local COLOR_STYE = Color(1.5, 2.0, 2.0, 1.0)
local COLOR_EXPLOSIVO = Color(0.2, 0.09, 0.065, 1.0)
local COLOR_GODS_FLESH = Color(0.6, 0.7, 1.0, 1.0)
local COLOR_SUPER_BALL = Color(1.0, 1.0, 0.8, 1.0, 0.1, 0.1, 0.1)
local COLOR_SCORPIO = Color(50/255, 1.0, 50/255, 1.0)
local COLOR_LITTLE_HORN = Constants.COLOR_MOD_BLACK
local COLOR_ROTTEN_TOMATO = Color(0.7, 0.14, 0.1, 1.0, 0.3, 0.0, 0.0)
local COLOR_OCULAR_RIFT = Constants.COLOR_MOD_BLACK

--#region Ops

---@param ctx Player.Blackboard.GetTearHitParams
---@param playerType PlayerType | integer
---@return boolean
local function is_player_type(ctx, playerType)
    return ctx.player.m_playerType == playerType
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param babyType BabySubType | integer
---@return boolean
local function is_baby_type(ctx, babyType)
    local player = ctx.player
    return player.m_variant == PlayerVariant.CO_OP_BABY and player.m_babySkin == babyType
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param collectible CollectibleType | integer
---@return boolean
local function has_collectible(ctx, collectible)
    return IEntityPlayer.HasCollectible(ctx.player, collectible, false)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param collectible CollectibleType | integer
---@return boolean
local function has_collectible_or_effect(ctx, collectible)
    local player = ctx.player
    return IEntityPlayer.HasCollectible(player, collectible, false)
        or ITemporaryEffects.HasCollectibleEffect(player.m_temporaryEffects, collectible)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param collectible CollectibleType | integer
---@return boolean
local function has_zodiac_collectible(ctx, collectible)
    local player = ctx.player
    return IEntityPlayer.HasCollectible(player, collectible, false)
        or IEntityPlayer.GetZodiacEffect(player) == collectible
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param trinket TrinketType | integer
---@return boolean
local function has_trinket(ctx, trinket)
    return IEntityPlayer.HasTrinket(ctx.player, trinket, false)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param collectible CollectibleType | integer
---@return boolean
local function has_collectible_effect(ctx, collectible)
    return ITemporaryEffects.HasCollectibleEffect(ctx.player.m_temporaryEffects, collectible)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param trinket TrinketType | integer
---@return boolean
local function has_trinket_effect(ctx, trinket)
    return ITemporaryEffects.HasTrinketEffect(ctx.player.m_temporaryEffects, trinket)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param effect NullItemID | integer
---@return boolean
local function has_null_effect(ctx, effect)
    return ITemporaryEffects.HasNullEffect(ctx.player.m_temporaryEffects, effect)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param variant TearVariant | integer
---@return boolean
local function is_tear_variant(ctx, variant)
    return ctx.tearParams.tearVariant == variant
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param variants (TearVariant | integer)[]
---@return boolean
local function is_any_tear_variant(ctx, variants)
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
local function has_flags(ctx, flags)
    return (ctx.tearParams.tearFlags & flags) ~= BITSET_ZERO
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param weapon WeaponType | integer
---@return boolean
local function is_weapon_type(ctx, weapon)
    return ctx.weaponType == weapon
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param weapons (WeaponType | integer)[]
---@return boolean
local function is_any_weapon_type(ctx, weapons)
    local weaponType = ctx.weaponType
    for i = 1, #weapons, 1 do
        if weaponType == weapons[i] then
            return true
        end
    end

    return false
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param collectible CollectibleType | integer
local function collectible_left_eye(ctx, collectible)
    return has_collectible(ctx, collectible) and ctx.leftEyeBonus
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param collectible CollectibleType | integer
local function collectible_effect_right_eye(ctx, collectible)
    return has_collectible_effect(ctx, collectible) and ctx.rightEyeBonus
end

---@param numerator integer
---@param denominator integer
---@return boolean
local function static_chance(numerator, denominator)
    return IsaacUtils.RandomInt(denominator) < numerator
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param numerator integer
---@param max integer
---@param min integer
---@param step number
---@return boolean
local function luck_based_chance(ctx, numerator, max, min, step)
    local chance = math.max(max - math.floor(ctx.player.m_luck * step), min)
    return IsaacUtils.RandomInt(chance) < numerator
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param value number
local function damage_add(ctx, value)
    local tearParams = ctx.tearParams
    tearParams.tearDamage = tearParams.tearDamage + value
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param multi number
local function damage_multiply(ctx, multi)
    local tearParams = ctx.tearParams
    tearParams.tearDamage = tearParams.tearDamage * multi
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param multi number
local function base_damage_multiply(ctx, multi)
    local tearParams = ctx.tearParams
    tearParams.tearDamage = math.max(tearParams.tearDamage, ctx.baseDamage * multi)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param multi number
local function scale_multiply(ctx, multi)
    local tearParams = ctx.tearParams
    tearParams.tearScale = tearParams.tearScale * multi
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param multi number
local function speed_multiply(ctx, multi)
    local tearParams = ctx.tearParams
    tearParams.speed = tearParams.speed * multi
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param value number
local function tear_height_add(ctx, value)
    local tearParams = ctx.tearParams
    tearParams.tearHeight = tearParams.tearHeight + value
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param multi number
local function tear_height_multiply(ctx, multi)
    local tearParams = ctx.tearParams
    tearParams.tearHeight = tearParams.tearHeight * multi
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param flags TearFlags | integer
local function set_flags(ctx, flags)
    local tearParams = ctx.tearParams
    tearParams.tearFlags = tearParams.tearFlags | flags
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param flags TearFlags | integer
local function clear_flags(ctx, flags)
    local tearParams = ctx.tearParams
    tearParams.tearFlags = tearParams.tearFlags & ~flags
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param variant TearVariant | integer
local function set_tear_variant(ctx, variant)
    ctx.tearParams.tearVariant = variant
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param color Color
local function set_color(ctx, color)
    local tearParams = ctx.tearParams
    tearParams.tearColor = ColorUtils.Copy(color)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param color Color
local function set_color_tint(ctx, color)
    ColorUtils.SetColorTint(ctx.tearParams.tearColor, color)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param color Color
local function set_color_tint_offset(ctx, color)
    local tearColor = ctx.tearParams.tearColor
    ColorUtils.SetColorTint(tearColor, color)
    ColorUtils.SetColorOffset(tearColor, color)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param r number
---@param g number
---@param b number
---@param a number
local function set_color_colorize(ctx, r, g, b, a)
    ctx.tearParams.tearColor:SetColorize(r, g, b, a)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param color Color
local function set_color_no_bomb(ctx, color)
    local tearColor = ctx.tearParams.tearColor
    if ctx.weaponType ~= WeaponType.WEAPON_BOMBS then
        ColorUtils.SetColorTint(tearColor, color)
    end
    ColorUtils.SetColorOffset(tearColor, color)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param multi number
local function knockback_multiply(ctx, multi)
    ctx.tearParams.knockback = ctx.tearParams.knockback * multi
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param value number
local function set_height(ctx, value)
    ctx.tearParams.height = value
end

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
local function is_left_eye(ctx)
    return ctx.leftEyeBonus
end

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
local function is_right_eye(ctx)
    return ctx.rightEyeBonus
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param value boolean
local function set_blood_tears(ctx, value)
    ctx.isBloodTear = value
end

--#endregion

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
local function RedStew_has_blood_tears(ctx)
    return ctx.player.m_redStew_bonusDuration > 90
end

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
local function BloodBaby_has_blood_tears(ctx)
    local familiar = ctx.familiar
    if not familiar then return false end
    if not familiar.m_variant ~= FamiliarVariant.BLOOD_BABY then return false end

    local subtype = familiar.m_subtype
    return subtype == BloodClotSubtype.RED or subtype == BloodClotSubtype.ROTTEN or subtype == BloodClotSubtype.LIL_CLOT
end

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
local function DecapAttack_is_buffed(ctx)
    return has_collectible_effect(ctx, CollectibleType.COLLECTIBLE_DECAP_ATTACK) and has_collectible(ctx, CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE)
end

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
---@param bonusValue integer
local function PlaydoughCookie_PurpleEffect(ctx, bonusValue)
    set_flags(ctx, IsaacUtils.RandomInt(2) == 0 and TearFlags.TEAR_TURN_HORIZONTAL or TearFlags.TEAR_HOMING)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param bonusValue integer
local function PlaydoughCookie_GreenEffect(ctx, bonusValue)
    set_flags(ctx, TearFlags.TEAR_POISON)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param bonusValue integer
local function PlaydoughCookie_RedEffect(ctx, bonusValue)
    if IsaacUtils.RandomInt(2) ~= 0 then
        damage_multiply(ctx, 2.0)
    elseif bonusValue < 2 then
        set_flags(ctx, TearFlags.TEAR_FREEZE)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param bonusValue integer
local function PlaydoughCookie_YellowEffect(ctx, bonusValue)
    if bonusValue < 3 then
        set_flags(ctx, TearFlags.TEAR_FEAR)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param bonusValue integer
local function PlaydoughCookie_PinkEffect(ctx, bonusValue)
    if bonusValue < 3 then
        set_flags(ctx, TearFlags.TEAR_CHARM)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param bonusValue integer
local function PlaydoughCookie_DarkOrangeEffect(ctx, bonusValue)
    if IsaacUtils.RandomInt(2) ~= 0 and bonusValue <= 2 then
        set_flags(ctx, TearFlags.TEAR_BAIT)
    elseif bonusValue < 4 then
        set_flags(ctx, TearFlags.TEAR_BURN)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param bonusValue integer
local function PlaydoughCookie_LightBlueEffect(ctx, bonusValue)
    if IsaacUtils.RandomInt(2) ~= 0 and bonusValue <= 2 then
        set_flags(ctx, TearFlags.TEAR_SLOW)
    else
        set_flags(ctx, TearFlags.TEAR_ICE)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
---@param bonusValue integer
local function PlaydoughCookie_BlueEffect(ctx, bonusValue)
    if bonusValue < 2 then
        set_flags(ctx, TearFlags.TEAR_SHRINK)
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

local PLAYDOUGH_COOKIE_EFFECTS_DEFAULT = {color = {R = 0.7, G = 0.6, B = 0.4}, fn = function() end}


---@param ctx Player.Blackboard.GetTearHitParams
local function BloodBaby_BlackTearEffects(ctx)
    set_tear_variant(ctx, TearVariant.DARK_MATTER)
    damage_multiply(ctx, 1.25)
    scale_multiply(ctx, 1.1)
    set_flags(ctx, TearFlags.TEAR_DARK_MATTER)

    if luck_based_chance(ctx, 1, 5, 1, 0.1) then
        set_flags(ctx, TearFlags.TEAR_FEAR)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
local function BloodBaby_EternalTearEffects(ctx)
    damage_multiply(ctx, 1.5)
    scale_multiply(ctx, 1.3)
    set_flags(ctx, TearFlags.TEAR_HOMING)
end

---@param ctx Player.Blackboard.GetTearHitParams
local function BloodBaby_GoldTearEffects(ctx)
    if luck_based_chance(ctx, 1, 9, 3, 0.25) then
        set_flags(ctx, TearFlags.TEAR_MIDAS)
    end

    ColorUtils.MultiplyCompound(ctx.tearParams.tearColor, Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 2.0, 1.0, 0.0, 1.0))
end

---@param ctx Player.Blackboard.GetTearHitParams
local function BloodBaby_BoneTearEffects(ctx)
    set_flags(ctx, TearFlags.TEAR_BONE)
    set_tear_variant(ctx, TearVariant.BONE)
end

---@param ctx Player.Blackboard.GetTearHitParams
local function BloodBaby_RottenTearEffects(ctx)
    set_flags(ctx, TearFlags.TEAR_MULLIGAN)
end

local BLOOD_BABY_SUBTYPE = {
    [BloodClotSubtype.BLACK] = BloodBaby_BlackTearEffects,
    [BloodClotSubtype.ETERNAL] = BloodBaby_EternalTearEffects,
    [BloodClotSubtype.GOLD] = BloodBaby_GoldTearEffects,
    [BloodClotSubtype.BONE] = BloodBaby_BoneTearEffects,
    [BloodClotSubtype.ROTTEN] = BloodBaby_RottenTearEffects,
}

---@param ctx Player.Blackboard.GetTearHitParams
local function GFuel_BuckshotEffect(ctx)
    set_flags(ctx, TearFlags.TEAR_BOUNCE_WALLSONLY | TearFlags.TEAR_DECELERATE)
end

---@param ctx Player.Blackboard.GetTearHitParams
local function GFuel_SlugShotgunEffect(ctx)
    scale_multiply(ctx, 2.0)
    damage_multiply(ctx, 4.0)
    set_flags(ctx, TearFlags.TEAR_BOUNCE_WALLSONLY | TearFlags.TEAR_DECELERATE)
end

---@param ctx Player.Blackboard.GetTearHitParams
local function GFuel_MinigunEffect(ctx)
    damage_multiply(ctx, 0.6)
end

---@param ctx Player.Blackboard.GetTearHitParams
local function GFuel_RocketLauncherEffect(ctx)
    damage_multiply(ctx, 4.0)
    set_flags(ctx, TearFlags.TEAR_ACCELERATE | TearFlags.TEAR_EXPLOSIVE)
    set_tear_variant(ctx, TearVariant.NAIL_BLOOD)
end

local G_FUEL_WEAPON_EFFECTS = {
    [2] = GFuel_BuckshotEffect,
    [3] = GFuel_SlugShotgunEffect,
    [4] = GFuel_MinigunEffect,
    [5] = GFuel_RocketLauncherEffect,
}

local BLOOD_VARIANT = {
    [TearVariant.BLUE] = TearVariant.BLOOD,
    [TearVariant.CUPID_BLUE] = TearVariant.CUPID_BLOOD,
    [TearVariant.NAIL] = TearVariant.NAIL_BLOOD,
    [TearVariant.PUPULA] = TearVariant.PUPULA_BLOOD,
    [TearVariant.GODS_FLESH] = TearVariant.GODS_FLESH_BLOOD,
    [TearVariant.GLAUCOMA] = TearVariant.GLAUCOMA_BLOOD,
    [TearVariant.EYE] = TearVariant.EYE_BLOOD
}

-- in-game the rules are not setup this way, but they do not depend or alter state, so the reorder doesn't cause issues
local BLOOD_TEARS_RULES = {
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_CHOCOLATE_MILK}, value = false},
    {condition = is_tear_variant, args = {TearVariant.BLOOD}, value = true},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_KIDNEY_STONE}, value = true},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_APPLE}, value = true},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_EYE_OF_BELIAL}, value = true},
    {condition = collectible_left_eye, args = {CollectibleType.COLLECTIBLE_LEAD_PENCIL}, value = true},
    {condition = collectible_left_eye, args = {CollectibleType.COLLECTIBLE_PEEPER}, value = true},
    {condition = is_player_type, args = {PlayerType.PLAYER_LAZARUS2}, value = true},
    {condition = is_player_type, args = {PlayerType.PLAYER_BLACKJUDAS}, value = true},
    {condition = RedStew_has_blood_tears, args = {}, value = true },
    {condition = collectible_effect_right_eye, args = {CollectibleType.COLLECTIBLE_SCOOPER}, value = true},
    {condition = is_player_type, args = {PlayerType.PLAYER_ESAU}, value = true},
    {condition = is_player_type, args = {PlayerType.PLAYER_JUDAS_B}, value = true},
    {condition = is_player_type, args = {PlayerType.PLAYER_LAZARUS2_B}, value = true},
    {condition = is_player_type, args = {PlayerType.PLAYER_BETHANY_B}, value = true},
    {condition = BloodBaby_has_blood_tears, args = {}, value = true},
    {condition = has_null_effect, args = {NullItemID.ID_BLOOD_OATH}, value = true},
    {condition = has_null_effect, args = {NullItemID.ID_INTRUDER}, value = true},
    {condition = has_null_effect, args = {NullItemID.ID_JUDAS_BIRTHRIGHT}, value = true},
    {condition = has_null_effect, args = {NullItemID.ID_JUDAS_BIRTHRIGHT_TIMED}, value = true},
    {condition = has_null_effect, args = {NullItemID.ID_JUDAS_BIRTHRIGHT_STAGE}, value = true},
    {condition = has_null_effect, args = {NullItemID.ID_JUDAS_BIRTHRIGHT_PERMANENT}, value = true},
    {condition = has_null_effect, args = {NullItemID.ID_ESAU_JR}, value = true},
    {condition = DecapAttack_is_buffed, args = {}, value = true},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_SOY_MILK}, value = false},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_ALMOND_MILK}, value = false},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_ABADDON}, value = true},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_MONSTROS_LUNG}, value = true},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR}, value = true},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_STIGMATA}, value = true},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_PACT}, value = true},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_TOOTH_PICKS}, value = true},
    {condition = is_baby_type, args = {BabySubType.BABY_SHADOW}, value = true},
    {condition = has_collectible_effect, args = {CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL}, value = true},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_SMALL_ROCK}, value = true},
    {condition = has_collectible_effect, args = {CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON}, value = true},
    {condition = has_collectible_effect, args = {CollectibleType.COLLECTIBLE_RAZOR_BLADE}, value = true},
    {condition = has_trinket_effect, args = {TrinketType.TRINKET_RED_PATCH}, value = true},
    {condition = has_collectible_effect, args = {CollectibleType.COLLECTIBLE_VARICOSE_VEINS}, value = true},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID}, value = true},
    {condition = has_collectible_effect, args = {CollectibleType.COLLECTIBLE_THE_NAIL}, value = true},
}

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
local function TearHitParams_HasNoLeftEye(ctx)
    return ctx.familiar ~= nil
        or not IEntityPlayer.HasWeaponType(ctx.player, WeaponType.WEAPON_TEARS)
        or PlayerProperties.IsLeftEyeBlocked(ctx.player)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
local function TearHitParams_HasBloodTears(ctx)
    for i = 1, #BLOOD_TEARS_RULES, 1 do
        local rule = BLOOD_TEARS_RULES[i]
        if rule.condition(ctx, table.unpack(rule.args)) then
            return rule.value
        end
    end

    return false
end

---@param player Component.Entity.Player
---@param weaponType WeaponType | integer
---@param damageScale number
---@param tearDisplacement integer
---@param source Component.Entity?
---@return Component.Entity.Player.TearParams
local function GetTearHitParams(player, weaponType, damageScale, tearDisplacement, source)
    local familiar = source and IEntity.ToFamiliar(source)

    local tearParams = ITearParams.New()
    tearParams.tearVariant = TearVariant.BLUE
    tearParams.tearDamage = player.m_damage * damageScale
    tearParams.tearHeight = player.m_tearHeight
    tearParams.tearFlags = BitSet128Utils.Copy(player.m_tearFlags)
    tearParams.tearColor = ColorUtils.Copy(player.m_tearColor)
    tearParams.tearScale = 1.0
    tearParams.knockback = 1.0
    tearParams.height = 1.7

    ---@type Player.Blackboard.GetTearHitParams
    local ctx = {
        tearParams = tearParams,
        player = player,
        familiar = familiar,
        weaponType = weaponType,
        baseDamage = 0.0, -- uninitialized
        leftEyeBonus = false, -- uninitialized
        rightEyeBonus = false, -- uninitialized
        isBloodTear = false, -- uninitialized
    }

    if familiar ~= nil then
        if familiar.m_variant == FamiliarVariant.BLOOD_BABY then
            damage_multiply(ctx, 0.35)
        else
            if familiar.m_variant == FamiliarVariant.TWISTED_BABY then
                damage_multiply(ctx, 0.5)
            end

            if (player.m_playerType ~= PlayerType.PLAYER_LILITH and player.m_playerType ~= PlayerType.PLAYER_LILITH_B) then
                damage_multiply(ctx, 0.75)
            end
        end

        if IEntityPlayer.HasCollectible(player, CollectibleType.COLLECTIBLE_BFFS, false) then
            damage_multiply(ctx, 2.0)
        end

        if IEntityPlayer.HasTrinket(player, TrinketType.TRINKET_BABY_BENDER, false) and (tearParams.tearFlags & TearFlags.TEAR_HOMING) == BITSET_ZERO then
            set_flags(ctx, TearFlags.TEAR_HOMING)
            set_color(ctx, COLOR_BABY_BENDER)
        end

        if familiar.m_isLilDelirum then
            set_color_colorize(ctx, 2.4, 2.4, 2.4, 1.0)
            set_tear_variant(ctx, TearVariant.BLOOD)
        end
    end

    if is_player_type(ctx, PlayerType.PLAYER_EVE_B) then
        scale_multiply(ctx, 0.8)
    end

    ctx.baseDamage = tearParams.tearDamage
    local scaleMultiplier = 1.0

    if has_trinket(ctx, TrinketType.TRINKET_PINKY_EYE) and luck_based_chance(ctx, 1, 10, 1, 0.5) then
        set_flags(ctx, TearFlags.TEAR_POISON)
        set_color_no_bomb(ctx, COLOR_POISON)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_SERPENTS_KISS) and static_chance(15, 100) then
        set_flags(ctx, TearFlags.TEAR_POISON)
        set_color_no_bomb(ctx, COLOR_POISON)
    end

    if has_trinket(ctx, TrinketType.TRINKET_PUSH_PIN) and luck_based_chance(ctx, 1, 10, 1, 0.5) then
        set_flags(ctx, TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL)
        set_color_tint_offset(ctx, COLOR_PUSH_PIN)
        set_tear_variant(ctx, TearVariant.CUPID_BLUE)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_MOMS_CONTACTS) and luck_based_chance(ctx, 1, 5, 2, 0.15) then
        set_flags(ctx, TearFlags.TEAR_FREEZE)
        set_color_tint_offset(ctx, COLOR_MOMS_CONTACT)
    end

    if has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_HOLY_LIGHT) and luck_based_chance(ctx, 1, 10, 2, 0.9) then
        set_flags(ctx, TearFlags.TEAR_LIGHT_FROM_HEAVEN)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_SPIDER_BITE) and luck_based_chance(ctx, 1, 4, 1, 0.2) then
        set_color_tint_offset(ctx, COLOR_SPIDER_BITE)
        set_flags(ctx, TearFlags.TEAR_SLOW)
    end

    local gishSlowEffect = (has_collectible(ctx, CollectibleType.COLLECTIBLE_BALL_OF_TAR) and luck_based_chance(ctx, 1, 10, 1, 0.5))
        or (has_trinket(ctx, TrinketType.TRINKET_CHEWED_PEN) and luck_based_chance(ctx, 1, 10, 1, 0.5))

    if gishSlowEffect then
        set_flags(ctx, TearFlags.TEAR_GISH | TearFlags.TEAR_SLOW)
        set_color_tint_offset(ctx, COLOR_GISH_SLOW)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_COMMON_COLD) and luck_based_chance(ctx, 1, 4, 1, 0.25) then
        set_flags(ctx, TearFlags.TEAR_POISON)
        set_color_tint_offset(ctx, COLOR_COMMON_COLD)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_MOMS_EYESHADOW) and luck_based_chance(ctx, 1, 10, 1, 0.334) then
        set_color_tint_offset(ctx, COLOR_MOMS_EYESHADOW)
        set_flags(ctx, TearFlags.TEAR_CHARM)
    end

    if has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_IRON_BAR) and luck_based_chance(ctx, 1, 10, 1, 0.334) then
        set_color_tint_offset(ctx, COLOR_IRON_BAR)
        set_flags(ctx, TearFlags.TEAR_CONFUSION)
    end

    if has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_FRUIT_CAKE) then
        local randomFlag = IsaacUtils.RandomInt(TearFlags.TEAR_EFFECT_COUNT)
        local excluded = TearFlags.TEAR_BLACK_HP_DROP | TearFlags.TEAR_GLITTER_BOMB
            | TearFlags.TEAR_BUTT_BOMB | TearFlags.TEAR_SAD_BOMB
            | TearFlags.TEAR_TRACTOR_BEAM | TearFlags.TEAR_SCATTER_BOMB
        local addedFlag = BitSet128Utils.NewFromFlag(randomFlag) & ~excluded -- if flag is excluded then no flag is added
        set_flags(ctx, addedFlag)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_ALMOND_MILK) then
        tearParams.tearScale = tearParams.tearScale * 0.7
    elseif has_collectible(ctx, CollectibleType.COLLECTIBLE_SOY_MILK) then
        tearParams.tearScale = tearParams.tearScale * 0.5
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_DEAD_ONION) then
        tearParams.tearScale = tearParams.tearScale * 1.5
    end

    --local isBloodTear = tearParams.tearVariant == TearVariant.BLOOD (is now in BLOOD_TEARS_RULES)

    local leftEyeBonus = false
    local rightEyeBonus = false
    tearParams.tearDisplacement = 0

    if tearDisplacement < 0 or (TearHitParams_HasNoLeftEye(ctx) and IsaacUtils.RandomInt(2) == 0) then
        leftEyeBonus = true
        tearParams.tearDisplacement = -1
    elseif tearDisplacement > 0 then
        rightEyeBonus = true
        tearParams.tearDisplacement = 1
    end

    local isBloodTear = TearHitParams_HasBloodTears(ctx)

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_LACHRYPHAGY) and (weaponType == WeaponType.WEAPON_TEARS or weaponType == WeaponType.WEAPON_MONSTROS_LUNGS) then
        set_tear_variant(ctx, TearVariant.HUNGRY)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_GLAUCOMA) and static_chance(1, 20) then
        set_flags(ctx, TearFlags.TEAR_PERMANENT_CONFUSION)
        set_tear_variant(ctx, TearVariant.GLAUCOMA)
    end

    if (has_collectible(ctx, CollectibleType.COLLECTIBLE_MOMS_PERFUME) or has_collectible(ctx, CollectibleType.COLLECTIBLE_ABADDON)) and luck_based_chance(ctx, 15, 100, 1, 1.0) then
        if has_collectible(ctx, CollectibleType.COLLECTIBLE_ABADDON) then
            set_color_tint_offset(ctx, COLOR_ABADDON)
        elseif has_collectible(ctx, CollectibleType.COLLECTIBLE_MOMS_PERFUME) then
            set_color_tint_offset(ctx, COLOR_MOMS_PERFUME)
        end

        set_flags(ctx, TearFlags.TEAR_FEAR)
    end

    if is_baby_type(ctx, BabySubType.BABY_BEGOTTEN) then
        if static_chance(1, 30) then
            set_flags(ctx, TearFlags.TEAR_FEAR)
        end

        tearParams.tearScale = tearParams.tearScale * 2.0
        set_color_tint_offset(ctx, COLOR_BABY_BEGOTTEN)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_PEEPER) and is_left_eye(ctx) then
        set_blood_tears(ctx, true)
        damage_multiply(ctx, 1.35)
    end

    if has_collectible_effect(ctx, CollectibleType.COLLECTIBLE_SCOOPER) and is_right_eye(ctx) then
        set_blood_tears(ctx, true)
        damage_multiply(ctx, 1.35)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_CHEMICAL_PEEL) and is_left_eye(ctx) then
        set_blood_tears(ctx, true)
        damage_add(ctx, 2.0)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_SULFURIC_ACID) and static_chance(1, 4) then
        set_flags(ctx, TearFlags.TEAR_ACID)
        set_color_tint(ctx, COLOR_ACID)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_BLOOD_CLOT) and is_left_eye(ctx) then
        set_color_tint_offset(ctx, COLOR_BLOOD_CLOT)
        damage_add(ctx, 1.0)
        scale_multiply(ctx, 1.25)
        tear_height_add(ctx, -10.0)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_STYE) and is_right_eye(ctx) then
        set_color_tint_offset(ctx, COLOR_STYE)
        damage_multiply(ctx, 1.2857143)
        scale_multiply(ctx, 1.25)
        speed_multiply(ctx, 0.8)
    end

    if has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_PROPTOSIS) then
        scale_multiply(ctx, 3.0)
    end

    if has_zodiac_collectible(ctx, CollectibleType.COLLECTIBLE_PISCES) then
        scale_multiply(ctx, 1.25)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_CUPIDS_ARROW) or has_zodiac_collectible(ctx, CollectibleType.COLLECTIBLE_SAGITTARIUS) then
        set_tear_variant(ctx, TearVariant.CUPID_BLUE)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_8_INCH_NAILS) then
        set_tear_variant(ctx, TearVariant.NAIL)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_PUPULA_DUPLEX) then
        set_tear_variant(ctx, TearVariant.PUPULA)
        scale_multiply(ctx, 3.0)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_TROPICAMIDE) then
        tearParams.tearScale = (tearParams.tearScale + 0.2) * 1.25
    end

    if has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_URANUS) then
        set_tear_variant(ctx, TearVariant.ICE)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_TERRA) then
        set_tear_variant(ctx, TearVariant.ROCK)
        local randomExponent = (IsaacUtils.RandomFloat() * 2.0) - 1.0 -- [-1, 1] (equal chance to reduce or increase)
        scale_multiply(ctx, 2.0 ^ (randomExponent * 0.2))
        damage_multiply(ctx, 2.0 ^ randomExponent)
    end

    if has_null_effect(ctx, NullItemID.ID_REVERSE_HANGED_MAN) then
        set_flags(ctx, TearFlags.TEAR_COIN_DROP_DEATH)
    end

    if has_collectible_effect(ctx, CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT) then
        set_tear_variant(ctx, TearVariant.DIAMOND)
    end

    if has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR) then
        set_tear_variant(ctx, TearVariant.METALLIC)
    end

    if has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_EUTHANASIA) and luck_based_chance(ctx, 1, 30, 4, 2.0) then
        set_tear_variant(ctx, TearVariant.NEEDLE)
        set_flags(ctx, TearFlags.TEAR_NEEDLE)
        damage_multiply(ctx, 3.0)
    end

    local boogerEffect = (has_collectible(ctx, CollectibleType.COLLECTIBLE_SINUS_INFECTION) and static_chance(1, 5))
        or (has_trinket(ctx, TrinketType.TRINKET_NOSE_GOBLIN) and static_chance(1, 10))
    if boogerEffect then
        set_tear_variant(ctx, TearVariant.BOOGER)
        set_flags(ctx, TearFlags.TEAR_BOOGER)

        if has_trinket(ctx, TrinketType.TRINKET_NOSE_GOBLIN) and static_chance(1, 2) then
            set_flags(ctx, TearFlags.TEAR_HOMING)
        end
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_MUCORMYCOSIS) and static_chance(1, 4) then
        set_tear_variant(ctx, TearVariant.SPORE)
        set_flags(ctx, TearFlags.TEAR_SPORE)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_EXPLOSIVO) and static_chance(1, 4) then
        set_flags(ctx, TearFlags.TEAR_STICKY)

        if is_any_tear_variant(ctx, {TearVariant.BLUE, TearVariant.BLOOD, TearVariant.CUPID_BLUE, TearVariant.CUPID_BLOOD}) then
            set_tear_variant(ctx, TearVariant.EXPLOSIVO)
        else
            set_color_tint_offset(ctx, COLOR_EXPLOSIVO)
        end
    end

    if has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_LOST_CONTACT) then
        set_tear_variant(ctx, TearVariant.LOST_CONTACT)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE) then
        set_tear_variant(ctx, TearVariant.BONE)
    end

    if has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_GODS_FLESH) and static_chance(1, 10) then
        set_tear_variant(ctx, TearVariant.GODS_FLESH)
        set_flags(ctx, TearFlags.TEAR_GODS_FLESH)

        if not is_weapon_type(ctx, WeaponType.WEAPON_TEARS) then
            set_color(ctx, COLOR_GODS_FLESH)
        end
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_POP) then
        local eyeVariant = ctx.isBloodTear and TearVariant.EYE_BLOOD or TearVariant.EYE
        set_tear_variant(ctx, eyeVariant)
    end

    if has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_DARK_MATTER) and luck_based_chance(ctx, 1, 3, 1, 0.1) then
        set_flags(ctx, TearFlags.TEAR_FEAR)
    end

    if has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER) and is_baby_type(ctx, BabySubType.BABY_SUPER_GREED) then
        set_tear_variant(ctx, TearVariant.COIN)
        set_flags(ctx, TearFlags.TEAR_GREED_COIN)
    end

    if has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_DEATHS_TOUCH) then
        set_tear_variant(ctx, TearVariant.SCHYTHE)
    end

    if has_trinket(ctx, TrinketType.TRINKET_SUPER_BALL) and static_chance(1, 10) then
        set_flags(ctx, TearFlags.TEAR_BOUNCE)
        set_color_tint_offset(ctx, COLOR_SUPER_BALL)
    end

    if has_zodiac_collectible(ctx, CollectibleType.COLLECTIBLE_SCORPIO) then
        set_color_tint_offset(ctx, COLOR_SCORPIO)
    end

    if has_trinket(ctx, TrinketType.TRINKET_BLACK_TOOTH) and luck_based_chance(ctx, 1, 33, 0, 1.0) then
        set_tear_variant(ctx, TearVariant.BLACK_TOOTH)
        base_damage_multiply(ctx, 2.0)
        set_flags(ctx, TearFlags.TEAR_POISON)
    end

    local toughLoveEffect = (has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_TOUGH_LOVE) and luck_based_chance(ctx, 1, 10, 0, 1.0))
        or (has_trinket(ctx, TrinketType.TRINKET_JAW_BREAKER) and luck_based_chance(ctx, 1, 10, 0, 1.0))

    if toughLoveEffect then
        set_tear_variant(ctx, TearVariant.TOOTH)
        base_damage_multiply(ctx, 3.2)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_APPLE) and luck_based_chance(ctx, 1, 15, 0, 1.0) then
        set_tear_variant(ctx, TearVariant.RAZOR)
        base_damage_multiply(ctx, 4.0)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_PARASITOID) and luck_based_chance(ctx, 1, 7, 2, 1.0) then
        set_tear_variant(ctx, TearVariant.EGG)
        set_flags(ctx, TearFlags.TEAR_EGG)
        tear_height_multiply(ctx, 2.0)
    end

    if has_trinket(ctx, TrinketType.TRINKET_OUROBOROS_WORM) and luck_based_chance(ctx, 1, 10, 1, 1.0) then
        set_flags(ctx, TearFlags.TEAR_HOMING)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_LITTLE_HORN) and luck_based_chance(ctx, 1, 20, 5, 1.0) then
        set_flags(ctx, TearFlags.TEAR_HORN)
        set_color(ctx, COLOR_LITTLE_HORN)
    end

    if has_collectible_effect(ctx, CollectibleType.COLLECTIBLE_GOLDEN_RAZOR) then
        local amount = ITemporaryEffects.GetCollectibleEffectNum(ctx.player.m_temporaryEffects, CollectibleType.COLLECTIBLE_GOLDEN_RAZOR) / 3.0
        local color = ctx.tearParams.tearColor

        local colorize = color:GetColorize()
        local offset = color:GetOffset()

        amount = MathUtils.Clamp(amount, 0.0, 0.9)

        colorize.R = MathUtils.Lerp(colorize.R, 2.0, amount)
        colorize.G = MathUtils.Lerp(colorize.G, 1.0, amount)
        colorize.B = MathUtils.Lerp(colorize.B, 0.0, amount)
        colorize.A = MathUtils.Lerp(colorize.A, 1.0, amount)
        offset.R = offset.R + (amount * 0.1)
        offset.G = offset.G + (amount * 0.05)

        color:SetColorize(colorize.R, colorize.G, colorize.B, colorize.A)
        color:SetOffset(offset.R, offset.G, offset.B)
    end

    if is_weapon_type(ctx, WeaponType.WEAPON_BOMBS) or is_weapon_type(ctx, WeaponType.WEAPON_ROCKETS) then
        set_flags(ctx, IEntityPlayer.GetBombFlags(ctx.player, true))
    end

    if not is_weapon_type(ctx, WeaponType.WEAPON_TEARS) and not is_weapon_type(ctx, WeaponType.WEAPON_FETUS) then
        if has_collectible(ctx, CollectibleType.COLLECTIBLE_HAEMOLACRIA) then
            set_flags(ctx, TearFlags.TEAR_BURSTSPLIT)
        end
    else
        if has_flags(ctx, TearFlags.TEAR_EXPLOSIVE) and not has_flags(ctx, TearFlags.TEAR_LUDOVICO) then
            scaleMultiplier = 0.5
        end

        if has_flags(ctx, TearFlags.TEAR_QUADSPLIT) and not has_flags(ctx, TearFlags.TEAR_LUDOVICO) then
            scale_multiply(ctx, 1.2)
        end

        if has_collectible(ctx, CollectibleType.COLLECTIBLE_HAEMOLACRIA) then
            set_tear_variant(ctx, TearVariant.BALLOON)

            if has_collectible(ctx, CollectibleType.COLLECTIBLE_BRIMSTONE) or has_collectible(ctx, CollectibleType.COLLECTIBLE_TECHNOLOGY) or has_collectible(ctx, CollectibleType.COLLECTIBLE_TECH_X) then
                set_tear_variant(ctx, TearVariant.BALLOON_BRIMSTONE)
            elseif has_collectible(ctx, CollectibleType.COLLECTIBLE_DR_FETUS) then
                set_tear_variant(ctx, TearVariant.BALLOON_BOMB)
            end

            scale_multiply(ctx, 1.71)
            set_flags(ctx, TearFlags.TEAR_BURSTSPLIT)
        elseif (is_player_type(ctx, PlayerType.PLAYER_THEFORGOTTEN) or is_player_type(ctx, PlayerType.PLAYER_THEFORGOTTEN_B)) and not is_tear_variant(ctx, TearVariant.SCHYTHE) then
            set_tear_variant(ctx, TearVariant.BONE)
        end

        if is_weapon_type(ctx, WeaponType.WEAPON_FETUS) then
            set_tear_variant(ctx, TearVariant.FETUS)
        end
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_LODESTONE) and luck_based_chance(ctx, 1, 6, 1, 1.0) then
        set_color_colorize(ctx, 0.5, 0.5, 0.5, 1.0)
        set_flags(ctx, TearFlags.TEAR_MAGNETIZE)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_ROTTEN_TOMATO) and luck_based_chance(ctx, 1, 6, 1, 1.0) then
        set_color_tint_offset(ctx, COLOR_ROTTEN_TOMATO)
        set_flags(ctx, TearFlags.TEAR_BAIT)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS) and luck_based_chance(ctx, 1, 10, 1, 1.0) then
        set_flags(ctx, TearFlags.TEAR_PUNCH)
        set_tear_variant(ctx, TearVariant.FIST)
        scale_multiply(ctx, 1.5)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_OCULAR_RIFT) and luck_based_chance(ctx, 1, 20, 5, 1.0) then
        set_flags(ctx, TearFlags.TEAR_RIFT)
        set_color(ctx, COLOR_OCULAR_RIFT)
    end

    if is_player_type(ctx, PlayerType.PLAYER_JACOB) then
        scale_multiply(ctx, 0.9)
    end

    if has_flags(ctx, TearFlags.TEAR_SHRINK) then
        damage_multiply(ctx, 3.0)
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_ALMOND_MILK) then
        local random = IsaacUtils.RandomFloat()
        local numFlags = 0.05 > random and 4
            or 0.1 > random and 3
            or 0.3 > random and 2
            or 0.8 > random and 1
            or 0

        local laserGroup = is_any_weapon_type(ctx, {WeaponType.WEAPON_LASER, WeaponType.WEAPON_BRIMSTONE, WeaponType.WEAPON_TECH_X})
        if laserGroup then
            numFlags = math.min(numFlags, 1)
        end

        if laserGroup then
            for i = 1, numFlags, 1 do
                local flag = ALMOND_MILK_LASER_EFFECTS[IsaacUtils.RandomInt(#ALMOND_MILK_LASER_EFFECTS) + 1]
                set_flags(ctx, flag)
            end
        else
            for i = 1, numFlags, 1 do
                local flag = ALMOND_MILK_EFFECTS[IsaacUtils.RandomInt(#ALMOND_MILK_EFFECTS) + 1]
                set_flags(ctx, flag)
            end
        end
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
        local maxEffectIdx = math.max(math.floor(11.0 - ctx.player.m_luck * 0.2), 6)
        local effectIdx = IsaacUtils.RandomInt(maxEffectIdx)

        local bonusChance = math.floor(6.0 - ctx.player.m_luck * 0.5)
        local bonusValue = IsaacUtils.RandomInt(bonusChance)
        local laserGroup = is_any_weapon_type(ctx, {WeaponType.WEAPON_LASER, WeaponType.WEAPON_BRIMSTONE, WeaponType.WEAPON_TECH_X})
        bonusValue = not laserGroup and bonusValue or 0

        local effect = PLAYDOUGH_COOKIE_EFFECTS[effectIdx + 1] or PLAYDOUGH_COOKIE_EFFECTS_DEFAULT
        effect.fn(ctx, bonusValue)
        local color = effect.color

        set_color_colorize(ctx, color.R, color.G, color.B, 1.5)
    end

    if is_weapon_type(ctx, WeaponType.WEAPON_BONE) and has_collectible_effect(ctx, CollectibleType.COLLECTIBLE_BERSERK) then
        set_flags(ctx, TearFlags.TEAR_EXTRA_GORE)
    end

    if familiar and familiar.m_variant == FamiliarVariant.BLOOD_BABY then
        local fn = BLOOD_BABY_SUBTYPE[familiar.m_subtype]
        if fn then
            fn(ctx)
        end
    end

    if has_collectible(ctx, CollectibleType.COLLECTIBLE_ALMOND_MILK) then
        knockback_multiply(ctx, 0.3)
    elseif has_collectible(ctx, CollectibleType.COLLECTIBLE_SOY_MILK) then
        knockback_multiply(ctx, 0.2)
    end

    if has_zodiac_collectible(ctx, CollectibleType.COLLECTIBLE_PISCES) or has_collectible(ctx, CollectibleType.COLLECTIBLE_8_INCH_NAILS)
        or has_trinket(ctx, TrinketType.TRINKET_BLISTER) or has_collectible(ctx, CollectibleType.COLLECTIBLE_TERRA) then
        knockback_multiply(ctx, 3.0)
    end

    if has_trinket(ctx, TrinketType.TRINKET_BLISTER) then
        set_height(ctx, 3.0)
    elseif has_collectible(ctx, CollectibleType.COLLECTIBLE_8_INCH_NAILS) or has_collectible(ctx, CollectibleType.COLLECTIBLE_TERRA) then
        set_height(ctx, 2.0)
    end

    local compressedScale = tearParams.tearScale > 1.0 and math.log(tearParams.tearScale) + 1.0 or tearParams.tearScale
    tearParams.tearScale = (math.sqrt(ctx.baseDamage) * 0.23 + compressedScale * 0.55 + ctx.baseDamage * 0.01) * scaleMultiplier

    if ctx.isBloodTear then
        tearParams.tearVariant = BLOOD_VARIANT[tearParams.tearVariant] or tearParams.tearVariant
    end

    if IEntityPlayer.IsHologram(ctx.player) then
        tearParams.tearColor.A = 0.2
    end

    local gFuelWeapon = IEntityPlayer.GetGFuelWeaponType(ctx.player)
    if gFuelWeapon ~= -1 then
        set_tear_variant(ctx, TearVariant.NAIL)
        local height = math.max(ctx.tearParams.height)
        set_height(ctx, height)

        local laserColor = ColorUtils.ApplyColorMod(Constants.COLOR_WHITE, ctx.player.m_laserColor)
        set_color(ctx, Color(laserColor.Red, laserColor.Green, laserColor.Blue, laserColor.Alpha))
    end

    local fn = G_FUEL_WEAPON_EFFECTS[gFuelWeapon]
    if fn then
        fn(ctx)
    end

    return tearParams
end

---@class Content.Player.Properties.TearHitParams
local Module = {}

--#region Module



--#endregion

return Module