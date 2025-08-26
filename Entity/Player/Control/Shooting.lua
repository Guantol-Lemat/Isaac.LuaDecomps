--#region Dependencies

local EntityUtils = require("Entity.Common.Utils")
local PlayerUtils = require("Entity.Player.Utils")
local TemporaryEffectsUtils = require("Items.TemporaryEffects.Utils")
local StageTransitionUtils = require("Game.Transition.StageTransition.Utils")
local VectorUtils = require("General.Math.VectorUtils")

local PlayerInput = require("Entity.Player.Input")
local ShootingControls = require("Entity.Player.Control.Shooting.Controls")

--#endregion

---@class ControlShooting
local Module = {}

---@param context Context
---@param player EntityPlayerComponent
---@param controls ShootingControls -- can be modified
local function hook_pre_update_shooting_controls(context, player, controls)
    if player.m_variant == PlayerVariant.CO_OP_BABY and player.m_babySkin == BabySubType.BABY_YBAB then
        -- something with forced controls
    end

    if player.m_peeBurstCooldown > 0 then
        -- something with pee burst
    end

    -- throw entity if not moms bracelet or suplex item state

    -- evaluate some temporary effects

    -- something related to reset item state

    -- something related to setting two specific vectors

    -- evaluate marked target

    -- evaluate collectible number two

    -- evaluate tell a joke daily challenge

    -- firing cooldown evaluations

    -- mega blast evaluation

    -- bladder evaluation

    -- ibs evaluation
end

local function hook_pre_weapons_update()
    -- doctors remote weapon override
    -- notched axe weapon override
    -- urn of souls weapon override
    -- lilith weapon override
end

---@param context Context
---@param player EntityPlayerComponent
local function update_weapons(context, player)
    local weaponModifiers = get_weapon_modifiers(context, player)
    hook_pre_weapons_update()

    for i = 1, 4, 1 do
        local weapon = player.m_weapons[i]
        if not weapon then
            goto continue
        end

        weapon.m_maxFireDelay = player.m_maxFireDelay
        weapon.m_weaponModifiers = weaponModifiers
        if i == 1 then
            weapon.m_weaponModifiers = weapon.m_weaponModifiers | WeaponModifier.BONE -- should be renamed into MAIN
        end
        ::continue::
    end

    for i = 1, 4, 1 do
        local weapon = player.m_weapons[i]
        if not weapon then
            goto continue
        end

        player.m_weapons[1]:Update(context, EntityUtils.HasFlags(player, EntityFlag.FLAG_INTERPOLATION_UPDATE))
        if i == 1 then
            break -- only update 1st weapon if it exists
        end
        ::continue::
    end
end

local function hook_pre_update_item_state()
    -- update timers

    -- pointy rib update
    -- trinity shield update
    -- gb_bug update
    -- divine_intervention update
    -- hemoptysis update
    -- spear of destiny update
    -- scissors effect

    -- apply teardrop charm
end

local function update_item_state()
    -- update item state (collectible_null is for regular weapons)
end

---@param context Context
---@param player EntityPlayerComponent
local function Update(context, player)
    -- something related to player.m_target

    local shootingControls = ShootingControls.GetShootingControls(context, player)
    hook_pre_update_shooting_controls(context, player, shootingControls)

    -- head direction update
    -- fire direction update

    local stageTransition = context:GetStageTransition()
    if not PlayerUtils.IsExtraAnimationFinished(player) and not StageTransitionUtils.IsActive(stageTransition) and shootingControls.controlsEnabled then
        -- epiphora update
        -- maw of the void update
        -- revelation update
        -- montezumas_revenge update
        -- eve suptorium update
    end

    update_weapons(context, player)

    -- update timers

    if 1.0 < shootingControls.shootingInput:LengthSquared() then
        shootingControls.shootingInput:Normalize()
    end

    local axisAlignedInput = VectorUtils.AxisAligned(shootingControls.shootingInput)

    hook_pre_update_item_state()
    update_item_state()
    -- reset luck?

    -- update animation head?
    -- bone spurs particles update
    -- fire input deque update
end