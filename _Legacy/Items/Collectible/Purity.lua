---@class Decomp.Collectible.Purity
local Purity = {}
Decomp.Item.Collectible.Purity = Purity

---@param player EntityPlayer
---@return number addition
function Purity.GetTearsUp(player)
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_PURITY, false) then
        return 0.0
    end

    return player:GetPurityState() == PurityState.BLUE and 2.0 or 0.0
end