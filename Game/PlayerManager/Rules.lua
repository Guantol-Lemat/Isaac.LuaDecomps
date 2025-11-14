--#region Dependencies

local PlayerRules = require("Entity.Player.Rules")

--#endregion


---@class PlayerManagerRules
local Module = {}

---@param context Context
---@param manager PlayerManagerComponent
---@param collectibleType CollectibleType
---@return EntityPlayerComponent?
local function FirstCollectibleOwner(context, manager, collectibleType)
end

---@param context Context
---@param manager PlayerManagerComponent
---@param collectibleType CollectibleType
---@return boolean
local function AnyoneHasCollectible(context, manager, collectibleType)
    return not not FirstCollectibleOwner(context, manager, collectibleType)
end

---@param context Context
---@param manager PlayerManagerComponent
---@param trinket TrinketType
---@return EntityPlayerComponent?
local function FirstTrinketOwner(context, manager, trinket)
end

---@param context Context
---@param manager PlayerManagerComponent
---@param trinket TrinketType
---@return boolean
local function AnyoneHasTrinket(context, manager, trinket)
    return not not FirstTrinketOwner(context, manager, trinket)
end

---@param context Context
---@param manager PlayerManagerComponent
---@param trinket TrinketType
---@return integer
local function GetTrinketMultiplier(context, manager, trinket)
end

---@param context Context
---@param manager PlayerManagerComponent
---@param playerType PlayerType | integer
---@return EntityPlayerComponent?
local function FirstBirthrightOwner(context, manager, playerType)    
end

---@param context Context
---@param manager PlayerManagerComponent
---@param player EntityPlayerComponent
---@param other EntityPlayerComponent
local function ReplacePlayer(context, manager, player, other)
end

---@param context Context
---@param manager PlayerManagerComponent
---@param playerType PlayerType | integer
---@return boolean
local function AnyoneHasBirthright(context, manager, playerType)
    return not not FirstBirthrightOwner(context, manager, playerType)
end

---@param context Context
---@param manager PlayerManagerComponent
---@param playerType PlayerType | integer
---@return EntityPlayerComponent
local function SpawnCoPlayer(context, manager, playerType)
end

---@param context Context
---@param manager PlayerManagerComponent
---@param all boolean
---@return boolean
local function HasFullHeartsSoulHearts(context, manager, all)
    local result = all
    local players = manager.m_players
    local numPlayers = #players

    for i = 1, numPlayers, 1 do
        local player = players[i]
        if not player.m_variant == PlayerVariant.PLAYER then
            goto continue
        end

        local hasFullHeartsSoulHearts = (player.m_maxHearts <= player.m_redHearts + player.m_soulHearts) or PlayerRules.HasInstantDeathCurse(context, player)
        if all then
            result = result and hasFullHeartsSoulHearts
        else
            result = result or hasFullHeartsSoulHearts
        end
        ::continue::
    end

    return result
end

---@param context Context
---@param manager PlayerManagerComponent
---@param player EntityPlayerComponent
local function RemoveCoPlayer(context, manager, player)
end

--#region Module

Module.FirstCollectibleOwner = FirstCollectibleOwner
Module.AnyoneHasCollectible = AnyoneHasCollectible
Module.FirstTrinketOwner = FirstTrinketOwner
Module.AnyoneHasTrinket = AnyoneHasTrinket
Module.GetTrinketMultiplier = GetTrinketMultiplier
Module.FirstBirthrightOwner = FirstBirthrightOwner
Module.AnyoneHasBirthright = AnyoneHasBirthright
Module.HasFullHeartsSoulHearts = HasFullHeartsSoulHearts
Module.ReplacePlayer = ReplacePlayer
Module.SpawnCoPlayer = SpawnCoPlayer
Module.RemoveCoPlayer = RemoveCoPlayer

--#endregion

return Module