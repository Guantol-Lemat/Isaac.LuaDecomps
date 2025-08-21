---@class EffectUtils
local Module = {}

---@param entity EntityEffectComponent
---@param minRadius number
---@param maxRadius number
local function SetRadii(entity, minRadius, maxRadius)
    entity.m_minRadius = minRadius
    entity.m_maxRadius = maxRadius
end

--#region Module

Module.SetRadii = SetRadii

--#endregion

return Module