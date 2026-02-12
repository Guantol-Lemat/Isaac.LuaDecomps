--#region Dependencies



--#endregion

---@param knife EntityKnifeComponent
local function Wiggle(knife)
end

---@param myContext Context.Room
---@param knife EntityKnifeComponent
local function HomeIn(myContext, knife)
end

---@param myContext Context.Room
---@param knife EntityKnifeComponent
local function ScreenWrap(myContext, knife)
end

local Module = {}

--#region Module

Module.Wiggle = Wiggle
Module.HomeIn = HomeIn
Module.ScreenWrap = ScreenWrap

--#endregion

return Module