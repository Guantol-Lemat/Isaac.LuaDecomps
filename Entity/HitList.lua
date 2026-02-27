---@param entity EntityComponent
---@return integer
local function get_hit_list_index(entity)
end

---@param hitList HitListComponent
---@param index integer
local function insert(hitList, index)
end

---@param hitList HitListComponent
---@param entity EntityComponent
local function InsertEntity(hitList, entity)
end

---@param hitList HitListComponent
---@param entity EntityComponent
---@return boolean
local function Contains(hitList, entity)
end

---@param hitList HitListComponent
local function Clear(hitList)
    for i = #hitList, 1, -1 do
        hitList[i] = nil
    end
end

local Module = {}

--#region Module

Module.InsertEntity = InsertEntity
Module.Contains = Contains
Module.Clear = Clear

--#endregion

return Module