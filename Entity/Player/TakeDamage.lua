--#region Dependencies

local BitSetUtils = require("General.Bitset")
local EntityIdentity = require("Entity.Identity")
local CoPlayerSprite = require("Entity.Player.Sprite.CoPlayer")
local PlayerUtils = require("Entity.Player.Utils")
local PlayerRules = require("Entity.Player.Rules")
local EntityRefUtils = require("Entity.System.EntityRef.Utils")
local Inventory = require("Game.Inventory.Inventory")

local eFirePlaceVariant = EntityIdentity.eFirePlaceVariant
local eVisageVariant = EntityIdentity.eVisageVariant

--#endregion

---@class PlayerTakeDamageLogic
local Module = {}

---@param context Context
---@param player EntityPlayerComponent
---@param damage number
---@param damageFlags DamageFlag | integer
---@param source EntityRefComponent
---@param damageCountdown integer
---@return boolean? override
local function hook_pre_evaluate_take_damage(context, player, damage, damageFlags, source, damageCountdown)
    if player.m_playerType == PlayerType.PLAYER_THESOUL_B then
        local twin = player.m_twinPlayer
        if twin and not Inventory.HasCollectible(context, twin, CollectibleType.COLLECTIBLE_ISAACS_HEART, false) then
            return twin:TakeDamage(context, damage, damageFlags | DamageFlag.DAMAGE_ISSAC_HEART, source, damageCountdown)
        end
    end

    if TryDullRazorWisp(context, player, damageFlags) then
        return false
    end

    if source.type == EntityType.ENTITY_FIREPLACE and source.variant == eFirePlaceVariant.WHITE_FIRE_PLACE then
        local takenDamage = HandleWhiteFireDamage()
        return takenDamage
    end

    if PlayerUtils.IsHologram(player) then
        return false
    end

    if source.type == EntityType.ENTITY_EFFECT and source.variant == EffectVariant.CRACK_THE_SKY and source.spawnerType ~= EntityType.ENTITY_PLAYER then
        return false
    end

    if EntityRefUtils.IsFriendly(source) or damageFlags & (1 << 34) ~= 0 then
        return false
    end

    local effectTarget = PlayerRules.GetEffectTarget(context, player)
    -- if immune to direct damage
    if Inventory.HasCollectible(context, effectTarget, CollectibleType.COLLECTIBLE_ISAACS_HEART, false) or player.m_playerType == PlayerType.PLAYER_THEFORGOTTEN_B then
        if not BitSetUtils.HasAny(damageFlags, DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_ISSAC_HEART | DamageFlag.DAMAGE_INVINCIBLE) then
            return false
        end
    end
end

---@param context Context
---@param player EntityPlayerComponent
---@param damage number
---@param damageFlags DamageFlag | integer
---@param source EntityRefComponent
---@param damageCountdown integer
---@return boolean? override
local function hook_pre_take_damage(context, player, damage, damageFlags, source, damageCountdown)
    -- Evaluate Visage chain can damage
    -- Evaluate Friendly Bishop Block
    -- Handle WALNUT
    -- Handle PYROMANIAC Heal + Block
    -- Handle HOST_HAT block
    -- Handle DR_FETUS + IPECAC self damage block
    -- Handle HOT_BOMBS Fire damage block
    -- Handle JELLY_BELLY block
    -- Handle HOST_HAT projectile reflect + block
    -- Handle METAL_PLATE block
    -- Handle CONE_HEAD block
    -- Handle BREATH_OF_LIFE block
    -- SEED_INVINCIBLE and KIDS_MODE evaluation
end

---@param context Context
---@param player EntityPlayerComponent
---@param damage number
---@param damageFlags DamageFlag | integer
---@param source EntityRefComponent
---@param damageCountdown integer
---@return boolean? override
local function hook_pre_apply_damage(context, player, damage, damageFlags, source, damageCountdown)
    -- Evaluate HOLY_MANTLE block
    -- Evaluate HALLOWED_GROUND block
    -- ENTITY_TAKE_DAMAGE callback
    -- Evaluate ASTRAL_PROJECTION
    -- Handle Dark Esau Fake Death
end

