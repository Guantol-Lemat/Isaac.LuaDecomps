---@class Interface.PersistentGameData
local Interface = require("Isaac.Interface.PersistentGameData")

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

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param param_1 boolean
function Stub.DeleteCurrentSave(ctx, persistentData, param_1) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@return integer
function Stub.GetMostRecentBackupDate(ctx, persistentData) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param filename string
---@return boolean
function Stub.Load(ctx, persistentData, filename) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@return boolean
function Stub.load_file(ctx, persistentData) end

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

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param backup boolean
function Stub.Flush(ctx, persistentData, backup) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
function Stub.unlock_challenge_achievements(ctx, persistentData) end

---@param param_1 Achievement | integer
function Stub.unlock_steam_achievement(param_1) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
function Stub.check_booster_achievements(ctx, persistentData) end

---@param persistentData Component.PersistentGameData
---@param param_1 boolean
function Stub.SetReadOnly(persistentData, param_1) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param achievementId Achievement | integer
---@return boolean
function Stub.TryUnlock(ctx, persistentData, achievementId) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param achievementID Achievement | integer
---@return boolean
function Stub.Unlocked(ctx, persistentData, achievementID) end

---@param playerType PlayerType | integer
---@return Component.PlayerEvent
function Stub.GetCompletionEventDef(playerType) end

---@param param_1 integer
---@param playerType PlayerType | integer
---@return integer
function Stub.GetCompletionCounterID(param_1, playerType) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param eEventCounter EventCounter | integer
---@param num integer
function Stub.IncreaseEventCounter(ctx, persistentData, eEventCounter, num) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param collectibleType CollectibleType | integer
function Stub.AddToCollection(ctx, persistentData, collectibleType) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
function Stub.check_platinum_god(ctx, persistentData) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param ID integer
function Stub.AddMiniBoss(ctx, persistentData, ID) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param bossID BossType | integer
function Stub.AddBoss(ctx, persistentData, bossID) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param param_1 Challenge | integer
function Stub.AddChallenge(ctx, persistentData, param_1) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param EntityType EntityType | integer
---@param EntityVariant integer
---@return boolean
function Stub.AddBestiaryHit(ctx, persistentData, EntityType, EntityVariant) end

---@param persistentData Component.PersistentGameData
---@param entityHash integer
---@return boolean
function Stub.add_bestiary_hit(persistentData, entityHash) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param type EntityType | integer
---@param variant integer
---@return boolean
function Stub.AddBestiaryDeath(ctx, persistentData, type, variant) end

---@param persistentData Component.PersistentGameData
---@param entityHash integer
---@return boolean
function Stub.add_bestiary_death(persistentData, entityHash) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param type EntityType | integer
---@param var integer
---@return boolean
function Stub.AddBestiaryKill(ctx, persistentData, type, var) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param type EntityType | integer
---@param var integer
---@return boolean
function Stub.AddBestiaryEncounter(ctx, persistentData, type, var) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param EntityType EntityType | integer
---@param EntityVariant integer
---@return integer
function Stub.GetBestiaryDeathCount(ctx, persistentData, EntityType, EntityVariant) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param EntityType EntityType | integer
---@param EntityVariant integer
---@return integer
function Stub.GetBestiaryKillCount(ctx, persistentData, EntityType, EntityVariant) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param type EntityType | integer
---@param var integer
---@return integer
function Stub.GetBestiaryEncounterCount(ctx, persistentData, type, var) end

---@param persistentData Component.PersistentGameData
---@param SeedEffect SeedEffect | integer
function Stub.AddSpecialSeed(persistentData, SeedEffect) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param param_1 integer
function Stub.SetPlayerWinMask(ctx, persistentData, param_1) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param param_1 string
---@return boolean
function Stub.ImportRebirthSave(ctx, persistentData, param_1) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param param_1 integer
---@return boolean
function Stub.ImportABSave(ctx, persistentData, param_1) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@param param_1 string
---@return boolean
function Stub.TryImportABSave(ctx, persistentData, param_1) end

---@param persistentData Component.PersistentGameData
---@param param_1 string
---@return boolean
function Stub.TryImportABPSave(persistentData, param_1) end

---@param persistentData Component.PersistentGameData
function Stub.prepare_net_start(persistentData) end

---@param ctx Context.Common
---@param persistentData Component.PersistentGameData
---@return boolean
function Stub.SomethingForSaveSlotGraphics(ctx, persistentData) end

--endregion

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
Interface.SetReadOnly = Stub.SetReadOnly
Interface.TryUnlock = Stub.TryUnlock
Interface.Unlocked = Stub.Unlocked
Interface.GetCompletionEventDef = Stub.GetCompletionEventDef
Interface.GetCompletionCounterID = Stub.GetCompletionCounterID
Interface.IncreaseEventCounter = Stub.IncreaseEventCounter
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