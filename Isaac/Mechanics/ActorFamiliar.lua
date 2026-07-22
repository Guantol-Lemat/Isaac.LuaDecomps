--#region Dependencies

local IEntityList = require("Isaac.Interface.EntityList")

--#endregion

local Switch_TriggerNewRoomTemporaryEffects = {
    [FamiliarVariant.BLOOD_OATH] = Actor_BloodOath.apply_effects,
    [FamiliarVariant.PASCHAL_CANDLE] = Actor_PaschalCandle.apply_effects,
}

---@param entityList Component.EntityList
---@param ctx Context.Common
local function TriggerNewRoom_TemporaryEffects(entityList, ctx)
    local familiars = IEntityList.QueryType(entityList, EntityType.ENTITY_FAMILIAR, -1, -1, true, false)
    for i = 1, #familiars, 1 do
        local familiar = familiars[i]
        local ApplyEffects = Switch_TriggerNewRoomTemporaryEffects[familiar.m_variant]
        ApplyEffects(familiar, ctx)
    end
end

---@class Mechanics.Actor.Familiar
local Module = {}

--#region Module

Module.TriggerNewRoom_TemporaryEffects = TriggerNewRoom_TemporaryEffects

--#endregion

return Module