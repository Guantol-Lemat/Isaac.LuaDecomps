---@class Isaac.Color
---@field tint Isaac.Color.Tint
---@field offset Isaac.Color.Offset
---@field colorize Isaac.Color.Colorize

---@class Isaac.VarColor
---@field tint Isaac.Color.Tint?
---@field offset Isaac.Color.Offset?
---@field colorize Isaac.Color.Colorize?

---@alias Isaac.Color.Tint {R: number, G: number, B: number, A: number}
---@alias Isaac.Color.Offset {R: number, G: number, B: number}
---@alias Isaac.Color.Colorize {R: number, G: number, B: number, A: number}

---@param r number
---@param g number
---@param b number
---@param a number
---@param ro number
---@param go number
---@param bo number
---@param rc number
---@param gc number
---@param bc number
---@param ac number
local function NewColor(r, g, b, a, ro, go, bo, rc, gc, bc, ac)
    return {
        tint = {R = r, G = g, B = b, A = a},
        offset = {R = ro, G = go, B = bo},
        colorize = {R = rc, G = gc, B = bc, A = ac}
    }
end