--#region Dependencies

local IEntity = require("Isaac.Interface.Entity")

local ActorSlot = interface("Isaac.Mechanics.ActorSlot")

--#endregion

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param entityType EntityType | integer
---@param variant integer
---@param subType integer
---@param seed integer
local function Init(slot, ctx, entityType, variant, subType, seed)
    variant = ActorSlot.Effects_SelectSlotType(ctx, variant)

    IEntity.Init(slot, ctx, entityType, variant, subType, seed)

    local myConfig = slot.m_config
    if myConfig then
        local mySprite = slot.m_sprite
        mySprite:Load(myConfig.anm2Path, true)
        mySprite:Play(mySprite:GetDefaultAnimation(), false)
    end

    slot.m_targetPosition = Vector(0, 0)
    slot.m_positionOffset = Vector(0, 0)
    slot.m_sizeMulti = Vector(1, 1)
    slot.m_donationValue = 0
    slot.m_triggerTimer = 0
    slot.m_consecutiveCollisionGraceTimer = 0
    slot.m_consecutiveCollisionFrames = 0
    slot.m_state = SlotState.IDLE
    slot.m_shellGame_prizeSprite:Reset()
    slot.m_prizeCollectible = CollectibleType.COLLECTIBLE_NULL

    ActorSlot.InitLogic(slot, ctx)

    slot.m_gridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    slot.m_timeout = 0
end

---@class Gameplay.Slot.Init
local Module = {}

--#region Module

Module.Init = Init

--#endregion

return Module