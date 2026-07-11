--#region Dependencies

local IManager = require("Isaac.Interface.Manager")
local IEntity = require("Isaac.Interface.Entity")

--#endregion

local EVENT_GROUND = "Ground"

local SOUND_GROUND = SoundEffect.SOUND_CHEST_DROP

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

Module.PreUpdate = MomsDressingTable_PreUpdate

--#endregion

return Module