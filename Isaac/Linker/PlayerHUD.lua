---@class Interface.PlayerHUD
local Interface = require("Isaac.Interface.PlayerHUD")

--#region Stub

local Stub = {}

---@param playerHud Component.HUD.PlayerHUD
---@param param_1 boolean
function Stub.Free(playerHud, param_1) end

---@return Component.HUD.PlayerHUD
function Stub.constructor() end

---@param playerHud Component.HUD.PlayerHUD
function Stub.destructor(playerHud) end

---@param playerHud Component.HUD.PlayerHUD
---@param right Component.HUD.PlayerHUD
function Stub.copy_player(playerHud, right) end

---@param playerHud Component.HUD.PlayerHUD
function Stub.Reset(playerHud) end

---@param playerHud Component.HUD.PlayerHUD
---@param ctx Context.Common
---@param param_1 Component.HUD.PlayerHUD.Heart
---@param param_2 integer
---@param param_3 Component.Entity.Player
function Stub.UpdateHearts(playerHud, ctx, param_1, param_2, param_3) end

---@param playerHud Component.HUD.PlayerHUD
---@param ctx Context.Common
function Stub.Update(playerHud, ctx) end

---@param playerHud Component.HUD.PlayerHUD
---@param ctx Context.Common
---@param param_1 Vector
---@param HeartsSprite Sprite
---@param param_3 Vector
---@param param_4 number
function Stub.RenderHearts(playerHud, ctx, param_1, HeartsSprite, param_3, param_4) end

---@param playerHud Component.HUD.PlayerHUD
---@param ctx Context.Common
---@param slot integer
---@param pos Vector
---@param param_4 number
---@param alpha number
---@param param_6 boolean
function Stub.RenderActiveItem(playerHud, ctx, slot, pos, param_4, alpha, param_6) end

---@param playerHud Component.HUD.PlayerHUD
---@param ctx Context.Common
---@param slot integer
---@param pos Vector
---@param scale_qqq number
function Stub.RenderTrinket(playerHud, ctx, slot, pos, scale_qqq) end

---@param playerHud Component.HUD.PlayerHUD
---@param ctx Context.Common
---@param param_2 Vector
---@param param_3 number
---@param param_4 number
function Stub.RenderPocketItems(playerHud, ctx, param_2, param_3, param_4) end

---@param playerHud Component.HUD.PlayerHUD
---@param ctx Context.Common
---@param param_2 Vector
---@param param_3 number
function Stub.RenderInventory(playerHud, ctx, param_2, param_3) end

---@param playerHud Component.HUD.PlayerHUD
---@param ctx Context.Common
---@param pos Vector
---@param param_3 number
function Stub.RenderCraftingTable(playerHud, ctx, pos, param_3) end

---@param playerHud Component.HUD.PlayerHUD
---@param ctx Context.Common
---@param param_2 Vector
---@param param_3 number
function Stub.RenderSpellQueue(playerHud, ctx, param_2, param_3) end

--#endregion

Interface.Free = Stub.Free
Interface.constructor = Stub.constructor
Interface.destructor = Stub.destructor
Interface.copy_player = Stub.copy_player
Interface.Reset = Stub.Reset
Interface.UpdateHearts = Stub.UpdateHearts
Interface.Update = Stub.Update
Interface.RenderHearts = Stub.RenderHearts
Interface.RenderActiveItem = Stub.RenderActiveItem
Interface.RenderTrinket = Stub.RenderTrinket
Interface.RenderPocketItems = Stub.RenderPocketItems
Interface.RenderInventory = Stub.RenderInventory
Interface.RenderCraftingTable = Stub.RenderCraftingTable
Interface.RenderSpellQueue = Stub.RenderSpellQueue