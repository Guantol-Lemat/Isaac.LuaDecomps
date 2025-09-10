--#region Dependencies

local MySprite = require("Actor.Boss.Widow.Sprite")

local Animations = MySprite.Animations
local Events = MySprite.Events

--#endregion

---@class WidowComponent : EntityNPCComponent
---@field m_jumpTargetPosition Vector -- V1

---@class WidoCommonLogic
local Module = {}

---@param widow WidowComponent
local function update_jump_physics(widow)
    local sprite = widow.m_sprite
    if not sprite:WasEventTriggered(Events.JUMP) then
        return
    end

    if sprite:WasEventTriggered(Events.LAND) then
        return
    end

    local friction = widow.m_friction
    widow.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    widow.m_gridCollisionClass = GridCollisionClass.COLLISION_SOLID

    if friction ~= 0.0 then
        widow.m_velocity = widow.m_velocity + (widow.m_timescale * widow.m_jumpTargetPosition / friction)
    end

    widow.m_friction = friction * 0.9
end

---@param widow WidowComponent
local function update_state_jump(widow)
    local sprite = widow.m_sprite
    sprite:Play(Animations.JUMP, false)

    -- update_jump_visual_sugar
    update_jump_physics(widow)

    if sprite:IsFinished("") then
        widow.m_state = 4
        sprite.PlaybackSpeed = 1.0
    end
end

--#region Module



--#endregion

return Module