---@class Interface.HUD
local Interface = require("Isaac.Interface.HUD")

--#region Stub

local Stub = {}

---@param hud Component.HUD
---@param param_1 boolean
function Stub.SetVisible(hud, param_1) end

---@return Component.HUD
function Stub.constructor() end

---@param hud Component.HUD
function Stub.destructor(hud) end

---@param hud Component.HUD
---@return boolean
function Stub.IsVisible(hud) end

---@param hud Component.HUD
function Stub.Reset(hud) end

---@param hud Component.HUD
function Stub.UnloadGraphics(hud) end

---@param hud Component.HUD
---@param ctx Context.Common
function Stub.Update(hud, ctx) end

---@param hud Component.HUD
---@param ctx Context.Common
function Stub.PostUpdate(hud, ctx) end

---@param hud Component.HUD
---@param Player Component.Entity.Player
---@param ActiveSlot ActiveSlot | integer
function Stub.FlashChargeBar(hud, Player, ActiveSlot) end

---@param hud Component.HUD
---@param Player Component.Entity.Player
---@param ActiveSlot ActiveSlot | integer
function Stub.InvalidateActiveItem(hud, Player, ActiveSlot) end

---@param hud Component.HUD
---@param Player Component.Entity.Player
function Stub.InvalidateCraftingItem(hud, Player) end

---@param hud Component.HUD
---@param ctx Context.Common
---@param font Font
---@param param_3 integer
---@param param_4 number
---@param color KColor
---@param unused_qqq boolean
---@param param_7 number
function Stub.RenderGlitchText(hud, ctx, font, param_3, param_4, color, unused_qqq, param_7) end

---@param hud Component.HUD
---@param ctx Context.Common
---@param title string
---@param subtitle string
---@param isSticky boolean
---@param isCurseDisplay boolean
function Stub.ShowItemTextCustomUTF8(hud, ctx, title, subtitle, isSticky, isCurseDisplay) end

---@param hud Component.HUD
---@param ctx Context.Common
---@param title string
---@param subtitle string
---@param isSticky boolean
---@param isCurseDisplay boolean
function Stub.ShowItemTextCustom(hud, ctx, title, subtitle, isSticky, isCurseDisplay) end

---@param hud Component.HUD
---@param ctx Context.Common
---@param param_1 Component.Entity.Player
---@param param_2 Component.ItemConfig.Item
function Stub.ShowItemText(hud, ctx, param_1, param_2) end

---@param hud Component.HUD
---@param ctx Context.Common
---@param param_1 string
function Stub.ShowFortuneTextWrapped(hud, ctx, param_1) end

---@param hud Component.HUD
---@param ctx Context.Common
---@param param_1 integer
function Stub.ShowFortuneText(hud, ctx, param_1) end

---@param hud Component.HUD
---@param ctx Context.Common
function Stub.Render(hud, ctx) end

---@param hud Component.HUD
---@param ctx Context.Common
function Stub.render_streak(hud, ctx) end

---@param hud Component.HUD
---@param param_1 Component.HUD.PlayerHUD
---@param param_2 Component.Entity.Player
function Stub.CreatePlayerHUD(hud, param_1, param_2) end

---@param hud Component.HUD
---@param ctx Context.Common
function Stub.AssignPlayerHUDs(hud, ctx) end

---@param hud Component.HUD
---@param ctx Context.Common
---@param param_1 boolean
---@param ResetHistory boolean
function Stub.InvalidateItemHistory(hud, ctx, param_1, ResetHistory) end

---@param hud Component.HUD
---@param ctx Context.Common
---@param pos Vector
---@param ent Component.Entity
function Stub.RenderHealthBar(hud, ctx, pos, ent) end

---@param hud Component.HUD
---@param Player Component.Entity.Player
function Stub.FlashRedHearts(hud, Player) end

---@param hud Component.HUD
---@param ctx Context.Common
---@param param_1 boolean
function Stub.AssignPlayerHUDs(hud, ctx, param_1) end

--endregion

Interface.SetVisible = Stub.SetVisible
Interface.constructor = Stub.constructor
Interface.destructor = Stub.destructor
Interface.IsVisible = Stub.IsVisible
Interface.Reset = Stub.Reset
Interface.UnloadGraphics = Stub.UnloadGraphics
Interface.Update = Stub.Update
Interface.PostUpdate = Stub.PostUpdate
Interface.FlashChargeBar = Stub.FlashChargeBar
Interface.InvalidateActiveItem = Stub.InvalidateActiveItem
Interface.InvalidateCraftingItem = Stub.InvalidateCraftingItem
Interface.RenderGlitchText = Stub.RenderGlitchText
Interface.ShowItemTextCustomUTF8 = Stub.ShowItemTextCustomUTF8
Interface.ShowItemTextCustom = Stub.ShowItemTextCustom
Interface.ShowItemText = Stub.ShowItemText
Interface.ShowFortuneTextWrapped = Stub.ShowFortuneTextWrapped
Interface.ShowFortuneText = Stub.ShowFortuneText
Interface.Render = Stub.Render
Interface.render_streak = Stub.render_streak
Interface.CreatePlayerHUD = Stub.CreatePlayerHUD
Interface.AssignPlayerHUDs = Stub.AssignPlayerHUDs
Interface.InvalidateItemHistory = Stub.InvalidateItemHistory
Interface.RenderHealthBar = Stub.RenderHealthBar
Interface.FlashRedHearts = Stub.FlashRedHearts
Interface.AssignPlayerHUDs = Stub.AssignPlayerHUDs