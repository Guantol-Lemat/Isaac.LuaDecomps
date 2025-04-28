local super = require("Entity.Entity")

---@class Decomp.Object.EntityEffect : Decomp.Class.EntityEffect.Data, Decomp.Class.EntityEffect.API

---@class Decomp.Class.EntityEffect.Data : Decomp.Class.Entity.Data
---@field object EntityEffect

---@param entityData Decomp.Class.EntityEffect.Data
local function should_save(entityData)
    local entity = entityData.object

    if not (entity.Variant == EffectVariant.HEAVEN_LIGHT_DOOR and entity.SubType == 1) then
        return true
    end

    if entity.State < 0 then
        return false
    end

    if entity.SpawnerType ~= 0 then
        return false
    end

    return super.should_save(entityData)
end