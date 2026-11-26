--#region Dependencies

local IEntity = require("Isaac.Interface.Entity")

local ActorSlot = interface("Isaac.Content.ActorSlot")

--#endregion

---@param slot Component.Entity.Slot
---@param offset Vector
local function Render(slot, offset)
    IEntity.Render(slot, offset)

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