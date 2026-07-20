---@class Interface.SoundEffects
local Interface = require("Isaac.Interface.SoundEffects")

--#region Stub

local Stub = {}

---@param sfx Component.SoundEffects
---@param ctx Context.Common
---@param Id SoundEffect | integer
function Stub.Preload(sfx, ctx, Id) end

---@param sfx Component.SoundEffects
---@param filename string
---@param ismod boolean
function Stub.LoadConfig(sfx, filename, ismod) end

---@param sfx Component.SoundEffects
---@param ctx Context.Common
---@param ID SoundEffect | integer
---@param Volume number
---@param FrameDelay integer
---@param Loop boolean
---@param Pitch number
---@param Pan number
function Stub.Play(sfx, ctx, ID, Volume, FrameDelay, Loop, Pitch, Pan) end

---@param sfx Component.SoundEffects
---@param ctx Context.Common
---@param Id SoundEffect | integer
---@param Volume number
function Stub.AdjustVolume(sfx, ctx, Id, Volume) end

---@param sfx Component.SoundEffects
---@param Id SoundEffect | integer
---@param Pitch number
function Stub.AdjustPitch(sfx, Id, Pitch) end

---@param sfx Component.SoundEffects
---@param Id SoundEffect | integer
function Stub.Stop(sfx, Id) end

---@param sfx Component.SoundEffects
function Stub.StopLoopingSounds(sfx) end

---@param sfx Component.SoundEffects
---@param ctx Context.Common
function Stub.UpdateVolume(sfx, ctx) end

---@param sfx Component.SoundEffects
---@param Id SoundEffect | integer
---@return boolean
function Stub.IsPlaying(sfx, Id) end

---@param sfx Component.SoundEffects
---@param ctx Context.Common
---@param Id SoundEffect | integer
---@param Volume number
---@param Pitch number
function Stub.SetAmbientSound(sfx, ctx, Id, Volume, Pitch) end

---@param sfx Component.SoundEffects
---@param Id SoundEffect | integer
---@return number
function Stub.GetAmbientSoundVolume(sfx, Id) end

---@param sfx Component.SoundEffects
function Stub.Destroy(sfx) end

---@param sfx Component.SoundEffects
function Stub.unk_mod_related(sfx) end

--#endregion

Interface.Preload = Stub.Preload
Interface.LoadConfig = Stub.LoadConfig
Interface.Play = Stub.Play
Interface.AdjustVolume = Stub.AdjustVolume
Interface.AdjustPitch = Stub.AdjustPitch
Interface.Stop = Stub.Stop
Interface.StopLoopingSounds = Stub.StopLoopingSounds
Interface.UpdateVolume = Stub.UpdateVolume
Interface.IsPlaying = Stub.IsPlaying
Interface.SetAmbientSound = Stub.SetAmbientSound
Interface.GetAmbientSoundVolume = Stub.GetAmbientSoundVolume
Interface.Destroy = Stub.Destroy
Interface.unk_mod_related = Stub.unk_mod_related