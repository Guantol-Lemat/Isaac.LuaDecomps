---@class Interface.ProceduralItemInventory
local Interface = require("Isaac.Interface.ProceduralItemInventory")

--#region Stub

local Stub = {}

---@param inventory Component.ProceduralItemInventory
---@return number
function Stub.GetDamage(inventory) end

---@param inventory Component.ProceduralItemInventory
---@return number
function Stub.GetFireDelay(inventory) end

---@param inventory Component.ProceduralItemInventory
---@return number
function Stub.GetSpeed(inventory) end

---@param inventory Component.ProceduralItemInventory
---@return number
function Stub.GetRange(inventory) end

---@param inventory Component.ProceduralItemInventory
---@return number
function Stub.GetShotSpeed(inventory) end

---@param inventory Component.ProceduralItemInventory
---@return number
function Stub.GetLuck(inventory) end

---@param inventory Component.ProceduralItemInventory
function Stub.destructor(inventory) end

---@param inventory Component.ProceduralItemInventory
---@param ctx Context.Common
---@param collectible_id integer
function Stub.Add(inventory, ctx, collectible_id) end

---@param inventory Component.ProceduralItemInventory
---@param ctx Context.Common
---@param param_1 integer
function Stub.Remove(inventory, ctx, param_1) end

---@param inventory Component.ProceduralItemInventory
---@param param_1 integer
---@return boolean
function Stub.HasItem(inventory, param_1) end

---@param inventory Component.ProceduralItemInventory
---@param ctx Context.Common
function Stub.RestoreGameState(inventory, ctx) end

---@param inventory Component.ProceduralItemInventory
---@param param_1 CollectibleType | integer
---@return integer
function Stub.GetNumSimulatedCollectible(inventory, param_1) end

---@param inventory Component.ProceduralItemInventory
---@param ctx Context.Common
---@param TriggerCondition ProceduralEffectConditionType | integer
---@param Entity Component.Entity
---@param Position Vector
---@param Velocity Vector
function Stub.TriggerEffects(inventory, ctx, TriggerCondition, Entity, Position, Velocity) end

--#endregion

Interface.GetDamage = Stub.GetDamage
Interface.GetFireDelay = Stub.GetFireDelay
Interface.GetSpeed = Stub.GetSpeed
Interface.GetRange = Stub.GetRange
Interface.GetShotSpeed = Stub.GetShotSpeed
Interface.GetLuck = Stub.GetLuck
Interface.destructor = Stub.destructor
Interface.Add = Stub.Add
Interface.Remove = Stub.Remove
Interface.HasItem = Stub.HasItem
Interface.RestoreGameState = Stub.RestoreGameState
Interface.GetNumSimulatedCollectible = Stub.GetNumSimulatedCollectible
Interface.TriggerEffects = Stub.TriggerEffects