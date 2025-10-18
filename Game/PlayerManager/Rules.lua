---@class PlayerManagerRules
local Module = {}

---@param context Context
---@param manager PlayerManagerComponent
---@param collectibleType CollectibleType
---@return EntityPlayerComponent?
local function FirstCollectibleOwner(context, manager, collectibleType)
end

---@param context Context
---@param manager PlayerManagerComponent
---@param collectibleType CollectibleType
---@return boolean
local function AnyoneHasCollectible(context, manager, collectibleType)
    return not not FirstCollectibleOwner(context, manager, collectibleType)
end

---@param context Context
---@param manager PlayerManagerComponent
---@param trinket TrinketType
---@return EntityPlayerComponent?
local function FirstTrinketOwner(context, manager, trinket)
end

---@param context Context
---@param manager PlayerManagerComponent
---@param trinket TrinketType
---@return boolean
local function AnyoneHasTrinket(context, manager, trinket)
    return not not FirstTrinketOwner(context, manager, trinket)
end

--#region Module

Module.FirstCollectibleOwner = FirstCollectibleOwner
Module.AnyoneHasCollectible = AnyoneHasCollectible
Module.FirstTrinketOwner = FirstTrinketOwner
Module.AnyoneHasTrinket = AnyoneHasTrinket

--#endregion

return Module