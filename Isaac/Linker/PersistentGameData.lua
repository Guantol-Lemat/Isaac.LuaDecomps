---@class Interface.PersistentGameData
local Interface = require("Isaac.Interface.PersistentGameData")

local PersistentDataMisc = require("Isaac.Gameplay.Manager.PersistentGameData.PersistentDataMisc")

--#region Stub

local Stub = {}

---@param persistentData Component.PersistentGameData
---@param path string
---@param param_2 integer
---@return boolean
function Stub.PushToSteamCloud(persistentData, path, param_2) end

---@param persistentData Component.PersistentGameData
---@return Component.PersistentGameData
function Stub.constructor(persistentData) end

---@param persistentData Component.PersistentGameData
---@param param_1 boolean
function Stub.Clear(persistentData, param_1) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param param_1 boolean
function Stub.DeleteCurrentSave(persistentData, ctx, param_1) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@return integer
function Stub.GetMostRecentBackupDate(persistentData, ctx) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param filename string
---@return boolean
function Stub.Load(persistentData, ctx, filename) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@return boolean
function Stub.load_file(persistentData, ctx) end

---@param param_1 integer
---@return boolean
function Stub.load(param_1) end

---@param persistentData Component.PersistentGameData
function Stub.fix_cutscene_unlocks(persistentData) end

---@param persistentData Component.PersistentGameData
function Stub.save(persistentData) end

---@param persistentData Component.PersistentGameData
function Stub.SaveToSteamCloud(persistentData) end

---@param persistentData Component.PersistentGameData
---@return unknown
function Stub.get_backup_file_name(persistentData) end

---@param persistentData Component.PersistentGameData
function Stub.SaveBackup(persistentData) end

---@param persistentData Component.PersistentGameData
function Stub.Save(persistentData) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param backup boolean
function Stub.Flush(persistentData, ctx, backup) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
function Stub.unlock_challenge_achievements(persistentData, ctx) end

---@param param_1 Achievement | integer
function Stub.unlock_steam_achievement(param_1) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
function Stub.check_booster_achievements(persistentData, ctx) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param achievementId Achievement | integer
---@return boolean unlockedNow
function Stub.TryUnlock(persistentData, ctx, achievementId) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param achievementID Achievement | integer
---@return boolean
function Stub.Unlocked(persistentData, ctx, achievementID) end

---@param playerType PlayerType | integer
---@return (Component.CompletionEventDef[])?
function Stub.GetCompletionEventDef(playerType) end

---@param completion CompletionType | integer
---@param playerType PlayerType | integer
---@return integer
function Stub.GetCompletionCounterID(completion, playerType) end

---@param persistentData Component.PersistentGameData
---@param event EventCounter | integer
---@return integer
function Stub.GetEventCounter(persistentData, event) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param eEventCounter EventCounter | integer
---@param num integer
function Stub.IncreaseEventCounter(persistentData, ctx, eEventCounter, num) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param completion eCompletionType | integer
---@param playerType PlayerType | integer
---@param isCompletionMark boolean
function Stub.IncreasePlayerEventCounter(persistentData, ctx, completion, playerType, isCompletionMark) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param collectibleType CollectibleType | integer
function Stub.AddToCollection(persistentData, ctx, collectibleType) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
function Stub.check_platinum_god(persistentData, ctx) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param ID integer
function Stub.AddMiniBoss(persistentData, ctx, ID) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param bossID BossType | integer
function Stub.AddBoss(persistentData, ctx, bossID) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param param_1 Challenge | integer
function Stub.AddChallenge(persistentData, ctx, param_1) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param EntityType EntityType | integer
---@param EntityVariant integer
---@return boolean
function Stub.AddBestiaryHit(persistentData, ctx, EntityType, EntityVariant) end

---@param persistentData Component.PersistentGameData
---@param entityHash integer
---@return boolean
function Stub.add_bestiary_hit(persistentData, entityHash) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param type EntityType | integer
---@param variant integer
---@return boolean
function Stub.AddBestiaryDeath(persistentData, ctx, type, variant) end

---@param persistentData Component.PersistentGameData
---@param entityHash integer
---@return boolean
function Stub.add_bestiary_death(persistentData, entityHash) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param type EntityType | integer
---@param var integer
---@return boolean
function Stub.AddBestiaryKill(persistentData, ctx, type, var) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param type EntityType | integer
---@param var integer
---@return boolean
function Stub.AddBestiaryEncounter(persistentData, ctx, type, var) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param EntityType EntityType | integer
---@param EntityVariant integer
---@return integer
function Stub.GetBestiaryDeathCount(persistentData, ctx, EntityType, EntityVariant) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param EntityType EntityType | integer
---@param EntityVariant integer
---@return integer
function Stub.GetBestiaryKillCount(persistentData, ctx, EntityType, EntityVariant) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param type EntityType | integer
---@param var integer
---@return integer
function Stub.GetBestiaryEncounterCount(persistentData, ctx, type, var) end

