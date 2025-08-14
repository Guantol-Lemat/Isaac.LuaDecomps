---@class Decomp.Class.EntityTear
local Class_Tear = {}

local Lib = {
    Math = require("Lib.Math"),
    Table = require("Lib.Table")
}

---@class Decomp.Object.EntityTear : Decomp.EntityTearObject, Decomp.Object.Entity
---@field _API Decomp.IGlobalAPI
---@field _ENV Decomp.EnvironmentObject
---@field _Object EntityTear
---@field m_Variant TearVariant | integer
---@field m_Height number
---@field m_CalcRenderHeight boolean -- Only set to false when initializing a tear with HydroBounce flag
---@field m_FallingSpeed number
---@field m_FallingAcceleration number

local s_ConstantRenderHeightTears = Lib.Table.CreateDictionary({
    TearVariant.FIRE, TearVariant.SWORD_BEAM, TearVariant.TECH_SWORD_BEAM
})

local s_GFuelTears = Lib.Table.CreateDictionary({
    TearVariant.NAIL, TearVariant.NAIL_BLOOD
})

---@param tear Decomp.Object.EntityTear
---@return boolean
local function should_calc_render_height(tear)
    return tear.m_FallingAcceleration <= 0.001 or tear.m_CalcRenderHeight
end

---@param tear Decomp.Object.EntityTear
---@param height number
---@return number
local function GetRenderHeight(tear, height)
    local tearVariant = tear.m_Variant

    if s_ConstantRenderHeightTears[tearVariant] and should_calc_render_height(tear) then
        return -8.0
    end

    local api = tear._API
    local game = api.Isaac.GetGame(tear._ENV)
    local seeds = api.Game.GetSeeds(game)

    if s_GFuelTears[tearVariant] and api.Seeds.HasSeedEffect(seeds, SeedEffect.SEED_G_FUEL) and should_calc_render_height(tear) then
        return -12.0
    end

    if not should_calc_render_height(tear) then
        return height
    end

    local t = tear.m_Height + 8.5
    t = math.max(t, 0.0)
    return (tear.m_Height * 0.5 - 15.0) + t * t
end

--#region Module

Class_Tear.get_render_height = GetRenderHeight

--#endregion