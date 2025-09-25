---@class VanillaColorUtils
local Module = {}

---@param color Color
---@return Color
local function Copy(color)
    local colorize = color:GetColorize()
    return Color(
        color.R, color.G, color.B, color.A,
        color.RO, color.GO, color.BO,
        colorize.R, colorize.G, colorize.B, colorize.A
    )
end

--#region Module

Module.Copy = Copy

--#endregion

return Module