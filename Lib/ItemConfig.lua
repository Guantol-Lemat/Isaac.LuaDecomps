local Lib = {}
---@class Decomp.Lib.ItemConfig
Lib.ItemConfig = {}
Lib.Table = require("Lib.Table")

local g_ItemConfig = Isaac.GetItemConfig()

local s_UnusedCollectibles = Lib.Table.CreateDictionary({43, 61, 235})

---@param collectible CollectibleType | integer
---@return boolean valid
function Lib.ItemConfig.IsValidCollectible(collectible)
    if not (0 < collectible and collectible < #g_ItemConfig:GetCollectibles()) then
        return false
    end

    return not s_UnusedCollectibles[collectible] and g_ItemConfig:GetCollectible(collectible) ~= nil
end

return Lib.ItemConfig