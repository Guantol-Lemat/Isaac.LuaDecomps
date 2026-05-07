--#region Stub

local Stub = {}

---@param pickup Component.Entity.Pickup
---@return integer
function Stub.GetPrice(pickup) end

---@param pickup Component.Entity.Pickup
---@param Time integer
function Stub.SetWait(pickup, Time) end

---@param pickup Component.Entity.Pickup
---@return boolean
function Stub.IsShopItem(pickup) end

---@param pickup Component.Entity.Pickup
---@param Timeout integer
function Stub.SetTimeout(pickup, Timeout) end

---@param pickup Component.Entity.Pickup
---@return integer
function Stub.GetTimeout(pickup) end

---@param pickup Component.Entity.Pickup
---@param Value boolean
function Stub.SetTouched(pickup, Value) end

---@param pickup Component.Entity.Pickup
---@param Index integer
function Stub.SetOptionsPickupIndex(pickup, Index) end

---@param pickup Component.Entity.Pickup
---@return integer
function Stub.GetOptionsPickupIndex(pickup) end

---@param param_1 boolean
function Stub.SetIgnoreModifiers(param_1) end

---@param pickup Component.Entity.Pickup
---@param param_1 integer
function Stub.SetDropDelay(pickup, param_1) end

---@param pickup Component.Entity.Pickup
---@return unknown
function Stub.IsForceBlind(pickup) end

---@param pickup Component.Entity.Pickup
---@param param_1 integer
function Stub.SetUnkInt(pickup, param_1) end

---@param pickup Component.Entity.Pickup
---@param Collectible integer
function Stub.SetOptionCycleCollectible(pickup, Collectible) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param param_2 boolean
---@return Component.LootList
function Stub.GetLootList(ctx, pickup, param_2) end

---@param ctx Context.Common
---@param seed integer
---@param variant integer
---@param param_3 integer
---@param param_4 boolean
---@param param_5 boolean
function Stub.SelectPickupType(ctx, seed, variant, param_3, param_4, param_5) end

---@param pickup Component.Entity.Pickup
---@return Component.Entity.Pickup
function Stub.Constructor(pickup) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param param_1 boolean
function Stub.Free(ctx, pickup, param_1) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
function Stub.destructor(ctx, pickup) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param Type EntityType | integer
---@param Variant PickupVariant | integer
---@param Subtype integer
---@param Seed integer
function Stub.Init(ctx, pickup, Type, Variant, Subtype, Seed) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
function Stub.InitFlipState(ctx, pickup) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@return boolean
function Stub.TryFlip(ctx, pickup) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
function Stub.UpdatePickupGhosts(ctx, pickup) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param numCycle integer
---@return boolean
function Stub.TryInitOptionCycle(ctx, pickup, numCycle) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param pedestalType ePedestalType | integer
function Stub.SetAlternatePedestal(ctx, pickup, pedestalType) end

---@param pickup Component.Entity.Pickup
---@return ePedestalType | integer
function Stub.GetAlternatePedestal(pickup) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param setBlind boolean
function Stub.SetForceBlind(ctx, pickup, setBlind) end

---@param ctx Context.Common
---@param param_1 Sprite
---@param layer integer
---@param id CollectibleType | integer
---@param param_4 integer
---@param param_5 boolean
function Stub.SetupCollectibleGraphics(ctx, param_1, layer, id, param_4, param_5) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param param_1 boolean
function Stub.ReloadGraphics(ctx, pickup, param_1) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param Price ShopItemPrice | integer
function Stub.SetPrice(ctx, pickup, Price) end

---@param pickup Component.Entity.Pickup
function Stub.AppearFast(pickup) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param Type EntityType | integer
---@param Variant PickupVariant | integer
---@param SubType integer
---@param KeepPrice boolean
---@param KeepSeed boolean
---@param IgnoreModifiers boolean
function Stub.Morph(ctx, pickup, Type, Variant, SubType, KeepPrice, KeepSeed, IgnoreModifiers) end

