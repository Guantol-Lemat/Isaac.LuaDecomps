--#region Dependencies



--#endregion

---@class PickupInitLogic
local Module = {}

local s_IgnoreModifiers = 0

local function StartIgnoreModifiers()
    s_IgnoreModifiers = s_IgnoreModifiers + 1
end

local function EndIgnoreModifiers()
    s_IgnoreModifiers = s_IgnoreModifiers - 1
end

---@param pickup EntityPickupComponent
---@param shopId integer
local function MakeShopItem(pickup, shopId)
end

--#region Module

Module.StartIgnoreModifiers = StartIgnoreModifiers
Module.EndIgnoreModifiers = EndIgnoreModifiers
Module.MakeShopItem = MakeShopItem

--#endregion

return Module
