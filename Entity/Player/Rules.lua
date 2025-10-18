--#region Dependencies

local NetplayUtils = require("Admin.Netplay.Utils")
local TemporaryEffectsUtils = require("Entity.Player.Inventory.TemporaryEffects")

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

---@param context Context
---@param player EntityPlayerComponent
---@return boolean
local function CanCrushRocks(context, player)
end

---@param context Context
---@param player EntityPlayerComponent
---@param gridEntity GridEntityComponent
---@param collisionClass GridCollisionClass
---@return boolean
local function CanCrushGridEntity(context, player, gridEntity, collisionClass)
    if collisionClass ~= GridCollisionClass.COLLISION_SOLID and collisionClass == GridCollisionClass.COLLISION_OBJECT then
        return false
    end

    if CanCrushRocks(context, player) then
        return true
    end

    local gridType = gridEntity.m_desc.m_type
    if TemporaryEffectsUtils.HasCollectibleEffect(player.m_temporaryEffects, CollectibleType.COLLECTIBLE_MARS) and gridType == GridEntityType.GRID_POOP then
        return true
    end

    return false
end

--#region Module

Module.IsLocalPlayer = IsLocalPlayer
Module.GetRealPlayer = GetRealPlayer
Module.CanCrushRocks = CanCrushRocks
Module.CanCrushGridEntity = CanCrushGridEntity

--#endregion

return Module