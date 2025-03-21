---@class Decomp.Lib.PlayerManager
local Lib_PlayerManager = {}
Decomp.Lib.PlayerManager = Lib_PlayerManager

local g_Game = Game()

---@param playerType PlayerType | integer
---@param allowedTypes PlayerType[] | integer[]
local function is_any_player_type(playerType, allowedTypes)
    for index, value in ipairs(allowedTypes) do
        if playerType == value then
            return true
        end
    end

    return false
end

---@param playerTypes PlayerType[] | integer[]
---@return boolean allPlayersType
function Lib_PlayerManager.AllPlayersType(playerTypes)
    for i = 0, g_Game:GetNumPlayers() - 1, 1 do
        local player = Isaac.GetPlayer(i)
        if player.Variant == 0 and not player:IsCoopGhost() and not is_any_player_type(player:GetPlayerType(), playerTypes) then
            return false
        end
    end

    return true
end