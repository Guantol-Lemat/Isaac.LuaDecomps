--#region Dependencies

local PlayerUtils = require("Entity.Player.Utils")

--#endregion

---@class PlayerManagerUtils
local Module = {}

---@param playerManager PlayerManagerComponent
---@param index integer
---@return EntityPlayerComponent
local function GetPlayer(playerManager, index)
    local players = playerManager.m_players
    local numPlayers = #players
    assert(numPlayers > 0, "Player Manager must always have at least one player")

    if numPlayers >= index then
        index = 0
    end

    return players[index + 1]
end

---@param playerManager PlayerManagerComponent
---@return integer
local function GetNumCoins(playerManager)
    return GetPlayer(playerManager, 0).m_numCoins
end

---@param playerManager PlayerManagerComponent
---@return integer
local function GetNumKeys(playerManager)
    return GetPlayer(playerManager, 0).m_numKeys
end

---@param playerManager PlayerManagerComponent
---@return boolean
local function IsCoopPlay(playerManager)
    local players = playerManager.m_players
    local numPlayers = #players
    if #numPlayers < 2 then
        return false
    end

    local playerCount = 0
    for i = 1, numPlayers, 1 do
        local player = players[i]
        if player.m_variant == PlayerVariant.PLAYER and PlayerUtils.IsMainPlayerCharacter(player) then
            playerCount = playerCount + 1
        end
    end

    return playerCount > 1
end

---@param playerManager PlayerManagerComponent
local function ReviveCoopPlayers(playerManager)

end

---@param playerManager PlayerManagerComponent
---@return number
local function GetNumCoopPlayers(playerManager)
    local players = playerManager.m_players
    local numPlayers = #players
    local playerCount = 0
    for i = 1, numPlayers, 1 do
        local player = players[i]
        if player.m_variant == PlayerVariant.PLAYER and PlayerUtils.IsMainPlayerCharacter(player) and not player.m_isCoopGhost then
            playerCount = playerCount + 1
        end
    end

    return playerCount
end

---@param playerManager PlayerManagerComponent
---@param playerType PlayerType | integer
---@return EntityPlayerComponent?
local function FirstPlayerByType(playerManager, playerType)
    local players = playerManager.m_players
    local numPlayers = #players
    for i = 1, numPlayers, 1 do
        local player = players[i]
        if player.m_variant == PlayerVariant.PLAYER and player.m_playerType == playerType then
            return player
        end
    end

    return nil
end

---@param playerManager PlayerManagerComponent
---@param playerType PlayerType | integer
---@return boolean
local function AnyoneIsPlayerType(playerManager, playerType)
    return not not FirstPlayerByType(playerManager, playerType)
end

---@param myContext InventoryContext.HasCollectible
---@param manager PlayerManagerComponent
---@param collectibleType CollectibleType
---@return EntityPlayerComponent?
local function FirstCollectibleOwner(myContext, manager, collectibleType)
end

---@param myContext InventoryContext.HasCollectible
---@param manager PlayerManagerComponent
---@param collectibleType CollectibleType
---@return boolean
local function AnyoneHasCollectible(myContext, manager, collectibleType)
    return not not FirstCollectibleOwner(myContext, manager, collectibleType)
end

---@param myContext InventoryContext.GetTrinketMultiplier
---@param manager PlayerManagerComponent
---@param trinket TrinketType
---@return integer
local function GetTrinketMultiplier(myContext, manager, trinket)
end

---@param myContext InventoryContext.GetTrinketMultiplier
---@param manager PlayerManagerComponent
---@param trinket TrinketType
---@return EntityPlayerComponent?
local function FirstTrinketOwner(myContext, manager, trinket)
end

---@param myContext InventoryContext.GetTrinketMultiplier
---@param manager PlayerManagerComponent
---@param trinket TrinketType
---@return boolean
local function AnyoneHasTrinket(myContext, manager, trinket)
    return not not FirstTrinketOwner(myContext, manager, trinket)
end

---@param myContext InventoryContext.HasCollectible
---@param manager PlayerManagerComponent
---@param playerType PlayerType | integer
---@return EntityPlayerComponent?
local function FirstBirthrightOwner(myContext, manager, playerType)
end

---@param myContext InventoryContext.HasCollectible
---@param manager PlayerManagerComponent
---@param playerType PlayerType | integer
---@return boolean
local function AnyoneHasBirthright(myContext, manager, playerType)
    return not not FirstBirthrightOwner(myContext, manager, playerType)
end

---@param manager PlayerManagerComponent
---@param all boolean
---@return boolean
local function HasFullHeartsSoulHearts(manager, all)
    local result = all
    local players = manager.m_players
    local numPlayers = #players

    for i = 1, numPlayers, 1 do
        local player = players[i]
        if player.m_variant ~= PlayerVariant.PLAYER then
            goto continue
        end

        local hasFullHeartsSoulHearts = (player.m_maxHearts <= player.m_redHearts + player.m_soulHearts) or PlayerUtils.HasInstantDeathCurse(player)
        if all then
            result = result and hasFullHeartsSoulHearts
        else
            result = result or hasFullHeartsSoulHearts
        end
        ::continue::
    end

    return result
end

--#region Module

Module.GetPlayer = GetPlayer
Module.GetNumCoins = GetNumCoins
Module.GetNumKeys = GetNumKeys
Module.IsCoopPlay = IsCoopPlay
Module.GetNumCoopPlayers = GetNumCoopPlayers
Module.ReviveCoopPlayers = ReviveCoopPlayers
Module.FirstPlayerByType = FirstPlayerByType
Module.AnyoneIsPlayerType = AnyoneIsPlayerType
Module.FirstCollectibleOwner = FirstCollectibleOwner
Module.GetTrinketMultiplier = GetTrinketMultiplier
Module.AnyoneHasCollectible = AnyoneHasCollectible
Module.FirstTrinketOwner = FirstTrinketOwner
Module.AnyoneHasTrinket = AnyoneHasTrinket
Module.FirstBirthrightOwner = FirstBirthrightOwner
Module.AnyoneHasBirthright = AnyoneHasBirthright
Module.HasFullHeartsSoulHearts = HasFullHeartsSoulHearts

--#endregion

return Module