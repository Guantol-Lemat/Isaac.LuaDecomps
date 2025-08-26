--#region

local EntityUtils = require("Entity.Common.Utils")

--#endregion

---@class ModuleName
local Module = {}

---@param weapon WeaponComponent
---@return EntityPlayerComponent?
local function GetPlayer(weapon)
    local owner = weapon.m_owner
    if not owner then
        return nil
    end

    local familiarOwner = EntityUtils.ToFamiliar(owner)
    if familiarOwner then
        owner = familiarOwner.m_player
    end

    return EntityUtils.ToPlayer(owner)
end

---@param weapon WeaponComponent
---@return number
local function GetShotSpeed(weapon)
    local owner = weapon.m_owner
    if not owner then
        return 1.0
    end

    local familiarOwner = EntityUtils.ToFamiliar(owner)
    if familiarOwner then
        owner = familiarOwner.m_player
    end

    local playerOwner = EntityUtils.ToPlayer(owner)
    if playerOwner then
        return playerOwner.m_shootSpeed
    end

    return 1.0
end

---@param weapon WeaponComponent
---@return Vector
local function GetPosition(weapon)
    local owner = weapon.m_owner
    if owner then
        return owner.m_position
    end

    return Vector(0, 0)
end

--#region Module

Module.GetPlayer = GetPlayer
Module.GetShotSpeed = GetShotSpeed
Module.GetPosition = GetPosition

--#endregion

return Module