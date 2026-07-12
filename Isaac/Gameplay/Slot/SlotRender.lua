--#region Dependencies

local IEntity = require("Isaac.Interface.Entity")

local Actor_ShellGame = require("Isaac.Actor.Slot.ShellGame")

--#endregion

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param offset Vector
local function Render(slot, ctx, offset)
    IEntity.Render(ctx, slot, offset)

    local variant = slot.m_variant
    local isShellGame = variant == SlotVariant.SHELL_GAME or variant == SlotVariant.HELL_GAME
    if isShellGame then
        Actor_ShellGame.PostRender(slot)
    end
end

---@class Gameplay.Slot.Render
local Module = {}

--#region Module

Module.Render = Render

--#endregion

return Module