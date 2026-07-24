--#region Dependencies

local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local ActorFamiliar = require("Isaac.Interface.Custom.ActorFamiliar")

--#endregion

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
local function InitPostLevelInitStats(playerManager, ctx)
    local players = playerManager.m_players
    for i = 1, players, 1 do
        local player = players[i]
        if player.m_variant == PlayerVariant.PLAYER then
            IEntityPlayer.InitPostLevelInitStats(player, ctx)
        end
    end
end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
local function TriggerNewRoom_TemporaryEffects(playerManager, ctx)
    local players = playerManager.m_players
    for i = 1, players, 1 do
        local player = players[i]
        IEntityPlayer.TriggerNewRoom_TemporaryEffects(player, ctx)
    end

    ActorFamiliar.TriggerNewRoom_TemporaryEffects(ctx.game.m_level.m_room.m_entityList, ctx)
end

---@class Gameplay.PlayerManager.Misc
local Module = {}

--#region Module

Module.InitPostLevelInitStats = InitPostLevelInitStats
Module.TriggerNewRoom_TemporaryEffects = TriggerNewRoom_TemporaryEffects

--#endregion

return Module