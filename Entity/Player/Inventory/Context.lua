--#region Dependencies



--#endregion

---@class InventoryContext
local Module = {}

--- shared context for both Collectible and Trinket queries, since they call each other
---@class InventoryContext.SharedCollectibleAndTrinket : PersistentDataContext.Unlocked, ItemConfigContext.GetCollectible
---@field level LevelComponent -- Trinket
---@field room RoomComponent -- Collectible
---@field persistentGameData PersistentDataComponent -- Collectible
---@field itemConfig ItemConfigComponent -- Collectible
---@field proceduralItemManager ProceduralItemManagerComponent
---@field seeds SeedsComponent -- Collectible
---@field frameCount integer -- Both
---@field challenge Challenge | integer -- Trinket
---@field dailyChallenge DailyChallengeComponent -- Trinket
---@field defaultPlayer EntityPlayerComponent? -- Both
---@field forceUnlock boolean

---@class InventoryContext.GetNumCollectibles : InventoryContext.SharedCollectibleAndTrinket

---@class InventoryContext.HasCollectible : InventoryContext.SharedCollectibleAndTrinket

---@class InventoryContext.GetTrinketMultiplier : InventoryContext.SharedCollectibleAndTrinket

--#region Module



--#endregion

return Module