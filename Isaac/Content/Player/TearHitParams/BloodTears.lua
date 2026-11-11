--#region Dependencies

local ops = require("Isaac.Content.Player.TearHitParams.Ops")

--#endregion

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
local function RedStew_HasBloodTears(ctx)
    return ctx.player.m_redStew_bonusDuration > 90
end

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
local function BloodBaby_HasBloodTears(ctx)
    local familiar = ctx.familiar
    if not familiar then return false end
    if not familiar.m_variant ~= FamiliarVariant.BLOOD_BABY then return false end

    local subtype = familiar.m_subtype
    return subtype == BloodClotSubtype.RED or subtype == BloodClotSubtype.ROTTEN or subtype == BloodClotSubtype.LIL_CLOT
end

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
local function DecapAttack_HasBloodTears(ctx)
    return ops.has_collectible_effect(ctx, CollectibleType.COLLECTIBLE_DECAP_ATTACK) and ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
local function BloodTears_HighPriority(ctx)
    return ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_KIDNEY_STONE)
        or ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_APPLE)
        or ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_EYE_OF_BELIAL)
        or (ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_LEAD_PENCIL) and ops.is_left_eye(ctx))
        or (ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_PEEPER) and ops.is_left_eye(ctx))
        or ops.is_player_type(ctx, PlayerType.PLAYER_LAZARUS2)
        or ops.is_player_type(ctx, PlayerType.PLAYER_BLACKJUDAS)
        or RedStew_HasBloodTears(ctx)
        or (ops.has_collectible_effect(ctx, CollectibleType.COLLECTIBLE_SCOOPER) and ops.is_right_eye(ctx))
        or ops.is_player_type(ctx, PlayerType.PLAYER_ESAU)
        or ops.is_player_type(ctx, PlayerType.PLAYER_JUDAS_B)
        or ops.is_player_type(ctx, PlayerType.PLAYER_LAZARUS2_B)
        or ops.is_player_type(ctx, PlayerType.PLAYER_BETHANY_B)
        or BloodBaby_HasBloodTears(ctx)
        or ops.has_null_effect(ctx, NullItemID.ID_BLOOD_OATH)
        or ops.has_null_effect(ctx, NullItemID.ID_INTRUDER)
        or ops.has_null_effect(ctx, NullItemID.ID_JUDAS_BIRTHRIGHT)
        or ops.has_null_effect(ctx, NullItemID.ID_JUDAS_BIRTHRIGHT_TIMED)
        or ops.has_null_effect(ctx, NullItemID.ID_JUDAS_BIRTHRIGHT_STAGE)
        or ops.has_null_effect(ctx, NullItemID.ID_JUDAS_BIRTHRIGHT_PERMANENT)
        or ops.has_null_effect(ctx, NullItemID.ID_ESAU_JR)
        or DecapAttack_HasBloodTears(ctx)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
local function BloodTears_LowPriority(ctx)
    return ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_ABADDON)
        or ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_MONSTROS_LUNG)
        or ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR)
        or ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_STIGMATA)
        or ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_PACT)
        or ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_TOOTH_PICKS)
        or ops.is_baby_type(ctx, BabySubType.BABY_SHADOW)
        or ops.has_collectible_effect(ctx, CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL)
        or ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_SMALL_ROCK)
        or ops.has_collectible_effect(ctx, CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON)
        or ops.has_collectible_effect(ctx, CollectibleType.COLLECTIBLE_RAZOR_BLADE)
        or ops.has_trinket_effect(ctx, TrinketType.TRINKET_RED_PATCH)
        or ops.has_collectible_effect(ctx, CollectibleType.COLLECTIBLE_VARICOSE_VEINS)
        or ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID)
        or ops.has_collectible_effect(ctx, CollectibleType.COLLECTIBLE_THE_NAIL)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
local function BloodTears_HighPriorityBlock(ctx)
    return ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_CHOCOLATE_MILK)
end

---@param ctx Player.Blackboard.GetTearHitParams
---@return boolean
local function BloodTears_LowPriorityBlock(ctx)
    return ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_SOY_MILK)
        or ops.has_collectible(ctx, CollectibleType.COLLECTIBLE_ALMOND_MILK)
end

local function ApplyBloodTearsModifiers(ctx)
    if (not BloodTears_LowPriorityBlock(ctx) and BloodTears_LowPriority(ctx))
        or BloodTears_HighPriority(ctx) then
        ctx.isBloodTear = true
    end

    ctx.isBloodTear = ctx.isBloodTear and not BloodTears_HighPriorityBlock(ctx)
end

---@class Content.Player.TearHitParams.BloodTears
local Module = {}

--#region Module

Module.ApplyBloodTearsModifiers = ApplyBloodTearsModifiers

--#endregion

return Module