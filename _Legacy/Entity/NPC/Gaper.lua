---@class Decomp.Entity.NPC.Gaper
local Gaper = {}
Decomp.Entity.NPC.Gaper = Gaper

Gaper.VARIANT_ROTTEN_GAPER = 3
Gaper.STATE_INIT = 0
Gaper.STATE_4 = 4

---@param npc EntityNPC
---@param damage number
---@param source EntityRef
---@return number newDamage
function Gaper.ApplyTakenDamageModifier(npc, damage, _, source)
    if source.SpawnerType == npc:GetType() then
        return 0.0
    end

    return damage
end

---@param npc EntityNPC
local function ai_rotten_gaper(npc)
end

---@param npc EntityNPC
local function init_gaper(npc)
    local type = npc:GetType()
    npc.State = Gaper.STATE_4
    npc.StateFrame = 0

    if type == EntityType.ENTITY_STONEY then
        -- Todo init_stoney
    end

    -- TODO: -- rest of init
end

---@param npc EntityNPC
local function morph_dead_gaper(npc)
    local subType = (Random() % 3 == 0 and npc.Variant ~= 2) and 1 or 0
    npc:Morph(EntityType.ENTITY_GUSHER, subType, 0, -1)

    npc:SetDead(false)
    npc.HitPoints = npc.MaxHitPoints
    npc.ProjectileCooldown = Random() % 20 + 20
end

---@param npc EntityNPC
local function morph_dead_fatty(npc)
end

local function morph_dead_conjoined_fatty(npc)
    if npc.Variant ~= 0 then
        return
    end


end

---@param npc EntityNPC
local function try_morph_dead_gaper(npc)
    if npc.HitPoints <= -25.0 or (Random() % 2 ~= 0) then
        return
    end

    local type = npc:GetType()
    if type == EntityType.ENTITY_GAPER then
        morph_dead_gaper(npc)
    elseif type == EntityType.ENTITY_FATTY then
        morph_dead_fatty(npc)
    elseif type == EntityType.ENTITY_CONJOINED_FATTY then

    end
end

---@param npc EntityNPC
---@return number speed
local function get_gaper_speed(npc)
    local DEFAULT_SPEED = 0.6

    local type = npc:GetType()
    local variant = npc.Variant

    if type == EntityType.ENTITY_FATTY then
        return variant == 2 and 0.33 or 3
    end

    if type == EntityType.ENTITY_CONJOINED_FATTY then
        return 0.3
    end

    if type == EntityType.ENTITY_STONEY then
        return variant == 10 and 0.48000002 or DEFAULT_SPEED
    end

    if type == EntityType.ENTITY_NULLS then
        return 0.90000004
    end

    if variant == 1 or type == EntityType.ENTITY_CYCLOPIA then
        return 0.498
    end

    if variant == 2 then
        npc:GetSprite():PlayOverlay("Head", false)
        return 0.5478
    end

    if npc:GetSprite():GetOverlayFrame() > 0 then
        return 0.72
    end

    return DEFAULT_SPEED
end

---@param npc EntityNPC
---@param speed number
local function gaper_path_find_chase_player(npc, speed)
    local pathMarker = npc:GetType() == EntityType.ENTITY_STONEY and 100 or 900
    local targetPosition = npc:CalcTargetPosition(0.0)
    npc.Pathfinder:FindGridPath(targetPosition, speed, pathMarker, true)
end

---@param npc EntityNPC
---@param speed number
local function gaper_path_find_evade_player(npc, speed)
    local targetPosition = npc:GetPlayerTarget()
    npc.Pathfinder:EvadeTarget(targetPosition.Position)

    npc.Friction = npc.Friction * 0.8
    local type = npc:GetType()
    if (type == EntityType.ENTITY_FATTY or type == EntityType.ENTITY_CONJOINED_FATTY) and npc.Pathfinder:GetEvadeMovementCountdown() > 0 then
        npc.Friction = npc.Friction * 0.8
    end
end

---@param npc EntityNPC
---@param speed number
local function gaper_path_find(npc, speed)
    if npc:HasEntityFlags(EntityFlag.FLAG_FEAR | EntityFlag.FLAG_SHRINK) then
        gaper_path_find_evade_player(npc, speed)
        return
    end

    gaper_path_find_chase_player(npc, speed)
end

---@param npc EntityNPC
local function animate_gaper(npc)
end

---@param npc EntityNPC
function Gaper.UpdateAI(npc)
    if npc:GetType() == EntityType.ENTITY_GAPER and npc.Variant == Gaper.VARIANT_ROTTEN_GAPER then
        ai_rotten_gaper(npc)
        return
    end

    -- Here the Entity Modifies the damage buffer here directly, instead you should call Gape.ApplyTakenDamageModifier on take damage

    if npc.State == Gaper.STATE_INIT then
        init_gaper(npc)
    end

    -- Some fatty null frame stuff

    if npc.State == Gaper.STATE_INIT then
        return
    end

    if npc:IsDead() then
        try_morph_dead_gaper(npc)
        return
    end

    if npc:GetType() == EntityType.ENTITY_FATTY or npc:GetType() == EntityType.ENTITY_CONJOINED_FATTY then
        
    end

    if npc:GetType() == EntityType.ENTITY_CYCLOPIA and npc.State == 8 then
        
    end

    if npc:GetType() ~= EntityType.ENTITY_STONEY or npc.State ~= 16 then
        npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
    end

    local speed = get_gaper_speed(npc)
    gaper_path_find(npc, speed)

    animate_gaper(npc)
end