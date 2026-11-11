--#region Dependencies

local ops = require("Isaac.Content.Player.TearHitParams.Ops")
local IsaacUtils = require("Isaac.Utils.Common")
local BitSet128Utils = require("General.VanillaAPI.BitSet128")
local ColorUtils = require("General.VanillaAPI.Color")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local PlayerProperties = require("Isaac.Content.Player.Properties.Misc")

local ITearParams = IEntityPlayer.TearParams

local MyModifiers = require("Isaac.Content.Player.TearHitParams.Modifiers")

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
---@field scaleMultiplier number

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

---@param ctx Player.Blackboard.GetTearHitParams
---@param functions function[]
local function mutually_exclusive(ctx, functions)
    for i = 1, #functions, 1 do
        if functions[i](ctx) then
            return
        end
    end
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
        scaleMultiplier = 1.0, -- uninitialized
    }

    if familiar ~= nil then
        if familiar.m_variant == FamiliarVariant.BLOOD_BABY then
            ops.damage_multiply(ctx, 0.35)
        else
            if familiar.m_variant == FamiliarVariant.TWISTED_BABY then
                ops.damage_multiply(ctx, 0.5)
            end

            if (player.m_playerType ~= PlayerType.PLAYER_LILITH and player.m_playerType ~= PlayerType.PLAYER_LILITH_B) then
                ops.damage_multiply(ctx, 0.75)
            end
        end

        MyModifiers.Familiar_BFFS_ApplyTearHitParams(ctx)
        MyModifiers.Familiar_BabyBender_ApplyTearHitParams(ctx)
        MyModifiers.Familiar_IsLilDelirium_ApplyTearHitParams(ctx)
    end

    MyModifiers.PlayerEveB_ApplyTearHitParams(ctx)

    ctx.baseDamage = tearParams.tearDamage
    ctx.scaleMultiplier = 1.0

    MyModifiers.PinkyEye_ApplyTearHitParams(ctx)
    MyModifiers.SerpentsKiss_ApplyTearHitParams(ctx)
    MyModifiers.PushPin_ApplyTearHitParams(ctx)
    MyModifiers.MomsContacts_ApplyTearHitParams(ctx)
    MyModifiers.HolyLight_ApplyTearHitParams(ctx)
    MyModifiers.SpiderBite_ApplyTearHitParams(ctx)
    MyModifiers.GishTearEffect_ApplyTearHitParams(ctx)
    MyModifiers.CommonCold_ApplyTearHitParams(ctx)
    MyModifiers.MomsEyeshadow_ApplyTearHitParams(ctx)
    MyModifiers.IronBar_ApplyTearHitParams(ctx)
    MyModifiers.FruitCake_ApplyTearHitParams(ctx)
    mutually_exclusive(ctx, {MyModifiers.AlmondMilk_ApplyTearScale, MyModifiers.SoyMilk_ApplyTearScale})
    MyModifiers.DeadOnion_ApplyTearHitParams(ctx)

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

    MyModifiers.Lachrypargy_ApplyTearHitParams(ctx)
    MyModifiers.Glaucoma_ApplyTearHitParams(ctx)
    MyModifiers.TearFearEffect_ApplyTearHitParams(ctx)
    MyModifiers.BabyBegotten_ApplyTearHitParams(ctx)
    MyModifiers.Peeper_ApplyTearHitParams(ctx)
    MyModifiers.Scooper_ApplyTearHitParams(ctx)
    MyModifiers.ChemicalPeel_ApplyTearHitParams(ctx)
    MyModifiers.SulfuricAcid_ApplyTearHitParams(ctx)
    MyModifiers.BloodClot_ApplyTearHitParams(ctx)
    MyModifiers.Stye_ApplyTearHitParams(ctx)
    MyModifiers.Proptosis_ApplyTearHitParams(ctx)
    MyModifiers.Pisces_ApplyTearHitParams(ctx)
    MyModifiers.CupidTearEffect_ApplyTearHitParams(ctx)
    MyModifiers.EightInchNails_ApplyTearHitParams(ctx)
    MyModifiers.PupulaDuplex_ApplyTearHitParams(ctx)
    MyModifiers.Tropicamide_ApplyTearHitParams(ctx)
    MyModifiers.Uranus_ApplyTearHitParams(ctx)
    MyModifiers.Terra_ApplyTearHitParams(ctx)
    MyModifiers.ReverseHangedMan_ApplyTearHitParams(ctx)
    MyModifiers.CrownOfLight_ApplyTearHitParams(ctx)
    MyModifiers.StrangeAttractor_ApplyTearHitParams(ctx)
    MyModifiers.Euthanasia_ApplyTearHitParams(ctx)
    MyModifiers.BoogerTearEffect_ApplyTearHitParams(ctx)
    MyModifiers.Mucormycosis_ApplyTearHitParams(ctx)
    MyModifiers.Explosivo_ApplyTearHitParams(ctx)
    MyModifiers.LostContact_ApplyTearHitParams(ctx)
    MyModifiers.CompoundFracture_ApplyTearHitParams(ctx)
    MyModifiers.GodsFlesh_ApplyTearHitParams(ctx)
    MyModifiers.Pop_ApplyTearHitParams(ctx)
    MyModifiers.DarkMatter_ApplyTearHitParams(ctx)
    MyModifiers.HeadOfTheKeeper_ApplyTearHitParams(ctx)
    MyModifiers.DeathsTouch_ApplyTearHitParams(ctx)
    MyModifiers.SuperBall_ApplyTearHitParams(ctx)
    MyModifiers.Scorpio_ApplyTearHitParams(ctx)
    MyModifiers.BlackTooth_ApplyTearHitParams(ctx)
    MyModifiers.ToothTearEffect(ctx)
    MyModifiers.Apple_ApplyTearHitParams(ctx)
    MyModifiers.Parasitoid_ApplyTearHitParams(ctx)
    MyModifiers.OuroborosWorm_ApplyTearHitParams(ctx)
    MyModifiers.LittleHorn_ApplyTearHitParams(ctx)
    MyModifiers.GoldenRazor_ApplyTearHitParams(ctx)
    MyModifiers.WeaponBombs_ApplyTearHitParams(ctx)

    if not ops.is_weapon_type(ctx, WeaponType.WEAPON_TEARS) and not ops.is_weapon_type(ctx, WeaponType.WEAPON_FETUS) then
        MyModifiers.Haemolacria_NonTearWeapon_ApplyTearHitParams(ctx)
    else
        MyModifiers.TearExplosive_ApplyTearHitParams(ctx)
        MyModifiers.TearQuadSplit_ApplyTearHitParams(ctx)
        mutually_exclusive(ctx, {MyModifiers.WeaponTear_Haemolacria_ApplyTearHitParams, MyModifiers.WeaponTear_PlayerForgotten_ApplyTearHitParams})
        MyModifiers.WeaponFetus_ApplyTearHitParams(ctx)
    end

    MyModifiers.Lodestone_ApplyTearHitParams(ctx)
    MyModifiers.RottenTomato_ApplyTearHitParams(ctx)
    MyModifiers.KnockoutDrops_ApplyTearHitParams(ctx)
    MyModifiers.OcularRift_ApplyTearHitParams(ctx)
    MyModifiers.PlayerJacob_ApplyTearHitParams(ctx)
    MyModifiers.TearShrink_ApplyTearHitParams(ctx)
    MyModifiers.AlmondMilk_ApplyTearHitParams(ctx)
    MyModifiers.PlaydoughCookie_ApplyTearHitParams(ctx)
    MyModifiers.DonkeyBone_ApplyTearHitParams(ctx)
    MyModifiers.BloodBaby_ApplyTearHitParams(ctx)
    mutually_exclusive(ctx, {MyModifiers.AlmondMilk_ApplyKnockback, MyModifiers.SoyMilk_ApplyKnockback})
    MyModifiers.HighKnockback(ctx)
    mutually_exclusive(ctx, {MyModifiers.HighHeight, MyModifiers.MediumHeight})

    local compressedScale = tearParams.tearScale > 1.0 and math.log(tearParams.tearScale) + 1.0 or tearParams.tearScale
    tearParams.tearScale = (math.sqrt(ctx.baseDamage) * 0.23 + compressedScale * 0.55 + ctx.baseDamage * 0.01) * ctx.scaleMultiplier

    if ctx.isBloodTear then
        tearParams.tearVariant = BLOOD_VARIANT[tearParams.tearVariant] or tearParams.tearVariant
    end

    MyModifiers.PlayerHologram_ApplyHitParams(ctx)
    MyModifiers.GFuel_ApplyTearHitParams(ctx)

    return tearParams
end

---@class Content.Player.Properties.TearHitParams
local Module = {}

--#region Module



--#endregion

return Module