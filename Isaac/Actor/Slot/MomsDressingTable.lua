--#region Dependencies

local IManager = require("Isaac.Interface.Manager")
local IEntity = require("Isaac.Interface.Entity")

--#endregion

local ANIMATION_IDLE = "Idle"
local ANIMATION_APPEAR = "Appear"

local EVENT_GROUND = "Ground"

local SOUND_GROUND = SoundEffect.SOUND_CHEST_DROP

---@type Slot.Switch.Init
local function MomsDressingTable_Init(slot, ctx)
    slot.m_sizeMulti = Vector(1.5, 0.75)
    local appear = ctx.game.m_level.m_room.m_isFirstVisit
    if appear then
        slot.m_sprite:Play(ANIMATION_APPEAR, false)
        slot.m_visible = false
    else
        slot.m_sprite:Play(ANIMATION_IDLE, false)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function MomsDressingTable_PreUpdate(slot, ctx)
    if IEntity.GetFrameCount(ctx, slot) > 1 then
        slot.m_visible = true
        if slot.m_sprite:IsEventTriggered(EVENT_GROUND) then
            IManager.PlaySound(ctx, SOUND_GROUND, 1.0, 2, false, 1.0)
        end
    end
end

---@class Actor.MomsDressingTable
local Module = {}

--#region Module

Module.Init = MomsDressingTable_Init
Module.PreUpdate = MomsDressingTable_PreUpdate

--#endregion

return Module