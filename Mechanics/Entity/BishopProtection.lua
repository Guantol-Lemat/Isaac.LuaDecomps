--#region Dependencies



--#endregion

---@class BishopProtection
local Module = {}

---@class BishopProtectionContext.FindClosestBishop
---@field entityManager EntityManagerComponent

---@class BishopProtectionContext.TriggerProtectPlayer

---@param context BishopProtectionContext.FindClosestBishop
---@param entity Component.Entity
---@param isFriendly boolean
---@return Component.Entity?
---@return Vector distance
local function FindClosestBishop(context, entity, isFriendly)
end

---@param context BishopProtectionContext.TriggerProtectPlayer
---@param bishop Component.Entity
---@param player Component.Entity.Player
local function TriggerProtectPlayer(context, bishop, player)
end

--#region Module

Module.FindClosestBishop = FindClosestBishop
Module.TriggerProtectPlayer = TriggerProtectPlayer

--#endregion

return Module