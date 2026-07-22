--#region Dependencies

local IHud = require("Isaac.Interface.HUD")
local IRoom = require("Isaac.Interface.Room")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")

--#endregion

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param seed integer
local function init_special_baby_selection(playerManager, ctx, seed)
    -- TODO
end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param playerType PlayerType | integer
---@param seed integer
local function Init(playerManager, ctx, playerType, seed)
    playerManager.m_rng = RNG(seed, 34)
    playerManager.m_startPlayerType = playerType

    local playerList = playerManager.m_players
    if #playerList == 0 then
        local newPlayer = IEntityPlayer.New(ctx)
        newPlayer.m_playerIndex = #playerList
        newPlayer.m_gameStatePlayerIdx = 0
        table.insert(playerList, newPlayer)
    end

    local player = playerList[1]
    player:Init(ctx, EntityType.ENTITY_PLAYER, PlayerVariant.PLAYER, playerType, seed)
    player.m_position = Vector(320.0, 400.0)

    if not player.m_valid then
        IRoom.AddEntity(ctx.game.m_level.m_room, ctx, player)
    end

    for i = 1, 4, 1 do
        local slot = playerManager.m_playerSlots[i]
        slot.m_controllerIdx = -1
        slot.field0x4 = 0
        slot.field0x8 = -1
        slot.field0xc = 0
    end

    playerManager.m_notifyDeadPlayer = nil
    init_special_baby_selection(playerManager, ctx, seed)
    IHud.AssignPlayerHUDs(ctx.game.m_hud, ctx)
end

---@class Gameplay.PlayerManager.Init
local Module = {}

--#region Module

Module.Init = Init

--#endregion

return Module