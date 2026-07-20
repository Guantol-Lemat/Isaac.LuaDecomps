---@class Interface.ItemConfig
local Interface = require("Isaac.Interface.ItemConfig")

---@class Interface.ItemConfig.Item
local Interface_Item = Interface.Item

---@class Interface.ItemConfig.Card
local Interface_Card = Interface.Card

---@class Interface.ItemConfig.PillEffect
local Interface_PillEffect = Interface.PillEffect

local AvailableLogic = require("Isaac.Gameplay.ItemConfig.AvailableLogic")

--#region Stub

local Stub = {}

---@param itemConfig Component.ItemConfig
---@return Component.ItemConfig.PillEffect[]
function Stub.GetPillEffects(itemConfig) end

---@param ctx Context.Common
---@param id integer
---@return Component.ItemConfig.Locust
function Stub.GetLocustConfig(ctx, id) end

---@param itemConfig Component.ItemConfig
---@return unknown
function Stub.GetTrinkets(itemConfig) end

---@param itemConfig Component.ItemConfig
---@return unknown
function Stub.GetCards(itemConfig) end

---@param ctx Context.Common
---@param Collectible integer
---@return boolean
function Stub.IsQuestItem(ctx, Collectible) end

---@param param_1 unknown
---@return unknown
function Stub.parse_item_tags_qqq(param_1) end

---@param itemConfig Component.ItemConfig
function Stub.part_of_Load(itemConfig) end

---@param itemConfig Component.ItemConfig
function Stub.Init(itemConfig) end

---@param itemConfig Component.ItemConfig
function Stub.destructor(itemConfig) end

---@param itemConfig Component.ItemConfig
function Stub.Unload(itemConfig) end

---@param itemConfig Component.ItemConfig
---@param param_1 string
---@param param_2 Component.ModEntry
function Stub.Load(itemConfig, param_1, param_2) end

---@param itemConfig Component.ItemConfig
---@param xmlpath string
---@param modentry Component.ModEntry
function Stub.LoadCostumes(itemConfig, xmlpath, modentry) end

---@param itemConfig Component.ItemConfig
---@param param_1 string
---@param modentry Component.ModEntry
---@return unknown
function Stub.LoadMetadata(itemConfig, param_1, modentry) end

---@param param_1_00 unknown
---@param param_2_00 integer
---@param wisp Component.ItemConfig.Wisp
---@param param_4 unknown
function Stub.LoadWispConfigEntry_qqq(param_1_00, param_2_00, wisp, param_4) end

---@param itemConfig Component.ItemConfig
---@param xmlpath string
---@param modentry Component.ModEntry
function Stub.LoadWispConfig(itemConfig, xmlpath, modentry) end

---@param param_1_00 unknown
---@param param_2_00 integer
---@param locust Component.ItemConfig.Locust
---@param param_4 unknown
function Stub.LoadLocustConfigEntry_qqq(param_1_00, param_2_00, locust, param_4) end

---@param itemConfig Component.ItemConfig
---@param xmlpath string
---@param modentry Component.ModEntry
function Stub.LoadLocustConfig(itemConfig, xmlpath, modentry) end

---@param content BagOfCraftingPickup | integer
---@return integer
function Stub.CraftingRecipeToU64(content) end

---@param itemConfig Component.ItemConfig
---@param xmlpath string
---@param modentry Component.ModEntry
function Stub.LoadCraftingRecipes(itemConfig, xmlpath, modentry) end

---@param itemConfig Component.ItemConfig
---@param param_1 string
---@param param_2 Component.ModEntry
function Stub.LoadPocketItems(itemConfig, param_1, param_2) end

---@param itemConfig Component.ItemConfig
---@param xmlpath string
function Stub.LoadPlayerForms(itemConfig, xmlpath) end

---@param itemConfig Component.ItemConfig
---@param filepath string
---@param mod boolean
function Stub.LoadBombCostumeRules(itemConfig, filepath, mod) end

