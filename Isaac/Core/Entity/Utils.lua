--#region Dependencies

local IsaacUtils = require("Isaac.Utils.Common")

--#endregion

---@param entity Component.Entity
---@param offset Vector
local function InitScreenPosition(entity, offset)
    entity.m_screenPosition = IsaacUtils.GetRenderPosition(entity.m_position + entity.m_positionOffset, true) + offset
end

---@class Entity.Utils
local Module = {}

--#region Module

Module.InitScreenPosition = InitScreenPosition

--#endregion

return Module