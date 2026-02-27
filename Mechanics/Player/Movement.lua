--#region Dependencies

local IsaacUtils = require("Isaac.Utils")
local MathUtils = require("General.Math")
local VectorUtils = require("General.Math.VectorUtils")
local ItemConfigUtils = require("Isaac.ItemConfig.Utils")
local SpawnLogic = require("Game.Spawn")
local SeedsUtils = require("Admin.Seeds.Utils")
local TemporaryEffectsUtils = require("Game.TemporaryEffects.Utils")
local EntityUtils = require("Entity.Utils")
local EntityCast = require("Entity.TypeCast")
local HitListUtils = require("Entity.HitList")
local PlayerUtils = require("Entity.Player.Utils")
local PlayerInventory = require("Mechanics.Player.Inventory")
local PlayerItemAnim = require("Entity.Player.ItemAnim")
local PlayerCostume = require("Entity.Player.Costume")
local QuestUtils = require("Mechanics.Game.Quest.Utils")

local VectorZero = VectorUtils.VectorZero
--#endregion

local SIDE_ONLY_ANIMATION = {
    [Direction.LEFT] = "HeadLeft",
    [Direction.UP] = "HeadLeft",
    default = "HeadRight",
}

local HEAD_ANIMATION = {
    [Direction.LEFT] = "HeadLeft",
    [Direction.UP] = "HeadUp",
    [Direction.RIGHT] = "HeadRight",
    default = "HeadDown",
}