---@param pickup Component.Entity.Pickup
---@param param_1 Component.Entity.EntityRef
---@param Pos Vector
---@param param_3 number
---@return boolean
function Stub.TryThrow(pickup, param_1, Pos, param_3) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
function Stub.Interpolate(ctx, pickup) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
function Stub.Update(ctx, pickup) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param offset Vector
function Stub.Render(ctx, pickup, offset) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param Player Component.Entity.Player
---@return boolean
function Stub.TryOpenChest(ctx, pickup, Player) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
function Stub.PlayDropSound(ctx, pickup) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
function Stub.PlayPickupSound(ctx, pickup) end

---@param pickup Component.Entity.Pickup
---@return integer
function Stub.GetCoinValue(pickup) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param player Component.Entity.Player
---@return boolean
function Stub.CanPickupShopItem(ctx, pickup, player) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param player Component.Entity.Player
---@param spentMoney integer
function Stub.TriggerShopPurchase(ctx, pickup, player, spentMoney) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param collider Component.Entity
---@param low boolean
---@return integer
function Stub.handle_collision(ctx, pickup, collider, low) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@return boolean
function Stub.TryRemoveCollectible(ctx, pickup) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
function Stub.update_magnet_effect(ctx, pickup) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param param_1 number
---@param param_2 integer
---@param param_3 Component.Entity.EntityRef
---@param param_4 integer
---@return boolean
function Stub.TakeDamage(ctx, pickup, param_1, param_2, param_3, param_4) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
function Stub.Remove(ctx, pickup) end

---@param pickup Component.Entity.Pickup
function Stub.ClearReferences(pickup) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@return boolean
function Stub.CanReroll(ctx, pickup) end

---@param ctx Context.Common
---@param variant PickupVariant | integer
---@param subtype integer
---@return boolean
function Stub.can_reroll(ctx, variant, subtype) end

---@param pickup Component.Entity.Pickup
---@return boolean
function Stub.IsChest_wrapper(pickup) end

---@param variant PickupVariant | integer
---@return boolean
function Stub.IsChest(variant) end

---@param pickup Component.Entity.Pickup
---@param ignorePrice boolean
---@return boolean
function Stub.CanBePickedUp(pickup, ignorePrice) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@return boolean
function Stub.CanDuplicate(ctx, pickup) end

---@param ctx Context.Common
---@param position Vector
---@param ePickVelType integer
---@param RNG RNG
---@return Vector
function Stub.get_random_pickup_velocity(ctx, position, ePickVelType, RNG) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
function Stub.TriggerTheresOptionsPickup(ctx, pickup) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param itemId integer
function Stub.MakeShopItem(ctx, pickup, itemId) end

---@param ctx Context.Common
---@param pos Vector
---@return Vector
function Stub.GetCollectibleSpawnPos(ctx, pos) end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@return integer
function Stub.SetNewOptionsPickupIndex(ctx, pickup) end

---@param pickup Component.Entity.Pickup
---@param Charge integer
function Stub.SetCharge(pickup, Charge) end

---@param pickup Component.Entity.Pickup
---@return integer
function Stub.GetCharge(pickup) end

---@param pickup Component.Entity.Pickup
---@param Value boolean
function Stub.SetAutoUpdatePrice(pickup, Value) end

---@param pickup Component.Entity.Pickup
---@return boolean
function Stub.GetAutoUpdatePrice(pickup) end

---@param pickup Component.Entity.Pickup
---@return boolean
function Stub.GetTouched(pickup) end

---@param pickup Component.Entity.Pickup
---@return integer
function Stub.GetShopItemId(pickup) end

---@param pickup Component.Entity.Pickup
---@param ID integer
function Stub.SetShopItemId(pickup, ID) end

---@param pickup Component.Entity.Pickup
---@return unknown
function Stub.GetWait(pickup) end

--endregion

