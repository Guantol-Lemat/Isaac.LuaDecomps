---@class SoundRules
local Module = {}

---@param context Context
---@param manager SFXManagerComponent
---@param id SoundEffect
---@param volume number
---@param frameDelay integer
---@param loop boolean
---@param pitch number
local function Play(context, manager, id, volume, frameDelay, loop, pitch)
end

--#region Module

Module.Play = Play

--#endregion

return Module