--#region Dependencies

local EntityUtils = require("Entity.Utils")
local MySprite = require("Actor.Boss.Widow.Sprite")

local Animations = MySprite.Animations
local Events = MySprite.Events

--#endregion

---@class WidowComponent : EntityNPCComponent
---@field m_jumpVelocity Vector -- V1

---@class WidoCommonLogic
local Module = {}

---@param widow WidowComponent
---@param targetPosition Vector
local function init_state_jump(widow, targetPosition)
    widow.m_state = 6
    widow.m_stateFrame = 0

    -- I1 = 0
    widow.m_friction = widow.m_friction * 0.7

    local distance = targetPosition - widow.m_position
    distance:Normalize()
    widow.m_jumpVelocity = distance * 7.0
end

---@param widow WidowComponent
local function update_jump_physics(widow)
    local sprite = widow.m_sprite
    if not sprite:WasEventTriggered(Events.JUMP) then
        return
    end

    if sprite:WasEventTriggered(Events.LAND) then
        return
    end

    widow.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    widow.m_gridCollisionClass = GridCollisionClass.COLLISION_SOLID

    EntityUtils.AddVelocity(widow, widow.m_jumpVelocity, false)

    widow.m_friction = widow.m_friction * 0.9
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