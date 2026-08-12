--#region Dependencies

local IEntity = require("Isaac.Interface.Entity")

local ActorSlot = interface("Isaac.Mechanics.ActorSlot")

--#endregion

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param offset Vector
local function Render(slot, ctx, offset)
    IEntity.Render(ctx, slot, offset)

    if ActorSlot.IsShellGame(slot) then
        ActorSlot.ShellGame_PostRender(slot)
    end
end

---@class Gameplay.Slot.Render
local Module = {}

--#region Module

Module.Render = Render

--#endregion

return Module