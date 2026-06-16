---@class Interface.ItemPool
local Interface = require("Isaac.Interface.ItemPool")

--#region Stub

local Stub = {}

---@param itemPool Component.ItemPool
---@param Item CollectibleType | integer
function Stub.AddRoomBlacklist(itemPool, Item) end

---@param itemPool Component.ItemPool
---@param PillColor PillColor | integer
function Stub.IdentifyPill(itemPool, PillColor) end

---@param itemPool Component.ItemPool
---@param param_1 integer
---@return Component.ItemPool.Pool
function Stub.GetPool(itemPool, param_1) end

---@param itemPool Component.ItemPool
function Stub.destructor(itemPool) end

---@param ctx Context.Common
---@param itemPool Component.ItemPool
---@param id CollectibleType | integer
---@param flags integer
---@return boolean
function Stub.CanSpawnCollectible(ctx, itemPool, id, flags) end

---@param ctx Context.Common
---@param itemPool Component.ItemPool
---@param RoomType RoomType | integer
---@param Seed integer
---@return ItemPoolType | integer
function Stub.GetPoolForRoom(ctx, itemPool, RoomType, Seed) end

---@param ctx Context.Common
---@param itemPool Component.ItemPool
---@param targetWeight number
---@param Pool Component.ItemPool.Pool
---@param flags integer
---@return Component.ItemPool.PoolItem
function Stub.pick_collectible(ctx, itemPool, targetWeight, Pool, flags) end

---@param ctx Context.Common
---@param Seed integer
---@return boolean
function Stub.TryReplaceWithMagicSkin(ctx, Seed) end

---@param ctx Context.Common
---@param itemPool Component.ItemPool
---@param PoolType ItemPoolType | integer
---@param Seed integer
---@param Flags integer
---@param DefaultItem CollectibleType | integer
---@return CollectibleType | integer
function Stub.GetCollectible(ctx, itemPool, PoolType, Seed, Flags, DefaultItem) end

---@param ctx Context.Common
---@param itemPool Component.ItemPool
---@param DontAdvanceRNG boolean
---@return TrinketType | integer
function Stub.GetTrinket(ctx, itemPool, DontAdvanceRNG) end

---@param ctx Context.Common
---@param itemPool Component.ItemPool
---@param Item CollectibleType | integer
---@param checkIfAvailable boolean
---@param ignoreModifiers boolean
---@return boolean
function Stub.RemoveCollectible(ctx, itemPool, Item, checkIfAvailable, ignoreModifiers) end

---@param itemPool Component.ItemPool
---@param Collectible CollectibleType | integer
function Stub.ResetCollectible(itemPool, Collectible) end

---@param itemPool Component.ItemPool
---@param Trinket TrinketType | integer
---@return boolean
function Stub.RemoveTrinket(itemPool, Trinket) end

---@param ctx Context.Common
---@param Seed integer
---@param SpecialChance integer
---@param RuneChance integer
---@param SuitChance integer
---@param AllowNonCards boolean
---@return integer
function Stub.GetCardEx(ctx, Seed, SpecialChance, RuneChance, SuitChance, AllowNonCards) end

---@param ctx Context.Common
---@param Seed integer
---@param Playing boolean
---@param Rune boolean
---@param OnlyRunes boolean
---@return integer
function Stub.GetCard(ctx, Seed, Playing, Rune, OnlyRunes) end

---@param ctx Context.Common
---@param Seed integer
---@return PillColor | integer
function Stub.GetPill(ctx, Seed) end

---@param ctx Context.Common
---@param itemPool Component.ItemPool
---@param PillColor PillColor | integer
---@param Player Component.Entity.Player
---@return PillEffect | integer
function Stub.GetPillEffect(ctx, itemPool, PillColor, Player) end

---@param ctx Context.Common
---@param itemPool Component.ItemPool
---@param seed integer
---@param path string
function Stub.Init(ctx, itemPool, seed, path) end

---@param itemPool Component.ItemPool
function Stub.shuffle_pools(itemPool) end

---@param itemPool Component.ItemPool
---@param xmlpath string
---@param ismod boolean
function Stub.load_pools(itemPool, xmlpath, ismod) end

