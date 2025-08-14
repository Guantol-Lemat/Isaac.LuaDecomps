---@class Decomp.Collectible.Birthright
local Birthright = {}
Decomp.Item.Collectible.Birthright = Birthright

Birthright.COLLECTIBLE_ID = CollectibleType.COLLECTIBLE_BIRTHRIGHT

---@param player EntityPlayer
---@return boolean spoof
function Birthright.SpoofPassiveBelial(player)
    local playerType = player:GetPlayerType()
    return playerType == PlayerType.PLAYER_JUDAS or playerType == PlayerType.PLAYER_BLACKJUDAS
end

---@param player EntityPlayer
---@param lootCount integer
---@return integer newLootCount
function Birthright.ApplySalvageCountModifier(player, lootCount)
    if player:GetPlayerType() ~= PlayerType.PLAYER_CAIN_B then
        return lootCount
    end

    return lootCount * 2
end