---@class Interface.Manager
local Interface = require("Isaac.Interface.Manager")

--#region Stub

local Stub = {}

---@param ctx Context.Common
---@return Component.ModManager
function Stub.GetModManager(ctx) end

---@param ctx Context.Common
---@return unknown
function Stub.GetNetplayManager(ctx) end

---@param ctx Context.Common
---@return Component.SoundEffects
function Stub.GetSFXManager(ctx) end

---@param manager Component.Manager
---@return Component.PersistentGameData
function Stub.GetPersistentGameData(manager) end

---@param ctx Context.Common
---@return Component.EntityConfig
function Stub.GetEntityConfig(ctx) end

---@param ctx Context.Common
---@return Component.Music
function Stub.GetMusicManager(ctx) end

---@param ctx Context.Common
---@return Component.ItemConfig
function Stub.GetItemConfig(ctx) end

---@param ctx Context.Common
---@return Component.AchievementOverlay
function Stub.GetAchievementOverlay(ctx) end

---@param ctx Context.Common
---@return Component.StringTable
function Stub.GetStringTable(ctx) end

---@return Component.Manager
function Stub.constructor() end

---@param manager Component.Manager
function Stub.destructor(manager) end

---@param ctx Context.Common
---@param manager Component.Manager
function Stub.create_surfaces(ctx, manager) end

---@param ctx Context.Common
---@param manager Component.Manager
function Stub.load_language_fonts(ctx, manager) end

---@param ctx Context.Common
---@param param_1 integer
function Stub.InitLoadImage(ctx, param_1) end

---@param ctx Context.Common
---@param manager Component.Manager
function Stub.Init(ctx, manager) end

---@param ctx Context.Common
---@param manager Component.Manager
function Stub.LoadConfigs(ctx, manager) end

---@param ctx Context.Common
---@return unknown
function Stub.ReloadConfigs(ctx) end

---@param ctx Context.Common
---@param width integer
---@param height integer
---@param letterbox_qqq boolean
function Stub.ResizeCutsceneWindow(ctx, width, height, letterbox_qqq) end

---@param ctx Context.Common
---@param windowWidth integer
---@param windowHeight integer
function Stub.ResizeWindow(ctx, windowWidth, windowHeight) end

---@param ctx Context.Common
function Stub.PostLanguageSwitch(ctx) end

---@param ctx Context.Common
---@return string
function Stub.GetLanguage(ctx) end

---@param ctx Context.Common
---@param manager Component.Manager
function Stub.handle_hotkeys(ctx, manager) end

---@param ctx Context.Common
---@return boolean
function Stub.AssignTriggeredController(ctx) end

---@param ctx Context.Common
---@param manager Component.Manager
function Stub.Update(ctx, manager) end

---@param ctx Context.Common
---@param manager Component.Manager
function Stub.Render(ctx, manager) end

---@param ctx Context.Common
---@param param_1 ButtonAction | integer
---@param param_2 integer
---@param param_3 Component.Entity
---@return boolean
function Stub.IsActionPressed(ctx, param_1, param_2, param_3) end

---@param ctx Context.Common
---@param manager Component.Manager
---@param action ButtonAction | integer
---@param param_2 integer
---@param param_3 unknown
---@return boolean
function Stub.IsActionTriggered(ctx, manager, action, param_2, param_3) end

---@param ctx Context.Common
---@param param_1 ButtonAction | integer
---@param param_2 integer
---@param param_3 unknown
---@return number
function Stub.GetActionValue(ctx, param_1, param_2, param_3) end

---@param manager Component.Manager
---@return boolean
function Stub.IsSteamCloudEnabled(manager) end

---@param ctx Context.Common
---@param Sound SoundEffect | integer
---@param Volume number
---@param FrameDelay integer
---@param Loop boolean
---@param Pitch number
function Stub.PlaySound(ctx, Sound, Volume, FrameDelay, Loop, Pitch) end

---@param ctx Context.Common
---@param manager Component.Manager
---@param challengeId integer
---@return Component.ChallengeParam
function Stub.GetChallengeParams(ctx, manager, challengeId) end

---@param manager Component.Manager
---@param param_1 string
---@param ismod boolean
function Stub.LoadChallenges(manager, param_1, ismod) end

---@param param_1 Component.StringTable
---@param param_2 string
---@param param_3 integer
---@param param_4 string
---@return string
function Stub.GetString(param_1, param_2, param_3, param_4) end

---@param ctx Context.Common
---@param param_2 string
---@param param_3 Component.Graphics.VertexAttributeDescriptor
---@param param_4 boolean
---@return Component.Image
function Stub.LoadImage(ctx, result, param_2, param_3, param_4) end

---@param ctx Context.Common
---@param manager Component.Manager
---@param playerType integer
---@param challenge Challenge | integer
---@param seeds Component.Seeds
---@param difficulty Difficulty | integer
function Stub.StartNewGame(ctx, manager, playerType, challenge, seeds, difficulty) end

---@param ctx Context.Common
function Stub.InitDailyChallenge(ctx) end

