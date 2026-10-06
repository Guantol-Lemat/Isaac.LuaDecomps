--#region Dependencies

local C = require("Isaac.Constants")

local ISprite = require("Isaac.Interface.ANM2")
local IRoom = require("Isaac.Interface.Room")

--#endregion

---@param room Component.Room
local function RenderDadsNoteLight(room)
    if not IRoom.IsBackwardsPathEntrance(room) then
        return
    end

    local centerPos = IRoom.GetCenterPos(room)
    local renderPosition = IRoom.WorldToScreenPosition(room, centerPos)

    ISprite.SetScale(room.m_lightGradientSprite, C.VECTOR_ONE)
    ISprite.SetColor(room.m_lightGradientSprite, C.COLOR_MOD_WHITE)
    ISprite.Render(room.m_lightGradientSprite, renderPosition, C.VECTOR_ZERO, C.VECTOR_ZERO)
end

---@class Content.Game.BackwardsPathEntrance
local Module = {}

--#region Module

Module.RenderDadsNoteLight = RenderDadsNoteLight

--#endregion

return Module