---@class EntityRules
local Module = {}

---@param game GameComponent
---@param entity EntityComponent
local function GetFrameCount(game, entity)
    return game.m_frameCount - entity.m_spawnFrame
end

---@param context Context
---@param entity EntityComponent
---@param source EntityRefComponent
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