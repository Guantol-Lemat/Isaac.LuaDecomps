--#region

local EntityUtils = require("Entity.Common.Utils")

--#endregion

---@class WeaponUtils
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
    local player = GetPlayer(weapon)
    return player and player.m_shotSpeed or 1.0
end

---@param weapon WeaponComponent
---@return Vector
local function GetPosition(weapon)
    local owner = weapon.m_owner
    return owner and owner.m_position or Vector(0, 0)
end

---@param weapon WeaponComponent
---@return number
local function GetTimeScale(weapon)
    local owner = weapon.m_owner
    return owner and owner.m_timescale or 1.0
end

---@param weapon WeaponComponent
---@return integer
local function GetPeeBurstCooldown(weapon)
    local owner = weapon.m_owner
    local playerOwner = owner and EntityUtils.ToPlayer(owner)

    return playerOwner and playerOwner.m_peeBurstCooldown or 0
end

---@param weapon WeaponComponent
---@return EntityComponent?
local function GetMarkedTarget(weapon)
    local player = GetPlayer(weapon)
    return player and player.m_marked_targetEntity or nil
end

---@param weapon WeaponComponent
---@param blinkTime integer
local function SetBlinkTime(weapon, blinkTime)
    local owner = weapon.m_owner
    if not owner then
        return
    end

    local familiarOwner = EntityUtils.ToFamiliar(owner)
    if familiarOwner then
        familiarOwner.m_blinkTime = math.max(familiarOwner.m_blinkTime, blinkTime)
        return
    end

    local playerOwner = EntityUtils.ToPlayer(owner)
    if playerOwner then
        playerOwner.m_blinkTime = math.max(playerOwner.m_blinkTime, blinkTime)
    end
end

--#region Module

Module.GetPlayer = GetPlayer
Module.GetShotSpeed = GetShotSpeed
Module.GetPosition = GetPosition
Module.GetTimeScale = GetTimeScale
Module.GetPeeBurstCooldown = GetPeeBurstCooldown
Module.GetMarkedTarget = GetMarkedTarget
Module.SetBlinkTime = SetBlinkTime

--#endregion

return Module