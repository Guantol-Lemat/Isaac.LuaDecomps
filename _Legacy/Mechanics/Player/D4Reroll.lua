--#region Dependencies

local TemporaryEffectsUtils = require("Game.TemporaryEffects.Utils")
local PlayerUtils = require("Entity.Player.Utils")
local PlayerCostume = require("Entity.Player.Costume")
local PlayerInventory = require("Mechanics.Player.Inventory")

--#endregion

---@param player Component.Entity.Player
---@param rng RNG
---@param includeActiveItems boolean
local function RerollAllCollectibles(player, rng, includeActiveItems)
end

local Module = {}

--#region Module

Module.RerollAllCollectibles = RerollAllCollectibles

--#endregion

return Module