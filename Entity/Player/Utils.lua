--#region Dependencies

local TemporaryEffectsUtils = require("Entity.Player.Inventory.TemporaryEffects")

--#endregion

---@class EntityPlayerUtils
local Module = {}

local PLAYER_HEALTH = {
    [PlayerType.PLAYER_BLUEBABY] = HealthType.SOUL,
    [PlayerType.PLAYER_BLACKJUDAS] = HealthType.SOUL,
    [PlayerType.PLAYER_THESOUL] = HealthType.SOUL,
    [PlayerType.PLAYER_JUDAS_B] = HealthType.SOUL,
    [PlayerType.PLAYER_BLUEBABY_B] = HealthType.SOUL,
    [PlayerType.PLAYER_THEFORGOTTEN_B] = HealthType.SOUL,
    [PlayerType.PLAYER_BETHANY_B] = HealthType.SOUL,
    [PlayerType.PLAYER_THELOST] = HealthType.NO_HEALTH,
    [PlayerType.PLAYER_THELOST_B] = HealthType.NO_HEALTH,
    [PlayerType.PLAYER_THESOUL_B] = HealthType.NO_HEALTH,
    [PlayerType.PLAYER_KEEPER] = HealthType.COIN,
    [PlayerType.PLAYER_KEEPER_B] = HealthType.COIN,
    [PlayerType.PLAYER_THEFORGOTTEN] = HealthType.BONE
}

---@param player EntityPlayerComponent
---@return EntityPlayerComponent
local function GetMainTwin(player)
    local twin = player.m_twinPlayer.ref
    ---@cast twin EntityPlayerComponent

    if not twin or player.m_playerIndex <= twin.m_playerIndex then
        return player
    end

    return twin
end

---@param player EntityPlayerComponent
---@return boolean
local function IsMainTwin(player)
    return player == GetMainTwin(player)
end

---@param player EntityPlayerComponent
---@return boolean
local function IsMainPlayerCharacter(player)
    return player.m_parent == nil and IsMainTwin(player)
end

---@param player EntityPlayerComponent
---@return boolean
local function IsHologram(player)
    if not player.m_exists then
        return false
    end

    local playerType = player.m_playerType
    if playerType ~= PlayerType.PLAYER_LAZARUS_B or playerType ~= PlayerType.PLAYER_LAZARUS2_B then
        return false
    end

    if IsMainTwin(player) then
        return false
    end

    return true
end

---@param player EntityPlayerComponent
---@return boolean
local function HasInstantDeathCurse(player)
    if TemporaryEffectsUtils.HasNullEffect(player.m_temporaryEffects, NullItemID.ID_LOST_CURSE) then
        return true
    end

    if player.m_playerType == PlayerType.PLAYER_JACOB2_B then
        return true
    end

    return false
end

---@param player EntityPlayerComponent
---@return HealthType
local function GetHealthType(player)
    return PLAYER_HEALTH[player.m_playerType] or HealthType.RED
end

---@param player EntityPlayerComponent
---@return HealthType
local function GetEffectiveMaxHearts(player)
    local healthType = GetHealthType(player)
    if healthType == HealthType.SOUL or healthType == HealthType.NO_HEALTH then
        return player.m_maxHearts
    end

    return player.m_maxHearts + player.m_boneHearts * 2
end

---@param player EntityPlayerComponent
---@return EntityComponent?
local function GetFocusEntity(player)
    if player.m_markedTarget then
        return player.m_markedTarget
    end

    for i = 1, 4, 1 do
        local weapon = player.m_weapons[i]
        if not weapon then
            goto continue
        end

        local focusEntity = weapon:GetFocusEntity()
        if focusEntity then
            return focusEntity
        end
        ::continue::
    end

    return nil
end

---@param player EntityPlayerComponent
local function IsExtraAnimationFinished(player)
    return not player.m_isPlayingExtraAnimation and not player.m_isPlayingItemNullAnimation
end

---@param fireDelay number
---@return number
local function FireDelayToTearsUp(fireDelay)
    return 30.0 / (fireDelay + 1.0)
end

---@param tearsUp number
---@return number
local function TearsUpToFireDelay(tearsUp)
    return 30.0 / tearsUp - 1.0
end

--#region Module

Module.IsMainPlayerCharacter = IsMainPlayerCharacter
Module.GetMainTwin = GetMainTwin
Module.IsMainTwin = IsMainTwin
Module.IsHologram = IsHologram
Module.HasInstantDeathCurse = HasInstantDeathCurse
Module.IsExtraAnimationFinished = IsExtraAnimationFinished
Module.GetHealthType = GetHealthType
Module.GetEffectiveMaxHearts = GetEffectiveMaxHearts
Module.GetFocusEntity = GetFocusEntity
Module.FireDelayToTearsUp = FireDelayToTearsUp
Module.TearsUpToFireDelay = TearsUpToFireDelay

--#endregion

return Module