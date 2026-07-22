---@class Interface.Seeds
local Interface = require("Isaac.Interface.Seeds")

local SeedsStringConversion = require("Isaac.Gameplay.Manager.Seeds.StringConversion")
local SeedsMisc = require("Isaac.Gameplay.Manager.Seeds.SeedsMisc")

--#region Stub

local Stub = {}

---@param ctx Context.Common
---@param str string
---@return boolean
function Stub.IsSpecialSeed(ctx, str) end

---@param seeds Component.Seeds
---@return integer
function Stub.GetPlayerInitSeed(seeds) end

---@param seeds Component.Seeds
---@param Stage LevelStage | integer
---@return integer
function Stub.GetStageSeed(seeds, Stage) end

---@param Seed1 integer
---@param Seed2 integer
---@return boolean
function Stub.IsSeedComboBanned(Seed1, Seed2) end

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
---@param name string
function Stub.GetSeedEffect(ctx, name) end

---@param seeds Component.Seeds
---@param CurrentChallenge Challenge | integer
function Stub.Restart(seeds, CurrentChallenge) end

---@param seeds Component.Seeds
---@param Stage StageType | integer
function Stub.ForgetStageSeed(seeds, Stage) end

--#endregion

Interface.GetStartSeed = SeedsMisc.GetStartSeed
Interface.HasSeedEffect = SeedsMisc.HasSeedEffect
Interface.GetStartSeedString = SeedsMisc.GetStartSeedString
Interface.ClearSeedEffects = SeedsMisc.ClearSeedEffects
Interface.IsSpecialSeed = Stub.IsSpecialSeed
Interface.GetNextSeed = SeedsMisc.GetNextSeed
Interface.GetPlayerInitSeed = Stub.GetPlayerInitSeed
Interface.AddSeedEffect = SeedsMisc.AddSeedEffect
Interface.GetStageSeed = Stub.GetStageSeed
Interface.ClearStartSeed = SeedsMisc.ClearStartSeed
Interface.CountSeedEffects = SeedsMisc.CountSeedEffects
Interface.IsSeedComboBanned = Stub.IsSeedComboBanned
Interface.RemoveSeedEffect = SeedsMisc.RemoveSeedEffect
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
Interface.IsStringValidSeed = SeedsStringConversion.IsStringValidSeed
Interface.Seed2String = SeedsStringConversion.Seed2String
Interface.String2Seed = SeedsStringConversion.String2Seed
Interface.SetStartSeed_String = SeedsMisc.SetStartSeed_String
Interface.SetStartSeed = SeedsMisc.SetStartSeed
Interface.Restart = Stub.Restart
Interface.ForgetStageSeed = Stub.ForgetStageSeed