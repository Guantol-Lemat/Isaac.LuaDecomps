--#region Dependencies



--#endregion

---@param myContext Context.Common
---@param weapon WeaponComponent
---@param shootingInput Vector
---@param numTears integer
local function TriggerTearFired(myContext, weapon, shootingInput, numTears)
end

---@param myContext Context.Common
---@param weapon WeaponComponent
---@param position Vector
---@param velocity Vector
---@param flags eFireTearFlags | integer
---@param source EntityComponent?
---@param damageMultiplier number
---@param startPositionFactor number
---@return EntityTearComponent
local function FireTear(myContext, weapon, position, velocity, flags, source, damageMultiplier, startPositionFactor)
end

---@param myContext Context.Common
---@param weapon WeaponComponent
---@param position Vector
---@param velocity Vector
---@param positionOffset Vector
---@return EntityEffectComponent
local function FireBrimstoneBall(myContext, weapon, position, velocity, positionOffset)
end

---@param myContext Context.Common
---@param weapon WeaponComponent
---@param position Vector
---@param velocity Vector
---@return EntityBombComponent
local function FireBomb(myContext, weapon, position, velocity)
end

---@param myContext Context.Common
---@param weapon WeaponComponent
---@param parent EntityComponent?
---@param variant KnifeVariant
---@param persistent boolean
---@return EntityKnifeComponent
local function FireBoneClub(myContext, weapon, parent, variant, persistent)
end

---@param myContext Context.Common
---@param weapon WeaponComponent
---@param position Vector
---@param velocity Vector
---@param flags eFireTearFlags | integer
---@param source any
---@param damageScale any
local function FireFetus(myContext, weapon, position, velocity, flags, source, damageScale)
end

local Module = {}

--#region Module

Module.TriggerTearFired = TriggerTearFired
Module.FireTear = FireTear
Module.FireBrimstoneBall = FireBrimstoneBall
Module.FireBomb = FireBomb
Module.FireBoneClub = FireBoneClub
Module.FireFetus = FireFetus

--#endregion

return Module