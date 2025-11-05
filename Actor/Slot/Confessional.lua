--#region Dependencies

local Inventory = require("Entity.Player.Inventory.Inventory")

--#endregion

---@class ConfessionalLogic
local Module = {}

---@param context Context
---@param slot EntitySlotComponent
---@param player EntityPlayerComponent
local function UpdateOnTimeoutEnd(context, slot, player)
    -- if playing wiggle

    local game = context:GetGame()
    local rng = slot.m_dropRNG
    local prizeChance = game.m_difficulty == Difficulty.DIFFICULTY_HARD and 0.25 or 0.3

    if Inventory.HasCollectible(context, player, CollectibleType.COLLECTIBLE_LUCKY_FOOT, false) then
        prizeChance = prizeChance * 1.5
    end

    local random = rng:RandomFloat()
    if random < prizeChance then
        -- play prize animation
    else
        -- play no prize animation
    end

    -- determine prize
end

--#region Module



--#endregion

return Module