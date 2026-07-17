---@class Component.Entity.Slot : Component.Entity
---@field m_state SlotState | integer : 0x360
---@field m_prizeType integer : 0x364
---@field m_shellGame_shellIndex integer : 0x368
---@field m_timeout integer : 0x36a
---@field m_donationValue integer : 0x36c
---@field m_triggerTimer integer : 0x370
---@field m_consecutiveCollisionGraceTimer integer : 0x374
---@field m_consecutiveCollisionFrames integer : 0x376
---@field m_shellGame_prizeSprite Sprite : 0x378
---@field m_prizeCollectible CollectibleType | integer : 0x48c

local IEntity = require("Isaac.Interface.Entity")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")

local NOT_INITIALIZED_INT = 0

---@param entity Component.Entity
local function init_virtual_functions(entity)
    entity.Init = IEntitySlot.Init
    entity.Update = IEntitySlot.Update
    entity.Render = IEntitySlot.Render
    entity.TakeDamage = IEntitySlot.TakeDamage
    entity.HandleCollision = IEntitySlot.handle_collision
end

---@return Component.Entity.Slot
local function New()
    local entity = IEntity.New()
    ---@cast entity Component.Entity.Slot

    init_virtual_functions(entity)

    entity.m_state = NOT_INITIALIZED_INT
    entity.m_prizeType = NOT_INITIALIZED_INT
    entity.m_shellGame_shellIndex = NOT_INITIALIZED_INT
    entity.m_timeout = NOT_INITIALIZED_INT
    entity.m_donationValue = NOT_INITIALIZED_INT
    entity.m_triggerTimer = NOT_INITIALIZED_INT
    entity.m_consecutiveCollisionGraceTimer = NOT_INITIALIZED_INT
    entity.m_consecutiveCollisionFrames = NOT_INITIALIZED_INT
    entity.m_shellGame_prizeSprite = Sprite()
    entity.m_prizeCollectible = NOT_INITIALIZED_INT

    return entity
end

---@class Module.Entity.SlotComponent
local Module = {
    New = New
}

return Module