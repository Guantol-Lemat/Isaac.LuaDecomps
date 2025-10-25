---@class EntityPlayerUtils
local Module = {}

---@param player EntityPlayerComponent
---@return EntityPlayerComponent
local function GetMainTwin(player)
    local twin = player.m_twinPlayer
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

local function TearsUpToFireDelay(tearsUp)
    return 30.0 / tearsUp - 1.0
end

--#region Module

Module.IsMainPlayerCharacter = IsMainPlayerCharacter
Module.GetMainTwin = GetMainTwin
Module.IsMainTwin = IsMainTwin
Module.IsHologram = IsHologram
Module.GetFocusEntity = GetFocusEntity
Module.IsExtraAnimationFinished = IsExtraAnimationFinished
Module.FireDelayToTearsUp = FireDelayToTearsUp
Module.TearsUpToFireDelay = TearsUpToFireDelay

--#endregion

return Module