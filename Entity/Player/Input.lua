--#region Dependencies

local InputRules = require("Admin.Input.Rules")
local InputUtils = require("Admin.Input.Utils")
local ScreenUtils = require("Admin.Screen.Utils")
local DeathmatchUtils = require("Admin.Deathmatch.Utils")
local SeedsUtils = require("Admin.Seeds.Utils")
local EntityUtils = require("Entity.Common.Utils")
local PlayerUtils = require("Entity.Player.Utils")
local MirrorUtils = require("Level.Dimension.Mirror.Rules")
local VectorUtils = require("General.Math.VectorUtils")

--#endregion

---@class PlayerInput
local Module = {}

---@param options OptionsComponent
---@param player EntityPlayerComponent
local function UsesMouseControls(options, player)
    return player.m_controllerIndex == 0 and options.m_mouseControlsEnabled
end

---@param player EntityPlayerComponent
---@return boolean
local function can_disable_player_movement(player)
    local playerType = player.m_playerType
    if playerType == PlayerType.PLAYER_ESAU then
        return true
    end

    local parent = player.m_parent
    if parent and parent.m_type == EntityType.ENTITY_PLAYER then
        return true
    end

    if playerType == PlayerType.PLAYER_LAZARUS_B or playerType == PlayerType.PLAYER_LAZARUS2_B and not PlayerUtils.IsMainTwin(player) then
        return true
    end

    return false
end

---@param context Context
---@param player EntityPlayerComponent
---@return boolean
local function should_block_movement(context, player)
    if not can_disable_player_movement(player) then
        return false
    end

    if not player.m_controlsEnabled or player.m_controlsCooldown > 0 then
        return false
    end

    return InputRules.IsActionPressed(context, ButtonAction.ACTION_DROP, player.m_controllerIndex, nil)
end

---@param context Context
---@param player EntityPlayerComponent
---@param movementInput Vector
---@return Vector
local function hook_movement_input(context, player, movementInput)
    local game = context:GetGame()
    local level = context:GetLevel()
    local seeds = context:GetSeeds()
    local deathmatchManager = context:GetDeathmatchManager()

    movementInput = VectorUtils.Copy(movementInput)

    if DeathmatchUtils.InDeathmatch(deathmatchManager) then
        if EntityUtils.HasFlags(player, EntityFlag.FLAG_CONFUSION) then
            movementInput = movementInput * -1.0
        end
    end

    if SeedsUtils.HasSeedEffect(seeds, SeedEffect.SEED_CONTROLS_REVERSED) then
        movementInput = movementInput * -1.0
    end

    if SeedsUtils.HasSeedEffect(seeds, SeedEffect.SEED_AXIS_ALIGNED_CONTROLS) then
        movementInput = VectorUtils.GetAxisAligned(movementInput)
    end

    if MirrorUtils.IsMirrorWorld(context, game, level) then
        movementInput.X = movementInput.X * -1.0
    end

    return movementInput
end

---@param context Context
---@param player EntityPlayerComponent
---@return Vector
local function GetMovementInput(context, player)
    if should_block_movement(context , player) then
        return Vector(0, 0)
    end

    local left = InputRules.GetActionValue(context, ButtonAction.ACTION_LEFT, player.m_controllerIndex, player)
    local right = InputRules.GetActionValue(context, ButtonAction.ACTION_RIGHT, player.m_controllerIndex, player)
    local up = InputRules.GetActionValue(context, ButtonAction.ACTION_UP, player.m_controllerIndex, player)
    local down = InputRules.GetActionValue(context, ButtonAction.ACTION_DOWN, player.m_controllerIndex, player)

    local horizontalMovement = right - left
    local verticalMovement = down - up

    local movementInput = Vector(horizontalMovement, verticalMovement)
    movementInput = hook_movement_input(context, player, movementInput)
    return movementInput
end

