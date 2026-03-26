--#region Dependencies

local Log = require("General.Log")
local VectorUtils = require("General.Math.VectorUtils")
local Enums = require("General.Enums")
local IsaacUtils = require("Isaac.Utils")
local GameUtils = require("Game.Utils")
local WeaponFactory = require("Game.Weapon.Factory")
local Spawn = require("Game.Spawn")
local EntityUtils = require("Entity.Utils")
local PlayerUtils = require("Entity.Player.Utils")
local TemporaryEffectsUtils = require("Game.TemporaryEffects.Utils")
local PlayerInventory = require("Mechanics.Player.Inventory")

local VectorZero = VectorUtils.VectorZero
local eSpecialDailyRuns = Enums.eSpecialDailyRuns
--#endregion

local ItemStateUpdate = {}

local function switch_item_state_update(itemState)
    local update = ItemStateUpdate[itemState]
    if not update then
        Log.LogMessage(0, string.format("No Such State %d\n", itemState))
        return
    end

    update()
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@return WeaponModifier | integer
local function get_weapon_modifiers(myContext, player)
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param shootingInput Vector
local function do_zit_effect(myContext, player, shootingInput)
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param shootingInput Vector
---@param isShooting boolean
local function fire(myContext, player, shootingInput, isShooting)
    local game = myContext.game

    local fireDeadTooth = PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_DEAD_TOOTH, false)
        and isShooting and not player.m_deadTooth_effectEntity.ref

    if fireDeadTooth then
        local seed = IsaacUtils.Random()
        local fartRing = Spawn.Spawn(myContext, game, EntityType.ENTITY_EFFECT, EffectVariant.FART_RING, 0, seed, player.m_position, VectorZero, player)

        local sprite = fartRing.m_sprite
        sprite.Scale = Vector(0.8, 0.8)
        EntityUtils.SetEntityReference(player.m_deadTooth_effectEntity, fartRing)
        EntityUtils.SetEntityReference(fartRing.m_parent, player)

        fartRing:Update(myContext)
    end

    local zitEffect = PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_LARGE_ZIT, false)
        and isShooting and EntityUtils.IsFrame(myContext, player, 30, 0) and IsaacUtils.RandomInt(3) == 0

    if zitEffect then
        do_zit_effect(myContext, player, shootingInput)
    end

    local interpolation = (player.m_flags & EntityFlag.FLAG_INTERPOLATION_UPDATE) ~= 0

    local hasWeaponOverride = player.m_weapons[1] ~= nil
    if hasWeaponOverride then
        local weapon = player.m_weapons[1]
        weapon:Fire(myContext, shootingInput, isShooting, interpolation)
    else
        for i = 2, 5, 1 do
            local weapon = player.m_weapons[i]
            if weapon then
                weapon:Fire(myContext, shootingInput, isShooting, interpolation)
            end
        end
    end
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
local function ControlShooting(myContext, player)
    local game = myContext.game

    local shootingInput = Vector(0, 0)
    local isShooting = false
    local realIsShooting = false
    local opposingShootDirectionsPressed = false

    local interpolationUpdate = (player.m_flags & EntityFlag.FLAG_INTERPOLATION_UPDATE) ~= 0
    local controlsEnabled = player.m_controlsEnabled and player.m_controlsCooldown <= 0
        and (player.m_flags & EntityFlag.FLAG_FEAR) == 0

    local target = player.m_target.ref
    if target and target.m_isDead then
        player.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        EntityUtils.SetEntityReference(player.m_target, nil)
    end

    if player.m_playerType == PlayerType.PLAYER_THESOUL_B and player.m_itemState == CollectibleType.COLLECTIBLE_NULL then
        controlsEnabled = false
    end

    if controlsEnabled then
        -- TODO
    end

    if player.m_variant == PlayerVariant.CO_OP_BABY and player.m_babySkin == BabySubType.BABY_YBAB then
        -- TODO
    end

    if player.m_peeBurstCooldown > 0 then
        -- TODO
    end

    local heldEntity = player.m_heldEntity.ref
    local forceThrow = not PlayerUtils.IsExtraAnimationFinished(player) and heldEntity and
        player.m_itemState ~= CollectibleType.COLLECTIBLE_MOMS_BRACELET and player.m_itemState ~= CollectibleType.COLLECTIBLE_SUPLEX

    if forceThrow then
        -- TODO
    end

    local temporaryEffects = player.m_temporaryEffects
    local preventFiring = player.m_firingCooldown > 0
        or TemporaryEffectsUtils.HasCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_GAMEKID)
        or TemporaryEffectsUtils.HasCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN)
        or TemporaryEffectsUtils.HasCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_UNICORN_STUMP)
    if not preventFiring then
        local taurusEffect = TemporaryEffectsUtils.GetCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_TAURUS)
        if taurusEffect then
            preventFiring = taurusEffect.m_cooldown ~= 0
        end
    end

    if preventFiring then
        shootingInput = Vector(0, 0)
        isShooting = false
        realIsShooting = false
    end

    local itemState_isShooting = false
    local itemState_realIsShooting = false
    local itemState_active = player.m_itemStateCooldown <= 0

    if itemState_active then
        -- TODO
    else
        -- TODO
    end

    if itemState_active then
        itemState_isShooting = isShooting
        itemState_realIsShooting = realIsShooting
    end

    realIsShooting = not VectorUtils.Equals(shootingInput, VectorZero)
    if realIsShooting and itemState_isShooting then
        shootingInput = -player.m_lastDirection
    end

    local realIsShooting_1 = not VectorUtils.Equals(shootingInput, VectorZero)

    local suplexState = player.m_suplex_state
    local markedTarget_variant = EffectVariant.EFFECT_NULL
    local markedTarget_weapon = player.m_weapons[2]

    if markedTarget_weapon then
        markedTarget_variant = markedTarget_weapon:GetMarkedTargetVariant()
    end
    if suplexState == SuplexState.AIMING then
        markedTarget_variant = EffectVariant.TARGET
    end

    local markedTarget_entity = player.m_marked_targetEntity.ref

    if markedTarget_variant ~= EffectVariant.EFFECT_NULL then
        -- TODO
    else
        -- Remove Target if it exists
        if markedTarget_entity and not interpolationUpdate then
            markedTarget_entity:Remove(myContext)
            EntityUtils.SetEntityReference(player.m_marked_targetEntity, nil)
        end
    end

    local stageTransitionActive = game.m_stageTransition.m_mode == 0

    local number2Effect = PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_NUMBER_TWO, false)
        and not stageTransitionActive and controlsEnabled and player.m_firingCooldown <= 0

    if number2Effect then
        -- TODO
    end

    local tellAJokeEffect = game.m_dailyChallenge.m_specialDailyChallenge == eSpecialDailyRuns.TELL_A_JOKE_DAY
        and not stageTransitionActive and controlsEnabled and isShooting
        and EntityUtils.IsFrame(myContext, player, 30, 0) and IsaacUtils.RandomInt(4) == 0

    if tellAJokeEffect then
        -- TODO
    end

    if not stageTransitionActive and controlsEnabled and player.m_firingCooldown <= 0 then
        if isShooting then
            player.m_unkTimeSinceFireReady = 0
        else
            player.m_unkTimeSinceFireReady = player.m_unkTimeSinceFireReady + 1
        end
    end

    local canShoot = player.m_canShoot
        and not (player.m_megaBlast_duration > 0 or player.m_azazelsRage_laser.ref ~= nil)
        and player.m_firingCooldown <= 0

    local urethraBlocked = player.m_isUrethraBlocked and player.m_firingCooldown <= 0 and controlsEnabled
    if urethraBlocked then
        
    end

    local ibsCharge = player.m_ibs_charge
    if ibsCharge < 1.0 then
        player.m_ibsRelated = 0.0
    end

    local ibsEffect = ibsCharge < 1.0 and controlsEnabled and player.m_itemState == CollectibleType.COLLECTIBLE_NULL
    if ibsEffect then
        -- TODO
    end

    if player.m_headDirectionLockTime < 0 then
        -- TODO
    end

    -- update fire direction
    local hasFireDirection = player.m_firingCooldown <= 0 and (math.abs(shootingInput.X) + math.abs(shootingInput.Y) > 0.01)
    if hasFireDirection then
        player.m_fireDirection = IsaacUtils.GetVectorDirection(shootingInput)
    else
        player.m_fireDirection = Direction.NO_DIRECTION
    end

    local updateShootingEffects = PlayerUtils.IsExtraAnimationFinished(player) and not stageTransitionActive and controlsEnabled
    if updateShootingEffects then
        -- TODO
    end

    local weaponModifiers = get_weapon_modifiers(myContext, player)

    -- weapon override
    local weaponOverride_type = nil
    if player.m_itemState == CollectibleType.COLLECTIBLE_DOCTORS_REMOTE then
        weaponOverride_type = WeaponType.WEAPON_ROCKETS
    elseif TemporaryEffectsUtils.HasCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_NOTCHED_AXE) then
        weaponOverride_type = WeaponType.WEAPON_NOTCHED_AXE
        canShoot = true
    elseif TemporaryEffectsUtils.HasCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_URN_OF_SOULS) then
        weaponOverride_type = WeaponType.WEAPON_URN_OF_SOULS
        canShoot = true
    elseif player.m_playerType == PlayerType.PLAYER_LILITH_B then
        weaponOverride_type = WeaponType.WEAPON_UMBILICAL_WHIP
        canShoot = true
    end

    if weaponOverride_type then
        local override = player.m_weapons[1]
        if not override or override.m_weaponType ~= weaponOverride_type then
            if override then
                WeaponFactory.DestroyWeapon(player.m_weapons[1])
            end
            player.m_weapons[1] = WeaponFactory.CreateWeapon(weaponOverride_type)
        end
    else
        local override = player.m_weapons[1]
        if override then
            WeaponFactory.DestroyWeapon(player.m_weapons[1])
            player.m_weapons[1] = nil
        end
    end

    -- update weapons
    for i = 2, 5, 1 do
        local weapon = player.m_weapons[i]
        if weapon then
            weapon.m_maxFireDelay = player.m_maxFireDelay
            weapon.m_weaponModifiers = weaponModifiers
        end
    end

    local weaponOverride = player.m_weapons[1]
    if weaponOverride then
        weaponOverride.m_maxFireDelay = player.m_maxFireDelay
        weaponOverride.m_weaponModifiers = weaponModifiers | WeaponModifier.BONE -- modifier OVERRIDE
        weaponOverride:Update(myContext, interpolationUpdate)
    else
        for i = 2, 5, 1 do
            local weapon = player.m_weapons[i]
            if weapon then
                weaponOverride:Update(myContext, interpolationUpdate)
            end
        end
    end

    -- update lock times
    if player.m_itemState == CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP and realIsShooting_1 then
        player.m_blinkTime = 10
    end

    local unkBlinkRelated = player.m_blinkTime < 9 and 0 or 2
    if interpolationUpdate then
        if player.m_blinkTime > -1 then
            player.m_blinkTime = player.m_blinkTime - 1
        end

        if player.m_headDirectionLockTime > -1 then
            player.m_headDirectionLockTime = player.m_headDirectionLockTime - 1
        end
    end

    local capBlink = PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_POINTY_RIB, false)
        or (player.m_playerType == PlayerType.PLAYER_LILITH and PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_BIRTHRIGHT, false))

    if capBlink then
        player.m_blinkTime = math.max(player.m_blinkTime, 7)
    end

    if shootingInput:Length() > 1.0 then
        shootingInput:Resize(1.0)
    end

    local axisAlignedInput = VectorUtils.GetAxisAlignedUnitVector(shootingInput)

    -- update trinity shield
    if PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_TRINITY_SHIELD, false) then
        -- TODO
    else
        -- TODO: remove trinity shield
    end

    local evaluateDoubleTap = player.m_controlsEnabled and (PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_GB_BUG, false)
        or PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_DIVINE_INTERVENTION, false)
        or PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_HEMOPTYSIS, false))

    if evaluateDoubleTap then
        -- TODO
    end
    player.m_doubleFireTap_framesSinceTrigger = player.m_doubleFireTap_framesSinceTrigger + 1

    -- update spear of destiny
    if PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_SPEAR_OF_DESTINY, false) then
        -- TODO
    else
        -- TODO: remove spear of destiny
    end

    local bleedOutEffect = not interpolationUpdate
        and EntityUtils.IsFrame(myContext, player, 2, 0)
        and (TemporaryEffectsUtils.HasCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_SCISSORS)
        or (player.m_flags & EntityFlag.FLAG_BLEED_OUT) ~= 0)
        and not PlayerUtils.IsFullSpriteRendering(player)
        and IsaacUtils.RandomInt(2) == 0

    if bleedOutEffect then
        -- TODO
    end

    -- teardrop charm
    local teardropCharm_originalLuck = player.m_luck
    local teardropCharm_newLuck = teardropCharm_originalLuck
    local teardropCharm_multiplier = PlayerInventory.GetTrinketMultiplier(myContext, player, TrinketType.TRINKET_TEARDROP_CHARM)

    if teardropCharm_multiplier > 0 then
        teardropCharm_newLuck = player.m_luck + (teardropCharm_multiplier + teardropCharm_multiplier + 2.0)
        player.m_luck = teardropCharm_newLuck
    end

    -- itemState update
    switch_item_state_update(player.m_itemState)

    if player.m_luck == teardropCharm_newLuck then
        player.m_luck = teardropCharm_originalLuck
    end

    local keepCurrentHeadDirection = isShooting or player.m_blinkTime > -1 or player.m_headDirectionLockTime > -1 or
        game.m_roomTransition.m_mode ~= 0

    if not keepCurrentHeadDirection then
        -- TODO:
    end

    if not PlayerUtils.IsFullSpriteRendering(player) then
        -- TODO: update head sprite

    end

    if player.m_firingCooldown <= 0 then
        -- update shootingInput data
        player.m_aimDirection = VectorUtils.Copy(shootingInput)
        player.m_opposingShootDirectionsPressed = opposingShootDirectionsPressed
        if not realIsShooting then
            player.m_fireInputs = {}
        else
            player.m_lastDirection = VectorUtils.Copy(shootingInput)
            table.insert(player.m_fireInputs, VectorUtils.Copy(shootingInput))

            while #player.m_fireInputs > 3 do
                table.remove(player.m_fireInputs, 1) -- pop_front
            end
        end
    end
end

local Module = {}

--#region Module

Module.ControlShooting = ControlShooting

--#endregion

return Module