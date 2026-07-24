--#region Dependencies



--#endregion

---@param rng RNG
---@return boolean hearBlocked
local function TryDaemonsTailBlock(rng)
    return rng:RandomInt(5) ~= 0
end

---@class Gameplay.PickupUtils
local Module = {}

--#region Module

Module.TryDaemonsTailBlock = TryDaemonsTailBlock

--#endregion

return Module