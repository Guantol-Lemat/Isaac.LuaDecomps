--#region Dependencies



--#endregion

---@class WeaponParamsUtils
local Module = {}

---@alias PosVelComponent {position: Vector, velocity: Vector}

---@param index integer -- current shot in the multi-shot sequence
---@param weaponType WeaponType
---@param shotDirection Vector
---@param shotSpeed number
---@param multiShotParams MultiShotParamsComponent
---@return PosVelComponent
local function GetMultiShotPositionVelocity(index, weaponType, shotDirection, shotSpeed, multiShotParams)
end

--#region Module

Module.GetMultiShotPositionVelocity = GetMultiShotPositionVelocity

--#endregion

return Module