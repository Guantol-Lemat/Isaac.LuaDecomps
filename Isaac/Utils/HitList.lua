--#region Dependencies



--#endregion

---@class Component.HitList
---@field m_list integer[]

---@return Component.HitList
local function New()
    ---@type Component.HitList
    return {
        m_list = {}
    }
end

---@param hitList Component.HitList
local function Clear(hitList)
    hitList.m_list = {}
end

---@param hitList Component.HitList
---@param entity Component.Entity
local function AddEntity(hitList, entity)
end

---@param hitList Component.HitList
---@param entity Component.Entity
---@return boolean
local function IsInHitList(hitList, entity)
end

---@class Utils.HitList
local Module = {}

--#region Module

Module.New = New
Module.Clear = Clear
Module.AddEntity = AddEntity
Module.IsInHitList = IsInHitList

--#endregion

return Module