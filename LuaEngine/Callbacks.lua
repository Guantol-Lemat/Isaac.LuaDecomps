--#region Dependencies



--#endregion

--- The arguments are read only, internally the callbacks will get a copy of their value.
---@param rng RNG
---@param position Vector
---@return boolean
local function SpawnClearAward(rng, position)
end

---@param knife EntityKnifeComponent
local function PostKnifeUpdate(knife)
end

local Module = {}

--#region Module

Module.SpawnClearAward = SpawnClearAward
Module.PostKnifeUpdate = PostKnifeUpdate

--#endregion

return Module