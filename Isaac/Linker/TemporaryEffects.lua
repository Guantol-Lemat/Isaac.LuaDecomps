---@class Interface.TemporaryEffects
local Interface = require("Isaac.Interface.TemporaryEffects")

--#region Stub

local Stub = {}

---@param temporaryEffects Component.TemporaryEffects.TemporaryEffect[]
---@param effect Component.TemporaryEffects.TemporaryEffect
function Stub.insert(temporaryEffects, effect) end

---@param temporaryEffects Component.TemporaryEffects
function Stub.DisableCacheEvaluate_qqq(temporaryEffects) end

---@param temporaryEffects Component.TemporaryEffects
---@param ctx Context.Common
---@param Effect Component.TemporaryEffects.TemporaryEffect
---@param addCostume boolean
---@param count integer
function Stub.AddEffect(temporaryEffects, ctx, Effect, addCostume, count) end

---@param temporaryEffects Component.TemporaryEffects
---@param ctx Context.Common
---@param CollectibleType CollectibleType | integer
---@param AddCostume boolean
---@param Count integer
function Stub.AddCollectibleEffect(temporaryEffects, ctx, CollectibleType, AddCostume, Count) end

---@param temporaryEffects Component.TemporaryEffects
---@param ctx Context.Common
---@param TrinketType TrinketType | integer
---@param AddCostume boolean
---@param Count integer
function Stub.AddTrinketEffect(temporaryEffects, ctx, TrinketType, AddCostume, Count) end

---@param temporaryEffects Component.TemporaryEffects
---@param ctx Context.Common
---@param NullId NullItemID | integer
---@param AddCostume boolean
---@param Count integer
function Stub.AddNullEffect(temporaryEffects, ctx, NullId, AddCostume, Count) end

---@param temporaryEffects Component.TemporaryEffects
---@param ctx Context.Common
---@param Effect Component.TemporaryEffects.TemporaryEffect
---@param Count integer
function Stub.RemoveEffect(temporaryEffects, ctx, Effect, Count) end

---@param temporaryEffects Component.TemporaryEffects
---@param ctx Context.Common
---@param CollectibleType CollectibleType | integer
---@param Count integer
function Stub.RemoveCollectibleEffect(temporaryEffects, ctx, CollectibleType, Count) end

---@param temporaryEffects Component.TemporaryEffects
---@param ctx Context.Common
---@param TrinketType integer
---@param Count integer
function Stub.RemoveTrinketEffect(temporaryEffects, ctx, TrinketType, Count) end

---@param temporaryEffects Component.TemporaryEffects
---@param ctx Context.Common
---@param NullId NullItemID | integer
---@param Count integer
function Stub.RemoveNullEffect(temporaryEffects, ctx, NullId, Count) end

---@param temporaryEffects Component.TemporaryEffects
---@param param_1 Component.ItemConfig.Item
---@return boolean
function Stub.HasItem(temporaryEffects, param_1) end

---@param temporaryEffects Component.TemporaryEffects
---@param CollectibleType CollectibleType | integer
---@return boolean
function Stub.HasCollectibleEffect(temporaryEffects, CollectibleType) end

---@param temporaryEffects Component.TemporaryEffects
---@param TrinketType TrinketType | integer
---@return boolean
function Stub.HasTrinketEffect(temporaryEffects, TrinketType) end

---@param temporaryEffects Component.TemporaryEffects
---@param NullId NullItemID | integer
---@return boolean
function Stub.HasNullEffect(temporaryEffects, NullId) end

---@param temporaryEffects Component.TemporaryEffects
---@param ctx Context.Common
---@param includePersistent boolean
function Stub.ClearEffects(temporaryEffects, ctx, includePersistent) end

---@param temporaryEffects Component.TemporaryEffects
---@param ctx Context.Common
function Stub.Update(temporaryEffects, ctx) end

---@param temporaryEffects Component.TemporaryEffects
---@param CollectibleType CollectibleType | integer
---@return Component.TemporaryEffects.TemporaryEffect
function Stub.GetCollectibleEffect(temporaryEffects, CollectibleType) end

---@param temporaryEffects Component.TemporaryEffects
---@param TrinketType integer
---@return unknown
function Stub.GetTrinketEffect(temporaryEffects, TrinketType) end

---@param temporaryEffects Component.TemporaryEffects
---@param NullId NullItemID | integer
---@return Component.TemporaryEffects.TemporaryEffect
function Stub.GetNullEffect(temporaryEffects, NullId) end

---@param temporaryEffects Component.TemporaryEffects
---@param CollectibleType CollectibleType | integer
---@return integer
function Stub.GetCollectibleEffectNum(temporaryEffects, CollectibleType) end

---@param temporaryEffects Component.TemporaryEffects
---@param TrinketType TrinketType | integer
---@return integer
function Stub.GetTrinketEffectNum(temporaryEffects, TrinketType) end

---@param temporaryEffects Component.TemporaryEffects
---@param NullId NullItemID | integer
---@return integer
function Stub.GetNullEffectNum(temporaryEffects, NullId) end

--#endregion

Interface.insert = Stub.insert
Interface.DisableCacheEvaluate_qqq = Stub.DisableCacheEvaluate_qqq
Interface.AddEffect = Stub.AddEffect
Interface.AddCollectibleEffect = Stub.AddCollectibleEffect
Interface.AddTrinketEffect = Stub.AddTrinketEffect
Interface.AddNullEffect = Stub.AddNullEffect
Interface.RemoveEffect = Stub.RemoveEffect
Interface.RemoveCollectibleEffect = Stub.RemoveCollectibleEffect
Interface.RemoveTrinketEffect = Stub.RemoveTrinketEffect
Interface.RemoveNullEffect = Stub.RemoveNullEffect
Interface.HasItem = Stub.HasItem
Interface.HasCollectibleEffect = Stub.HasCollectibleEffect
Interface.HasTrinketEffect = Stub.HasTrinketEffect
Interface.HasNullEffect = Stub.HasNullEffect
Interface.ClearEffects = Stub.ClearEffects
Interface.Update = Stub.Update
Interface.GetCollectibleEffect = Stub.GetCollectibleEffect
Interface.GetTrinketEffect = Stub.GetTrinketEffect
Interface.GetNullEffect = Stub.GetNullEffect
Interface.GetCollectibleEffectNum = Stub.GetCollectibleEffectNum
Interface.GetTrinketEffectNum = Stub.GetTrinketEffectNum
Interface.GetNullEffectNum = Stub.GetNullEffectNum