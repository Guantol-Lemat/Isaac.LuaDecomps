--#region Dependencies

local EntityUtils = require("Entity.Utils")
local AiUtils = require("Mechanics.NPC.Action.AiUtils")
local RoomGrid = require("Game.Room.Grid")
local NpcPathfinder = require("Mechanics.NPC.Action.Pathfinder")

--#endregion

---@param ctx Context.Common
---@param npc Component.Entity.Npc
local function UpdateAI(ctx, npc)
    local room = ctx.game.m_level.m_room

    npc.m_friction = npc.m_friction * 0.95
    if EntityUtils.IsFrame(ctx, npc, 7, 0) then
        
    end

    local gfx_unk = "WalkVert"
    local gfx_unk1 = "WalkHori"

    !! UNK CALL

    local target_entity = AiUtils.GetPlayerTarget(ctx, npc)
    local target_velocity = target_entity.m_velocity
    local target_position = AiUtils.CalcTargetPosition(ctx, npc, 0.0)

    local unk = (target_velocity * 10.0 + target_position) - npc.m_position
    local hasDirectPath = RoomGrid.CheckLine(ctx, room, npc.m_position, target_position, LineCheckMode.ENTITY, 0, false, false)

    if hasDirectPath then
    else

    end
end

---@class Actor.Enemy.Lust
local Module = {}

--#region Module



--#endregion

return Module