---@param itemConfig Component.ItemConfig
---@param ctx Context.Common
---@param id CollectibleType | integer
---@return Component.ItemConfig.Item?
function Stub.GetCollectible(itemConfig, ctx, id) end

---@param itemConfig Component.ItemConfig
---@param id TrinketType | integer
---@return Component.ItemConfig.Item?
function Stub.GetTrinket(itemConfig, id) end

---@param itemConfig Component.ItemConfig
---@param id NullItemID | integer
---@return Component.ItemConfig.Item?
function Stub.GetNullItem(itemConfig, id) end

---@param itemConfig Component.ItemConfig
---@param id PillEffect | integer
---@return Component.ItemConfig.PillEffect?
function Stub.GetPillEffect(itemConfig, id) end

---@param itemConfig Component.ItemConfig
---@param SlotId integer
---@return Component.ItemConfig.Card
function Stub.GetCard(itemConfig, SlotId) end

---@param ctx Context.Common
---@param CollectibleID CollectibleType | integer
---@return boolean
function Stub.IsValidCollectible(ctx, CollectibleID) end

---@param ctx Context.Common
---@param Collectible CollectibleType | integer
---@param param_2 integer
---@return boolean
function Stub.IsTaggedCollectible(ctx, Collectible, param_2) end

---@param itemConfig Component.ItemConfig
---@param tags integer
---@return Component.ItemConfig.Item[]
function Stub.GetTaggedItems(itemConfig, tags) end

---@param itemConfig Component.ItemConfig
---@param func function
function Stub.PushItemFilter(itemConfig, func) end

---@param itemConfig Component.ItemConfig
function Stub.PopItemFilter(itemConfig) end

---@param Item Component.ItemConfig.Item
---@return boolean
function Stub.ShouldAddCostumeOnPickup(Item) end

---@param itemConfig Component.ItemConfig
---@return integer
function Stub.lua_get_item_id(itemConfig, item) end

--#endregion

--#region Stub

local Stub_Item = {}

---@param item Component.ItemConfig.Item
---@return boolean
function Stub_Item.IsCollectible(item) end

---@param item Component.ItemConfig.Item
---@param tags integer
---@return boolean
function Stub_Item.HasTags(item, tags) end

---@param item Component.ItemConfig.Item
---@return boolean
function Stub_Item.IsTrinket(item) end

---@return Component.ItemConfig.Item
function Stub_Item.constructor() end

---@param item Component.ItemConfig.Item
---@return boolean
function Stub_Item.IsNull(item) end

---@param item Component.ItemConfig.Item
---@return unknown
function Stub_Item.destructor(item) end

---@param item Component.ItemConfig.Item
---@param ctx Context.Common
---@param param_2 integer
---@return string
function Stub_Item.GetDisplayName(item, ctx, param_2) end

---@param item Component.ItemConfig.Item
---@param ctx Context.Common
---@return string
function Stub_Item.GetDisplayDescription(item, ctx) end

---@param item Component.ItemConfig.Item
---@param ctx Context.Common
---@param flags integer
---@return boolean
function Stub_Item.IsAvailableEx(item, ctx, flags) end

---@param item Component.ItemConfig.Item
---@return boolean
function Stub_Item.TemporaryEffectsAreInstances(item) end

---@param item Component.ItemConfig.Item
---@return integer
function Stub_Item.GetSoulChargeType(item) end

---@param item Component.ItemConfig.Item
---@param ctx Context.Common
---@param ignoreUnlock boolean
---@return boolean
function Stub_Item.IsAvailable(item, ctx, ignoreUnlock) end

--#endregion

--#region Card Stub

local Stub_Card = {}

---@param card Component.ItemConfig.Card
---@return boolean
function Stub_Card.IsCard(card) end

---@param card Component.ItemConfig.Card
---@return boolean
function Stub_Card.IsRune(card) end

