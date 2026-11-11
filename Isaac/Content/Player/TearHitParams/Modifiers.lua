--#region Dependencies

local ops = require("Isaac.Content.Player.TearHitParams.Ops")
local MathUtils = require("General.Math")
local IsaacUtils = require("Isaac.Utils.Common")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local ITemporaryEffects = require("Isaac.Interface.TemporaryEffects")
local BitSet128Utils = require("General.VanillaAPI.BitSet128")

local BloodBaby = require("Isaac.Content.Player.TearHitParams.BloodBaby")
local AlmondMilk = require("Isaac.Content.Player.TearHitParams.AlmondMilk")
local PlaydoughCookie = require("Isaac.Content.Player.TearHitParams.PlaydoughCookie")
local GFuel = require("Isaac.Content.Player.TearHitParams.GFuel")

--#endregion

local COLOR_POISON = { tint = {R = 0.5, G = 0.97, B = 0.5, A = 1.0}, offset = { R = 0.0, G = 0.0, B = 0.0} }

local COLOR_LIL_DELIRIUM = { colorize = {R = 2.4, G = 2.4, B = 2.4, A = 1.0} }
local COLOR_BABY_BENDER = { tint = {R = 0.4, G = 0.15, B = 0.38, A = 1.0}, offset = { R = 55/255, G = 5/255, B = 95/255}, colorize = {R = 0.0, G = 0.0, B = 0.0, A = 0.0} }
local COLOR_PINKY_EYE = COLOR_POISON
local COLOR_SERPENTS_KISS = COLOR_POISON
local COLOR_PUSH_PIN = { tint = {R = 1.5, G = 2.0, B = 2.0, A = 0.5}, offset = { R = 0.0, G = 0.0, B = 0.0} }
local COLOR_MOMS_CONTACT = { tint = {R = 1.25, G = 0.05, B = 0.15, A = 1.0}, offset = { R = 0.0, G = 0.0, B = 0.0} }
local COLOR_SPIDER_BITE = { tint = {R = 2.0, G = 2.0, B = 2.0, A = 1.0}, offset = { R = 50/255, G = 50/255, B = 50/255} }
local COLOR_GISH_SLOW = { tint = {R = 0.15, G = 0.15, B = 0.15, A = 1.0}, offset = { R = 0.0, G = 0.0, B = 0.0} }
local COLOR_COMMON_COLD = { tint = {R = 0.4, G = 0.97, B = 0.5, A = 1.0}, offset = { R = 0.0, G = 0.0, B = 0.0} }
local COLOR_MOMS_EYESHADOW = { tint = {R = 1.0, G = 0.0, B = 1.0, A = 1.0}, offset = { R = 50/255, G = 0.0, B = 0.0} }
local COLOR_IRON_BAR = { tint = {R = 0.5, G = 0.5, B = 0.5, A = 1.0}, offset = { R = 0.0, G = 0.0, B = 0.0} }
local COLOR_ABADDON = { tint = {R = 100/255, G = 100/255, B = 100/255, A = 1.0}, offset = { R = 0.0, G = 0.0, B = 0.0} }
local COLOR_MOMS_PERFUME = { tint = {R = 1.0, G = 1.0, B = 116/255, A = 1.0}, offset = { R = 43/255, G = 37/255, B = 0.0} }
local COLOR_BABY_BEGOTTEN = { tint = { R = 0.0, G = 0.0, B = 0.0, A = 1.0 }, offset = { R = 0.0, G = 0.0, B = 0.0 } }
local COLOR_ACID = { tint = { R = 1.0, G = 1.0, B = 0.1, A = 1.0 } }
local COLOR_BLOOD_CLOT = { tint = { R = 1.0, G = 0.0, B = 0.0, A = 1.0 }, offset = { R = 0.0, G = 0.0, B = 0.0 } }
local COLOR_STYE = { tint = { R = 1.5, G = 2.0, B = 2.0, A = 1.0 }, offset = { R = 0.0, G = 0.0, B = 0.0 } }
local COLOR_EXPLOSIVO = { tint = { R = 0.2, G = 0.09, B = 0.065, A = 1.0 }, offset = { R = 0.0, G = 0.0, B = 0.0 } }
local COLOR_GODS_FLESH = { tint = { R = 0.6, G = 0.7, B = 1.0, A = 1.0 }, offset = { R = 0.0, G = 0.0, B = 0.0 } , colorize = {R = 0.0, G = 0.0, B = 0.0, A = 0.0} }
local COLOR_SUPER_BALL = { tint = {R = 1.0, G = 1.0, B = 0.8, A = 1.0}, offset = { R = 0.1, G = 0.1, B = 0.1} }
local COLOR_SCORPIO = { tint = { R = 50/255, G = 1.0, B = 50/255, A = 1.0 }, offset = { R = 0.0, G = 0.0, B = 0.0 } }
local COLOR_LITTLE_HORN = { tint = { R = 0.0, G = 0.0, B = 0.0, A = 1.0 }, offset = { R = 0.0, G = 0.0, B = 0.0 } , colorize = {R = 0.0, G = 0.0, B = 0.0, A = 0.0} }
local COLOR_LODESTONE = { colorize = { R = 0.5, G = 0.5, B = 0.5, A = 1.0 } }
local COLOR_ROTTEN_TOMATO = { tint = {R = 0.7, G = 0.14, B = 0.1, A = 1.0}, offset = { R = 0.3, G = 0.0, B = 0.0} }
local COLOR_OCULAR_RIFT = { tint = { R = 0.0, G = 0.0, B = 0.0, A = 1.0 }, offset = { R = 0.0, G = 0.0, B = 0.0 } , colorize = {R = 0.0, G = 0.0, B = 0.0, A = 0.0} }

