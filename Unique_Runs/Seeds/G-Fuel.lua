---@class Decomp.UniqueRuns.GFuel
local GFuel = {}
Decomp.UniqueRuns.Seed.GFuel = GFuel

require("Data.EntityPlayer")

local Data = Decomp.Data

local g_Seeds = Game():GetSeeds()

---@param player EntityPlayer
---@return integer gFuelAmount
function GFuel.GetGFuelAmount(player)
    if not g_Seeds:HasSeedEffect(SeedEffect.SEED_G_FUEL) then
        return 0
    end

    -- TODO
end

local s_AmountToWeapon = {
    [0] = -1,
    [1] = -1,
    [2] = 0,
    [3] = 1,
    [4] = 2,
    [5] = 3,
    [6] = 4,
    [7] = 5
}

---@param player EntityPlayer
---@return integer weaponType
function GFuel.GetGFuelWeaponType(player)
    local gFuelAmount = GFuel.GetGFuelAmount(player)

    local weapon = s_AmountToWeapon[gFuelAmount]
    if not weapon then
        local seed = g_Seeds:GetStartSeed() + gFuelAmount
        seed = seed > 1 and seed or 1
        local rng = RNG(); rng:SetSeed(seed, 15)

        weapon = rng:RandomInt(4) + 2
    end

    return weapon
end