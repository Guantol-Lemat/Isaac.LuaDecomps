--#region Dependencies

local EntityUtils = require("Entity.Utils")

--#endregion

---@param entity Component.Entity.Effect
---@param minRadius number
---@param maxRadius number
local function SetRadii(entity, minRadius, maxRadius)
    entity.m_minRadius = minRadius
    entity.m_maxRadius = maxRadius
end

---@param entity Component.Entity.Effect
---@param timeout integer
local function SetTimeout(entity, timeout)
    entity.m_timeout = timeout
    entity.m_lifeSpan = timeout
end

---@param effect Component.Entity.Effect
---@param parent Component.Entity
local function FollowParent(effect, parent)
    EntityUtils.SetEntityReference(effect.m_parent, parent)
    effect.m_isFollowing = true
    effect.m_parentOffset = effect.m_position - parent.m_position
end

---@class EffectUtils
local Module = {}

--#region Module

Module.SetRadii = SetRadii
Module.SetTimeout = SetTimeout
Module.FollowParent = FollowParent

--#endregion

return Module