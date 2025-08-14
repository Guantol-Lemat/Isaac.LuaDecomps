---@class EntityRules
local Module = {}

---@param game GameComponent
---@param entity EntityComponent
local function GetFrameCount(game, entity)
    return game.m_frameCounter - entity.m_spawnFrame
end

--#region Module

Module.GetFrameCount = GetFrameCount

--#endregion

return Module