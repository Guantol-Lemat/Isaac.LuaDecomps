--#region Dependencies

local VectorUtils = require("General.Math.VectorUtils")
local WeaponParamsFactory = require("Entity.Player.WeaponParams.Component")
local WeaponParams = require("Mechanics.Player.WeaponParams")
local EntityCast = require("Entity.TypeCast")
local PlayerInventory = require("Mechanics.Player.Inventory")

local VectorZero = VectorUtils.VectorZero
--#endregion

---@param weapon WeaponComponent
---@return EntityPlayerComponent?
local function GetPlayer(weapon)
    local owner = weapon.m_owner
    if not owner then
        return nil
    end

    local familiarOwner = EntityCast.ToFamiliar(owner)
    if familiarOwner then
        owner = familiarOwner.m_player
    end

    return EntityCast.ToPlayer(owner)
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
    return owner and owner.m_timeScale or 1.0
end

---@param weapon WeaponComponent
---@return integer
local function GetPeeBurstCooldown(weapon)
    local owner = weapon.m_owner
    local playerOwner = owner and EntityCast.ToPlayer(owner)

    return playerOwner and playerOwner.m_peeBurstCooldown or 0
end

---@param weapon WeaponComponent
---@return EntityComponent?
local function GetMarkedTarget(weapon)
    local player = GetPlayer(weapon)
    return player and player.m_marked_targetEntity.ref or nil
end

---@param myContext Context.Common
---@param weapon WeaponComponent
---@param default Vector
---@return Vector
local function GetLastBufferedDirection(myContext, weapon, default)
end

---@param weapon WeaponComponent
---@param time integer
local function SetHeadLockTime(weapon, time)
end

---@param weapon WeaponComponent
---@param blinkTime integer
local function SetBlinkTime(weapon, blinkTime)
    local owner = weapon.m_owner
    if not owner then
        return
    end

    local familiarOwner = EntityCast.ToFamiliar(owner)
    if familiarOwner then
        familiarOwner.m_blinkTime = math.max(familiarOwner.m_blinkTime, blinkTime)
        return
    end

    local playerOwner = EntityCast.ToPlayer(owner)
    if playerOwner then
        playerOwner.m_blinkTime = math.max(playerOwner.m_blinkTime, blinkTime)
    end
end

---@param myContext Context.Common
---@param weapon WeaponComponent
local function IsAxisAligned(myContext, weapon)
    local player = GetPlayer(weapon)
    if not player or not VectorUtils.Equals(weapon.m_targetPosition, VectorZero) then
        return false
    end

    return not PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_ANALOG_STICK, false) and not PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_MARKED, false)
end

---@param myContext Context.Manager
---@param weapon WeaponComponent
---@param item CollectibleType | integer
---@param itemAnimation eItemAnimation
---@param direction Vector
---@param progress number
local function PlayItemAnim(myContext, weapon, item, itemAnimation, direction, progress)
end

---@param myContext Context.Manager
---@param weapon WeaponComponent
---@param item CollectibleType | integer
---@param itemAnimation eItemAnimation
---@param direction Vector
---@param progress number
local function PlayItemBodySubAnim(myContext, weapon, item, itemAnimation, direction, progress)
end

---@param myContext Context.Manager
---@param weapon WeaponComponent
---@param item CollectibleType | integer
---@return boolean
local function IsItemAnimFinished(myContext, weapon, item)
end

---@param myContext Context.Manager
---@param weapon WeaponComponent
---@param item CollectibleType | integer
---@return boolean
local function IsItemBodySubAnimFinished(myContext, weapon, item)
end

---@param myContext Context.Manager
---@param weapon WeaponComponent
---@param item CollectibleType | integer
local function ClearItemAnim(myContext, weapon, item)
end

---@param myContext Context.Manager
---@param weapon WeaponComponent
---@param item CollectibleType | integer
local function ClearAllItemAnim(myContext, weapon, item)
end

---@param myContext Context.Common
---@param weapon WeaponComponent
---@param shotDirection Vector
---@return Vector
local function GetTearMovementInheritance(myContext, weapon, shotDirection)
end

---@param myContext Context.Common
---@param weapon WeaponComponent
---@return MultiShotParamsComponent
local function GetMultiShotParams(myContext, weapon)
    local player = GetPlayer(weapon)
    if player then
        return WeaponParams.GetMultiShotParams(myContext, player, weapon.m_weaponType)
    end

    return WeaponParamsFactory.NewMultiShotParams()
end

---@param eyeIndex integer -- the "index" of the numEyesActive that is currently being evaluated
---@param weaponType WeaponType | integer
---@param shotDirection Vector
---@param shotSpeed number
---@param multiShotParams MultiShotParamsComponent
---@return Vector position
---@return Vector velocity
local function GetMultiShotPositionVelocity(eyeIndex, weaponType, shotDirection, shotSpeed, multiShotParams)
    return WeaponParams.GetMultiShotPositionVelocity(eyeIndex, weaponType, shotDirection, shotSpeed, multiShotParams)
end

local Module = {}

--#region Module

Module.GetPlayer = GetPlayer
Module.GetShotSpeed = GetShotSpeed
Module.GetPosition = GetPosition
Module.GetTimeScale = GetTimeScale
Module.GetPeeBurstCooldown = GetPeeBurstCooldown
Module.GetMarkedTarget = GetMarkedTarget
Module.GetLastBufferedDirection = GetLastBufferedDirection
Module.SetHeadLockTime = SetHeadLockTime
Module.SetBlinkTime = SetBlinkTime
Module.PlayItemAnim = PlayItemAnim
Module.PlayItemBodySubAnim = PlayItemBodySubAnim
Module.IsAxisAligned = IsAxisAligned
Module.IsItemAnimFinished = IsItemAnimFinished
Module.IsItemBodySubAnimFinished = IsItemBodySubAnimFinished
Module.ClearItemAnim = ClearItemAnim
Module.ClearAllItemAnim = ClearAllItemAnim
Module.GetTearMovementInheritance = GetTearMovementInheritance
Module.GetMultiShotParams = GetMultiShotParams
Module.GetMultiShotPositionVelocity = GetMultiShotPositionVelocity

--#endregion

return Module