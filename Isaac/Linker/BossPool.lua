---@class Interface.BossPool
local Interface = require("Isaac.Interface.BossPool")

local BossPoolInit = require("Isaac.Gameplay.BossPool.Init")
local BossPoolLoad = require("Isaac.Gameplay.BossPool.Load")

--#region Stub

local Stub = {}

---@param bossPool Component.BossPool
---@param id BossType | integer
---@return boolean
function Stub.WasBossRemoved(bossPool, id) end

---@param bossPool Component.BossPool
function Stub.destructor(bossPool) end

---@param bossPool Component.BossPool
function Stub.CommitLevelBlacklist(bossPool) end

---@param bossPool Component.BossPool
---@param ctx Context.Common
---@param pool Component.BossPool.Pool
---@param r number
---@return Component.BossPool.Pool.Boss
function Stub.PickBoss(bossPool, ctx, pool, r) end

---@param bossPool Component.BossPool
---@param ctx Context.Common
---@param leveltype LevelStage | integer
---@param levelvariant StageType | integer
---@param challenge_unused_qqq Component.ChallengeParam
---@return BossType | integer
function Stub.GetBossId(bossPool, ctx, leveltype, levelvariant, challenge_unused_qqq) end

---@param bossPool Component.BossPool
---@param param_1 Component.GameState.BossPool
function Stub.RestoreGameState(bossPool, param_1) end

---@param bossPool Component.BossPool
---@param param_1 Component.GameState.BossPool
function Stub.StoreGameState(bossPool, param_1) end

---@param bossPool Component.BossPool
function Stub.UnkBossPoolMethod(bossPool) end

--#endregion

Interface.WasBossRemoved = Stub.WasBossRemoved
Interface.destructor = Stub.destructor
Interface.Init = BossPoolInit.Init
Interface.CommitLevelBlacklist = Stub.CommitLevelBlacklist
Interface.LoadPools = BossPoolLoad.LoadPools
Interface.PickBoss = Stub.PickBoss
Interface.GetBossId = Stub.GetBossId
Interface.RestoreGameState = Stub.RestoreGameState
Interface.StoreGameState = Stub.StoreGameState
Interface.UnkBossPoolMethod = Stub.UnkBossPoolMethod