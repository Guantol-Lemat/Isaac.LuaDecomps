--#region Dependencies



--#endregion

---@class PersistentDataUtils
local Module = {}

---@param myContext PersistentDataContext.Unlocked
---@param persistentGameData PersistentDataComponent
---@param achievement Achievement | integer
---@return boolean
local function Unlocked(myContext, persistentGameData, achievement)
    if achievement == -2 then
        return false
    end

    if achievement < 0 then
        return true
    end

    if achievement <= 637 and (achievement == 0 or persistentGameData.m_achievements[achievement] or myContext.forceUnlock) then
        return true
    end

    return false
end

--#region Module

Module.Unlocked = Unlocked

--#endregion

return Module