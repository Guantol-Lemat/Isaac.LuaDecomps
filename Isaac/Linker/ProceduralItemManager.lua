---@class Interface.ProceduralItemManager
local Interface = require("Isaac.Interface.ProceduralItemManager")

--#region Stub

local Stub = {}

---@param proceduralItemManager Component.ProceduralItemManager
---@param size integer
function Stub.StoreGameState(proceduralItemManager, size) end

---@return Component.ProceduralItemManager
function Stub.constructor() end

---@param proceduralItemManager Component.ProceduralItemManager
function Stub.destructor(proceduralItemManager) end

---@param proceduralItemManager Component.ProceduralItemManager
---@param ctx Context.Common
function Stub.Reset(proceduralItemManager, ctx) end

---@param proceduralItemManager Component.ProceduralItemManager
---@param ctx Context.Common
---@param seed integer
---@param flags_qqq integer
function Stub.CreateProceduralItem(proceduralItemManager, ctx, seed, flags_qqq) end

---@param proceduralItemManager Component.ProceduralItemManager
---@param ctx Context.Common
---@param param_1 integer
---@param itemCfg Component.ItemConfig.Item
---@param param_3 unknown
---@param item Component.ItemConfig.Item
---@return integer
function Stub.CreateSpecialProceduralItem(proceduralItemManager, ctx, param_1, itemCfg, param_3, item) end

---@param proceduralItemManager Component.ProceduralItemManager
---@param param_1 integer
---@return unknown
function Stub.GetProceduralItemDesc(proceduralItemManager, param_1) end

---@param ctx Context.Common
---@param ProceduralId integer
---@param Player Component.Entity.Player
---@param TriggerCondition ProceduralEffectConditionType | integer
---@param TriggerEntity_qqq Component.Entity
---@param Position Vector
---@param Velocity_qqq Vector
function Stub.TriggerEffects(ctx, ProceduralId, Player, TriggerCondition, TriggerEntity_qqq, Position, Velocity_qqq) end

---@param proceduralItemManager Component.ProceduralItemManager
---@param id integer
---@param SourceQuad Engine.Graphics.SourceQuad
---@param DestQuad Engine.Graphics.DestinationQuad
---@param color KColor
---@return unknown
function Stub.Render(proceduralItemManager, id, SourceQuad, DestQuad, color) end

---@param proceduralItemManager Component.ProceduralItemManager
---@param ctx Context.Common
---@param param_1 Component.GameState.ProceduralItems
function Stub.RestoreGameState(proceduralItemManager, ctx, param_1) end

--endregion

Interface.StoreGameState = Stub.StoreGameState
Interface.constructor = Stub.constructor
Interface.destructor = Stub.destructor
Interface.Reset = Stub.Reset
Interface.CreateProceduralItem = Stub.CreateProceduralItem
Interface.CreateSpecialProceduralItem = Stub.CreateSpecialProceduralItem
Interface.GetProceduralItemDesc = Stub.GetProceduralItemDesc
Interface.TriggerEffects = Stub.TriggerEffects
Interface.Render = Stub.Render
Interface.RestoreGameState = Stub.RestoreGameState