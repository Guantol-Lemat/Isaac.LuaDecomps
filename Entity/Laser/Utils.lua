--#region Dependencies



--#endregion

---@param laser EntityLaserComponent
---@param angle number
local function SetAngle(laser, angle)
end

---@param myContext Context.Common
---@param variant LaserVariant
---@param sourcePos Vector
---@param angle number
---@param timeout integer
---@param posOffset Vector
---@param source Entity?
---@param force boolean
---@return EntityLaserComponent
local function ShootAngle(myContext, variant, sourcePos, angle, timeout, posOffset, source, force)
end

local Module = {}

--#region Module

Module.SetAngle = SetAngle
Module.ShootAngle = ShootAngle

--#endregion

return Module