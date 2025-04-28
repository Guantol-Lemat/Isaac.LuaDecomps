local super = require("Entity.Entity")

---@class Decomp.Object.EntityBomb : Decomp.Class.EntityBomb.Data, Decomp.Class.EntityBomb.API

---@class Decomp.Class.EntityBomb.Data : Decomp.Class.Entity.Data
---@field object EntityBomb

---@param entityData Decomp.Class.EntityBomb.Data
local function should_save_bomb(entityData)
    local entity = entityData.object
    if not entity.Visible then
        return false
    end

    return super.should_save(entityData)
end