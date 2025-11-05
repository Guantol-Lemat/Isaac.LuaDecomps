--#region Dependencies

local Inventory = require("Entity.Player.Inventory.Inventory")

--#endregion

---@class ShellGameLogic
local Module = {}

---@param context Context
---@param slot EntitySlotComponent
---@param player EntityPlayerComponent
local function UpdateDispensePrize(context, slot, player)
    -- Play Animation

    local rng = slot.m_dropRNG
    local luckyFootRNG = player.m_collectibleRNG[CollectibleType.COLLECTIBLE_LUCKY_FOOT]

    local success = rng:RandomInt(3) == 0 or (Inventory.HasCollectible(context, player, CollectibleType.COLLECTIBLE_LUCKY_FOOT, false) and luckyFootRNG:RandomInt(3) == 0)
    if not success then
        -- fly
    end

    -- dispense based on prizeType
end

--#region Module



--#endregion

return Module