--#region Dependencies



--#endregion

local s_ColorOverride = {}

local function PushColorOverride(color)
end

local function PopColorOverride()
end

local Module = {}

--#region Module

Module.PushColorOverride = PushColorOverride
Module.PopColorOverride = PopColorOverride

--#endregion

return Module