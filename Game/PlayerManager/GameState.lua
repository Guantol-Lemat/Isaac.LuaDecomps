--#region Dependencies

local PlayerLifecycle = require("Game.PlayerManager.Lifecycle")
local PlayerPersistence = require("Entity.Player.GameState.Persistence")
local EntityUtils = require("Entity.Common.Utils")

--#endregion

--- Ties each GameState playerIdx to an actual EntityPlayer
---@param playerManager PlayerManagerComponent
---@param gameState GameStateComponent
---@param manageLifecycle boolean
---@return table<integer, EntityPlayerComponent>
local function compute_player_state_map(playerManager, gameState, manageLifecycle)
    ---@type table<integer, EntityPlayerComponent>
    local playerStateMap = {}

    ---@type EntityPlayerComponent[]
    local playerList = {}
    local players = playerManager.m_players
    for i = 1, #players, 1 do
        local player = players[i]
        if player.m_variant == PlayerVariant.PLAYER then
            table.insert(playerList, player)
        end
    end

    local playersState = gameState.m_players
    for i = 1, gameState.m_playerCount, 1 do
        local playerState = playersState[i]
        if playerState.m_backupOwnerIdx ~= 0 then -- skip if backup player
            goto continue
        end

        local controllerIndex = playerState.m_controllerIdx
        for j = 1, #playerList, 1 do
            local player = playerList[j]
            if player.m_controllerIndex == controllerIndex then
                playerStateMap[i] = player
                table.remove(playerList, j)
                break
            end
        end
        ::continue::
    end

    if manageLifecycle then
        -- remove non associated players
        for i = 1, #playerList, 1 do
            PlayerLifecycle.RemoveCoPlayer(playerManager, playerList[i])
        end

        -- spawn non associated player states
        for i = 1, gameState.m_playerCount, 1 do
            local playerState = playersState[i]
            if playerState.m_backupOwnerIdx ~= 0 or playerStateMap[i] then -- skip if backup player or there is an associated player
                goto continue
            end

            local player = PlayerLifecycle.SpawnCoPlayer(playerManager, playerState.m_playerType)
            playerStateMap[i] = player
            ::continue::
        end
    end

    return playerStateMap
end

local function restore_backup_relation()
end

local function restore_parent_relation()
end

local TWIN_PLAYERS = {
    [PlayerType.PLAYER_JACOB] = PlayerType.PLAYER_ESAU,
    [PlayerType.PLAYER_LAZARUS_B] = PlayerType.PLAYER_LAZARUS2_B,
    [PlayerType.PLAYER_THEFORGOTTEN_B] = PlayerType.PLAYER_THESOUL_B,
    [PlayerType.PLAYER_LAZARUS2_B] = PlayerType.PLAYER_LAZARUS2,
}

---@param gameState GameStateComponent
---@param playerStateMap table<integer, EntityPlayerComponent>
---@param index integer
local function try_restore_twin_relation(gameState, playerStateMap, index)
    local player = playerStateMap[index]
    local twinPlayerType = TWIN_PLAYERS[player.m_playerType]
    if not twinPlayerType then
        return
    end

    local controllerIndex = player.m_controllerIndex
    for i = index + 1, gameState.m_playerCount, 1 do
        local twin = playerStateMap[i]
        if twin and twin.m_playerType == twinPlayerType and twin.m_controllerIndex and controllerIndex and not twin.m_twinPlayer.ref then
            EntityUtils.SetEntityReference(player.m_twinPlayer, twin)
            EntityUtils.SetEntityReference(twin.m_twinPlayer, player)
            -- the loop does not break
        end
    end
end

---@param playerManager PlayerManagerComponent
---@param gameState GameStateComponent
local function RestoreGameState(playerManager, gameState)
    local playerStateMap = compute_player_state_map(playerManager, gameState, true)

    local playersState = gameState.m_players
    for i = 1, gameState.m_playerCount, 1 do
        local playerState = playersState[i]
        local player = playerStateMap[i]

        if player then
            EntityUtils.SetEntityReference(player.m_twinPlayer, nil)
            PlayerPersistence.RestoreGameState(player, playerState)
        end
    end

    for i = 1, gameState.m_playerCount, 1 do
        local playerState = playersState[i]

        if playerState.m_backupOwnerIdx ~= 0 then
            -- TODO: Restore Backup player
        elseif playerState.m_parentIdx >= 0 then
            -- TODO: Restore PlayerParenthood
        elseif playerStateMap[i] then
            try_restore_twin_relation(gameState, playerStateMap, i)
        end
    end
end

local Module = {}

--#region Module

Module.RestoreGameState = RestoreGameState

--#endregion

return Module