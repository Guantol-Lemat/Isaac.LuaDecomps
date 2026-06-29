--#region Dependencies



--#endregion

---@class InventoryContext
local Module = {}

--- shared context for both Collectible and Trinket queries, since they call each other
---@class InventoryContext.SharedCollectibleAndTrinket : PersistentDataContext.Unlocked, ItemConfigContext.GetCollectible
---@field level Component.Level -- Trinket
---@field room Component.Room -- Collectible
---@field persistentGameData Component.PersistentGameData -- Collectible
---@field itemConfig Component.ItemConfig.Item -- Collectible
---@field proceduralItemManager Component.ProceduralItemManager
---@field seeds Component.Seeds -- Collectible
---@field frameCount integer -- Both
---@field challenge Challenge | integer -- Trinket
---@field dailyChallenge Component.DailyChallenge -- Trinket
---@field defaultPlayer Component.Entity.Player? -- Both
---@field forceUnlock boolean

---@class InventoryContext.GetNumCollectibles : InventoryContext.SharedCollectibleAndTrinket

---@class InventoryContext.HasCollectible : InventoryContext.SharedCollectibleAndTrinket

---@class InventoryContext.GetTrinketMultiplier : InventoryContext.SharedCollectibleAndTrinket

--#region Module



--#endregion

return Module