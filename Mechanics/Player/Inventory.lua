--#region Dependencies



--#endregion

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

local Module = {}

--#region Module

Module.HasCollectible = HasCollectible
Module.HasTrinket = HasTrinket

--#endregion

return Module