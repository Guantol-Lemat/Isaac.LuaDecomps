---@class Decomp.Collectible.BingeEater
local BingeEater = {}

local Enums = require("General.Enums")

---@param collectibleNum integer
---@param modifiers number[]
---@param mod_1 integer
---@param mod_2 integer
local function apply_food_stat_multiplier(collectibleNum, modifiers, mod_1, mod_2)
    modifiers[mod_1] = modifiers[mod_1] + collectibleNum
    modifiers[mod_2] = modifiers[mod_2] + collectibleNum
    modifiers[Enums.eStatModifiers.SPEED] = modifiers[Enums.eStatModifiers.SPEED] - collectibleNum * 0.15
end

local s_FoodStatModifiers = {
    {CollectibleType.COLLECTIBLE_LUNCH, Enums.eStatModifiers.TEARS, Enums.eStatModifiers.RANGE},
    {CollectibleType.COLLECTIBLE_DINNER, Enums.eStatModifiers.TEARS, Enums.eStatModifiers.SHOT_SPEED},
    {CollectibleType.COLLECTIBLE_DESSERT, Enums.eStatModifiers.DAMAGE, Enums.eStatModifiers.SHOT_SPEED},
    {CollectibleType.COLLECTIBLE_BREAKFAST, Enums.eStatModifiers.RANGE, Enums.eStatModifiers.SHOT_SPEED},
    {CollectibleType.COLLECTIBLE_ROTTEN_MEAT, Enums.eStatModifiers.DAMAGE, Enums.eStatModifiers.RANGE},
    {CollectibleType.COLLECTIBLE_SNACK, Enums.eStatModifiers.SHOT_SPEED, Enums.eStatModifiers.LUCK},
    {CollectibleType.COLLECTIBLE_MIDNIGHT_SNACK, Enums.eStatModifiers.DAMAGE, Enums.eStatModifiers.SHOT_SPEED},
    {CollectibleType.COLLECTIBLE_SUPPER, Enums.eStatModifiers.TEARS, Enums.eStatModifiers.LUCK}
}

---@param player EntityPlayer
---@param modifiers number[]
local function ApplyStatModifiers(player, modifiers)
    for index, value in ipairs(s_FoodStatModifiers) do
        local collectibleNum = player:GetCollectibleNum(value[1], false)
        apply_food_stat_multiplier(collectibleNum, modifiers, value[2], value[3])
    end
end

---@param env Decomp.EnvironmentObject
---@param seed integer
local function GetRandomFoodCollectible(env, seed)
    local api = env._API

    local itemConfig = api.Isaac.GetItemConfig(env)
    local foodItems = api.ItemConfig.GetTaggedItems(itemConfig, ItemConfig.TAG_FOOD)

    local pool = {}
    for index, value in ipairs(foodItems) do
        if api.ItemConfigItem.IsCollectible(value) then
            table.insert(pool, value.ID)
        end
    end

    local itemCount = #pool
    if itemCount == 0 then
        return CollectibleType.COLLECTIBLE_BREAKFAST
    end

    local rng = RNG(); rng:SetSeed(seed, 9)
    return pool[rng:RandomInt(itemCount) + 1]
end

--#region Module

BingeEater.ApplyStatModifiers = ApplyStatModifiers
BingeEater.GetRandomFoodCollectible = GetRandomFoodCollectible

--#endregion

return BingeEater