---@class Content.Player.TearHitParams.Modifiers
local Modifiers = {}

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Familiar_BFFS_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_BFFS) then
        ops.damage_multiply(ctx, 2.0)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Familiar_BabyBender_ApplyTearHitParams(ctx)
    if ops.has_trinket(ctx, TrinketType.TRINKET_BABY_BENDER) and not ops.has_flags(ctx, TearFlags.TEAR_HOMING) then
        ops.set_flags(ctx, TearFlags.TEAR_HOMING)
        ops.set_color(ctx, COLOR_BABY_BENDER)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Familiar_IsLilDelirium_ApplyTearHitParams(ctx)
    if ctx.familiar.m_isLilDelirum then
        ops.set_color(ctx, COLOR_LIL_DELIRIUM)
        ops.set_tear_variant(ctx, TearVariant.BLOOD)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.PlayerEveB_ApplyTearHitParams(ctx)
    if ops.is_player_type(ctx, PlayerType.PLAYER_EVE_B) then
        ops.scale_multiply(ctx, 0.8)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.PinkyEye_ApplyTearHitParams(ctx)
    if ops.has_trinket(ctx, TrinketType.TRINKET_PINKY_EYE) and ops.luck_based_chance(ctx, 1, 10, 1, 0.5) then
        ops.set_flags(ctx, TearFlags.TEAR_POISON)
        if ops.is_weapon_type(ctx, WeaponType.WEAPON_BOMBS) then
            ops.set_tint(ctx, COLOR_PINKY_EYE.tint)
        end
        ops.set_color_offset(ctx, COLOR_PINKY_EYE.offset)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.SerpentsKiss_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_SERPENTS_KISS) and ops.static_chance(15, 100) then
        ops.set_flags(ctx, TearFlags.TEAR_POISON)
        if ops.is_weapon_type(ctx, WeaponType.WEAPON_BOMBS) then
            ops.set_tint(ctx, COLOR_SERPENTS_KISS.tint)
        end
        ops.set_color_offset(ctx, COLOR_SERPENTS_KISS.offset)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.PushPin_ApplyTearHitParams(ctx)
    if ops.has_trinket(ctx, TrinketType.TRINKET_PUSH_PIN) and ops.luck_based_chance(ctx, 1, 10, 1, 0.5) then
        ops.set_flags(ctx, TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL)
        ops.set_color(ctx, COLOR_PUSH_PIN)
        ops.set_tear_variant(ctx, TearVariant.CUPID_BLUE)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.MomsContacts_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_MOMS_CONTACTS) and ops.luck_based_chance(ctx, 1, 5, 2, 0.15) then
        ops.set_flags(ctx, TearFlags.TEAR_FREEZE)
        ops.set_color(ctx, COLOR_MOMS_CONTACT)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.HolyLight_ApplyTearHitParams(ctx)
    if ops.has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_HOLY_LIGHT) and ops.luck_based_chance(ctx, 1, 10, 2, 0.9) then
        ops.set_flags(ctx, TearFlags.TEAR_LIGHT_FROM_HEAVEN)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.SpiderBite_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_SPIDER_BITE) and ops.luck_based_chance(ctx, 1, 4, 1, 0.2) then
        ops.set_color(ctx, COLOR_SPIDER_BITE)
        ops.set_flags(ctx, TearFlags.TEAR_SLOW)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.GishTearEffect_ApplyTearHitParams(ctx)
    local gishSlowEffect = (ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_BALL_OF_TAR) and ops.luck_based_chance(ctx, 1, 10, 1, 0.5))
        or (ops.has_trinket(ctx, TrinketType.TRINKET_CHEWED_PEN) and ops.luck_based_chance(ctx, 1, 10, 1, 0.5))
    if gishSlowEffect then
        ops.set_flags(ctx, TearFlags.TEAR_GISH | TearFlags.TEAR_SLOW)
        ops.set_color(ctx, COLOR_GISH_SLOW)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.CommonCold_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_COMMON_COLD) and ops.luck_based_chance(ctx, 1, 4, 1, 0.25) then
        ops.set_flags(ctx, TearFlags.TEAR_POISON)
        ops.set_color(ctx, COLOR_COMMON_COLD)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.MomsEyeshadow_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_MOMS_EYESHADOW) and ops.luck_based_chance(ctx, 1, 10, 1, 0.334) then
        ops.set_color(ctx, COLOR_MOMS_EYESHADOW)
        ops.set_flags(ctx, TearFlags.TEAR_CHARM)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.IronBar_ApplyTearHitParams(ctx)
    if ops.has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_IRON_BAR) and ops.luck_based_chance(ctx, 1, 10, 1, 0.334) then
        ops.set_color(ctx, COLOR_IRON_BAR)
        ops.set_flags(ctx, TearFlags.TEAR_CONFUSION)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.FruitCake_ApplyTearHitParams(ctx)
    if ops.has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_FRUIT_CAKE) then
        local randomFlag = IsaacUtils.RandomInt(TearFlags.TEAR_EFFECT_COUNT)
        local excluded = TearFlags.TEAR_BLACK_HP_DROP | TearFlags.TEAR_GLITTER_BOMB
            | TearFlags.TEAR_BUTT_BOMB | TearFlags.TEAR_SAD_BOMB
            | TearFlags.TEAR_TRACTOR_BEAM | TearFlags.TEAR_SCATTER_BOMB
        local addedFlag = BitSet128Utils.NewFromFlag(randomFlag) & ~excluded -- if flag is excluded then no flag is added
        ops.set_flags(ctx, addedFlag)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.AlmondMilk_ApplyTearScale(ctx)
    local condition = ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_ALMOND_MILK)
    if condition then
        ops.scale_multiply(ctx, 0.7)
    end
    return condition
