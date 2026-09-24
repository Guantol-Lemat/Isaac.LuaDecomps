---@class Interface.MenuManager
local Interface = require("Isaac.Interface.MenuManager")

--#region Stub

local Stub = {}

---@param menu Component.MenuManager
---@return integer
function Stub.New(menu) end

---@param menu Component.MenuManager
function Stub.destructor(menu) end

---@param menu Component.MenuManager
function Stub.CreateSurfaces(menu) end

---@param menu Component.MenuManager
function Stub.TriggerWindowResize(menu) end

---@param menu Component.MenuManager
function Stub.SetTitleMenuVariant(menu) end

---@param menu Component.MenuManager
function Stub.Init(menu) end

---@param menu Component.MenuManager
function Stub.PreLanguageSwitch(menu) end

---@param menu Component.MenuManager
function Stub.PostLanguageSwitch(menu) end

---@param menu Component.MenuManager
function Stub.ResetCharacterMenu(menu) end

---@param menu Component.MenuManager
function Stub.PostInitMods(menu) end

---@param menu Component.MenuManager
---@param param_1 KColor
function Stub.StartFadeIn(menu, param_1) end

---@param menu Component.MenuManager
---@param param_1 KColor
function Stub.StartFadeOut(menu) end

---@param menu Component.MenuManager
function Stub.Update(menu) end

---@param menu Component.MenuManager
function Stub.Render(menu) end

---@param menu Component.MenuManager
---@param param_1 integer
function Stub.RenderButtonOverlay(menu, param_1) end

---@param menu Component.MenuManager
---@param estate integer
function Stub.SetState(menu, estate) end

---@param menu Component.MenuManager
---@param value integer
function Stub.SetControllerID(menu, value) end

---@param menu Component.MenuManager
---@param value integer
function Stub.SetChallengeOffset(menu, value) end

---@param menu Component.MenuManager
---@param value integer
function Stub.SetCustomChallengeOffset(menu, value) end

---@param menu Component.MenuManager
---@param value integer
function Stub.SetModsOffset(menu, value) end

---@param menu Component.MenuManager
---@param param_1 integer
function Stub.SetOptionsOffset(menu, param_1) end

---@param menu Component.MenuManager
---@param value integer
function Stub.SetKeyConfigOffset(menu, value) end

---@param menu Component.MenuManager
---@param value integer
function Stub.SetCharacterOffset(menu, value) end

---@param menu Component.MenuManager
---@param value integer
function Stub.SetSpecialSeedOffset(menu, value) end

---@param menu Component.MenuManager
function Stub.TriggerCutsceneEnd(menu) end

---@param menu Component.MenuManager
---@param value integer
function Stub.SetColorModifier(menu, value) end

--#endregion

Interface.New = Stub.New
Interface.destructor = Stub.destructor
Interface.CreateSurfaces = Stub.CreateSurfaces
Interface.TriggerWindowResize = Stub.TriggerWindowResize
Interface.SetTitleMenuVariant = Stub.SetTitleMenuVariant
Interface.Init = Stub.Init
Interface.PreLanguageSwitch = Stub.PreLanguageSwitch
Interface.PostLanguageSwitch = Stub.PostLanguageSwitch
Interface.ResetCharacterMenu = Stub.ResetCharacterMenu
Interface.PostInitMods = Stub.PostInitMods
Interface.StartFadeIn = Stub.StartFadeIn
Interface.StartFadeOut = Stub.StartFadeOut
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.RenderButtonOverlay = Stub.RenderButtonOverlay
Interface.SetState = Stub.SetState
Interface.SetControllerID = Stub.SetControllerID
Interface.SetChallengeOffset = Stub.SetChallengeOffset
Interface.SetCustomChallengeOffset = Stub.SetCustomChallengeOffset
Interface.SetModsOffset = Stub.SetModsOffset
Interface.SetOptionsOffset = Stub.SetOptionsOffset
Interface.SetKeyConfigOffset = Stub.SetKeyConfigOffset
Interface.SetCharacterOffset = Stub.SetCharacterOffset
Interface.SetSpecialSeedOffset = Stub.SetSpecialSeedOffset
Interface.TriggerCutsceneEnd = Stub.TriggerCutsceneEnd
Interface.SetColorModifier = Stub.SetColorModifier