---@param ctx Context.Common
---@param seeds Component.Seeds
---@param ClearSeedEffects boolean
---@param ProgressScaredHeart boolean
function Stub.RestartGame(ctx, seeds, ClearSeedEffects, ProgressScaredHeart) end

---@param ctx Context.Common
---@param manager Component.Manager
---@param param_1 Cutscene | integer
---@param param_2 boolean
function Stub.ShowCutscene(ctx, manager, param_1, param_2) end

---@param ctx Context.Common
function Stub.SaveGameState(ctx) end

---@param ctx Context.Common
---@return unknown
function Stub.DeleteGameState(ctx) end

---@param ctx Context.Common
function Stub.SaveRerun(ctx) end

---@param ctx Context.Common
---@param param_1 boolean
---@return boolean
function Stub.AchievementUnlocksDisallowed(ctx, param_1) end

---@param ctx Context.Common
---@param manager Component.Manager
function Stub.cleanup_current_state(ctx, manager) end

---@param ctx Context.Common
---@param manager Component.Manager
function Stub.execute_start_game(ctx, manager) end

---@param ctx Context.Common
---@param manager Component.Manager
function Stub.execute_start_menu(ctx, manager) end

---@param ctx Context.Common
---@param manager Component.Manager
---@param slot integer
function Stub.SetSaveSlot(ctx, manager, slot) end

---@param ctx Context.Common
---@param manager Component.Manager
---@param saveSlot integer
function Stub.LoadGameState(ctx, manager, saveSlot) end

---@param ctx Context.Common
---@param manager Component.Manager
function Stub.RecordLoss(ctx, manager) end

---@param ctx Context.Common
---@param type CompletionType | integer
function Stub.RecordPlayerCompletion(ctx, type) end

---@param ctx Context.Common
---@param controllerIdx integer
---@param param_2 integer
---@param param_3 integer
---@param param_4 boolean
---@param position Vector
---@return boolean
function Stub.RenderButtonIcon(ctx, controllerIdx, param_2, param_3, param_4, position) end

--endregion

Interface.GetModManager = Stub.GetModManager
Interface.GetNetplayManager = Stub.GetNetplayManager
Interface.GetSFXManager = Stub.GetSFXManager
Interface.GetPersistentGameData = Stub.GetPersistentGameData
Interface.GetEntityConfig = Stub.GetEntityConfig
Interface.GetMusicManager = Stub.GetMusicManager
Interface.GetItemConfig = Stub.GetItemConfig
Interface.GetAchievementOverlay = Stub.GetAchievementOverlay
Interface.GetStringTable = Stub.GetStringTable
Interface.constructor = Stub.constructor
Interface.destructor = Stub.destructor
Interface.create_surfaces = Stub.create_surfaces
Interface.load_language_fonts = Stub.load_language_fonts
Interface.InitLoadImage = Stub.InitLoadImage
Interface.Init = Stub.Init
Interface.LoadConfigs = Stub.LoadConfigs
Interface.ReloadConfigs = Stub.ReloadConfigs
Interface.ResizeCutsceneWindow = Stub.ResizeCutsceneWindow
Interface.ResizeWindow = Stub.ResizeWindow
Interface.PostLanguageSwitch = Stub.PostLanguageSwitch
Interface.GetLanguage = Stub.GetLanguage
Interface.handle_hotkeys = Stub.handle_hotkeys
Interface.AssignTriggeredController = Stub.AssignTriggeredController
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.IsActionPressed = Stub.IsActionPressed
Interface.IsActionTriggered = Stub.IsActionTriggered
Interface.GetActionValue = Stub.GetActionValue
Interface.IsSteamCloudEnabled = Stub.IsSteamCloudEnabled
Interface.PlaySound = Stub.PlaySound
Interface.GetChallengeParams = Stub.GetChallengeParams
Interface.LoadChallenges = Stub.LoadChallenges
Interface.GetString = Stub.GetString
Interface.LoadImage = Stub.LoadImage
Interface.StartNewGame = Stub.StartNewGame
Interface.InitDailyChallenge = Stub.InitDailyChallenge
Interface.RestartGame = Stub.RestartGame
Interface.ShowCutscene = Stub.ShowCutscene
Interface.SaveGameState = Stub.SaveGameState
Interface.DeleteGameState = Stub.DeleteGameState
Interface.SaveRerun = Stub.SaveRerun
Interface.AchievementUnlocksDisallowed = Stub.AchievementUnlocksDisallowed
Interface.cleanup_current_state = Stub.cleanup_current_state
Interface.execute_start_game = Stub.execute_start_game
Interface.execute_start_menu = Stub.execute_start_menu
Interface.SetSaveSlot = Stub.SetSaveSlot
Interface.LoadGameState = Stub.LoadGameState
Interface.RecordLoss = Stub.RecordLoss
Interface.RecordPlayerCompletion = Stub.RecordPlayerCompletion
Interface.RenderButtonIcon = Stub.RenderButtonIcon