end

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
function Modifiers.SoyMilk_ApplyTearScale(ctx)
    local condition = ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_SOY_MILK)
    if condition then
        ops.scale_multiply(ctx, 0.5)
    end
    return condition
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.DeadOnion_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_DEAD_ONION) then
        ops.scale_multiply(ctx, 1.5)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Lachrypargy_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_LACHRYPHAGY) and ops.is_weapon_type(ctx, WeaponType.WEAPON_TEARS) or ops.is_weapon_type(ctx, WeaponType.WEAPON_MONSTROS_LUNGS) then
        ops.set_tear_variant(ctx, TearVariant.HUNGRY)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Glaucoma_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_GLAUCOMA) and ops.static_chance(1, 20) then
        ops.set_flags(ctx, TearFlags.TEAR_PERMANENT_CONFUSION)
        ops.set_tear_variant(ctx, TearVariant.GLAUCOMA)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.TearFearEffect_ApplyTearHitParams(ctx)
    if (ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_MOMS_PERFUME) or ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_ABADDON)) and ops.luck_based_chance(ctx, 15, 100, 1, 1.0) then
        if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_ABADDON) then
            ops.set_color(ctx, COLOR_ABADDON)
        elseif ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_MOMS_PERFUME) then
            ops.set_color(ctx, COLOR_MOMS_PERFUME)
        end

        ops.set_flags(ctx, TearFlags.TEAR_FEAR)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.BabyBegotten_ApplyTearHitParams(ctx)
    if ops.is_baby_type(ctx, BabySubType.BABY_BEGOTTEN) then
        if ops.static_chance(1, 30) then
            ops.set_flags(ctx, TearFlags.TEAR_FEAR)
        end

        ops.scale_multiply(ctx, 2.0)
        ops.set_color(ctx, COLOR_BABY_BEGOTTEN)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Peeper_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_PEEPER) and ops.is_left_eye(ctx) then
        ops.set_blood_tears(ctx, true)
        ops.damage_multiply(ctx, 1.35)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Scooper_ApplyTearHitParams(ctx)
    if ops.has_collectible_effect(ctx, CollectibleType.COLLECTIBLE_SCOOPER) and ops.is_right_eye(ctx) then
        ops.set_blood_tears(ctx, true)
        ops.damage_multiply(ctx, 1.35)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.ChemicalPeel_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_CHEMICAL_PEEL) and ops.is_left_eye(ctx) then
        ops.set_blood_tears(ctx, true)
        ops.damage_add(ctx, 2.0)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.SulfuricAcid_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_SULFURIC_ACID) and ops.static_chance(1, 4) then
        ops.set_flags(ctx, TearFlags.TEAR_ACID)
        ops.set_color(ctx, COLOR_ACID)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.BloodClot_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_BLOOD_CLOT) and ops.is_left_eye(ctx) then
        ops.set_color(ctx, COLOR_BLOOD_CLOT)
        ops.damage_add(ctx, 1.0)
        ops.scale_multiply(ctx, 1.25)
        ops.tear_height_add(ctx, -10.0)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Stye_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_STYE) and ops.is_right_eye(ctx) then
        ops.set_color(ctx, COLOR_STYE)
        ops.damage_multiply(ctx, 1.2857143)
        ops.scale_multiply(ctx, 1.25)
        ops.speed_multiply(ctx, 0.8)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Proptosis_ApplyTearHitParams(ctx)
    if ops.has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_PROPTOSIS) then
        ops.scale_multiply(ctx, 3.0)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Pisces_ApplyTearHitParams(ctx)
    if ops.has_zodiac_collectible(ctx, CollectibleType.COLLECTIBLE_PISCES) then
        ops.scale_multiply(ctx, 1.25)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.CupidTearEffect_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_CUPIDS_ARROW) or ops.has_zodiac_collectible(ctx, CollectibleType.COLLECTIBLE_SAGITTARIUS) then
        ops.set_tear_variant(ctx, TearVariant.CUPID_BLUE)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.EightInchNails_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_8_INCH_NAILS) then
        ops.set_tear_variant(ctx, TearVariant.NAIL)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.PupulaDuplex_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_PUPULA_DUPLEX) then
        ops.set_tear_variant(ctx, TearVariant.PUPULA)
        ops.scale_multiply(ctx, 3.0)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Tropicamide_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_TROPICAMIDE) then
        ctx.tearParams.tearScale = (ctx.tearParams.tearScale + 0.2) * 1.25
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Uranus_ApplyTearHitParams(ctx)
    if ops.has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_URANUS) then
        ops.set_tear_variant(ctx, TearVariant.ICE)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Terra_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_TERRA) then
        ops.set_tear_variant(ctx, TearVariant.ROCK)
        local randomExponent = (IsaacUtils.RandomFloat() * 2.0) - 1.0 -- [-1, 1] (equal chance to reduce or increase)
        ops.scale_multiply(ctx, 2.0 ^ (randomExponent * 0.2))
        ops.damage_multiply(ctx, 2.0 ^ randomExponent)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.ReverseHangedMan_ApplyTearHitParams(ctx)
    if ops.has_null_effect(ctx, NullItemID.ID_REVERSE_HANGED_MAN) then
        ops.set_flags(ctx, TearFlags.TEAR_COIN_DROP_DEATH)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.CrownOfLight_ApplyTearHitParams(ctx)
    if ops.has_collectible_effect(ctx, CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT) then
        ops.set_tear_variant(ctx, TearVariant.DIAMOND)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.StrangeAttractor_ApplyTearHitParams(ctx)
    if ops.has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR) then
        ops.set_tear_variant(ctx, TearVariant.METALLIC)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Euthanasia_ApplyTearHitParams(ctx)
    if ops.has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_EUTHANASIA) and ops.luck_based_chance(ctx, 1, 30, 4, 2.0) then
        ops.set_tear_variant(ctx, TearVariant.NEEDLE)
        ops.set_flags(ctx, TearFlags.TEAR_NEEDLE)
        ops.damage_multiply(ctx, 3.0)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.BoogerTearEffect_ApplyTearHitParams(ctx)
    local boogerEffect = (ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_SINUS_INFECTION) and ops.static_chance(1, 5))
        or (ops.has_trinket(ctx, TrinketType.TRINKET_NOSE_GOBLIN) and ops.static_chance(1, 10))
    if boogerEffect then
        ops.set_tear_variant(ctx, TearVariant.BOOGER)
        ops.set_flags(ctx, TearFlags.TEAR_BOOGER)

        if ops.has_trinket(ctx, TrinketType.TRINKET_NOSE_GOBLIN) and ops.static_chance(1, 2) then
            ops.set_flags(ctx, TearFlags.TEAR_HOMING)
        end
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Mucormycosis_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_MUCORMYCOSIS) and ops.static_chance(1, 4) then
        ops.set_tear_variant(ctx, TearVariant.SPORE)
        ops.set_flags(ctx, TearFlags.TEAR_SPORE)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Explosivo_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_EXPLOSIVO) and ops.static_chance(1, 4) then
        ops.set_flags(ctx, TearFlags.TEAR_STICKY)

        if ops.is_any_tear_variant(ctx, {TearVariant.BLUE, TearVariant.BLOOD, TearVariant.CUPID_BLUE, TearVariant.CUPID_BLOOD}) then
            ops.set_tear_variant(ctx, TearVariant.EXPLOSIVO)
        else
            ops.set_color(ctx, COLOR_EXPLOSIVO)
        end
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.LostContact_ApplyTearHitParams(ctx)
    if ops.has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_LOST_CONTACT) then
        ops.set_tear_variant(ctx, TearVariant.LOST_CONTACT)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.CompoundFracture_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE) then
        ops.set_tear_variant(ctx, TearVariant.BONE)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.GodsFlesh_ApplyTearHitParams(ctx)
    if ops.has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_GODS_FLESH) and ops.static_chance(1, 10) then
        ops.set_tear_variant(ctx, TearVariant.GODS_FLESH)
        ops.set_flags(ctx, TearFlags.TEAR_GODS_FLESH)

        if not ops.is_weapon_type(ctx, WeaponType.WEAPON_TEARS) then
            ops.set_color(ctx, COLOR_GODS_FLESH)
        end
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Pop_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_POP) then
        local eyeVariant = ctx.isBloodTear and TearVariant.EYE_BLOOD or TearVariant.EYE
        ops.set_tear_variant(ctx, eyeVariant)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.DarkMatter_ApplyTearHitParams(ctx)
    if ops.has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_DARK_MATTER) and ops.luck_based_chance(ctx, 1, 3, 1, 0.1) then
        ops.set_flags(ctx, TearFlags.TEAR_FEAR)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.HeadOfTheKeeper_ApplyTearHitParams(ctx)
    if ops.has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER) and ops.is_baby_type(ctx, BabySubType.BABY_SUPER_GREED) then
        ops.set_tear_variant(ctx, TearVariant.COIN)
        ops.set_flags(ctx, TearFlags.TEAR_GREED_COIN)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.DeathsTouch_ApplyTearHitParams(ctx)
    if ops.has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_DEATHS_TOUCH) then
        ops.set_tear_variant(ctx, TearVariant.SCHYTHE)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.SuperBall_ApplyTearHitParams(ctx)
    if ops.has_trinket(ctx, TrinketType.TRINKET_SUPER_BALL) and ops.static_chance(1, 10) then
        ops.set_flags(ctx, TearFlags.TEAR_BOUNCE)
        ops.set_color(ctx, COLOR_SUPER_BALL)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Scorpio_ApplyTearHitParams(ctx)
    if ops.has_zodiac_collectible(ctx, CollectibleType.COLLECTIBLE_SCORPIO) then
        ops.set_color(ctx, COLOR_SCORPIO)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.BlackTooth_ApplyTearHitParams(ctx)
    if ops.has_trinket(ctx, TrinketType.TRINKET_BLACK_TOOTH) and ops.luck_based_chance(ctx, 1, 33, 0, 1.0) then
        ops.set_tear_variant(ctx, TearVariant.BLACK_TOOTH)
        ops.base_damage_multiply(ctx, 2.0)
        ops.set_flags(ctx, TearFlags.TEAR_POISON)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.ToothTearEffect(ctx)
    local toughLoveEffect = (ops.has_collectible_or_effect(ctx, CollectibleType.COLLECTIBLE_TOUGH_LOVE) and ops.luck_based_chance(ctx, 1, 10, 0, 1.0))
        or (ops.has_trinket(ctx, TrinketType.TRINKET_JAW_BREAKER) and ops.luck_based_chance(ctx, 1, 10, 0, 1.0))

    if toughLoveEffect then
        ops.set_tear_variant(ctx, TearVariant.TOOTH)
        ops.base_damage_multiply(ctx, 3.2)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Apple_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_APPLE) and ops.luck_based_chance(ctx, 1, 15, 0, 1.0) then
        ops.set_tear_variant(ctx, TearVariant.RAZOR)
        ops.base_damage_multiply(ctx, 4.0)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Parasitoid_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_PARASITOID) and ops.luck_based_chance(ctx, 1, 7, 2, 1.0) then
        ops.set_tear_variant(ctx, TearVariant.EGG)
        ops.set_flags(ctx, TearFlags.TEAR_EGG)
        ops.tear_height_multiply(ctx, 2.0)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.OuroborosWorm_ApplyTearHitParams(ctx)
    if ops.has_trinket(ctx, TrinketType.TRINKET_OUROBOROS_WORM) and ops.luck_based_chance(ctx, 1, 10, 1, 1.0) then
        ops.set_flags(ctx, TearFlags.TEAR_HOMING)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.LittleHorn_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_LITTLE_HORN) and ops.luck_based_chance(ctx, 1, 20, 5, 1.0) then
        ops.set_flags(ctx, TearFlags.TEAR_HORN)
        ops.set_color(ctx, COLOR_LITTLE_HORN)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.GoldenRazor_ApplyTearHitParams(ctx)
    if ops.has_collectible_effect(ctx, CollectibleType.COLLECTIBLE_GOLDEN_RAZOR) then
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
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.WeaponBombs_ApplyTearHitParams(ctx)
    if ops.is_weapon_type(ctx, WeaponType.WEAPON_BOMBS) or ops.is_weapon_type(ctx, WeaponType.WEAPON_ROCKETS) then
        ops.set_flags(ctx, IEntityPlayer.GetBombFlags(ctx.player, true))
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.TearExplosive_ApplyTearHitParams(ctx)
    if ops.has_flags(ctx, TearFlags.TEAR_EXPLOSIVE) and not ops.has_flags(ctx, TearFlags.TEAR_LUDOVICO) then
        ctx.scaleMultiplier = 0.5
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.TearQuadSplit_ApplyTearHitParams(ctx)
    if ops.has_flags(ctx, TearFlags.TEAR_QUADSPLIT) and not ops.has_flags(ctx, TearFlags.TEAR_LUDOVICO) then
        ops.scale_multiply(ctx, 1.2)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.WeaponTear_Haemolacria_ApplyTearHitParams(ctx)
    local condition = ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_HAEMOLACRIA)
    if condition then
        ops.set_tear_variant(ctx, TearVariant.BALLOON)

        if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_BRIMSTONE) or ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_TECHNOLOGY) or ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_TECH_X) then
            ops.set_tear_variant(ctx, TearVariant.BALLOON_BRIMSTONE)
        elseif ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_DR_FETUS) then
            ops.set_tear_variant(ctx, TearVariant.BALLOON_BOMB)
        end

        ops.scale_multiply(ctx, 1.71)
        ops.set_flags(ctx, TearFlags.TEAR_BURSTSPLIT)
    end
    return condition
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Haemolacria_NonTearWeapon_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_HAEMOLACRIA) then
        ops.set_flags(ctx, TearFlags.TEAR_BURSTSPLIT)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.WeaponTear_PlayerForgotten_ApplyTearHitParams(ctx)
    local condition = (ops.is_player_type(ctx, PlayerType.PLAYER_THEFORGOTTEN) or ops.is_player_type(ctx, PlayerType.PLAYER_THEFORGOTTEN_B))
        and not ops.is_tear_variant(ctx, TearVariant.SCHYTHE)
    if condition then
        ops.set_tear_variant(ctx, TearVariant.BONE)
    end
    return condition
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.WeaponFetus_ApplyTearHitParams(ctx)
    if ops.is_weapon_type(ctx, WeaponType.WEAPON_FETUS) then
        ops.set_tear_variant(ctx, TearVariant.FETUS)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.Lodestone_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_LODESTONE) and ops.luck_based_chance(ctx, 1, 6, 1, 1.0) then
        ops.set_color(ctx, COLOR_LODESTONE)
        ops.set_flags(ctx, TearFlags.TEAR_MAGNETIZE)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.RottenTomato_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_ROTTEN_TOMATO) and ops.luck_based_chance(ctx, 1, 6, 1, 1.0) then
        ops.set_color(ctx, COLOR_ROTTEN_TOMATO)
        ops.set_flags(ctx, TearFlags.TEAR_BAIT)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.KnockoutDrops_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS) and ops.luck_based_chance(ctx, 1, 10, 1, 1.0) then
        ops.set_flags(ctx, TearFlags.TEAR_PUNCH)
        ops.set_tear_variant(ctx, TearVariant.FIST)
        ops.scale_multiply(ctx, 1.5)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.OcularRift_ApplyTearHitParams(ctx)
    if ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_OCULAR_RIFT) and ops.luck_based_chance(ctx, 1, 20, 5, 1.0) then
        ops.set_flags(ctx, TearFlags.TEAR_RIFT)
        ops.set_color(ctx, COLOR_OCULAR_RIFT)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.PlayerJacob_ApplyTearHitParams(ctx)
    if ops.is_player_type(ctx, PlayerType.PLAYER_JACOB) then
        ops.scale_multiply(ctx, 0.9)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.TearShrink_ApplyTearHitParams(ctx)
    if ops.has_flags(ctx, TearFlags.TEAR_SHRINK) then
        ops.damage_multiply(ctx, 3.0)
    end