---@param context Context
---@param player EntityPlayerComponent
---@param damage number
---@param damageFlags DamageFlag | integer
---@param source EntityRefComponent
---@param damageCountdown integer
local function hook_apply_damage_effects(context, player, damage, damageFlags, source, damageCountdown)
    -- Steal Coin effect
    -- Coop Baby effects
    -- MARBLES effect
    -- THE_NAIL effect
    -- Evaluate damage sound
    -- RED_PATCH
    -- MISSING_PAGE
    -- FISH_HEAD
    -- INFESTATION
    -- LEPROSY
    -- GIANT_CELL
    -- SALVATION
    -- evaluate PERFECTION_REMOVED
    -- STOMPY form effects
    -- CELTIC_CROSS
    -- DEAD_BIRD
    -- BIRD_CAGE
    -- Add charge to all instances of LARYNX
    -- SAMSON_B berserk charge
    -- BEST_BUD
    -- HABIT
    -- BLACK_BEAN
    -- ANEMIC
    -- SWALLOWED_PENNY
    -- FANNY_PACK
    -- OLD_BANDAGE
    -- GIMPY
    -- PIGGY_BANK
    -- CARTRIDGE
    -- SPIDERBABY
    -- MISSING_PAGE_2
    -- COLLECTIBLE_CANCER or ZodiacEffect
    -- VIRGO or ZodiacEffect
    -- BLOODY_LUST
    -- BLOODY_GUST
    -- CURSE_OF_THE_TOWER
    -- CRACKED_DICE
    -- PURITY
    -- CROWN_OF_LIGHT
    -- CAMBION_CONCEPTION
    -- Update Bleedout
    -- SHARD_OF_GLASS
    -- VARICOSE_VEINS
    -- IT_HURTS
    -- CRACKED_ORB
    -- VENGEFUL_SPIRIT
    -- TORN_POCKET
    -- HYPERCOAGULATION
    -- TRIGGER procedural DAMAGE_TAKEN effects
    -- LARGE_ZIT
    -- TONSIL
    -- BAG_LUNCH
    -- UMBILICAL_CORD
    -- WISH_BONE
    -- BOZO
    -- BUTTER
end

---@param context Context
---@param player EntityPlayerComponent
---@param damage number
---@param damageFlags DamageFlag | integer
---@param source EntityRefComponent
---@param damageCountdown integer
local function hook_post_take_damage_effects(context, player, damage, damageFlags, source, damageCountdown)
    -- CURSED_EYE
    -- POLAROID
    -- NEGATIVE
    -- CURSED_SKULL
    -- SCAPULAR
    -- MONKEY_PAW
    -- ASTRAL_PROJECTION
    -- BLIND_RAGE
    -- FINGER_BONE
    -- GLASS_CANNON
end

---@param context Context
---@param player EntityPlayerComponent
---@param damage number
---@param damageFlags DamageFlag | integer
---@param source EntityRefComponent
---@param damageCountdown integer
local function hook_post_take_damage(context, player, damage, damageFlags, source, damageCountdown)
    -- update_golden_hearts
    -- update_bone_hearts
    -- SWALLOWED_M80
    -- T.Eden Reroll
end

---@param player EntityPlayerComponent
---@param context Context
---@param damage number
---@param damageFlags DamageFlag | integer
---@param source EntityRefComponent
---@param damageCountdown integer
---@return boolean? override
local function TakeDamage(player, context, damage, damageFlags, source, damageCountdown)
    local override = hook_pre_evaluate_take_damage(context, player, damage, damageFlags, source, damageCountdown)
    if override ~= nil then
        return override
    end

    if player.m_isDead then
        return false
    end

    if player.m_variant == PlayerVariant.CO_OP_BABY or player.m_isCoopGhost then
        local sprite = player.m_sprite
        if sprite:IsPlaying(CoPlayerSprite.Animations.APPEAR) or sprite:IsPlaying(CoPlayerSprite.Animations.GLITCH) then
            return false
        end
    end

    override = hook_pre_take_damage(context, player, damage, damageFlags, source, damageCountdown)
    if override ~= nil then
        return override
    end

    -- apply poison damage
    local realDamage = 0.0 -- TODO: calc real damage received
    
    local forceTriggerDamage = DamageFlag.DAMAGE_FAKE
    local invincibility = false -- TODO evaluate invincibility
    if (player.m_damageCooldown >= 0 or damage <= 0.0 or invincibility) and not forceTriggerDamage then
        return false
    end

    override = hook_pre_apply_damage(context, player, damage, damageFlags, source, damageCountdown)
    if override ~= nil then
        return override
    end

    -- buffer damage
    hook_apply_damage_effects(context, player, damage, damageFlags, source, damageCountdown)
    -- wisp take damage?
    -- set damage flags
    
    if debug_flag then
        realDamage = 0.0
    end

    if realDamage > 0.0 then
        -- reduce hearts
    end

    -- if should_trigger death then
    --  -- HEARTBREAK
    --  -- prevent death
    --  -- check_death
    --  -- unlock self ipecac kill achievement
    -- end

    hook_post_take_damage_effects(context, player, damage, damageFlags, source, damageCountdown)
    -- play hit extra animation
    -- reset item state, unless item state is DOCTORS_REMOTE
    -- sync twin damage cooldown
    hook_post_take_damage(context, player, damage, damageFlags, source, damageCountdown)
    return true
end

--#region Module



--#endregion

return Module