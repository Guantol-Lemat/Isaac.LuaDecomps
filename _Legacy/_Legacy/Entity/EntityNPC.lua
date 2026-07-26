---@class Decomp.Class.EntityNPC
local Class_EntityNPC = {}
Decomp.Class.EntityNPC = Class_EntityNPC

require("Entity.NPC.Gaper")

local NPC = Decomp.Entity.NPC

local switch_NPCAI = {
    [EntityType.ENTITY_GAPER] = NPC.Gaper.UpdateAI,
    [EntityType.ENTITY_FATTY] = NPC.Gaper.UpdateAI,
    [EntityType.ENTITY_NULLS] = NPC.Gaper.UpdateAI,
    [EntityType.ENTITY_CONJOINED_FATTY] = NPC.Gaper.UpdateAI,
    [EntityType.ENTITY_CYCLOPIA] = NPC.Gaper.UpdateAI,
    [EntityType.ENTITY_STONEY] = NPC.Gaper.UpdateAI,
    [EntityType.ENTITY_WRAITH] = NPC.Gaper.UpdateAI,
}