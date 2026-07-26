---@class RoomRules
local Module = {}

---@param context Context
---@param seed integer
---@param noDecrease boolean
---@return CollectibleType
local function GetSeededCollectible(context, seed, noDecrease)
end

---@param context Context
---@param room Component.Room
---@param pit Component.GridEntity?
---@param source Component.GridEntity?
---@return boolean
local function TryMakeBridge(context, room, pit, source)
end

---@param context Context
---@param room Component.Room
---@param entity Component.Entity
---@param position Vector
---@return GridCollisionClass
local function GetSpecialGridCollision(context, room, entity, position)
end

--#region Module

Module.GetSeededCollectible = GetSeededCollectible
Module.TryMakeBridge = TryMakeBridge
Module.GetSpecialGridCollision = GetSpecialGridCollision

--#endregion

return Module