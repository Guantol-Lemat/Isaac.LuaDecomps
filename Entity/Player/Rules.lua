--#region Dependencies

local NetplayUtils = require("Admin.Netplay.Utils")

--#endregion

---@class PlayerRules
local Module = {}

---@param context Context
---@param player EntityPlayerComponent
---@return boolean
local function IsLocalPlayer(context, player)
    local netplayManager = context:GetNetplayManager()
    if not NetplayUtils.IsNetplay(netplayManager) then
        return true
    end

    return NetplayUtils.IsIdxLocalPlayer(netplayManager, player.m_controllerIndex)
end

---@param context Context
---@param player EntityPlayerComponent
---@param realPlayer EntityPlayerComponent
---@return EntityPlayerComponent
local function hook_get_real_player(context, player, realPlayer)
    local twin = player.m_twinPlayer
    if player.m_playerType == PlayerType.PLAYER_THESOUL_B and twin then
        realPlayer = twin
    end

    return realPlayer
end

---@param context Context
---@param player EntityPlayerComponent
---@return EntityPlayerComponent
local function GetRealPlayer(context, player)
    local realPlayer = player
    realPlayer = hook_get_real_player(context, player, realPlayer)
    return realPlayer
end

--#region Module

Module.IsLocalPlayer = IsLocalPlayer
Module.GetRealPlayer = GetRealPlayer

--#endregion

return Module