---@class Interface.ModManager
local Interface = require("Isaac.Interface.ModManager")

---@class Interface.ModEntry
local Interface_ModEntry = Interface.ModEntry

local ModLoadConfig = require("Isaac.ModManager.LoadConfig")

--#region Stub

local Stub = {}

---@param modManager Component.ModManager
function Stub.destructor(modManager) end

---@param modManager Component.ModManager
---@param ctx Context.Common
function Stub.LoadConfigs(modManager, ctx) end

---@param modManager Component.ModManager
---@param ctx Context.Common
function Stub.RenderLoadingScreen(modManager, ctx) end

---@param modManager Component.ModManager
function Stub.LoadShaders(modManager) end

---@param modManager Component.ModManager
function Stub.UnloadMods(modManager) end

---@param modManager Component.ModManager
---@param path string
---@return string
function Stub.TryRedirectPath(modManager, path) end

---@param modManager Component.ModManager
---@param ctx Context.Common
function Stub.ListMods(modManager, ctx) end

---@param modManager Component.ModManager
function Stub.TriggerResize(modManager) end

---@param modManager Component.ModManager
---@param ctx Context.Common
function Stub.ApplyShaders(modManager, ctx) end

---@param modManager Component.ModManager
function Stub.CreateSurfaces(modManager) end

---@param modManager Component.ModManager
function Stub.DestroySurfaces(modManager) end

---@param modManager Component.ModManager
function Stub.ShutdownShaders(modManager) end

---@param modManager Component.ModManager
---@param ctx Context.Common
---@param Stage StbType | integer
---@param Mode eMode | integer
function Stub.UpdateRooms(modManager, ctx, Stage, Mode) end

---@param modManager Component.ModManager
---@param ctx Context.Common
function Stub.UpdateCurses(modManager, ctx) end

---@param modManager Component.ModManager
---@param ctx Context.Common
---@param id integer
---@param pos Vector
---@param color Color
---@param scale Vector
function Stub.RenderCustomCharacters(modManager, ctx, id, pos, color, scale) end

---@param modManager Component.ModManager
---@param ctx Context.Common
---@param id integer
---@param pos Vector
function Stub.RenderCustomCard(modManager, ctx, id, pos) end

---@param modManager Component.ModManager
---@param ctx Context.Common
---@return unknown
function Stub.Reset(modManager, ctx) end

---@param modManager Component.ModManager
---@return boolean
function Stub.IsActive(modManager) end

---@param modManager Component.ModManager
---@param ctx Context.Common
---@param CharacterId integer
---@param RenderPos Vector
---@param DefaultSprite Sprite
function Stub.RenderCustomCharacterMenu(modManager, ctx, CharacterId, RenderPos, DefaultSprite) end

---@param modManager Component.ModManager
---@param ctx Context.Common
---@param id integer
---@param pos Vector
---@param scale Vector
---@param color Color
function Stub.RenderCustomCharacterCoopMenu(modManager, ctx, id, pos, scale, color) end

---@param modManager Component.ModManager
---@param ctx Context.Common
---@param id integer
---@param position Vector
---@param scale Vector
---@param color Color
---@param blend Engine.BlendMode
function Stub.RenderCustomCollectionItem(modManager, ctx, id, position, scale, color, blend) end

---@param ctx Context.Common
---@param param_1 unknown
function Stub.workshop_update_thread(ctx, param_1) end

---@param modManager Component.ModManager
---@param ctx Context.Common
function Stub.UpdateWorkshopMods(modManager, ctx) end

--#endregion

--region ModEntry Stub

local Stub_ModEntry = {}

---@return Component.ModEntry
function Stub_ModEntry.New() end

---@param mod Component.ModEntry
function Stub_ModEntry.WriteMetadata(mod) end

---@param mod Component.ModEntry
---@param path string
---@return string
function Stub_ModEntry.GetContentPath(mod, path) end

---@param mod Component.ModEntry
---@param offset integer
---@param path string
function Stub_ModEntry.LoadCustomResource(mod, offset, path) end

--#endregion

Interface.destructor = Stub.destructor
Interface.LoadConfigs = Stub.LoadConfigs
Interface.RenderLoadingScreen = Stub.RenderLoadingScreen
Interface.LoadShaders = Stub.LoadShaders
Interface.UnloadMods = Stub.UnloadMods
Interface.TryRedirectPath = Stub.TryRedirectPath
Interface.ListMods = Stub.ListMods
Interface.TriggerResize = Stub.TriggerResize
Interface.ApplyShaders = Stub.ApplyShaders
Interface.CreateSurfaces = Stub.CreateSurfaces
Interface.DestroySurfaces = Stub.DestroySurfaces
Interface.ShutdownShaders = Stub.ShutdownShaders
Interface.UpdateRooms = Stub.UpdateRooms
Interface.UpdatePools = ModLoadConfig.UpdatePools
Interface.UpdateBossPools = ModLoadConfig.UpdateBossPools
Interface.UpdateCurses = Stub.UpdateCurses
Interface.RenderCustomCharacters = Stub.RenderCustomCharacters
Interface.RenderCustomCard = Stub.RenderCustomCard
Interface.Reset = Stub.Reset
Interface.IsActive = Stub.IsActive
Interface.RenderCustomCharacterMenu = Stub.RenderCustomCharacterMenu
Interface.RenderCustomCharacterCoopMenu = Stub.RenderCustomCharacterCoopMenu
Interface.RenderCustomCollectionItem = Stub.RenderCustomCollectionItem
Interface.workshop_update_thread = Stub.workshop_update_thread
Interface.UpdateWorkshopMods = Stub.UpdateWorkshopMods

Interface_ModEntry.New = Stub_ModEntry.New
Interface_ModEntry.WriteMetadata = Stub_ModEntry.WriteMetadata
Interface_ModEntry.GetContentPath = Stub_ModEntry.GetContentPath
Interface_ModEntry.LoadCustomResource = Stub_ModEntry.LoadCustomResource