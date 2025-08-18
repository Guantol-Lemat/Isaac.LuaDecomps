---@class EntitySaveStateLogic
local Module = {}

---@param context Context
---@param entity EntityComponent
---@param saveState EntitySaveStateComponent
---@return EntitySaveStateComponent
local function SaveState(context, entity, saveState)
    saveState.type = entity.m_type
    saveState.variant = entity.m_variant
    saveState.subtype = entity.m_subtype
    saveState.initSeed = entity.m_initSeed

    return saveState
end

--#region Module

Module.SaveState = SaveState

--#endregion

return Module