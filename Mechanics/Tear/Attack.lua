--#region Dependencies



--#endregion

---@param myContext Context.Common
---@param position Vector
---@param radius number
---@param damage number
---@param source EntityComponent?
---@param flags TearFlags | BitSet128
local function TearSplashDamage(myContext, position, radius, damage, source, flags)
end

local Module = {}

--#region Module

Module.TearSplashDamage = TearSplashDamage

--#endregion

return Module