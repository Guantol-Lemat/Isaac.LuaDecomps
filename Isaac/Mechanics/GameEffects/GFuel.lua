--#region Dependencies

local ISeeds = require("Isaac.Interface.Seeds")
local IProceduralItemManager = require("Isaac.Interface.ProceduralItemManager")

--#endregion

---@param game Component.Game
---@param ctx Context.Common
---@param proceduralItemManager Component.ProceduralItemManager
local function CreateGFuelItem(game, ctx, proceduralItemManager)
    local gFuel = ISeeds.HasSeedEffect(game.m_seeds, SeedEffect.SEED_G_FUEL)
    if not gFuel then
        return
    end

    IProceduralItemManager.CreateProceduralItem(proceduralItemManager, ctx, 1, 0)
end

---@class GameEffects.GFuel
local Module = {}

--#region Module

Module.CreateGFuelItem = CreateGFuelItem

--#endregion

return Module