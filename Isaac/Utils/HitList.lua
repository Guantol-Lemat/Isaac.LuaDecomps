--#region Dependencies



--#endregion

---@class Component.HitList
---@field m_list integer[]

---@param hitList Component.HitList
local function Clear(hitList)
    hitList.m_list = {}
end

---@class Utils.HitList
local Module = {}

--#region Module

Module.Clear = Clear

--#endregion

return Module