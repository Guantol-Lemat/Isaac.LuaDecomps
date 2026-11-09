--#region Dependencies

local IEntityPlayer = require("Isaac.Interface.Entity_Player")

--#endregion

---@param player Component.Entity.Player
---@return boolean
local function IsLeftEyeBlocked(player)
    return player.m_playerType == PlayerType.PLAYER_CAIN or player.m_playerType == PlayerType.PLAYER_CAIN_B
        or IEntityPlayer.HasCollectible(player, CollectibleType.COLLECTIBLE_LEAD_PENCIL, false)
        or IEntityPlayer.HasCollectible(player, CollectibleType.COLLECTIBLE_CURSED_EYE, false)
        or IEntityPlayer.HasCollectible(player, CollectibleType.COLLECTIBLE_STAPLER, false)
end

---@param player Component.Entity.Player
---@param weapon Component.Weapon
---@return boolean
local function IsLeftEyeBlocked_Weapon(player, weapon)
    return player.m_playerType == PlayerType.PLAYER_CAIN or player.m_playerType == PlayerType.PLAYER_CAIN_B
        or IEntityPlayer.HasCollectible(player, CollectibleType.COLLECTIBLE_LEAD_PENCIL, false)
        or (weapon.m_weaponModifier & WeaponModifier.CURSED_EYE) ~= 0
        or IEntityPlayer.HasCollectible(player, CollectibleType.COLLECTIBLE_STAPLER, false)
end

---@param player Component.Entity.Player
---@return boolean
local function IsRightEyeBlocked(player)
    return IEntityPlayer.HasCollectible(player, CollectibleType.COLLECTIBLE_TECHNOLOGY_2, false)
end

---@class Content.Player.MiscProperties
local Module = {}

--#region Module

Module.IsLeftEyeBlocked = IsLeftEyeBlocked
Module.IsLeftEyeBlocked_Weapon = IsLeftEyeBlocked_Weapon
Module.IsRightEyeBlocked = IsRightEyeBlocked

--#endregion

return Module