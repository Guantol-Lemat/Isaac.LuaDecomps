--#region Dependencies



--#endregion

---@class SfxUtils
local Module = {}

local function PlaySound()
end

---@param sfxManager SfxManagerComponent
---@param sound SoundEffect | integer
local function Stop(sfxManager, sound)
end

--#region Module

Module.PlaySound = PlaySound
Module.Stop = Stop

--#endregion

return Module