---@param itemPool Component.ItemPool
---@param param_1 Component.GameStateItemPool
function Stub.RestoreGameState(itemPool, param_1) end

---@param itemPool Component.ItemPool
---@param state Component.GameStateItemPool
function Stub.StoreGameState(itemPool, state) end

---@param ctx Context.Common
---@param itemPool Component.ItemPool
function Stub.ResetTrinkets(ctx, itemPool) end

---@param itemPool Component.ItemPool
---@param ID PillEffect | integer
---@return PillColor | integer
function Stub.ForceAddPillEffect(itemPool, ID) end

---@param ctx Context.Common
---@param itemPool Component.ItemPool
---@param pillColor PillColor | integer
---@param seed integer
---@return unknown
function Stub.RerollPillEffect(ctx, itemPool, pillColor, seed) end

---@param itemPool Component.ItemPool
function Stub.ResetRoomBlacklist(itemPool) end

---@param itemPool Component.ItemPool
---@param Add integer
---@param PoolType ItemPoolType | integer
function Stub.AddBibleUpgrade(itemPool, Add, PoolType) end

---@param ctx Context.Common
---@param itemPool Component.ItemPool
---@param rng RNG
---@return integer
function Stub.get_chaos_pool(ctx, itemPool, rng) end

---@param ctx Context.Common
---@param itemPool Component.ItemPool
---@param list (CollectibleType | integer)[]
---@param length integer
---@param seed integer
---@param defaultItem CollectibleType | integer
---@param addToBlacklist boolean
---@param excludeLockedItems boolean
---@return CollectibleType | integer
function Stub.GetCollectibleFromList(ctx, itemPool, list, length, seed, defaultItem, addToBlacklist, excludeLockedItems) end

---@param ctx Context.Common
---@param itemPool Component.ItemPool
---@param seed integer
---@return integer
function Stub.GetCantrippedItemCard(ctx, itemPool, seed) end

---@param itemPool Component.ItemPool
---@return ItemPoolType | integer
function Stub.GetLastPool(itemPool) end

---@param itemPool Component.ItemPool
---@param PillColor PillColor | integer
---@return boolean
function Stub.IsPillIdentified(itemPool, PillColor) end

--endregion

Interface.AddRoomBlacklist = Stub.AddRoomBlacklist
Interface.IdentifyPill = Stub.IdentifyPill
Interface.GetPool = Stub.GetPool
Interface.destructor = Stub.destructor
Interface.CanSpawnCollectible = Stub.CanSpawnCollectible
Interface.GetPoolForRoom = Stub.GetPoolForRoom
Interface.pick_collectible = Stub.pick_collectible
Interface.TryReplaceWithMagicSkin = Stub.TryReplaceWithMagicSkin
Interface.GetCollectible = Stub.GetCollectible
Interface.GetTrinket = Stub.GetTrinket
Interface.RemoveCollectible = Stub.RemoveCollectible
Interface.ResetCollectible = Stub.ResetCollectible
Interface.RemoveTrinket = Stub.RemoveTrinket
Interface.GetCardEx = Stub.GetCardEx
Interface.GetCard = Stub.GetCard
Interface.GetPill = Stub.GetPill
Interface.GetPillEffect = Stub.GetPillEffect
Interface.Init = Stub.Init
Interface.shuffle_pools = Stub.shuffle_pools
Interface.load_pools = Stub.load_pools
Interface.RestoreGameState = Stub.RestoreGameState
Interface.StoreGameState = Stub.StoreGameState
Interface.ResetTrinkets = Stub.ResetTrinkets
Interface.ForceAddPillEffect = Stub.ForceAddPillEffect
Interface.RerollPillEffect = Stub.RerollPillEffect
Interface.ResetRoomBlacklist = Stub.ResetRoomBlacklist
Interface.AddBibleUpgrade = Stub.AddBibleUpgrade
Interface.get_chaos_pool = Stub.get_chaos_pool
Interface.GetCollectibleFromList = Stub.GetCollectibleFromList
Interface.GetCantrippedItemCard = Stub.GetCantrippedItemCard
Interface.GetLastPool = Stub.GetLastPool
Interface.IsPillIdentified = Stub.IsPillIdentified