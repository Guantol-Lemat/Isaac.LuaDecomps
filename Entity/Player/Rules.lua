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

--#region Module

Module.IsLocalPlayer = IsLocalPlayer

--#endregion

return Module