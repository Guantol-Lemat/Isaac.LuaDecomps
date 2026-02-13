--#region Dependencies



--#endregion

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param velocity Vector
local function ThrowHeldEntity(myContext, player, velocity)
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param direction Vector
local function TryForgottenThrow(myContext, player, direction)
end

local Module = {}

--#region Module

Module.ThrowHeldEntity = ThrowHeldEntity
Module.TryForgottenThrow = TryForgottenThrow

--#endregion

return Module