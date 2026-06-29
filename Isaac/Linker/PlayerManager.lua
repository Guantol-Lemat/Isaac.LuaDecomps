---@class Interface.PlayerManager
local Interface = require("Isaac.Interface.PlayerManager")

--#region Stub

local Stub = {}

---@param playerManager Component.PlayerManager
---@param idx integer
---@return Component.Entity.Player
function Stub.GetPlayer(playerManager, idx) end

---@param playerManager Component.PlayerManager
---@return integer
function Stub.GetNumPlayers(playerManager) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param id TrinketType | integer
---@return boolean
function Stub.AnyoneHasTrinket(ctx, playerManager, id) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param id CollectibleType | integer
---@return boolean
function Stub.AnyoneHasCollectible(ctx, playerManager, id) end

---@param playerManager Component.PlayerManager
---@param type PlayerType | integer
---@return boolean
function Stub.AnyoneIsPlayerType(playerManager, type) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param param_1 PlayerType | integer
---@return boolean
function Stub.AnyoneHasBirthright(ctx, playerManager, param_1) end

---@param playerManager Component.PlayerManager
function Stub.Destructor(playerManager) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param param_1 BabySubType | integer
---@return Component.Entity.Player
function Stub.SpawnCoPlayerBaby(ctx, playerManager, param_1) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param playerType PlayerType | integer
---@return Component.Entity.Player
function Stub.SpawnCoPlayer(ctx, playerManager, playerType) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param param_1 Component.Entity.Player
function Stub.add_coplayer(ctx, playerManager, param_1) end

---@param playerManager Component.PlayerManager
---@param param_1 Component.Entity.Player
function Stub.remove_coplayer(playerManager, param_1) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param player Component.Entity.Player
function Stub.RemoveCoPlayer(ctx, playerManager, player) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param playerType PlayerType | integer
---@param seed integer
function Stub.Init(ctx, playerManager, playerType, seed) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
function Stub.Reset(ctx, playerManager) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
function Stub.InitPostLevelInitStats(ctx, playerManager) end

---@param ctx Context.Common
---@return boolean
function Stub.CoopBabiesOnly(ctx) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param idx integer
---@return integer
function Stub.GetPlayerSlotFromController(ctx, playerManager, idx) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
function Stub.ProcessInput(ctx, playerManager) end

---@param ctx Context.Common
function Stub.Update(ctx) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
function Stub.TriggerRoomClear(ctx, playerManager) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
function Stub.TriggerNewStage(ctx, playerManager) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
function Stub.TriggerNewRoom(ctx, playerManager) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
function Stub.TriggerNewRoom_TemporaryEffects(ctx, playerManager) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param player Component.Entity.Player
function Stub.NotifyDead(ctx, playerManager, player) end

---@param ctx Context.Common
---@param desired Vector
---@return Vector
function Stub.GetSpawnPosition(ctx, desired) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param player Component.Entity.Player
---@param param_3 Vector
---@return Vector
function Stub.ComputeInitSpawnPosition(ctx, playerManager, player, param_3) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param map Component.Entity.Player[]
---@param state Component.GameState
---@param fullRestore boolean
---@return unknown
function Stub.compute_player_state_map(ctx, playerManager, map, state, fullRestore) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param param_1 Component.GameState
function Stub.RestoreGameState(ctx, playerManager, param_1) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param state Component.GameState
function Stub.RestoreGameState_PostLevelInit(ctx, playerManager, state) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param param_1 Component.GameState
function Stub.StoreGameState(ctx, playerManager, param_1) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param controllerIdx integer
function Stub.spawn_selected_baby(ctx, playerManager, controllerIdx) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param seed integer
function Stub.init_special_baby_selection(ctx, playerManager, seed) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param collectibleID CollectibleType | integer
---@param unusedRNG RNG
---@param checkLazSharedGlobal boolean
---@return Component.Entity.Player
function Stub.FirstCollectibleOwner(ctx, playerManager, collectibleID, unusedRNG, checkLazSharedGlobal) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param CollectibleType CollectibleType | integer
---@param Seed integer
---@param retRNG RNG
---@return Component.Entity.Player
function Stub.RandomCollectibleOwner(ctx, playerManager, CollectibleType, Seed, retRNG) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param trinket TrinketType | integer
---@param rng RNG
---@param checkLazSharedGlobal boolean
---@return Component.Entity.Player
function Stub.FirstTrinketOwner(ctx, playerManager, trinket, rng, checkLazSharedGlobal) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param id TrinketType | integer
---@param seed integer
---@param retRNG RNG
---@return Component.Entity.Player
function Stub.RandomTrinketOwner(ctx, playerManager, id, seed, retRNG) end

---@param playerManager Component.PlayerManager
---@param Form PlayerForm | integer
---@param Seed integer
---@return Component.Entity.Player
function Stub.RandomPlayerFormOwner(playerManager, Form, Seed) end

---@param playerManager Component.PlayerManager
---@param type PlayerType | integer
---@return Component.Entity.Player
function Stub.FirstPlayerByType(playerManager, type) end

---@param playerManager Component.PlayerManager
---@param inlinedTBB PlayerType | integer
---@return boolean
function Stub.AllPlayerType(playerManager, inlinedTBB) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param type CollectibleType | integer
---@return integer
function Stub.GetNumCollectibles(ctx, playerManager, type) end

---@param playerManager Component.PlayerManager
---@param item Component.ItemConfig.Item
---@return boolean
function Stub.HasTemporaryEffect(playerManager, item) end

