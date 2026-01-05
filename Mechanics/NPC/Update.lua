--#region Dependencies

local VectorUtils = require("General.Math.VectorUtils")
local EntityUtils = require("Entity.Common.Utils")
local NpcAppear = require("Mechanics.NPC.Appear")

local VectorZero = VectorUtils.VectorZero

--#endregion

---@class NPCUpdateLogic
local Module = {}

---@param room RoomComponent
---@param entity EntityNPCComponent
---@return number
local function get_time_scale(room, entity)
    local timeScale = 1.0
    -- TODO: Room:GetTimescale
    -- TODO: rest of npc timescale logic

    return timeScale
end

---@param context NpcMechanicsContext.Update
---@param npc EntityNPCComponent
local function update_status_effect_sprite(context, npc)
end

---@param context NpcMechanicsContext.Update
---@param npc EntityNPCComponent
local function Update(context, npc)
    local npcRead = npc
    local npcWrite = npc

    if not npcRead.m_exists then
        return
    end

    local room = context.room
    local flags = npcRead.m_flags

    npcWrite.m_timescale = get_time_scale(room, npcRead)
    -- TODO: update_player_crosshair

    if npcRead.m_possessor_controllerIdx == -1 then
        local crosshairPtr = npcWrite.m_possessor_crosshair
        VectorUtils.Assign(npcWrite.m_possessor_aim, VectorZero)
        local crosshair = crosshairPtr.ref

        if crosshair then
            crosshair:Remove(context)
            EntityUtils.SetEntityReference(crosshairPtr, nil)
        end
    end

    local frozen = (flags & EntityFlag.FLAG_ICE_FROZEN) ~= 0
    if frozen then
        -- TODO: Update Frozen
        return
    end

    -- TODO: Update Reverse Strength weakness
    -- TODO: Update UnkEntity (Crack the sky related maybe)
    update_status_effect_sprite(context, npc)

    local pauseTimer = npcRead.m_pauseTimer
    local held = (flags & EntityFlag.FLAG_HELD) ~= 0
    if pauseTimer ~= 0 or held then
        -- TODO: Update pause
        -- this can trigger a return
    end

    local state = npcRead.m_state
    if state == NpcState.STATE_APPEAR then
        NpcAppear.Update(context, npc)
    elseif state == NpcState.STATE_DEATH or NpcState.STATE_UNIQUE_DEATH then
        -- TODO: NpcDeath.Update
    end

    npcRead = npcWrite
    flags = npcRead.m_flags
    state = npcRead.m_state

    -- TODO: Rest of Update
end

--#region Module



--#endregion

return Module