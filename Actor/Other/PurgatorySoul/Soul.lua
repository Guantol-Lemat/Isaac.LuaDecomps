--#region Dependencies

local EntityUtils = require("Entity.Common.Utils")
local EffectUtils = require("Entity.Effect.Utils")
local SpawnLogic = require("Game.Spawn")

--#endregion

---@class PurgatorySoul.SoulLogic
local Module = {}

---@param context Context
---@param entity EntityEffectComponent
local function setup_trail(context, entity)
    local seed = context:Random()
    local trail = SpawnLogic.Spawn(context, EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, seed, entity.m_position, Vector(0, 0), entity)
    local trailEffect = EntityUtils.ToEffect(trail)
    assert(trailEffect, "Could not convert effect ToEffect")

    local sprite = trail.m_sprite
    sprite.Color = Color(1.0, 0.8, 0.8, 0.3)

    local scale = 2.0 * entity.m_sprite.Scale.X
    sprite.Scale = Vector(1, 1) * scale

    EffectUtils.SetRadii(trailEffect, 0.15, 0.15)
    EntityUtils.SetParent(trail, entity)
    trail:Update(context)
    EntityUtils.SetChild(entity, trail)
end

local function Update()
end

--#region Module



--#endregion

return Module