local WALK_ANIMATION = {
    [Direction.LEFT] = "WalkLeft",
    [Direction.UP] = "WalkUp",
    [Direction.RIGHT] = "WalkRight",
    default = "WalkDown",
}

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@return Vector
local function GetMovementInput(myContext, player)
    local playerType = player.m_playerType
    local indirectlyControlled = playerType == PlayerType.PLAYER_ESAU or
        (player.m_parent.ref and player.m_parent.ref.m_type == EntityType.ENTITY_PLAYER) or
        ((playerType == PlayerType.PLAYER_LAZARUS2 or playerType == PlayerType.PLAYER_LAZARUS2_B) and not PlayerUtils.IsMainTwin(player))

    if indirectlyControlled and player.m_controlsEnabled and player.m_controlsCooldown <= 0 and IsaacUtils.IsActionPressed(myContext.manager, ButtonAction.ACTION_DROP, player.m_controllerIndex, nil) then
        return VectorUtils.Copy(VectorZero)
    end

    local isaac = myContext.manager
    local controllerIdx = player.m_controllerIndex

    local left = IsaacUtils.GetActionValue(isaac, ButtonAction.ACTION_LEFT, controllerIdx, player)
    local right = IsaacUtils.GetActionValue(isaac, ButtonAction.ACTION_RIGHT, controllerIdx, player)
    local up = IsaacUtils.GetActionValue(isaac, ButtonAction.ACTION_UP, controllerIdx, player)
    local down = IsaacUtils.GetActionValue(isaac, ButtonAction.ACTION_DOWN, controllerIdx, player)
    local input = Vector(right - left, down - up)

    local seeds = myContext.game.m_seeds
    local controlsReversed = SeedsUtils.HasSeedEffect(seeds, SeedEffect.SEED_CONTROLS_REVERSED)
    local axisAlignedControls = SeedsUtils.HasSeedEffect(seeds, SeedEffect.SEED_AXIS_ALIGNED_CONTROLS)
    local mirrorWorld = QuestUtils.IsMirrorWorld(myContext, myContext.game.m_level)

    if controlsReversed then
        input = -input
    end

    if axisAlignedControls then
        local magnitude = input:Length()
        input = VectorUtils.GetAxisAlignedUnitVector(input)
        input = input * magnitude
    end

    if mirrorWorld then
        input.X = -input.X
    end

    return input
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
local function jupiter_update(myContext, player, targetVelocity)
    if VectorUtils.Equals(targetVelocity, VectorZero) then
        if player.m_velocity:Length() < 1.0 then
            local add = player.m_timeScale / 60.0
            player.m_jupiter_charge = math.min(player.m_jupiter_charge + add, 1.0)
        end

        return
    end

    local remove = player.m_timeScale / 60.0
    local charge = math.max(player.m_jupiter_charge - remove, 0.0)
    player.m_jupiter_charge = charge

    if not (charge > 0.0 and EntityUtils.IsTimeScaledFrame(myContext, player, 2.0, 0.0)) then
        return
    end

    if charge > 0.3 then
        IsaacUtils.PlaySound(myContext, SoundEffect.SOUND_FART, charge, IsaacUtils.RandomInt(8) + 5, false, 1.0)
    end

    local recentMovement = player.m_recentMovementVector
    local playerDirection
    if recentMovement:Length() <= 0.01 then
        local direction = player.m_movementDirection
        direction = direction == Direction.NO_DIRECTION and Direction.DOWN or direction

        playerDirection = IsaacUtils.GetAxisAlignedUnitVectorFromDirection(direction)
    else
        playerDirection = recentMovement:Normalized()
    end

    local fartDirection = -playerDirection
    local splashSpeed = IsaacUtils.RandomFloat() * 20.0 + 6.0
    local splashSeed = IsaacUtils.Random()
    local splashAngle = IsaacUtils.RandomFloat() * 40.0 - 20.0

    local splashPosition = player.m_position + fartDirection * 4.0
    local splashVelocity = fartDirection:Rotated(splashAngle) * splashSpeed
    local splash = SpawnLogic.Spawn(myContext, myContext.game, EntityType.ENTITY_EFFECT, EffectVariant.WATER_SPLASH, 1, splashSeed, splashPosition, splashVelocity, nil)

    local splashScale = IsaacUtils.RandomFloat() * 1.5 + 1.0
    local splashSprite = splash.m_sprite
    splashSprite.Scale = splashSprite.Scale * splashScale
    splashSprite.Color = Color(0.3, 0.42, 0.25, 1.0)
    splash:Update(myContext)

    local fartSpeed = IsaacUtils.RandomFloat() * 10.0 + 10.0
    local fartRotation = IsaacUtils.RandomFloat() * 40.0 - 20.0
    local fartStartOffset = IsaacUtils.RandomFloat() * 3.0 + 2.0
    local fartSeed = IsaacUtils.Random()

    local fartPosition = player.m_position + (fartDirection * fartStartOffset)
    local fartVelocity = fartDirection:Rotated(fartRotation) * fartSpeed
    local ent = SpawnLogic.Spawn(myContext, myContext.game, EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, fartSeed, fartPosition, fartVelocity, player)
    local fart = EntityCast.StaticToEffect(ent)

    local fartLifetime = IsaacUtils.RandomInt(30) + 60
    fart.m_timeout = fartLifetime
    fart.m_lifeSpan = fartLifetime
    local scaleMultiplier = PlayerInventory.GetTrinketMultiplier(myContext, player, TrinketType.TRINKET_GIGANTE_BEAN) > 1 and 2.0 or 1.0
    local fartScale = (IsaacUtils.RandomFloat() * 0.4 + 0.6) * scaleMultiplier
    fart.m_sprite.Scale = VectorUtils.VectorOne * fartScale
    fart:SetCollisionDamage(myContext, player.m_tearPoisonDamage * 0.5)
    fart:Update(myContext)
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param direction Direction | integer
local function update_mars_direction(myContext, player, direction)
    local currentTapDirection = player.m_mars_tapDirection
    local currentFrames = player.m_mars_framesSinceLastTap

    player.m_mars_tapDirection = direction
    player.m_mars_framesSinceLastTap = 0

    if currentTapDirection ~= direction or currentFrames > 10 or player.m_mars_cooldown > 0 then
        return
    end

    -- perform dash
    local directionVector = IsaacUtils.GetAxisAlignedUnitVectorFromDirection(direction)
    if QuestUtils.IsMirrorWorld(myContext, myContext.game.m_level) then
        directionVector.X = -directionVector.X
    end

    TemporaryEffectsUtils.AddCollectibleEffect(myContext, player.m_temporaryEffects, CollectibleType.COLLECTIBLE_MARS, false, 1)
    player.m_mars_cooldown = 90
    player.m_velocity = player.m_velocity + (directionVector * 4.0 * player.m_timeScale)
    HitListUtils.Clear(player.m_hitList)
    IsaacUtils.PlaySound(myContext, SoundEffect.SOUND_MONSTER_YELL_A, 1.0, 2, false, 0.0)

    local itemConfig = myContext.manager.m_itemConfig
    local marsCostume = ItemConfigUtils.GetNullItem(itemConfig, NullItemID.ID_MARS)
    ---@cast marsCostume ItemConfigItemComponent
    PlayerCostume.RemoveCostume(myContext, player, marsCostume)
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
local function ControlMovement(myContext, player)
    if player.m_tossedPosYOffsetRelated < 0.0 or player.m_positionOffset.Y < 0.0 then
        return
    end

    local target = player.m_target.ref
    if target then
        player.m_velocity = target.m_position - player.m_position
        return
    end

    local playerType = player.m_playerType
    local flags = player.m_flags
    local temporaryEffects = player.m_temporaryEffects

    local isForgottenB = playerType == PlayerType.PLAYER_THEFORGOTTEN_B and not player.m_isCoopGhost
    local applyGravity = (flags & EntityFlag.FLAG_APPLY_GRAVITY) ~= 0 and not player.m_canFly
    local isInterpolationUpdate = (flags & EntityFlag.FLAG_INTERPOLATION_UPDATE) ~= 0
    local isThrown = (flags & EntityFlag.FLAG_THROWN) ~= 0
    local isSlow = (flags & EntityFlag.FLAG_SLOW) ~= 0
    local isReverseChariot = TemporaryEffectsUtils.HasNullEffect(temporaryEffects, NullItemID.ID_REVERSE_CHARIOT)
    local spinToWin = TemporaryEffectsUtils.HasNullEffect(temporaryEffects, NullItemID.ID_SPIN_TO_WIN)

    player.m_velocityBeforeUpdate = VectorUtils.Copy(player.m_velocity)
    local movementVector = Vector(0.0, 0.0)

    if player.m_controlsEnabled and player.m_controlsCooldown <= 0 then
        movementVector = GetMovementInput(myContext, player)

        if applyGravity then
            movementVector.Y = 0.0
        end

        if movementVector:Length() > 1.0 then
            movementVector:Normalize()
        end
    end

    local ignoreMovementInput = isForgottenB or player.m_suplex_state ~= SuplexState.INACTIVE or player.m_darkArts_active
    if ignoreMovementInput then
        movementVector = Vector(0.0, 0.0)
    end

    local hasTwin = playerType == PlayerType.PLAYER_JACOB or playerType == PlayerType.PLAYER_ESAU
        or playerType == PlayerType.PLAYER_LAZARUS_B or playerType == PlayerType.PLAYER_LAZARUS2_B

    if (hasTwin and player.m_twinPlayer.ref) or playerType == PlayerType.PLAYER_EVE_B then
        local mainTwin = PlayerUtils.GetMainTwin(player)
        local twinInput = GetMovementInput(myContext, mainTwin)

        if VectorUtils.Equals(twinInput, VectorZero) then
            player.m_actionDropHoldTimer = 0
        end
    end

    -- reverse chariot update
    if isReverseChariot then
        local speed = movementVector:Length()
        local moveCooldown = player.m_reverseChariot_moveCooldown

        if speed <= 0.25 then
            moveCooldown = moveCooldown - 1
        elseif moveCooldown <= 0 then
            local addedVelocity = movementVector:Resized(2.0)
            -- this is not AddVelocity as it doesn't take friction into account
            player.m_velocity = player.m_velocity + addedVelocity * player.m_timeScale
            moveCooldown = 5
        else
            -- prevent the cooldown from actually reaching 0, so the player cannot keep the input pressed all the way.
            moveCooldown = math.max(moveCooldown - 1, 1)
        end

        player.m_reverseChariot_moveCooldown = moveCooldown
        movementVector = Vector(0.0, 0.0)
    else
        player.m_reverseChariot_moveCooldown = 0
    end

    if player.m_pony_charge > 0 then
        local previousDirection = VectorUtils.GetAxisAlignedUnitVector(movementVector)
        movementVector = movementVector + (previousDirection - movementVector) * 0.6
    end

    player.m_movementVector = VectorUtils.Copy(movementVector)
    if not VectorUtils.Equals(movementVector, VectorZero) then
        player.m_recentMovementVector = VectorUtils.Copy(movementVector)
    end

    local targetVelocity = movementVector * ((player.m_moveSpeed * 0.25) + 0.75)

    local movementDirection = Direction.NO_DIRECTION
    if not VectorUtils.Equals(targetVelocity, VectorZero) then
        movementDirection = IsaacUtils.GetVectorDirection(targetVelocity)
    end
    if player.m_suplex_state == SuplexState.DASHING then
        movementDirection = EntityUtils.GetVelocityDirection(player)
    end
    player.m_movementDirection = movementDirection

    if movementDirection ~= Direction.NO_DIRECTION then
        local angle = MathUtils.DegreesToRadians(targetVelocity:GetAngleDegrees())
        player.m_smoothBodyRotation = MathUtils.InterpolateAngle(player.m_smoothBodyRotation, angle, 0.3)
    end

    local slipStrength = MathUtils.InverseLerp(0.0, 60.0, player.m_slippery_strength)
    local velocityDampeningFactor
    local initialVelocity = VectorUtils.Copy(player.m_velocity)

    -- update velocity
    if isForgottenB then
        if isInterpolationUpdate then
            velocityDampeningFactor = 1.0
        elseif isThrown then
            velocityDampeningFactor = 0.97
        else
            velocityDampeningFactor =  MathUtils.Lerp(0.45, 0.96, slipStrength)
        end
    else
        if isSlow then
            slipStrength = 0.0
        end

        -- get dampening factor
        local sqrDampeningFactor = 1.0
        if not isThrown then
            local inSuplexSequence = player.m_suplex_state > SuplexState.DASHING
            local minFactor = 0.775
            if isReverseChariot or inSuplexSequence or isForgottenB then
                minFactor = 0.45
            end

            sqrDampeningFactor = MathUtils.Lerp(minFactor, 0.96, slipStrength)
        end

        velocityDampeningFactor = math.sqrt(sqrDampeningFactor)

        -- inertia preservation
        if not VectorUtils.Equals(targetVelocity, VectorZero) and not applyGravity then
            local currentVelocity = player.m_velocity
            local directionalAlignment = targetVelocity:Dot(currentVelocity)
            local inertiaReinforcedTarget = targetVelocity * directionalAlignment
            -- maximum slip -> maximum inertia
            local momentumRetention = math.sqrt(MathUtils.Lerp(0.8, 1.0, slipStrength)) -- values are between (0.9, 1.0]

            player.m_velocity = VectorUtils.Lerp(inertiaReinforcedTarget, currentVelocity, momentumRetention)
        end

        local directionalAlignment = targetVelocity:Dot(player.m_velocity)
        -- boost same direction when slipping (encourage momentum preservation), boost opposite when not slipping (encourage direction correction).
        local alignmentBoostFactor = MathUtils.Lerp(-0.2, 0.5, slipStrength)
        local alignmentBoost = alignmentBoostFactor * directionalAlignment
        alignmentBoost = math.max(alignmentBoost, 0.0)
        local normalizedBoost = alignmentBoost / player.m_moveSpeed

        local targetVelocityBoost = (normalizedBoost + 3.0) * 0.4 -- number is >= 1.2
        targetVelocityBoost = MathUtils.Lerp(targetVelocityBoost, targetVelocityBoost * 0.25, slipStrength) -- reduce impact of target velocity when slipping
        local newVelocity = player.m_velocity + (targetVelocity * 0.5 * targetVelocityBoost)

        local speedCap = player.m_moveSpeed * 4.41
        if slipStrength > 0.0 and newVelocity:Length() > speedCap then
            local oldSpeed = player.m_velocity:Length()
            newVelocity:Resize(oldSpeed)
        end

        initialVelocity = VectorUtils.Copy(player.m_velocity)
        player.m_velocity = newVelocity
    end

    local velocity = player.m_velocity
    velocity.X = velocity.X * velocityDampeningFactor
    if applyGravity then
        velocity.Y = velocity.Y + 0.225
    else
        velocity.Y = velocity.Y * velocityDampeningFactor
    end

    if spinToWin then
        player.m_velocity = player.m_velocity + initialVelocity * 0.05
        if player.m_collidesWithGrid then
            local collisionSpeed = player.m_velocityOnGridCollide:Dot(player.m_gridCollisionDirection)
            local knockBack = (player.m_gridCollisionDirection * collisionSpeed * 0.8) * 2.0
            player.m_velocity = player.m_velocityOnGridCollide - knockBack
        end
    end

    if not isInterpolationUpdate then
        local gameKid = TemporaryEffectsUtils.HasCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_GAMEKID)
        local littleUnicorn = TemporaryEffectsUtils.HasCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN)
        local unicornStump = TemporaryEffectsUtils.HasCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_UNICORN_STUMP)
        local taurus
        do local taurusEffect = TemporaryEffectsUtils.GetCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_TAURUS) taurus = taurusEffect and taurusEffect.m_cooldown > 0  end
        local bookOfShadowsCooldown
        do local bookOfShadowsEffect = TemporaryEffectsUtils.GetCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS) bookOfShadowsCooldown = bookOfShadowsEffect and bookOfShadowsCooldown.m_cooldown end
        local holyMantle = TemporaryEffectsUtils.HasCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_HOLY_MANTLE)
        local jupiter = PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_JUPITER, false)

        local sideAnimation = SIDE_ONLY_ANIMATION[player.m_movementDirection] or SIDE_ONLY_ANIMATION.default
        local headAnimation = HEAD_ANIMATION[player.m_movementDirection] or HEAD_ANIMATION.default
        local walkAnimation = WALK_ANIMATION[player.m_movementDirection] or WALK_ANIMATION.default

        -- invincibility animations
        if gameKid then
            PlayerItemAnim.PlayItemAnimCollectible(myContext, player, CollectibleType.COLLECTIBLE_GAMEKID, false, sideAnimation, -1)
        elseif littleUnicorn then
            PlayerItemAnim.PlayItemAnimCollectible(myContext, player, CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN, false, headAnimation, -1)
        elseif unicornStump then
            PlayerItemAnim.PlayItemAnimCollectible(myContext, player, CollectibleType.COLLECTIBLE_UNICORN_STUMP, false, headAnimation, -1)
        elseif taurus then
            PlayerItemAnim.PlayItemAnimCollectible(myContext, player, CollectibleType.COLLECTIBLE_TAURUS, false, headAnimation, 0)
        elseif bookOfShadowsCooldown ~= nil then
            local animation = bookOfShadowsCooldown < 60 and "Blink" or walkAnimation
            PlayerItemAnim.PlayItemAnimCollectible(myContext, player, CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, true, animation, -1)
        end

        if holyMantle then
            PlayerItemAnim.PlayItemAnimCollectible(myContext, player, CollectibleType.COLLECTIBLE_HOLY_MANTLE, true, "Shimmer", -1)
        end

        -- jupiter update
        if not jupiter then
            player.m_jupiter_charge = 0.0
        else
            local preJupiterCharge = player.m_jupiter_charge
            jupiter_update(myContext, player, targetVelocity)

            if preJupiterCharge ~= player.m_jupiter_charge then
                player.m_cacheFlags = player.m_cacheFlags | CacheFlag.CACHE_SPEED
                temporaryEffects.m_shouldEvaluateCache_qqq = true
            end
        end
    end

    if PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_MARS, false) and player.m_controlsEnabled then
        for i = 0, Direction.DOWN, 1 do
            local moveAction = IsaacUtils.GetDirectionToMoveAction(i)
            local actionTriggered = IsaacUtils.IsActionTriggered(myContext.manager, moveAction, player.m_controllerIndex, player)
            if actionTriggered then
                update_mars_direction(myContext, player, i)
            end
        end
    end

    player.m_mars_framesSinceLastTap = math.max(player.m_mars_framesSinceLastTap + 1, 10000)
end

local Module = {}

--#region Module

Module.GetMovementInput = GetMovementInput
Module.ControlMovement = ControlMovement

--#endregion

return Module