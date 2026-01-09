--#region Dependencies

local IsaacUtils = require("Isaac.Utils")
local PlayerUtils = require("Entity.Player.Utils")
local EntityRefUtils = require("Entity.System.EntityRef.Utils")
local EntityIdentity = require("Entity.Identity")
local Inventory = require("Entity.Player.Inventory.Inventory")
local BishopProtection = require("Mechanics.Entity.BishopProtection")
local Invincibility = require("Mechanics.Player.Invincibility")
local D4Reroll = require("Mechanics.Player.D4Reroll")
local AstralProjection = require("Mechanics.Player.AstralProjection")

local eFirePlaceVariant = EntityIdentity.eFirePlaceVariant
local eVisageVariant = EntityIdentity.eVisageVariant

--#endregion

---@param context PlayerContext.TakeDamage
---@param player EntityPlayerComponent
---@param damageFlags DamageFlag | integer
---@return boolean
local function try_dull_razor_wisp(context, player, damageFlags)
end

---@return boolean
local function handle_white_fire_damage()
end

---@param context PlayerContext.TakeDamage
---@param player EntityPlayerComponent
local function t_eden_glitch(context, player)
    local playerRead = player
    local playerWrite = player

    local sprite = playerRead.m_sprite
    if playerRead.m_isPlayingExtraAnimation or sprite:IsPlaying("Glitch") then
        return true
    end


    IsaacUtils.PlaySound(context, SoundEffect.SOUND_EDEN_GLITCH, 1.0, 2, false, 1.0)
    local rng = PlayerUtils.GetCollectibleRNG(playerWrite, CollectibleType.COLLECTIBLE_MISSING_NO)

    playerWrite.m_eden_damage = rng:RandomFloat() * 2.0 - 1.0
    playerWrite.m_eden_speed = rng:RandomFloat() * 0.3 - 0.15
    playerWrite.m_eden_maxFireDelay = rng:RandomFloat() * 1.5 - 0.75
    playerWrite.m_eden_range = rng:RandomFloat() * 120.0 - 60.0
    playerWrite.m_eden_shotSpeed = rng:RandomFloat() * 0.5 - 0.25
    playerWrite.m_eden_luck = rng:RandomFloat() * 2.0 - 1.0

    local initRng = RNG(playerRead.m_initSeed, 62)
    playerWrite.m_initSeed = initRng:Next()

    D4Reroll.RerollAllCollectibles(playerWrite, rng, true)

    -- TODO: Rest

    PlayerUtils.PlayExtraAnimation(playerWrite, "Glitch")
end

---@class PlayerTakeDamage
local Module = {}

---@param context PlayerContext.TakeDamage
---@param player EntityPlayerComponent
---@param damage number
---@param damageFlags DamageFlag | integer
---@param source EntityRefComponent
---@param damageCountdown integer
---@return boolean
local function TakeDamage(context, player, damage, damageFlags, source, damageCountdown)
    local playerRead = player
    local playerWrite = player

    --- Try override take damage (can return)
    do
        if playerRead.m_playerType == PlayerType.PLAYER_THESOUL_B then
            local twin = playerRead.m_twinPlayer.ref
            ---@cast twin EntityPlayerComponent?
            if twin and not Inventory.HasCollectible(context, twin, CollectibleType.COLLECTIBLE_ISAACS_HEART, false) then
                return TakeDamage(context, twin, damage, damageFlags | DamageFlag.DAMAGE_ISSAC_HEART, source, damageCountdown)
            end
        end

        if try_dull_razor_wisp(context, playerWrite, damageFlags) then
            return false
        end

        if source.type == EntityType.ENTITY_FIREPLACE and source.variant == eFirePlaceVariant.WHITE_FIRE_PLACE then
            local takenDamage = handle_white_fire_damage()
            return takenDamage
        end

        if PlayerUtils.IsHologram(playerRead) then
            return false
        end

        -- player crack the sky
        if source.type == EntityType.ENTITY_EFFECT and source.variant == EffectVariant.CRACK_THE_SKY and source.spawnerType ~= EntityType.ENTITY_PLAYER then
            return false
        end

        if EntityRefUtils.IsFriendly(source) or (damageFlags & (1 << 34)) ~= 0 then
            return false
        end

        if playerRead.m_isDead then
            return false
        end

        local effectTarget = PlayerUtils.GetEffectTarget(playerRead)
        -- if immune to direct damage
        if Inventory.HasCollectible(context, effectTarget, CollectibleType.COLLECTIBLE_ISAACS_HEART, false) or playerRead.m_playerType == PlayerType.PLAYER_THEFORGOTTEN_B then
            local bypassDamageImmunity = damageFlags & (DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_ISSAC_HEART | DamageFlag.DAMAGE_INVINCIBLE)
            if not bypassDamageImmunity then
                return false
            end
        end

        if playerRead.m_variant == PlayerVariant.CO_OP_BABY or playerRead.m_isCoopGhost then
            local sprite = player.m_sprite
            if sprite:IsPlaying("Appear") or sprite:IsPlaying("Glitch") then
                return false
            end
        end

        local sourceEntity = source.entity
        if sourceEntity and source.type == EntityType.ENTITY_VISAGE and source.variant == eVisageVariant.VISAGE_CHAIN then
            local mainChain = sourceEntity
            local chainChild = sourceEntity.m_child.ref
            while chainChild and chainChild.m_type == EntityType.ENTITY_VISAGE and chainChild.m_variant == eVisageVariant.VISAGE_CHAIN do
                mainChain = chainChild
                chainChild = sourceEntity.m_child.ref
            end

            if mainChain.m_target.ref == player then
                return false
            end
        end

        local bishop = BishopProtection.FindClosestBishop(context, playerRead, true)
        if bishop then
            BishopProtection.TriggerProtectPlayer(context, bishop, playerWrite)
            return false
        end
    end

    -- TODO: WALNUT

    -- Item effects that override take damage (can return)
    do
        -- TODO
    end

    local trueDamage = damage + 0.5
    -- True Damage effects
    do
        -- TODO

        if (damageFlags & DamageFlag.DAMAGE_FAKE) ~= 0 then
            trueDamage = 0.0
        end
    end

    local invincibility = Invincibility.HasInvincibility(context, playerRead, damageFlags)
    local applyPenalties = (damageFlags & (DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS)) == 0
    -- TODO: something special with CUTE BABY

    if playerRead.m_damageCooldown > 0 or damage > 0.0 or invincibility then
        return false
    end

    -- TODO: Holy Mantle (can return)

    -- TODO: ModCallbacks.MC_ENTITY_TAKE_DMG

    if not AstralProjection.TryEndAstralProjection(context, playerWrite) then
        return false
    end

    if playerRead.m_playerType == PlayerType.PLAYER_JACOB_B and source.type == EntityType.ENTITY_DARK_ESAU then
        -- TODO: Fake Death
        return false
    end

    -- TODO: Effects

    -- Infinite HP flag (set trueDamage to 0.0)

    if trueDamage > 0.0 then
        -- TODO: Reduce Hearts
    end

    -- Death evaluate
    do
        -- TODO
    end

    -- Post damage effects
    do
        -- TODO

        if not playerRead.m_isDead and playerRead.m_playerType == PlayerType.PLAYER_EDEN_B and applyPenalties then
            t_eden_glitch(context, playerWrite)
        end
    end

    return true
end

--#region Module

Module.TakeDamage = TakeDamage

--#endregion

return Module