---@class Decomp.Collectible.SoulLocket
local SoulLocket = {}
Decomp.Item.Collectible.SoulLocket = SoulLocket

local Data = Decomp.Data

local function apply_modifier(modifiers, soulLocketModifiers, index)
    modifiers[index] = modifiers[index] + soulLocketModifiers[index] * 0.2
end

---@param player EntityPlayer
---@param modifiers number[]
function SoulLocket.ApplyStatModifier(player, modifiers)
    local soulLocketModifiers = Data.Player.GetData(player).m_SoulLocketStatUps

    apply_modifier(modifiers, soulLocketModifiers, 1)
    apply_modifier(modifiers, soulLocketModifiers, 2)
    apply_modifier(modifiers, soulLocketModifiers, 3)
    apply_modifier(modifiers, soulLocketModifiers, 4)
    apply_modifier(modifiers, soulLocketModifiers, 5)
    apply_modifier(modifiers, soulLocketModifiers, 6)
end