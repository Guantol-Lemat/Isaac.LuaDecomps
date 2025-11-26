--#region Dependencies

local GameUtils = require("Game.Utils")
local EntityUtils = require("Entity.Common.Utils")
local RoomUtils = require("Room.Utils")
local NPCUtils = require("Entity.NPC.Utils")
local Log = require("General.Log")

--#endregion

---@class BossLifecycle
local Module = {}

---@param room RoomComponent
local function Reset(room)
    room.m_bossCount = 0
end

---@param room RoomComponent
---@return integer
local function GetAliveBossesCount(room)
    local entityList = room.m_entityList
    local aliveBosses = entityList.m_addedBosses + entityList.m_bossCount
    return math.max(aliveBosses, 0)
end

---@param room RoomComponent
local function UpdateBossCount(room)
    local aliveBossesCount = GetAliveBossesCount(room)

    if aliveBossesCount <= 0 and room.m_bossCount > 1 then
        Log.LogMessage(0, "[warn] last boss died without triggering the deathspawn.\n")
    end

    room.m_bossCount = aliveBossesCount
end

---@param room RoomComponent
---@param entity EntityNPCComponent
local function TriggerBossSpawn(room, entity)
    if entity then
        room.m_bossCount = room.m_bossCount + 1
    end
end

---@param room RoomComponent
---@param entity EntityNPCComponent
---@return boolean skipTrigger
local function hook_pre_trigger_boss_death(room, entity)
    if entity.m_type == EntityType.ENTITY_BIG_HORN then
        local variant = entity.m_variant
        if variant == 1 or variant == 2 then
            return true
        end
    end

    return false
end

---@param room RoomComponent
---@param entity EntityNPCComponent
local function hook_post_trigger_boss_death(room, entity)
    -- Angel Death Key Spawn
end

---@param room RoomComponent
---@param entity EntityNPCComponent
local function TriggerBossDeath(room, entity)
    if hook_pre_trigger_boss_death(room, entity) then
        return
    end

    if EntityUtils.HasAnyFlag(entity, EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_BOSSDEATH_TRIGGERED) then
        return
    end

    EntityUtils.AddFlags(entity, EntityFlag.FLAG_BOSSDEATH_TRIGGERED)

    if EntityUtils.HasAnyFlag(entity, EntityFlag.FLAG_FRIENDLY) then
        return
    end

    local bossCount = room.m_bossCount - 1
    room.m_bossCount = bossCount

    Log.LogMessage(0, string.format("TriggerBossDeath: %d bosses remaining.\n", bossCount))

    if bossCount <= 0 then
        if NPCUtils.IsMiniboss(entity) then
            miniboss_deathspawn(room, entity)
        else
            boss_deathspawn(room, entity)
        end
    end

    hook_post_trigger_boss_death(room, entity)
end

--#region Module

Module.Reset = Reset
Module.UpdateBossCount = UpdateBossCount
Module.TriggerBossSpawn = TriggerBossSpawn
Module.TriggerBossDeath = TriggerBossDeath

--#endregion

return Module