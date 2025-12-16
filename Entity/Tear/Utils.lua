---@class TearUtils
local Module = {}

---@param tear EntityTearComponent
---@param flags BitSet128
local function HasAnyTearFlag(tear, flags)
    local bitset = tear.m_tearFlags & flags
    return bitset.l ~= 0 or bitset.h ~= 0
end

---@param tear EntityTearComponent
---@param flags BitSet128
local function ClearTearFlags(tear, flags)
    tear.m_tearFlags = tear.m_tearFlags & (~flags)
end

---@param context TearContext.SetHeight
---@param tear EntityTearComponent
---@param height number
local function SetHeight(context, tear, height)
end

--#region Module

Module.HasAnyTearFlag = HasAnyTearFlag
Module.ClearTearFlags = ClearTearFlags
Module.SetHeight = SetHeight

--#endregion

return Module