end

Modifiers.AlmondMilk_ApplyTearHitParams = AlmondMilk.ApplyTearHitParams
Modifiers.PlaydoughCookie_ApplyTearHitParams = PlaydoughCookie.ApplyTearHitParams

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.DonkeyBone_ApplyTearHitParams(ctx)
    if ops.is_weapon_type(ctx, WeaponType.WEAPON_BONE) and ops.has_collectible_effect(ctx, CollectibleType.COLLECTIBLE_BERSERK) then
        ops.set_flags(ctx, TearFlags.TEAR_EXTRA_GORE)
    end
end

Modifiers.BloodBaby_ApplyTearHitParams = BloodBaby.ApplyTearHitParams

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.AlmondMilk_ApplyKnockback(ctx)
    local condition = ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_ALMOND_MILK)
    if condition then
        ops.knockback_multiply(ctx, 0.3)
    end
    return condition
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.SoyMilk_ApplyKnockback(ctx)
    local condition = ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_SOY_MILK)
    if condition then
        ops.knockback_multiply(ctx, 0.2)
    end
    return condition
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.HighKnockback(ctx)
    local hasHighKnockback = ops.has_zodiac_collectible(ctx, CollectibleType.COLLECTIBLE_PISCES) or ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_8_INCH_NAILS)
        or ops.has_trinket(ctx, TrinketType.TRINKET_BLISTER) or ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_TERRA)
    if hasHighKnockback then
        ops.knockback_multiply(ctx, 3.0)
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.HighHeight(ctx)
    local condition = ops.has_trinket(ctx, TrinketType.TRINKET_BLISTER)
    if condition then
        ops.set_height(ctx, 3.0)
    end
    return condition
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.MediumHeight(ctx)
    local condition = ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_8_INCH_NAILS)
        or ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_TERRA)
    if condition then
        ops.set_height(ctx, 2.0)
    end
    return condition
end

---@param ctx Player.Blackboard.GetTearHitParams
function Modifiers.PlayerHologram_ApplyHitParams(ctx)
    if IEntityPlayer.IsHologram(ctx.player) then
        ctx.tearParams.tearColor.A = 0.2
    end
end

Modifiers.GFuel_ApplyTearHitParams = GFuel.ApplyTearHitParams

return Modifiers