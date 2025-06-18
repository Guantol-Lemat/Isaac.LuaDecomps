local super = require("Entity.Entity")

---@class Decomp.Object.EntityEffect : Decomp.EntityEffectObject, Decomp.Object.Entity
---@field m_State integer
---@field m_FScale number
---@field m_RadiusMin number
---@field m_RadiusMax number
---@field m_Timeout integer
---@field m_HitList Decomp.HitListObject
---@field m_VarData any

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