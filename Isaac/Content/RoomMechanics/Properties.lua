--#region Dependencies

local ITemporaryEffects = require("Isaac.Interface.TemporaryEffects")

--#endregion

---@param room Component.Room
---@return boolean
local function IsGlitchRendering(room)
    return ITemporaryEffects.HasCollectibleEffect(room.m_temporaryEffects, CollectibleType.COLLECTIBLE_DATAMINER)
end

---@class Content.Room.Properties
local Module = {}

--#region Module

Module.IsGlitchRendering = IsGlitchRendering

--#endregion

return Module