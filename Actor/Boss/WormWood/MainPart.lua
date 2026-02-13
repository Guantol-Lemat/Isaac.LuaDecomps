---@class MainWormWoodLogic
local Module = {}

local FALLING_SPEED_STEP = 0.2
local BOUNCE_RESTITUTION = 0.4

---@param entity WormWoodComponent
local function update_height_above(entity)
    local fallingStep = entity.m_timeScale * FALLING_SPEED_STEP
    local fallingSpeed = entity.m_fallingSpeed + fallingStep
    entity.m_fallingSpeed = fallingSpeed + fallingStep
    entity.m_height = entity.m_height + fallingSpeed * entity.m_timeScale
end

---@param entity WormWoodComponent
local function update_height_burrowed(entity)
    entity.m_fallingSpeed = 0.0
    entity.m_height = 14.0
end

---@param entity WormWoodComponent
local function perform_bounce(entity)
    entity.m_fallingSpeed = -entity.m_fallingSpeed * BOUNCE_RESTITUTION
    entity.m_height = -8.0
end

---@param context Context
---@param entity WormWoodComponent
local function perform_jump(context, entity)
    -- TODO
    entity.m_fallingSpeed = -8.0
    -- TODO
end

--#region Module



--#endregion

return Module