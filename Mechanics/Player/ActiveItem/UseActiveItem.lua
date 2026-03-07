--#region Dependencies

local PlayerUtils = require("Entity.Player.Utils")
local LuaCallbacks = require("LuaEngine.Callbacks")
local ItemConfigUtils = require("Isaac.ItemConfig.Utils")
local ProceduralEffects = require("Mechanics.Game.ProceduralItems.Effects")

--#endregion

---@class Player.UseActiveItem.Closure
---@field COLLECTIBLE_TYPE CollectibleType | integer
---@field USE_FLAGS UseFlag | integer
---@field ACTIVE_SLOT ActiveSlot | integer
---@field CUSTOM_VAR_DATA integer
---@field ANIMATION_ENABLED boolean
---@field CAN_REMOVE boolean
---@field ALLOW_WISP_SPAWN boolean
---@field animate boolean
---@field remove boolean

---@alias Player.UseActiveItem.Signature fun(closure: Player.UseActiveItem.Closure, myContext: Context.Common, player: EntityPlayerComponent)

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param collectible CollectibleType | integer
---@param useFlags UseFlag | integer
---@param activeSlot ActiveSlot | integer
---@param customVarData integer
---@return integer resultFlags
local function UseActiveItem(myContext, player, collectible, useFlags, activeSlot, customVarData)
    local resultFlags

    if collectible == CollectibleType.COLLECTIBLE_NULL then
        resultFlags = 1
        return resultFlags
    end

    local rng = PlayerUtils.GetCollectibleRNG(player, collectible)
    local override = LuaCallbacks.PreUseItem(collectible, rng, player, useFlags, activeSlot, customVarData)
    if override then
        resultFlags = 1
        return resultFlags
    end

    local animationFlagEnabled = (useFlags & UseFlag.USE_NOANIM) == 0
    local allowNoMain = (useFlags & UseFlag.USE_ALLOWNONMAIN) ~= 0
    local costumeAllowed = (useFlags & UseFlag.USE_NOCOSTUME) == 0
    local canRemove = (useFlags & (UseFlag.USE_OWNED | UseFlag.USE_VOID)) ~= 0

    if player.m_variant == PlayerVariant.PLAYER and not player.m_usedByDischargeActiveItem then
        local players = myContext.game.m_playerManager.m_players
        for i = 1, #players, 1 do
            local foundSoul = players[i]
            if foundSoul.m_variant == PlayerVariant.FOUND_SOUL then
                UseActiveItem(myContext, foundSoul, collectible, 0, -1, 0)
            end
        end
    end

    collectible = collectible == CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE and CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL or collectible
    local itemConfig = myContext.manager.m_itemConfig
    local config = ItemConfigUtils.GetCollectible(myContext, itemConfig, collectible)

    local animationEnabled = player.m_variant == PlayerVariant.PLAYER and animationFlagEnabled
    local allowWispSpawn = animationEnabled and (useFlags & UseFlag.USE_ALLOWWISPSPAWN) ~= 0

    -- procedural items
    if collectible < CollectibleType.COLLECTIBLE_NULL then
        if animationEnabled then
            -- AnimateCollectible(player, collectible, "UseItem", "PlayerPickupSparkle")
        end

        ProceduralEffects.TriggerEffects(myContext, collectible, player, 0, nil, player.m_position, player.m_aimDirection)
    end

    -- TODO: run use active item 

    -- TODO: Post use active item
end

local Module = {}

--#region Module

Module.UseActiveItem = UseActiveItem

--#endregion

return Module