--#region Dependencies

local Enums = require("General.Enums")

local eItemAnimation = Enums.eItemAnimation

--#endregion

---@class WeaponRules
local Module = {}

---@param context Context
---@param weapon WeaponComponent
---@return boolean
local function IsAxisAligned(context, weapon)
end

---@param context Context
---@param weapon WeaponComponent
---@return boolean
local function HasWizardEffect(context, weapon)
end

---@param context Context
---@param weapon WeaponComponent
---@return MultiShotParamsComponent
local function GetMultiShotParams(context, weapon)
end

---@param context Context
---@param weapon WeaponComponent
---@param shootingInput Vector
---@return Vector
local function GetTearMovementInheritance(context, weapon, shootingInput)
end

---@param context Context
---@param weapon WeaponComponent
---@param shootingInput Vector
---@return Vector
local function GetLastBufferedDirection(context, weapon, shootingInput)
end

---@param context Context
---@param weapon WeaponComponent
---@param collectible CollectibleType | integer
---@param itemAnimation eItemAnimation
---@param direction Vector
---@param progress number
local function PlayItemAnim(context, weapon, collectible, itemAnimation, direction, progress)
end

---@param context Context
---@param weapon WeaponComponent
---@param collectible CollectibleType | integer
local function ClearItemAnim(context, weapon, collectible)
end

---@param context Context
---@param weapon WeaponComponent
local function ClearAllItemAnim(context, weapon)
end

--#region Module

Module.IsAxisAligned = IsAxisAligned
Module.HasWizardEffect = HasWizardEffect
Module.GetMultiShotParams = GetMultiShotParams
Module.GetTearMovementInheritance = GetTearMovementInheritance
Module.GetLastBufferedDirection = GetLastBufferedDirection
Module.PlayItemAnim = PlayItemAnim
Module.ClearItemAnim = ClearItemAnim
Module.ClearAllItemAnim = ClearAllItemAnim

--#endregion

return Module