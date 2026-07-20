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

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param id TrinketType | integer
---@return boolean
function Stub.AnyoneHasTrinket(playerManager, ctx, id) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param id CollectibleType | integer
---@return boolean
function Stub.AnyoneHasCollectible(playerManager, ctx, id) end

---@param playerManager Component.PlayerManager
---@param type PlayerType | integer
---@return boolean
function Stub.AnyoneIsPlayerType(playerManager, type) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param param_1 PlayerType | integer
---@return boolean
function Stub.AnyoneHasBirthright(playerManager, ctx, param_1) end

---@param playerManager Component.PlayerManager
function Stub.Destructor(playerManager) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param param_1 BabySubType | integer
---@return Component.Entity.Player
function Stub.SpawnCoPlayerBaby(playerManager, ctx, param_1) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param playerType PlayerType | integer
---@return Component.Entity.Player
function Stub.SpawnCoPlayer(playerManager, ctx, playerType) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param param_1 Component.Entity.Player
function Stub.add_coplayer(playerManager, ctx, param_1) end

---@param playerManager Component.PlayerManager
---@param param_1 Component.Entity.Player
function Stub.remove_coplayer(playerManager, param_1) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.RemoveCoPlayer(playerManager, ctx, player) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param playerType PlayerType | integer
---@param seed integer
function Stub.Init(playerManager, ctx, playerType, seed) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
function Stub.Reset(playerManager, ctx) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
function Stub.InitPostLevelInitStats(playerManager, ctx) end

---@param ctx Context.Common
---@return boolean
function Stub.CoopBabiesOnly(ctx) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param idx integer
---@return integer
function Stub.GetPlayerSlotFromController(playerManager, ctx, idx) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
function Stub.ProcessInput(playerManager, ctx) end

---@param ctx Context.Common
function Stub.Update(ctx) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
function Stub.TriggerRoomClear(playerManager, ctx) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
function Stub.TriggerNewStage(playerManager, ctx) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
function Stub.TriggerNewRoom(playerManager, ctx) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
function Stub.TriggerNewRoom_TemporaryEffects(playerManager, ctx) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.NotifyDead(playerManager, ctx, player) end

---@param ctx Context.Common
---@param desired Vector
---@return Vector
function Stub.GetSpawnPosition(ctx, desired) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_3 Vector
---@return Vector
function Stub.ComputeInitSpawnPosition(playerManager, ctx, player, param_3) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param map Component.Entity.Player[]
---@param state Component.GameState
---@param fullRestore boolean
---@return unknown
function Stub.compute_player_state_map(playerManager, ctx, map, state, fullRestore) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param param_1 Component.GameState
function Stub.RestoreGameState(playerManager, ctx, param_1) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param state Component.GameState
function Stub.RestoreGameState_PostLevelInit(playerManager, ctx, state) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param param_1 Component.GameState
function Stub.StoreGameState(playerManager, ctx, param_1) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param controllerIdx integer
function Stub.spawn_selected_baby(playerManager, ctx, controllerIdx) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param seed integer
function Stub.init_special_baby_selection(playerManager, ctx, seed) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param collectibleID CollectibleType | integer
---@param unusedRNG RNG
---@param checkLazSharedGlobal boolean
---@return Component.Entity.Player
function Stub.FirstCollectibleOwner(playerManager, ctx, collectibleID, unusedRNG, checkLazSharedGlobal) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param CollectibleType CollectibleType | integer
---@param Seed integer
---@param retRNG RNG
---@return Component.Entity.Player
function Stub.RandomCollectibleOwner(playerManager, ctx, CollectibleType, Seed, retRNG) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param trinket TrinketType | integer
---@param rng RNG
---@param checkLazSharedGlobal boolean
---@return Component.Entity.Player
function Stub.FirstTrinketOwner(playerManager, ctx, trinket, rng, checkLazSharedGlobal) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param id TrinketType | integer
---@param seed integer
---@return Component.Entity.Player?
---@return RNG?
function Stub.RandomTrinketOwner(playerManager, ctx, id, seed, retRNG) end

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

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param type CollectibleType | integer
---@return integer
function Stub.GetNumCollectibles(playerManager, ctx, type) end

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

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param TrinketID TrinketType | integer
---@return integer
function Stub.GetTrinketMultiplier(playerManager, ctx, TrinketID) end

---@param playerManager Component.PlayerManager
---@param notLevelGen boolean
---@return boolean
function Stub.HasFullHeartsSoulHearts(playerManager, notLevelGen) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param fromCache boolean
---@return Vector
function Stub.GetAveragedPlayerPos(playerManager, ctx, fromCache) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param param_1 Component.Entity.Player
---@param param_2 Component.Entity.Player
---@return unknown
function Stub.ReplacePlayer(playerManager, ctx, param_1, param_2) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
function Stub.AutoReassignControllers(playerManager, ctx) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
---@param playerType PlayerType | integer
---@return Component.Entity.Player
function Stub.FirstBirthrightOwner(playerManager, ctx, playerType) end

---@param playerManager Component.PlayerManager
---@return boolean
function Stub.IsCoopPlay(playerManager) end

---@param playerManager Component.PlayerManager
---@return integer
function Stub.GetNumCoopPlayersAlive(playerManager) end

---@param playerManager Component.PlayerManager
---@param ctx Context.Common
function Stub.ReviveCoopPlayers(playerManager, ctx) end

--#endregion

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