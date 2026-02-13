--#region Dependencies



--#endregion

---@param myContext Context.Common
---@param knife EntityKnifeComponent
---@param direction Vector
---@param source EntityComponent?
---@param offset number
local function InitHomingPath(myContext, knife, direction, source, offset)
end

---@param myContext Context.Common
---@param knife EntityKnifeComponent
local function DoShootEffects(myContext, knife)
end

---@param myContext Context.Common
---@param knife EntityKnifeComponent
local function Shoot(myContext, knife, charge, range)
end

---@param myContext Context.Common
---@param knife EntityKnifeComponent
local function UpdateBoneSwing(myContext, knife)
end

---@param myContext Context.Common
---@param knife EntityKnifeComponent
---@param multiShotCount integer
---@param startFrame integer
local function SpinAttack(myContext, knife, multiShotCount, startFrame)
end

local Module = {}

--#region Module

Module.InitHomingPath = InitHomingPath
Module.DoShootEffects = DoShootEffects
Module.Shoot = Shoot
Module.UpdateBoneSwing = UpdateBoneSwing
Module.SpinAttack = SpinAttack

--#endregion

return Module