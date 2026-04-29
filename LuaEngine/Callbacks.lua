--#region Dependencies



--#endregion

---@param collectibleType CollectibleType | integer
---@param rng RNG
---@param player EntityPlayerComponent
---@param useFlags UseFlag | integer
---@param activeSlot ActiveSlot
---@param customVarData integer
---@return boolean
local function PreUseItem(collectibleType, rng, player, useFlags, activeSlot, customVarData)
end

---@param cardType Card | integer
---@param player EntityPlayerComponent
---@param useFlags UseFlag | integer
local function UseCard(cardType, player, useFlags)
end

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

Module.PreUseItem = PreUseItem
Module.UseCard = UseCard
Module.SpawnClearAward = SpawnClearAward
Module.PostKnifeUpdate = PostKnifeUpdate

--#endregion

return Module