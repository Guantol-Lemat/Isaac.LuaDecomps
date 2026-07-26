---@class EntityRules
local Module = {}

---@param game Component.Game
---@param entity Component.Entity
local function GetFrameCount(game, entity)
    return game.m_frameCount - entity.m_spawnFrame
end

---@param context Context
---@param entity Component.Entity
---@param source Component.EntityRef
---@param duration integer
---@param slowValue number
---@param slowColor Color
local function AddSlowing(context, entity, source, duration, slowValue, slowColor)

end

--#region Module

Module.GetFrameCount = GetFrameCount
Module.AddSlowing = AddSlowing

--#endregion

return Module