---@param context Context
---@param player EntityPlayerComponent
---@param shootingInput Vector
---@return Vector
local function hook_shooting_input(context, player, shootingInput)
    local game = context:GetGame()
    local level = context:GetLevel()
    local seeds = context:GetSeeds()

    shootingInput = VectorUtils.Copy(shootingInput)

    local bravery = SeedsUtils.HasSeedEffect(seeds, SeedEffect.SEED_SHOOT_IN_MOVEMENT_DIRECTION)
    local cowardice = SeedsUtils.HasSeedEffect(seeds, SeedEffect.SEED_SHOOT_OPPOSITE_MOVEMENT_DIRECTION)

    if bravery or cowardice then
        shootingInput = GetMovementInput(context, player)
    elseif SeedsUtils.HasSeedEffect(seeds, SeedEffect.SEED_CONTROLS_REVERSED) then
        shootingInput = shootingInput * -1.0
    end

    if SeedsUtils.HasSeedEffect(seeds, SeedEffect.SEED_AXIS_ALIGNED_CONTROLS) then
        shootingInput = VectorUtils.GetAxisAligned(shootingInput)
    end

    if MirrorUtils.IsMirrorWorld(context, game, level) then
        shootingInput.X = shootingInput.X * -1.0
    end

    return shootingInput
end

---@param context Context
---@param player EntityPlayerComponent
---@return Vector
local function GetShootingInput(context, player)
    local left = InputRules.GetActionValue(context, ButtonAction.ACTION_SHOOTLEFT, player.m_controllerIndex, player)
    local right = InputRules.GetActionValue(context, ButtonAction.ACTION_SHOOTRIGHT, player.m_controllerIndex, player)
    local up = InputRules.GetActionValue(context, ButtonAction.ACTION_SHOOTUP, player.m_controllerIndex, player)
    local down = InputRules.GetActionValue(context, ButtonAction.ACTION_SHOOTDOWN, player.m_controllerIndex, player)

    local horizontalShoot = right - left
    local verticalShoot = down - up

    local shootingInput = Vector(horizontalShoot, verticalShoot)
    shootingInput = hook_shooting_input(context, player, shootingInput)
    return shootingInput
end

---@param context Context
---@param player EntityPlayerComponent
---@return Vector
local function GetMouseShootingInput(context, player)
    local options = context:GetOptions()
    local input = context:GetInput()
    local screen = context:GetScreen()
    local game = context:GetGame()
    local level = context:GetLevel()

    if not UsesMouseControls(options, player) then
        return Vector(0, 0)
    end

    if not InputUtils.IsMouseButtonPressed(input, MouseButton.LEFT) then
        return Vector(0, 0)
    end

    local room = context:GetRoom()
    local IsMirrorWorld = MirrorUtils.IsMirrorWorld(context, game, level)

    local focusEntity = PlayerUtils.GetFocusEntity(player)
    if not focusEntity then
        focusEntity = player
    end

    local focusRenderPosition = ScreenUtils.GetScreenPosition(screen, focusEntity.m_position, true)
    focusRenderPosition = focusRenderPosition + room.m_renderScrollOffset

    if IsMirrorWorld then
        focusRenderPosition.X = screen.m_width - focusRenderPosition.X -- get mirrored screen position
    end

    focusRenderPosition = focusRenderPosition + screen.m_renderingOffset

    local pointScale = screen.m_windowHeight / screen.m_height -- don't know why they didn't just get the point scale
    local focusWindowPosition = focusRenderPosition * pointScale

    local fireDirection = InputUtils.GetMousePosition(input) - focusWindowPosition
    fireDirection = fireDirection * 0.02

    if IsMirrorWorld then
        fireDirection.X = -fireDirection.X
    end

    return fireDirection
end

--#region Module

Module.UsesMouseControls = UsesMouseControls
Module.GetMovementInput = GetMovementInput
Module.GetShootingInput = GetShootingInput
Module.GetMouseShootingInput = GetMouseShootingInput

--#endregion

return Module