---@class Decomp.Collectible.CandyHeart
local CandyHeart = {}
Decomp.Item.Collectible.CandyHeart = CandyHeart

require("Data.EntityPlayer")

local Data = Decomp.Data

local function apply_modifier(modifiers, candyHeartModifiers, index)
    modifiers[index] = modifiers[index] + candyHeartModifiers[index] * 0.1
end

---@param player EntityPlayer
---@param modifiers number[]
function CandyHeart.ApplyStatModifier(player, modifiers)
    local candyHeartModifiers = Data.Player.GetData(player).m_CandyHeartStatUps

    apply_modifier(modifiers, candyHeartModifiers, 1)
    apply_modifier(modifiers, candyHeartModifiers, 2)
    apply_modifier(modifiers, candyHeartModifiers, 3)
    apply_modifier(modifiers, candyHeartModifiers, 4)
    apply_modifier(modifiers, candyHeartModifiers, 5)
    apply_modifier(modifiers, candyHeartModifiers, 6)
end