--#region Dependencies



--#endregion

---@param myContext Context.Common
---@param entity EntityComponent
local function Update(myContext, entity)
    -- TODO

    -- update position physics
    local timeScale = entity.m_timeScale
    local friction = entity.m_friction

    if timeScale ~= 1.0 then
        -- this seems to be an attempt to emulate friction ^ timeScale
        friction = friction / ((friction + timeScale) - friction * timeScale)
    end

    entity.m_friction = entity.m_initialFriction
    local velocity = entity.m_velocity * friction
    entity.m_velocity = velocity

    entity.m_position = entity.m_position + (velocity * timeScale)

    -- TODO
end

local Module = {}

--#region Module



--#endregion

return Module