--#region Dependencies

local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local ITemporaryEffects = require("Isaac.Interface.TemporaryEffects")

--#endregion

---@param player Component.Entity.Player
---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
local function TriggerDeviDealTaken(player, ctx, pickup)
    ---@type Component.Entity.Effect?
    ---@diagnostic disable-next-line: assign-type-mismatch
    local redemption_entity = player.m_redemption_effect.ref
    if not redemption_entity then
        return
    end

    local redemption_temporaryEffect = ITemporaryEffects.GetCollectibleEffect(player.m_temporaryEffects, CollectibleType.COLLECTIBLE_REDEMPTION)
    local activeRedemption = redemption_temporaryEffect ~= nil
        and redemption_temporaryEffect.m_count == 1

    if activeRedemption then
        ITemporaryEffects.AddCollectibleEffect(player.m_temporaryEffects, ctx, CollectibleType.COLLECTIBLE_REDEMPTION, true, 1)
        redemption_entity.m_state = 1
    end
end

---@class Mechanics.PlayerEffects.Redemption
local Module = {}

--#region Module

Module.TriggerDeviDealTaken = TriggerDeviDealTaken

--#endregion

return Module