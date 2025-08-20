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

--#region Module

Module.FirstCollectibleOwner = FirstCollectibleOwner
Module.AnyoneHasCollectible = AnyoneHasCollectible

--#endregion

return Module