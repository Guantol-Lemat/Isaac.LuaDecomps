---@class Interface.Seeds
local Interface = require("Isaac.Interface.Seeds")

--#region Stub

local Stub = {}

---@param seeds Component.Seeds
---@return integer
function Stub.GetStartSeed(seeds) end

---@param seeds Component.Seeds
---@param SeedEffect SeedEffect | integer
---@return boolean
function Stub.HasSeedEffect(seeds, SeedEffect) end

---@param seeds Component.Seeds
---@param string string
---@return string
function Stub.GetStartSeedString(seeds, string) end

---@param seeds Component.Seeds
function Stub.ClearSeedEffects(seeds) end

---@param ctx Context.Common
---@param str string
---@return boolean
function Stub.IsSpecialSeed(ctx, str) end

---@param seeds Component.Seeds
---@return integer
function Stub.GetNextSeed(seeds) end

---@param seeds Component.Seeds
---@return integer
function Stub.GetPlayerInitSeed(seeds) end

---@param seeds Component.Seeds
---@param param_1 unknown
function Stub.AddSeedEffect(seeds, param_1) end

---@param seeds Component.Seeds
---@param Stage LevelStage | integer
---@return integer
function Stub.GetStageSeed(seeds, Stage) end

---@param seeds Component.Seeds
function Stub.ClearStartSeed(seeds) end

---@param seeds Component.Seeds
---@return integer
function Stub.CountSeedEffects(seeds) end

---@param Seed1 integer
---@param Seed2 integer
---@return boolean
function Stub.IsSeedComboBanned(Seed1, Seed2) end

---@param seeds Component.Seeds
---@param SeedEffect integer
---@return integer
function Stub.RemoveSeedEffect(seeds, SeedEffect) end

---@return Component.Seeds
function Stub.New() end

---@param seeds Component.Seeds
---@return Component.Seeds
function Stub.Copy(seeds) end

---@param seeds Component.Seeds
---@param other Component.Seeds
function Stub.Assign(seeds, other) end

function Stub.InitSeedInfo() end

---@param ctx Context.Common
---@return integer
function Stub.CountUnlockedSeedEffects(ctx) end

---@param seeds Component.Seeds
---@return boolean
function Stub.AchievementUnlocksDisallowed(seeds) end

---@param seeds Component.Seeds
function Stub.Reset(seeds) end

---@param param_1 SeedEffect | integer
---@param param_2 SeedEffect | integer
function Stub.ban_seed_pair(param_1, param_2) end

---@param seeds Component.Seeds
---@param SeedEffect integer
---@return boolean
function Stub.CanAddSeedEffect(seeds, SeedEffect) end

---@param seeds Component.Seeds
---@param param_1 integer
function Stub.RemoveBlockingSeedEffects(seeds, param_1) end

---@param ctx Context.Common
---@param param_1 string
function Stub.GetSeedEffect(ctx, param_1) end

---@param str string
---@return boolean
function Stub.IsStringValidSeed(str) end

---@param string string
---@param Seed integer
function Stub.Seed2String(string, Seed) end

---@param str string
---@return integer
function Stub.String2Seed(str) end

---@param seeds Component.Seeds
---@param string string
function Stub.SetStartSeed(seeds, string) end

---@param seeds Component.Seeds
---@param seed integer
function Stub.SetStartSeed(seeds, seed) end

---@param seeds Component.Seeds
---@param CurrentChallenge Challenge | integer
function Stub.Restart(seeds, CurrentChallenge) end

---@param seeds Component.Seeds
---@param Stage StageType | integer
function Stub.ForgetStageSeed(seeds, Stage) end

--endregion

Interface.GetStartSeed = Stub.GetStartSeed
Interface.HasSeedEffect = Stub.HasSeedEffect
Interface.GetStartSeedString = Stub.GetStartSeedString
Interface.ClearSeedEffects = Stub.ClearSeedEffects
Interface.IsSpecialSeed = Stub.IsSpecialSeed
Interface.GetNextSeed = Stub.GetNextSeed
Interface.GetPlayerInitSeed = Stub.GetPlayerInitSeed
Interface.AddSeedEffect = Stub.AddSeedEffect
Interface.GetStageSeed = Stub.GetStageSeed
Interface.ClearStartSeed = Stub.ClearStartSeed
Interface.CountSeedEffects = Stub.CountSeedEffects
Interface.IsSeedComboBanned = Stub.IsSeedComboBanned
Interface.RemoveSeedEffect = Stub.RemoveSeedEffect
Interface.New = Stub.New
Interface.Copy = Stub.Copy
Interface.Assign = Stub.Assign
Interface.InitSeedInfo = Stub.InitSeedInfo
Interface.CountUnlockedSeedEffects = Stub.CountUnlockedSeedEffects
Interface.AchievementUnlocksDisallowed = Stub.AchievementUnlocksDisallowed
Interface.Reset = Stub.Reset
Interface.ban_seed_pair = Stub.ban_seed_pair
Interface.CanAddSeedEffect = Stub.CanAddSeedEffect
Interface.RemoveBlockingSeedEffects = Stub.RemoveBlockingSeedEffects
Interface.GetSeedEffect = Stub.GetSeedEffect
Interface.IsStringValidSeed = Stub.IsStringValidSeed
Interface.Seed2String = Stub.Seed2String
Interface.String2Seed = Stub.String2Seed
Interface.SetStartSeed = Stub.SetStartSeed
Interface.SetStartSeed = Stub.SetStartSeed
Interface.Restart = Stub.Restart
Interface.ForgetStageSeed = Stub.ForgetStageSeed