---@param persistentData Component.PersistentGameData
---@param SeedEffect SeedEffect | integer
function Stub.AddSpecialSeed(persistentData, SeedEffect) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param param_1 integer
function Stub.SetPlayerWinMask(persistentData, ctx, param_1) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param param_1 string
---@return boolean
function Stub.ImportRebirthSave(persistentData, ctx, param_1) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param param_1 integer
---@return boolean
function Stub.ImportABSave(persistentData, ctx, param_1) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@param param_1 string
---@return boolean
function Stub.TryImportABSave(persistentData, ctx, param_1) end

---@param persistentData Component.PersistentGameData
---@param param_1 string
---@return boolean
function Stub.TryImportABPSave(persistentData, param_1) end

---@param persistentData Component.PersistentGameData
function Stub.prepare_net_start(persistentData) end

---@param persistentData Component.PersistentGameData
---@param ctx Context.Common
---@return boolean
function Stub.SomethingForSaveSlotGraphics(persistentData, ctx) end

--#endregion

Interface.PushToSteamCloud = Stub.PushToSteamCloud
Interface.constructor = Stub.constructor
Interface.Clear = Stub.Clear
Interface.DeleteCurrentSave = Stub.DeleteCurrentSave
Interface.GetMostRecentBackupDate = Stub.GetMostRecentBackupDate
Interface.Load = Stub.Load
Interface.load_file = Stub.load_file
Interface.load = Stub.load
Interface.fix_cutscene_unlocks = Stub.fix_cutscene_unlocks
Interface.save = Stub.save
Interface.SaveToSteamCloud = Stub.SaveToSteamCloud
Interface.get_backup_file_name = Stub.get_backup_file_name
Interface.SaveBackup = Stub.SaveBackup
Interface.Save = Stub.Save
Interface.Flush = Stub.Flush
Interface.unlock_challenge_achievements = Stub.unlock_challenge_achievements
Interface.unlock_steam_achievement = Stub.unlock_steam_achievement
Interface.check_booster_achievements = Stub.check_booster_achievements
Interface.SetReadOnly = PersistentDataMisc.SetReadOnly
Interface.TryUnlock = Stub.TryUnlock
Interface.Unlocked = Stub.Unlocked
Interface.GetCompletionEventDef = Stub.GetCompletionEventDef
Interface.GetCompletionCounterID = Stub.GetCompletionCounterID
Interface.GetEventCounter = Stub.GetEventCounter
Interface.IncreaseEventCounter = Stub.IncreaseEventCounter
Interface.IncreasePlayerEventCounter = Stub.IncreasePlayerEventCounter
Interface.AddToCollection = Stub.AddToCollection
Interface.check_platinum_god = Stub.check_platinum_god
Interface.AddMiniBoss = Stub.AddMiniBoss
Interface.AddBoss = Stub.AddBoss
Interface.AddChallenge = Stub.AddChallenge
Interface.AddBestiaryHit = Stub.AddBestiaryHit
Interface.add_bestiary_hit = Stub.add_bestiary_hit
Interface.AddBestiaryDeath = Stub.AddBestiaryDeath
Interface.add_bestiary_death = Stub.add_bestiary_death
Interface.AddBestiaryKill = Stub.AddBestiaryKill
Interface.AddBestiaryEncounter = Stub.AddBestiaryEncounter
Interface.GetBestiaryDeathCount = Stub.GetBestiaryDeathCount
Interface.GetBestiaryKillCount = Stub.GetBestiaryKillCount
Interface.GetBestiaryEncounterCount = Stub.GetBestiaryEncounterCount
Interface.AddSpecialSeed = Stub.AddSpecialSeed
Interface.SetPlayerWinMask = Stub.SetPlayerWinMask
Interface.ImportRebirthSave = Stub.ImportRebirthSave
Interface.ImportABSave = Stub.ImportABSave
Interface.TryImportABSave = Stub.TryImportABSave
Interface.TryImportABPSave = Stub.TryImportABPSave
Interface.prepare_net_start = Stub.prepare_net_start
Interface.SomethingForSaveSlotGraphics = Stub.SomethingForSaveSlotGraphics