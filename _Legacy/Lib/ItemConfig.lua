---@class Decomp.Lib.ItemConfig
local Lib_ItemConfig = {}
Decomp.Lib.ItemConfig = Lib_ItemConfig

local Table = require("Lib.Table")

local g_ItemConfig = Isaac.GetItemConfig()

local s_UnusedCollectibles = Table.CreateDictionary({43, 61, 235})

---@param collectible CollectibleType | integer
---@return boolean valid
function Lib_ItemConfig.IsValidCollectible(collectible)
    if not (0 < collectible and collectible < #g_ItemConfig:GetCollectibles()) then
        return false
    end

    return not s_UnusedCollectibles[collectible] and g_ItemConfig:GetCollectible(collectible) ~= nil
end

---@param collectible CollectibleType | integer
---@return boolean itemConfig
function Lib_ItemConfig.IsQuestItem(collectible)
    local collectibleConfig = g_ItemConfig:GetCollectible(collectible)
    return (not not collectibleConfig) and collectibleConfig:HasTags(ItemConfig.TAG_QUEST)
end