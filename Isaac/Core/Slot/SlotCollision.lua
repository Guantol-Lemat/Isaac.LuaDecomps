--#region Dependencies

local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")

local ActorSlot = interface("Isaac.Mechanics.ActorSlot")

--#endregion

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param collider Component.Entity.Player
---@param isForced boolean
---@return boolean? ignoreCollision
local function handle_player_collision(slot, ctx, collider, isForced)
    local skip = ActorSlot.CustomHandlePlayerCollision(slot, ctx, collider)
    if skip then return end

    if not ActorSlot.CanInteractWithPlayer(slot) then
        return
    end

    local target = IEntityPlayer.GetEffectTarget(collider)
    if not isForced then
        local payed, ignoreCollision = ActorSlot.PaySlot(slot, ctx, target)
        if not payed then return ignoreCollision end
    end

    IEntity.SetTarget(slot, target)
    ActorSlot.Effects_OnPaySlot(slot, ctx, target)
    ActorSlot.PlayerInteraction(slot, ctx, target, collider)
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param collider Component.Entity
---@param low boolean
---@return boolean skipCollision
local function HandleCollision(slot, ctx, collider, low)
    local isForced = IEntity.IsForcedCollision()

    if collider.m_type == EntityType.ENTITY_PLAYER then
        ---@cast collider Component.Entity.Player
        local ignoreCollision = handle_player_collision(slot, ctx, collider, isForced)
        if not ignoreCollision then
            return false
        end
    end

    local updatePlayerCooldown = slot.m_state ~= SlotState.DESTROYED
        and collider.m_type == EntityType.ENTITY_PLAYER and collider.m_variant == PlayerVariant.PLAYER
    if updatePlayerCooldown then
        slot.m_consecutiveCollisionGraceTimer = 4
    end

    local ignoreCollision = IEntity.IsEnemy(collider) or collider.m_type == EntityType.ENTITY_BOMB
    return ignoreCollision
end

---@class Gameplay.Slot.Collision
local Module = {}

--#region Module

Module.HandleCollision = HandleCollision

--#endregion

return Module