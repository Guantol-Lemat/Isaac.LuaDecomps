--#region Dependencies

local EntityUtils = require("Entity.Utils")

--#endregion

---@param entity EntityEffectComponent
---@param minRadius number
---@param maxRadius number
local function SetRadii(entity, minRadius, maxRadius)
    entity.m_minRadius = minRadius
    entity.m_maxRadius = maxRadius
end

---@param effect EntityEffectComponent
---@param parent EntityComponent
local function FollowParent(effect, parent)
    EntityUtils.SetEntityReference(effect.m_parent, parent)
    effect.m_isFollowing = true
    effect.m_parentOffset = effect.m_position - parent.m_position
end

---@class EffectUtils
local Module = {}

--#region Module

Module.SetRadii = SetRadii
Module.FollowParent = FollowParent

--#endregion

return Module