---@param card Component.ItemConfig.Card
---@param ctx Context.Common
---@param param_2 integer
---@return string
function Stub_Card.GetDisplayName(card, ctx, param_2) end

---@param card Component.ItemConfig.Card
---@param ctx Context.Common
---@return string
function Stub_Card.GetDisplayDescription(card, ctx) end

--#endregion

Interface.GetPillEffects = Stub.GetPillEffects
Interface.GetLocustConfig = Stub.GetLocustConfig
Interface.GetTrinkets = Stub.GetTrinkets
Interface.GetCards = Stub.GetCards
Interface.IsQuestItem = Stub.IsQuestItem
Interface.parse_item_tags_qqq = Stub.parse_item_tags_qqq
Interface.part_of_Load = Stub.part_of_Load
Interface.Init = Stub.Init
Interface.destructor = Stub.destructor
Interface.Unload = Stub.Unload
Interface.Load = Stub.Load
Interface.LoadCostumes = Stub.LoadCostumes
Interface.LoadMetadata = Stub.LoadMetadata
Interface.LoadWispConfigEntry_qqq = Stub.LoadWispConfigEntry_qqq
Interface.LoadWispConfig = Stub.LoadWispConfig
Interface.LoadLocustConfigEntry_qqq = Stub.LoadLocustConfigEntry_qqq
Interface.LoadLocustConfig = Stub.LoadLocustConfig
Interface.CraftingRecipeToU64 = Stub.CraftingRecipeToU64
Interface.LoadCraftingRecipes = Stub.LoadCraftingRecipes
Interface.LoadPocketItems = Stub.LoadPocketItems
Interface.LoadPlayerForms = Stub.LoadPlayerForms
Interface.LoadBombCostumeRules = Stub.LoadBombCostumeRules
Interface.GetCollectible = Stub.GetCollectible
Interface.GetTrinket = Stub.GetTrinket
Interface.GetNullItem = Stub.GetNullItem
Interface.GetPillEffect = Stub.GetPillEffect
Interface.GetCard = Stub.GetCard
Interface.IsValidCollectible = Stub.IsValidCollectible
Interface.IsTaggedCollectible = Stub.IsTaggedCollectible
Interface.GetTaggedItems = Stub.GetTaggedItems
Interface.PushItemFilter = Stub.PushItemFilter
Interface.PopItemFilter = Stub.PopItemFilter
Interface.ShouldAddCostumeOnPickup = Stub.ShouldAddCostumeOnPickup
Interface.lua_get_item_id = Stub.lua_get_item_id

Interface_Item.IsCollectible = Stub_Item.IsCollectible
Interface_Item.HasTags = Stub_Item.HasTags
Interface_Item.IsTrinket = Stub_Item.IsTrinket
Interface_Item.constructor = Stub_Item.constructor
Interface_Item.IsNull = Stub_Item.IsNull
Interface_Item.destructor = Stub_Item.destructor
Interface_Item.GetDisplayName = Stub_Item.GetDisplayName
Interface_Item.GetDisplayDescription = Stub_Item.GetDisplayDescription
Interface_Item.IsAvailableEx = AvailableLogic.Item_IsAvailableEx
Interface_Item.TemporaryEffectsAreInstances = Stub_Item.TemporaryEffectsAreInstances
Interface_Item.GetSoulChargeType = Stub_Item.GetSoulChargeType
Interface_Item.IsAvailable = AvailableLogic.Item_IsAvailable

Interface_Card.IsCard = Stub_Card.IsCard
Interface_Card.IsRune = Stub_Card.IsRune
Interface_Card.GetDisplayName = Stub_Card.GetDisplayName
Interface_Card.GetDisplayDescription = Stub_Card.GetDisplayDescription
Interface_Card.IsAvailable = AvailableLogic.Card_IsAvailable

Interface_PillEffect.IsAvailable = AvailableLogic.PillEffect_IsAvailable