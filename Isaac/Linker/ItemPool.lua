---@class Interface.ItemPool
local Interface = require("Isaac.Interface.ItemPool")

local PoolInit = require("Isaac.Gameplay.ItemPool.Init")
local PoolLoad = require("Isaac.Gameplay.ItemPool.Load")
local CollectiblePool = require("Isaac.Gameplay.ItemPool.CollectiblePool")
local TrinketPool = require("Isaac.Gameplay.ItemPool.TrinketPool")

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

---@param itemPool Component.ItemPool
---@param ctx Context.Common
---@param id CollectibleType | integer
---@param flags integer
---@return boolean
function Stub.CanSpawnCollectible(itemPool, ctx, id, flags) end

---@param itemPool Component.ItemPool
---@param ctx Context.Common
---@param RoomType RoomType | integer
---@param Seed integer
---@return ItemPoolType | integer
function Stub.GetPoolForRoom(itemPool, ctx, RoomType, Seed) end

---@param itemPool Component.ItemPool
---@param ctx Context.Common
---@param targetWeight number
---@param Pool Component.ItemPool.Pool
---@param flags integer
---@return Component.ItemPool.PoolItem
function Stub.pick_collectible(itemPool, ctx, targetWeight, Pool, flags) end

---@param ctx Context.Common
---@param Seed integer
---@return boolean
function Stub.TryReplaceWithMagicSkin(ctx, Seed) end

---@param itemPool Component.ItemPool
---@param ctx Context.Common
---@param PoolType ItemPoolType | integer
---@param Seed integer
---@param Flags integer
---@param DefaultItem CollectibleType | integer
---@return CollectibleType | integer
function Stub.GetCollectible(itemPool, ctx, PoolType, Seed, Flags, DefaultItem) end

---@param itemPool Component.ItemPool
---@param ctx Context.Common
---@param DontAdvanceRNG boolean
---@return TrinketType | integer
function Stub.GetTrinket(itemPool, ctx, DontAdvanceRNG) end

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

---@param itemPool Component.ItemPool
---@param ctx Context.Common
---@param PillColor PillColor | integer
---@param Player Component.Entity.Player
---@return PillEffect | integer
function Stub.GetPillEffect(itemPool, ctx, PillColor, Player) end

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

---@param itemPool Component.ItemPool
---@param ID PillEffect | integer
---@return PillColor | integer
function Stub.ForceAddPillEffect(itemPool, ID) end

---@param itemPool Component.ItemPool
---@param ctx Context.Common
---@param pillColor PillColor | integer
---@param seed integer
---@return unknown
function Stub.RerollPillEffect(itemPool, ctx, pillColor, seed) end

---@param itemPool Component.ItemPool
function Stub.ResetRoomBlacklist(itemPool) end

---@param itemPool Component.ItemPool
---@param Add integer
---@param PoolType ItemPoolType | integer
function Stub.AddBibleUpgrade(itemPool, Add, PoolType) end

---@param itemPool Component.ItemPool
---@param ctx Context.Common
---@param rng RNG
---@return integer
function Stub.get_chaos_pool(itemPool, ctx, rng) end

--- one of the args is length, however given how lua arrays work, this is unnecessary
---@param itemPool Component.ItemPool
---@param ctx Context.Common
---@param list (CollectibleType | integer)[]
---@param seed integer
---@param defaultItem CollectibleType | integer
---@param addToBlacklist boolean
---@param excludeLockedItems boolean
---@return CollectibleType | integer
function Stub.GetCollectibleFromList(itemPool, ctx, list, seed, defaultItem, addToBlacklist, excludeLockedItems) end

---@param itemPool Component.ItemPool
---@param ctx Context.Common
---@param seed integer
---@return integer
function Stub.GetCantrippedItemCard(itemPool, ctx, seed) end

---@param itemPool Component.ItemPool
---@return ItemPoolType | integer
function Stub.GetLastPool(itemPool) end

---@param itemPool Component.ItemPool
---@param PillColor PillColor | integer
---@return boolean
function Stub.IsPillIdentified(itemPool, PillColor) end

--#endregion

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
Interface.RemoveCollectible = CollectiblePool.RemoveCollectible
Interface.ResetCollectible = Stub.ResetCollectible
Interface.RemoveTrinket = Stub.RemoveTrinket
Interface.GetCardEx = Stub.GetCardEx
Interface.GetCard = Stub.GetCard
Interface.GetPill = Stub.GetPill
Interface.GetPillEffect = Stub.GetPillEffect
Interface.Init = PoolInit.Init
Interface.load_pools = PoolLoad.LoadPools
Interface.RestoreGameState = Stub.RestoreGameState
Interface.StoreGameState = Stub.StoreGameState
Interface.ResetTrinkets = TrinketPool.ResetTrinkets
Interface.ForceAddPillEffect = Stub.ForceAddPillEffect
Interface.RerollPillEffect = Stub.RerollPillEffect
Interface.ResetRoomBlacklist = Stub.ResetRoomBlacklist
Interface.AddBibleUpgrade = Stub.AddBibleUpgrade
Interface.get_chaos_pool = Stub.get_chaos_pool
Interface.GetCollectibleFromList = Stub.GetCollectibleFromList
Interface.GetCantrippedItemCard = Stub.GetCantrippedItemCard
Interface.GetLastPool = Stub.GetLastPool
Interface.IsPillIdentified = Stub.IsPillIdentified