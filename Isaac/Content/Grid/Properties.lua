--#region Dependencies



--#endregion

---@param gridEntity Component.GridEntity
---@return boolean
local function IsBackgroundLayer(gridEntity)
    local entType = gridEntity.m_desc.m_type
    return entType == GridEntityType.GRID_DECORATION
end

---@param gridEntity Component.GridEntity
---@return boolean
local function IsGroundLayer(gridEntity)
    local desc = gridEntity.m_desc
    local entType = desc.m_type

    return (entType == GridEntityType.GRID_PIT)
        or (entType == GridEntityType.GRID_TRAPDOOR or entType == GridEntityType.GRID_STAIRS)
        or (entType == GridEntityType.GRID_POOP and desc.m_state == 1000)
end

---@param gridEntity Component.GridEntity
---@return boolean
local function IsDoorLayer(gridEntity)
    local entType = gridEntity.m_desc.m_type
    return entType == GridEntityType.GRID_DOOR
end

---@param gridEntity Component.GridEntity
---@param useWaterGraphics boolean
---@return boolean
local function IsNormalLayer(gridEntity, useWaterGraphics)
    return not IsBackgroundLayer(gridEntity)
        and not IsGroundLayer(gridEntity)
        and not IsDoorLayer(gridEntity)
        and ((useWaterGraphics == false or (gridEntity:GetWaterClipInfo().flags & WaterClipFlag.DISABLE_RENDER_ABOVE_WATER) == 0))
end

---@param gridEntity Component.GridEntity
---@return boolean
local function HasTop(gridEntity)
    return gridEntity.m_desc.m_type == GridEntityType.GRID_PILLAR
end

---@class Content.Grid.Properties
local Module = {}

--#region Module

Module.IsBackgroundLayer = IsBackgroundLayer
Module.IsGroundLayer = IsGroundLayer
Module.IsDoorLayer = IsDoorLayer
Module.IsNormalLayer = IsNormalLayer
Module.HasTop = HasTop

--#endregion

return Module