Interface.GetPrice = Stub.GetPrice
Interface.SetWait = Stub.SetWait
Interface.IsShopItem = Stub.IsShopItem
Interface.SetTimeout = Stub.SetTimeout
Interface.GetTimeout = Stub.GetTimeout
Interface.SetTouched = Stub.SetTouched
Interface.SetOptionsPickupIndex = Stub.SetOptionsPickupIndex
Interface.GetOptionsPickupIndex = Stub.GetOptionsPickupIndex
Interface.SetIgnoreModifiers = Stub.SetIgnoreModifiers
Interface.SetDropDelay = Stub.SetDropDelay
Interface.IsForceBlind = Stub.IsForceBlind
Interface.SetUnkInt = Stub.SetUnkInt
Interface.SetOptionCycleCollectible = Stub.SetOptionCycleCollectible
Interface.GetLootList = Stub.GetLootList
Interface.SelectPickupType = Stub.SelectPickupType
Interface.Constructor = Stub.Constructor
Interface.Free = Stub.Free
Interface.destructor = Stub.destructor
Interface.Init = Stub.Init
Interface.InitFlipState = Stub.InitFlipState
Interface.TryFlip = Stub.TryFlip
Interface.UpdatePickupGhosts = Stub.UpdatePickupGhosts
Interface.TryInitOptionCycle = Stub.TryInitOptionCycle
Interface.SetAlternatePedestal = Stub.SetAlternatePedestal
Interface.GetAlternatePedestal = Stub.GetAlternatePedestal
Interface.SetForceBlind = Stub.SetForceBlind
Interface.SetupCollectibleGraphics = Stub.SetupCollectibleGraphics
Interface.ReloadGraphics = Stub.ReloadGraphics
Interface.SetPrice = Stub.SetPrice
Interface.AppearFast = Stub.AppearFast
Interface.Morph = Stub.Morph
Interface.TryThrow = Stub.TryThrow
Interface.Interpolate = Stub.Interpolate
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.TryOpenChest = Stub.TryOpenChest
Interface.PlayDropSound = Stub.PlayDropSound
Interface.PlayPickupSound = Stub.PlayPickupSound
Interface.GetCoinValue = Stub.GetCoinValue
Interface.CanPickupShopItem = Stub.CanPickupShopItem
Interface.TriggerShopPurchase = Stub.TriggerShopPurchase
Interface.handle_collision = Stub.handle_collision
Interface.TryRemoveCollectible = Stub.TryRemoveCollectible
Interface.update_magnet_effect = Stub.update_magnet_effect
Interface.TakeDamage = Stub.TakeDamage
Interface.Remove = Stub.Remove
Interface.ClearReferences = Stub.ClearReferences
Interface.CanReroll = Stub.CanReroll
Interface.can_reroll = Stub.can_reroll
Interface.IsChest_wrapper = Stub.IsChest_wrapper
Interface.IsChest = Stub.IsChest
Interface.CanBePickedUp = Stub.CanBePickedUp
Interface.CanDuplicate = Stub.CanDuplicate
Interface.get_random_pickup_velocity = Stub.get_random_pickup_velocity
Interface.TriggerTheresOptionsPickup = Stub.TriggerTheresOptionsPickup
Interface.MakeShopItem = Stub.MakeShopItem
Interface.GetCollectibleSpawnPos = Stub.GetCollectibleSpawnPos
Interface.SetNewOptionsPickupIndex = Stub.SetNewOptionsPickupIndex
Interface.SetCharge = Stub.SetCharge
Interface.GetCharge = Stub.GetCharge
Interface.SetAutoUpdatePrice = Stub.SetAutoUpdatePrice
Interface.GetAutoUpdatePrice = Stub.GetAutoUpdatePrice
Interface.GetTouched = Stub.GetTouched
Interface.GetShopItemId = Stub.GetShopItemId
Interface.SetShopItemId = Stub.SetShopItemId
Interface.GetWait = Stub.GetWait