---@param playerManager Component.PlayerManager
---@return boolean
function Stub.AnyPlayerInPitfall(playerManager) end

---@param playerManager Component.PlayerManager
---@return boolean
function Stub.AnyPlayerIsFlying(playerManager) end

---@param playerManager Component.PlayerManager
---@param value boolean
function Stub.SetControlsEnabled(playerManager, value) end

---@param playerManager Component.PlayerManager
---@return number
function Stub.GetLuck(playerManager) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param TrinketID TrinketType | integer
---@return integer
function Stub.GetTrinketMultiplier(ctx, playerManager, TrinketID) end

---@param playerManager Component.PlayerManager
---@param notLevelGen boolean
---@return boolean
function Stub.HasFullHeartsSoulHearts(playerManager, notLevelGen) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param fromCache boolean
---@return Vector
function Stub.GetAveragedPlayerPos(ctx, playerManager, fromCache) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param param_1 Component.Entity.Player
---@param param_2 Component.Entity.Player
---@return unknown
function Stub.ReplacePlayer(ctx, playerManager, param_1, param_2) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
function Stub.AutoReassignControllers(ctx, playerManager) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
---@param playerType PlayerType | integer
---@return Component.Entity.Player
function Stub.FirstBirthrightOwner(ctx, playerManager, playerType) end

---@param playerManager Component.PlayerManager
---@return boolean
function Stub.IsCoopPlay(playerManager) end

---@param playerManager Component.PlayerManager
---@return integer
function Stub.GetNumCoopPlayersAlive(playerManager) end

---@param ctx Context.Common
---@param playerManager Component.PlayerManager
function Stub.ReviveCoopPlayers(ctx, playerManager) end

--endregion

Interface.GetPlayer = Stub.GetPlayer
Interface.GetNumPlayers = Stub.GetNumPlayers
Interface.AnyoneHasTrinket = Stub.AnyoneHasTrinket
Interface.AnyoneHasCollectible = Stub.AnyoneHasCollectible
Interface.AnyoneIsPlayerType = Stub.AnyoneIsPlayerType
Interface.AnyoneHasBirthright = Stub.AnyoneHasBirthright
Interface.Destructor = Stub.Destructor
Interface.SpawnCoPlayerBaby = Stub.SpawnCoPlayerBaby
Interface.SpawnCoPlayer = Stub.SpawnCoPlayer
Interface.add_coplayer = Stub.add_coplayer
Interface.remove_coplayer = Stub.remove_coplayer
Interface.RemoveCoPlayer = Stub.RemoveCoPlayer
Interface.Init = Stub.Init
Interface.Reset = Stub.Reset
Interface.InitPostLevelInitStats = Stub.InitPostLevelInitStats
Interface.CoopBabiesOnly = Stub.CoopBabiesOnly
Interface.GetPlayerSlotFromController = Stub.GetPlayerSlotFromController
Interface.ProcessInput = Stub.ProcessInput
Interface.Update = Stub.Update
Interface.TriggerRoomClear = Stub.TriggerRoomClear
Interface.TriggerNewStage = Stub.TriggerNewStage
Interface.TriggerNewRoom = Stub.TriggerNewRoom
Interface.TriggerNewRoom_TemporaryEffects = Stub.TriggerNewRoom_TemporaryEffects
Interface.NotifyDead = Stub.NotifyDead
Interface.GetSpawnPosition = Stub.GetSpawnPosition
Interface.ComputeInitSpawnPosition = Stub.ComputeInitSpawnPosition
Interface.compute_player_state_map = Stub.compute_player_state_map
Interface.RestoreGameState = Stub.RestoreGameState
Interface.RestoreGameState_PostLevelInit = Stub.RestoreGameState_PostLevelInit
Interface.StoreGameState = Stub.StoreGameState
Interface.spawn_selected_baby = Stub.spawn_selected_baby
Interface.init_special_baby_selection = Stub.init_special_baby_selection
Interface.FirstCollectibleOwner = Stub.FirstCollectibleOwner
Interface.RandomCollectibleOwner = Stub.RandomCollectibleOwner
Interface.FirstTrinketOwner = Stub.FirstTrinketOwner
Interface.RandomTrinketOwner = Stub.RandomTrinketOwner
Interface.RandomPlayerFormOwner = Stub.RandomPlayerFormOwner
Interface.FirstPlayerByType = Stub.FirstPlayerByType
Interface.AllPlayerType = Stub.AllPlayerType
Interface.GetNumCollectibles = Stub.GetNumCollectibles
Interface.HasTemporaryEffect = Stub.HasTemporaryEffect
Interface.AnyPlayerInPitfall = Stub.AnyPlayerInPitfall
Interface.AnyPlayerIsFlying = Stub.AnyPlayerIsFlying
Interface.SetControlsEnabled = Stub.SetControlsEnabled
Interface.GetLuck = Stub.GetLuck
Interface.GetTrinketMultiplier = Stub.GetTrinketMultiplier
Interface.HasFullHeartsSoulHearts = Stub.HasFullHeartsSoulHearts
Interface.GetAveragedPlayerPos = Stub.GetAveragedPlayerPos
Interface.ReplacePlayer = Stub.ReplacePlayer
Interface.AutoReassignControllers = Stub.AutoReassignControllers
Interface.FirstBirthrightOwner = Stub.FirstBirthrightOwner
Interface.IsCoopPlay = Stub.IsCoopPlay
Interface.GetNumCoopPlayersAlive = Stub.GetNumCoopPlayersAlive
Interface.ReviveCoopPlayers = Stub.ReviveCoopPlayers