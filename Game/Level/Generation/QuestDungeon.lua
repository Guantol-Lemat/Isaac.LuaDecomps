--#region Dependencies



--#endregion

---@class QuestDungeonGenerationLogic
local Module = {}

---@param myContext LevelGenerationContext.GenerateMirrorWorld
---@param level LevelComponent
local function GenerateMirrorWorld(myContext, level)
end

---@param myContext LevelGenerationContext.GenerateMinesDungeon
---@param level LevelComponent
local function GenerateMinesDungeon(myContext, level)
end

--#region Module

Module.GenerateMirrorWorld = GenerateMirrorWorld
Module.GenerateMinesDungeon = GenerateMinesDungeon

--#endregion

return Module