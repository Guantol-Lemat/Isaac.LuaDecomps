--#region Dependencies



--#endregion

---@class LevelGeneratorGenerationLogic
local Module = {}

---@param levelGen LevelGeneratorComponent
---@param roomCount integer
---@param isChapter6 boolean
---@param isXL boolean
---@param isVoid boolean
---@param allowedShapes integer
---@param deadEnds integer
---@param startRoom LevelGeneratorRoomComponent
local function Generate(levelGen, roomCount, isChapter6, isXL, isVoid, allowedShapes, deadEnds, startRoom)
end

---@param levelGen LevelGeneratorComponent
---@param shape RoomShape | integer
---@param doors integer
---@param determineBossRoom boolean
---@return LevelGeneratorRoomComponent?
local function GetNewBossRoom(levelGen, shape, doors, determineBossRoom)
end

---@param levelGen LevelGeneratorComponent
---@param blacklist Set<integer>
---@return LevelGeneratorRoomComponent?
local function CreateRandomEndRoom(levelGen, blacklist)
end

---@param levelGen LevelGeneratorComponent
---@param blacklist Set<integer>
---@return LevelGeneratorRoomComponent?
local function GetNewSecretRoom(levelGen, blacklist)
end

---@param levelGen LevelGeneratorComponent
---@param blacklist Set<integer>
---@return LevelGeneratorRoomComponent?
local function GetNewUltraSecretRoom(levelGen, blacklist)
end

--#region Module

Module.Generate = Generate
Module.GetNewBossRoom = GetNewBossRoom
Module.CreateRandomEndRoom = CreateRandomEndRoom
Module.GetNewSecretRoom = GetNewSecretRoom
Module.GetNewUltraSecretRoom = GetNewUltraSecretRoom

--#endregion

return Module