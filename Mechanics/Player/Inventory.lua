--#region Dependencies



--#endregion

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param collectibleId CollectibleType | integer
---@param ignoreModifiers boolean
---@return boolean
local function NumCollectibleHeld(myContext, player, collectibleId, ignoreModifiers)
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param trinketId TrinketType | integer
---@return integer
local function GetTrinketMultiplier(myContext, player, trinketId)
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param collectibleId CollectibleType | integer
---@param ignoreModifiers boolean
---@return boolean
local function HasCollectible(myContext, player, collectibleId, ignoreModifiers)
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param trinketId TrinketType | integer
---@param ignoreModifiers boolean
local function HasTrinket(myContext, player, trinketId, ignoreModifiers)
end

---@param myContext Context.Common
---@param collectibleId CollectibleType | integer
local function TriggerCollectibleRemoved(myContext, collectibleId)
end

local Module = {}

--#region Module

Module.NumCollectibleHeld = NumCollectibleHeld
Module.GetTrinketMultiplier = GetTrinketMultiplier
Module.HasCollectible = HasCollectible
Module.HasTrinket = HasTrinket
Module.TriggerCollectibleRemoved = TriggerCollectibleRemoved

--#endregion

return Module