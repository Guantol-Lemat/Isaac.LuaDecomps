--#region Dependencies

local ops = require("Isaac.Content.Player.TearHitParams.Ops")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local PlayerProperties = require("Isaac.Content.Player.Properties.Misc")

local MyModifiers = require("Isaac.Content.Player.TearHitParams.Modifiers")
local BloodTears = require("Isaac.Content.Player.TearHitParams.BloodTears")

--#endregion

---@param ctx Player.Blackboard.GetTearHitParams
---@param functions function[]
local function mutually_exclusive(ctx, functions)
    for i = 1, #functions, 1 do
        if functions[i](ctx) then
            return
        end
    end
end

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
local function HasNoLeftEye(ctx)
    return ctx.familiar ~= nil
        or not IEntityPlayer.HasWeaponType(ctx.player, WeaponType.WEAPON_TEARS)
        or PlayerProperties.IsLeftEyeBlocked(ctx.player)
end


---@param ctx Player.Blackboard.GetTearHitParams
local function ApplyBaseModifiers(ctx)
    local familiar = ctx.familiar
    if familiar ~= nil then
        if familiar.m_variant == FamiliarVariant.BLOOD_BABY then
            ops.damage_multiply(ctx, 0.35)
        else
            if familiar.m_variant == FamiliarVariant.TWISTED_BABY then
                ops.damage_multiply(ctx, 0.5)
            end

            local player = ctx.player
            if (player.m_playerType ~= PlayerType.PLAYER_LILITH and player.m_playerType ~= PlayerType.PLAYER_LILITH_B) then
                ops.damage_multiply(ctx, 0.75)
            end
        end

        MyModifiers.Familiar_BFFS_ApplyTearHitParams(ctx)
        MyModifiers.Familiar_BabyBender_ApplyTearHitParams(ctx)
        MyModifiers.Familiar_IsLilDelirium_ApplyTearHitParams(ctx)
    end

    MyModifiers.PlayerEveB_ApplyTearHitParams(ctx)
end

---@param ctx Player.Blackboard.GetTearHitParams
local function ApplyPreModifiers(ctx)
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
end

---@param ctx Player.Blackboard.GetTearHitParams
local function ApplyModifiers(ctx)
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
end

---@param ctx Player.Blackboard.GetTearHitParams
local function ApplyPostModifiers(ctx)
    MyModifiers.PlayerHologram_ApplyHitParams(ctx)
    MyModifiers.GFuel_ApplyTearHitParams(ctx)
end

---@class Content.Player.Properties.TearHitParams
local Module = {}

--#region Module

Module.HasNoLeftEye = HasNoLeftEye
Module.ApplyBaseModifiers = ApplyBaseModifiers
Module.ApplyPreModifiers = ApplyPreModifiers
Module.ApplyModifiers = ApplyModifiers
Module.ApplyPostModifiers = ApplyPostModifiers
Module.ApplyBloodTearsModifiers = BloodTears.ApplyBloodTearsModifiers

--#endregion

return Module