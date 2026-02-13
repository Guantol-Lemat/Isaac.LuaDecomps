--#region Dependencies

local EntityUtils = require("Entity.Utils")
local PlayerUtils = require("Entity.Player.Utils")
local PlayerSpriteUtils = require("Entity.Player.Sprite.PlayerUtils")
local SeedsUtils = require("Admin.Seeds.Utils")
local TemporaryEffectsUtils = require("Items.TemporaryEffects.Utils")
local InputUtils = require("Admin.Input.Utils")
local InputRules = require("Admin.Input.Rules")

local PlayerInput = require("Entity.Player.Input")

local PlayerAnimations = PlayerSpriteUtils.Animations

--#endregion

---@class ShootingControls
local Module = {}

---@class ShootingControls
---@field controlsEnabled boolean
---@field isShooting boolean
---@field shootingInput Vector

---@param player EntityPlayerComponent
---@return boolean
local function are_controls_enabled(player)
    if not player.m_controlsEnabled or player.m_controlsCooldown > 0 then
        return false
    end

    if EntityUtils.HasFlags(player, EntityFlag.FLAG_FEAR) then
        return false
    end

    if player.m_playerType == PlayerType.PLAYER_THESOUL_B and player.m_itemState == CollectibleType.COLLECTIBLE_NULL then
        return false
    end

    return true
end

---@param player EntityPlayerComponent
local function can_shoot(player)
    if not PlayerUtils.IsExtraAnimationFinished(player) and player.m_sprite:IsFinished(PlayerAnimations.LIFT_ITEM) then
        return false
    end

    if player.m_entityCollisionClass == EntityCollisionClass.ENTCOLL_NONE or player.m_isCoopGhost then
        return false
    end

    if player.m_suplex_state ~= 2 then
        return false
    end

    if EntityUtils.HasFlags(player, EntityFlag.FLAG_HELD) then
        return false
    end

    if TemporaryEffectsUtils.HasCollectibleEffect(player.m_temporaryEffects, CollectibleType.COLLECTIBLE_HOW_TO_JUMP) then
        return false
    end

    if PlayerUtils.IsHologram(player) then
        return
    end

    return true
end

---@param weapon WeaponComponent
---@param shootingInput Vector
---@param oppositeDirectionsPressed boolean
local function is_weapon_fire_direction_acceptable(weapon, shootingInput, oppositeDirectionsPressed)
    if weapon:GetMaxCharge() <= 0.0 or weapon.m_charge <= 0.0 or oppositeDirectionsPressed then
        return true
    end

    return shootingInput:Length() >= 0.5
end

---@param context Context
---@param player EntityPlayerComponent
---@return boolean isShooting
---@return Vector shootingInput
local function evaluate_shooting_controls(context, player)
    local seeds = context:GetSeeds()
    local input = context:GetInput()
    local options = context:GetOptions()

    local usesMovementInput = SeedsUtils.HasSeedEffect(seeds, SeedEffect.SEED_SHOOT_IN_MOVEMENT_DIRECTION) or SeedsUtils.HasSeedEffect(seeds, SeedEffect.SEED_SHOOT_OPPOSITE_MOVEMENT_DIRECTION)

    local leftAction = usesMovementInput and ButtonAction.ACTION_LEFT or ButtonAction.ACTION_SHOOTLEFT
    local rightAction = usesMovementInput and ButtonAction.ACTION_RIGHT or ButtonAction.ACTION_SHOOTRIGHT
    local upAction = usesMovementInput and ButtonAction.ACTION_UP or ButtonAction.ACTION_SHOOTUP
    local downAction = usesMovementInput and ButtonAction.ACTION_DOWN or ButtonAction.ACTION_SHOOTDOWN

    local left = InputRules.IsActionPressed(context, leftAction, player.m_controllerIndex, player)
    local right = InputRules.IsActionPressed(context, rightAction, player.m_controllerIndex, player)
    local up = InputRules.IsActionPressed(context, upAction, player.m_controllerIndex, player)
    local down = InputRules.IsActionPressed(context, downAction, player.m_controllerIndex, player)

    local oppositeDirectionsPressed = (up and down) or (left or right)
    local isShooting = left or right or up or down

    if PlayerInput.UsesMouseControls(options, player) and InputUtils.IsMouseButtonPressed(input, MouseButton.LEFT) then
        isShooting = true
    end

    local shootingInput = PlayerInput.GetShootingInput(context, player) + PlayerInput.GetMouseShootingInput(context, player)

    local weapon = player.m_weapons[0] or player.m_weapons[1]
    if weapon and not is_weapon_fire_direction_acceptable(weapon, shootingInput, oppositeDirectionsPressed) then
        shootingInput = Vector(0, 0)
        isShooting = false
    end

    return isShooting, shootingInput
end

---@param context Context
---@param player EntityPlayerComponent
---@return ShootingControls
local function GetShootingControls(context, player)
    ---@type ShootingControls
    local shootingControls = {
        controlsEnabled = false,
        isShooting = false,
        shootingInput = Vector(0, 0)
    }

    if not are_controls_enabled(player) then
        return shootingControls
    end

    shootingControls.controlsEnabled = true

    if not can_shoot(player) then
        return shootingControls
    end

    local isShooting, shootingInput = evaluate_shooting_controls(context, player)

    shootingControls.shootingInput = shootingInput
    shootingControls.isShooting = isShooting

    return shootingControls
end

--#region Module

Module.GetShootingControls = GetShootingControls

--#endregion

return Module