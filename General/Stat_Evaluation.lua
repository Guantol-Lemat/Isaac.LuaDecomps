---@class Decomp.Class.RNG
local StatEvaluation = {}
Decomp.StatEvaluation = StatEvaluation

local Math = require("Lib.Math")
local Table = require("Lib.Table")

require("Data.EntityPlayer")
require("Unique_Runs.Seeds.G-Fuel")

require("Items.Collectible.Binge_Eater")
require("Items.Collectible.Candy_Heart")
require("Items.Collectible.Soul_Locket")
require("Items.Collectible.Purity")

local Lib = Decomp.Lib
local Data = Decomp.Data
local Seeds = Decomp.UniqueRuns.Seed
local Collectible = Decomp.Item.Collectible

local g_Game = Game()
local g_Level = g_Game:GetLevel()

---@param player EntityPlayer
---@return boolean hasEffect
local function has_vibrant_bulb_effect(player)
    local activeMaxCharge = player:GetActiveMaxCharge(ActiveSlot.SLOT_PRIMARY)
    return activeMaxCharge > 0 and player:GetTotalActiveCharge(ActiveSlot.SLOT_PRIMARY) >= activeMaxCharge
end

---@param player EntityPlayer
---@return boolean hasEffect
local function has_dim_bulb_effect(player)
    return player:GetActiveMaxCharge(ActiveSlot.SLOT_PRIMARY) > 0 and player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) == 0
end

---@param player EntityPlayer
---@param collectibleType CollectibleType
---@param onlyCountTrueItems boolean
---@return integer totalCount
local function get_total_collectible_num(player, collectibleType, onlyCountTrueItems)
    return player:GetCollectibleNum(collectibleType, onlyCountTrueItems) + player:GetEffects():GetCollectibleEffectNum(collectibleType)
end

---@param player EntityPlayer
---@param collectibleType CollectibleType
---@param ignoreModifiers boolean
---@return boolean hasCollectible
local function has_collectible_or_effect(player, collectibleType, ignoreModifiers)
    return player:HasCollectible(collectibleType, ignoreModifiers) or player:GetEffects():HasCollectibleEffect(collectibleType)
end

---@param player EntityPlayer
---@return Weapon? weapon
local function get_current_weapon(player)
    local weapon = player:GetWeapon(0) -- Backup Weapon
    if not weapon then
        weapon = player:GetWeapon(1) -- Primary Weapon
    end

    return weapon
end

---@param player EntityPlayer
---@return Entity? entity
local function get_found_soul_owner(player)
    if player.Variant ~= 1 then
        return nil
    end

    local owner = player.Parent
    if not owner or owner.Type ~= EntityType.ENTITY_PLAYER then
        owner = Isaac.GetPlayer(0)
    end

    return owner
end

--#region StatModifiers

local function swap_elements(table, i, j)
    local temp = table[j]
    table[j] = table[i]
    table[i] = temp
end

---@param modifiers number[]
---@param rng RNG
local function shuffle_modifiers(modifiers, rng)
    local count = #modifiers

    for i = 1, count - 1, 1 do
        local randomIndex = rng:RandomInt(count - (i - 1))
        swap_elements(modifiers, i, randomIndex + i)
    end
end

---@param rng RNG
---@param statModifiers number[]
local function apply_stat_modifiers_experimental_treatment(statModifiers, rng)
    local modifiers = {1.0, 1.0, 1.0, -1.0, -1.0, -1.0}
    shuffle_modifiers(modifiers, rng)
    for i = 1, 6, 1 do
        statModifiers[i] = statModifiers[i] + modifiers[i]
    end
    return modifiers
end

---@param player EntityPlayer
---@return number[] statModifiers
function StatEvaluation.GetStatModifiers(player)
    local effects = player:GetEffects()
    local currentRoomDesc = g_Level:GetCurrentRoomDesc()

    local statModifiers = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}

    if effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_EXPERIMENTAL_TREATMENT) then
        local seed = currentRoomDesc and currentRoomDesc.SpawnSeed or 0
        local rng = RNG(); rng:SetSeed(seed, 19)
        apply_stat_modifiers_experimental_treatment(statModifiers, rng)
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER, false) then
        Collectible.BingeEater.ApplyStatModifiers(player, statModifiers)
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_CANDY_HEART, false) then
        Collectible.CandyHeart.ApplyStatModifier(player, statModifiers)
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_SOUL_LOCKET, false) then
        Collectible.SoulLocket.ApplyStatModifier(player, statModifiers)
    end

    return statModifiers
end

--#endregion

--#region StatGainMultiplier

function StatEvaluation.GetStatGainMultiplier(player)
    local multiplier = 1.0
    local playerType = player:GetPlayerType()

    multiplier = multiplier + player:GetTrinketMultiplier(TrinketType.TRINKET_CRACKED_CROWN) * 0.2
    if playerType == PlayerType.PLAYER_BETHANY_B then
        multiplier = multiplier * 0.75
    end

    return multiplier
end

--#endregion

--#region EvaluateTearDelay

local playerTearDelay = {
    [PlayerType.PLAYER_BLUEBABY_B] = -0.35,
    [PlayerType.PLAYER_EVE_B] = -0.5,
    [PlayerType.PLAYER_SAMSON] = -1.0,
    [PlayerType.PLAYER_SAMSON_B] = -1.0,
    [PlayerType.PLAYER_AZAZEL] = 0.5,
    [PlayerType.PLAYER_APOLLYON] = -0.5,
    [PlayerType.PLAYER_JACOB] = 0.27777,
    [PlayerType.PLAYER_JACOB_B] = 0.27777,
    [PlayerType.PLAYER_JACOB2_B] = 0.27777,
    [PlayerType.PLAYER_ESAU] = -0.99648997,
    [PlayerType.PLAYER_LAZARUS] = -0.99648997,
    default = 0.0
}

---@param player EntityPlayer
---@param statModifier number
---@return number
local function post_process_tears_up_modifier(player, statModifier)
    statModifier = statModifier * 0.5

    local playerType = player:GetPlayerType()
    if playerType == PlayerType.PLAYER_EDEN or playerType == PlayerType.PLAYER_EDEN_B then
        statModifier = statModifier + player:GetEdenFireDelay()
    end

    if statModifier < 0.0 then
        statModifier = statModifier * 0.68665498 -- reduce effectiveness of negative modifier
    end

    return statModifier
end

---this function aims to do the following things (aside from converting the raw tears up stat into the final fire delay)
---1. It applies the base fire delay of 10 (if tearsUp is 0 the result of this function is 10)
---2. It makes positive tears up have diminishing returns, making subsequent increases less effective
---3. It makes negative tears up have much more of an impact over positive tears up stat.
---4. It makes small negative values (-1.0, 0.0) have an even stronger impact on the final fire delay
---@param tearsUp number
---@return number fireDelay
local function scale_raw_tears_up_into_fire_delay(tearsUp)
    local positiveEffect = math.max(tearsUp * 1.3 + 1.0, 0.0)
    local negativeEffect = math.min(tearsUp, 0.0)

    return (16.0 - math.sqrt(positiveEffect) * 6.0) - negativeEffect * 6.0
end

---@param fireDelay number
---@return number tearsUp
local function convert_fire_delay_to_tears_up(fireDelay)
    return 30.0 / (fireDelay + 1.0)
end

---@param player EntityPlayer
---@param tearsUp number
---@return number newTearsUp
local function apply_decap_belial_tears_up(player, tearsUp)
    local weapon = get_current_weapon(player)
    if not weapon then
        return tearsUp
    end

    local weaponType = weapon:GetWeaponType()
    if weaponType == WeaponType.WEAPON_LUDOVICO_TECHNIQUE or weaponType == WeaponType.WEAPON_KNIFE or weaponType == WeaponType.WEAPON_UMBILICAL_WHIP then
        return tearsUp
    end

    return tearsUp * 3.0
end

local BASE_FIRE_DELAY = 10
local BASE_TEARS_UP = convert_fire_delay_to_tears_up(BASE_FIRE_DELAY)

---@param player EntityPlayer
---@param statModifier number
function StatEvaluation.EvaluateFireDelay(player, statModifier, statGainMultiplier)
    local playerType = player:GetPlayerType()
    local effects = player:GetEffects()
    local playerData = Data.Player.GetData(player)

    local tearsUp = 0.0

    if not player:HasCurseMistEffect() and not player:IsCoopGhost() then
        tearsUp = (playerData.m_PillEffectUses[PillEffect.PILLEFFECT_TEARS_UP]) * 0.5 - (playerData.m_PillEffectUses[PillEffect.PILLEFFECT_TEARS_DOWN] * 0.4)
        tearsUp = tearsUp * 0.7
    end

    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_WIRE_COAT_HANGER, false) * 0.7
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_PACT, false) * 0.7
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_EDENS_BLESSING, false) * 0.7
    tearsUp = tearsUp + get_total_collectible_num(player, CollectibleType.COLLECTIBLE_SAD_ONION, false) * 0.7
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MR_DOLLY, false) * 0.7
    tearsUp = tearsUp + get_total_collectible_num(player, CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN, false) * 0.7
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_TORN_PHOTO, false) * 0.7
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN, false) * 0.7
    tearsUp = tearsUp + get_total_collectible_num(player, CollectibleType.COLLECTIBLE_BLUE_CAP, false) * 0.7
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_TOOTH_PICKS, false) * 0.7
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MARKED, false) * 0.7
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_DIVORCE_PAPERS, false) * 0.7
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION, false) * 0.7
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_PLUTO, false) * 0.7
    tearsUp = tearsUp + get_total_collectible_num(player, CollectibleType.COLLECTIBLE_NUMBER_ONE, false) * 1.5
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SAUSAGE, false) * 0.5
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BAR_OF_SOAP, false) * 0.5
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SCREW, false) * 0.5
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_OUIJA_BOARD, false) * 0.5
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_ROSARY, false) * 0.5
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SQUEEZY, false) * 0.4
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SACRED_HEART, false) * -0.4
    tearsUp = tearsUp + player:GetTrinketMultiplier(TrinketType.TRINKET_OUROBOROS_WORM) * 0.4
    tearsUp = tearsUp + player:GetTrinketMultiplier(TrinketType.TRINKET_HOOK_WORM) * 0.4
    tearsUp = tearsUp + player:GetTrinketMultiplier(TrinketType.TRINKET_RING_WORM) * 0.4
    tearsUp = tearsUp + player:GetTrinketMultiplier(TrinketType.TRINKET_WIGGLE_WORM) * 0.4
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SMB_SUPER_FAN, false) * 0.2
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_HALO, false) * 0.2
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SMALL_ROCK, false) * 0.2
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_GODHEAD, false) * -0.3
    tearsUp = tearsUp + get_total_collectible_num(player, CollectibleType.COLLECTIBLE_DEATHS_TOUCH, false) * -0.3
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BINKY, false) * 0.75
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_APPLE, false) * 0.3
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_ANALOG_STICK, false) * 0.35
    tearsUp = tearsUp + (has_collectible_or_effect(player, CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN, false) and 1.0 or 0.0)
    tearsUp = tearsUp + ((player:HasTrinket(TrinketType.TRINKET_VIBRANT_BULB, false) and has_vibrant_bulb_effect(player)) and 0.2 or 0.0)
    tearsUp = tearsUp + ((player:HasTrinket(TrinketType.TRINKET_DIM_BULB, false) and has_dim_bulb_effect(player)) and 0.5 or 0.0)

    tearsUp = tearsUp + (playerTearDelay[playerType] or playerTearDelay.default)

    local cannotTriggerAzazelStumpBuff = Table.CreateDictionary({PlayerType.PLAYER_AZAZEL, PlayerType.PLAYER_SAMSON, PlayerType.PLAYER_SAMSON_B, PlayerType.PLAYER_BLUEBABY_B, PlayerType.PLAYER_APOLLYON_B, PlayerType.PLAYER_EVE_B})
    if not cannotTriggerAzazelStumpBuff[playerType] and effects:HasTrinketEffect(TrinketType.TRINKET_AZAZELS_STUMP) then
        tearsUp = tearsUp + playerTearDelay[PlayerType.PLAYER_AZAZEL]
    end

    tearsUp = tearsUp + post_process_tears_up_modifier(player, statModifier)

    if playerType == PlayerType.PLAYER_KEEPER and player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
        tearsUp = tearsUp - 1.9
    end

    if playerType == PlayerType.PLAYER_KEEPER_B and player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
        tearsUp = tearsUp - 2.2
    end

    tearsUp = tearsUp + (effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) and -1.9 or 0.0)
    tearsUp = tearsUp + (player:HasPlayerForm(PlayerForm.PLAYERFORM_BABY) and -0.3 or 0.0)

    if playerData.m_UnkFireDelayCacheCooldown > 0 then
        tearsUp = tearsUp + 1.0
    end

    local fireDelay = scale_raw_tears_up_into_fire_delay(tearsUp)
    fireDelay = math.max(fireDelay, 5.0)
    tearsUp = convert_fire_delay_to_tears_up(fireDelay)

    -- POST TEAR CAP
    tearsUp = tearsUp * (player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_DROPS, false) and 1.2 or 1.0)

    if statGainMultiplier ~= 1.0 and tearsUp > BASE_TEARS_UP then
        tearsUp = tearsUp + (tearsUp - BASE_TEARS_UP) * (statGainMultiplier - 1.0)
    end

    tearsUp = tearsUp + get_total_collectible_num(player, CollectibleType.COLLECTIBLE_GUILLOTINE, false) * 0.5
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MOMS_PERFUME, false) * 0.5
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_CRICKETS_BODY, false) * 0.5
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_CAPRICORN, false) * 0.5
    tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_PISCES, false) * 0.5
    tearsUp = tearsUp + (player:GetZodiacEffect() == CollectibleType.COLLECTIBLE_CAPRICORN and 0.5 or 0.0)
    tearsUp = tearsUp + (player:GetZodiacEffect() == CollectibleType.COLLECTIBLE_PISCES and 0.5 or 0.0)
    tearsUp = tearsUp + ((not player:HasCurseMistEffect() and not player:IsCoopGhost()) and player:GetFireDelayModifier() * 0.5 or 0.0)
    tearsUp = tearsUp + player:GetTrinketMultiplier(TrinketType.TRINKET_CANCER) * 1.0
    tearsUp = tearsUp + Collectible.Purity.GetTearsUp(player)
    tearsUp = tearsUp + get_total_collectible_num(player, CollectibleType.COLLECTIBLE_TRACTOR_BEAM, false) * 1.0
    tearsUp = tearsUp + playerData.m_UnkWord * 0.4
    tearsUp = tearsUp + (effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_PRINCES_CROWN) and 2.0 or 0.0)
    tearsUp = tearsUp + effects:GetNullEffectNum(NullItemID.ID_REVERSE_EMPRESS) * 1.5
    tearsUp = tearsUp + effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_WAVY_CAP) * 0.75
    tearsUp = tearsUp + effects:GetNullEffectNum(NullItemID.ID_WAVY_CAP_1) * 0.3

    if not player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
        tearsUp = tearsUp + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_ANTI_GRAVITY, false) * 1.0
    end

    tearsUp = tearsUp + Seeds.GFuel.GetGFuelAmount(player) * 0.5

    local gFuelWeapon = Seeds.GFuel.GetGFuelWeaponType(player)
    if gFuelWeapon == 3 or gFuelWeapon == 5 then
        tearsUp = tearsUp * 0.4
    elseif gFuelWeapon == 4 then
        tearsUp = tearsUp * 5.5
    end

    tearsUp = tearsUp + effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_MILK) * 1.0

    local itHurtsEffects = effects:GetNullEffectNum(NullItemID.ID_IT_HURTS)
    if itHurtsEffects > 0 then
        tearsUp = tearsUp + 0.8 + itHurtsEffects * 0.4
    end

    tearsUp = tearsUp + effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_PASCHAL_CANDLE) * 0.4

    local LunaEffects = effects:GetNullEffectNum(NullItemID.ID_LUNA)
    if LunaEffects > 0 then
        tearsUp = tearsUp + 0.5 + LunaEffects * 0.5
    end

    tearsUp = tearsUp + 0.0 -- ProceduralItemInventory.FireDelay
    tearsUp = tearsUp + (playerData.m_LiquidPoopFrameCount > 0 and 1.5 or 0.0)
    tearsUp = tearsUp + effects:GetNullEffectNum(NullItemID.ID_CAMO_BOOST) * 0.25

    if not player:HasCollectible(CollectibleType.COLLECTIBLE_20_20, false) then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER, false) or (player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS, false) and not player:HasWeaponType(WeaponType.WEAPON_FETUS)) then
            tearsUp = tearsUp * 0.42
        elseif has_collectible_or_effect(player, CollectibleType.COLLECTIBLE_INNER_EYE, false) or effects:HasNullEffect(NullItemID.ID_REVERSE_HANGED_MAN) then
            tearsUp = tearsUp * 0.51
        end
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC, false) and (player:HasWeaponType(WeaponType.WEAPON_TEARS) or player:HasWeaponType(WeaponType.WEAPON_LASER) or player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS)) then
        tearsUp = tearsUp / 3.0
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA, false) then
        if not player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC, false) and player:HasWeaponType(WeaponType.WEAPON_TEARS) then
            tearsUp = tearsUp * 0.5
        end

        local reductionFactor = player:HasWeaponType(WeaponType.WEAPON_FETUS) and 4.0 or 10.0
        tearsUp = tearsUp - (tearsUp * reductionFactor) / ((30.0 / tearsUp) + reductionFactor)

        reductionFactor = player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) and 20.0 or (player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) and 10.0 or 0.0)
        if player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS) then
            reductionFactor = reductionFactor * 0.5
        end
        tearsUp = tearsUp - (tearsUp * reductionFactor) / ((30.0 / tearsUp) + reductionFactor) -- Unless you have Brimstone or Dr.Fetus this has no effect
    end

    if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
        tearsUp = tearsUp / 3.0
        if (playerType == PlayerType.PLAYER_AZAZEL or effects:HasTrinketEffect(TrinketType.TRINKET_AZAZELS_STUMP)) and player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE, false) then
            tearsUp = tearsUp / 1.25
        end
    elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
        tearsUp = tearsUp / 2.5
    elseif player:HasWeaponType(WeaponType.WEAPON_BONE) then
        tearsUp = tearsUp * 0.5
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2, false) then
        tearsUp = tearsUp / 1.5
    end

    if playerType == PlayerType.PLAYER_EVE_B then
        tearsUp = tearsUp * 0.66
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_EVES_MASCARA, false) then
        tearsUp = tearsUp * 0.66
    end

    if player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS) then
        tearsUp = tearsUp / 4.3
    elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) and player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG, false) then
        tearsUp = tearsUp / 3.1
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK, false) then
        tearsUp = tearsUp * 4.0
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK, false) then
        tearsUp = tearsUp * 5.5
    end

    if playerData.m_HallowedGroundCountdown ~= 0 then
        tearsUp = tearsUp * 2.5
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_EPIPHORA) and playerData.m_EpiphoraCharge > 0 then
        tearsUp = tearsUp * (playerData.m_EpiphoraCharge / 180.0 + 1.0)
    end

    if playerData.m_PeeBurstCooldown > 0 then
        tearsUp = tearsUp * ((playerData.m_PeeBurstCooldown * 5.0) / playerData.m_MaxPeeBurtsCooldown + 1.0)
    end

    if effects:HasNullEffect(NullItemID.ID_REVERSE_CHARIOT) then
        tearsUp = tearsUp * 4.0
    elseif effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_DECAP_ATTACK) and player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
        tearsUp = apply_decap_belial_tears_up(player, tearsUp)
    end

    if effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK) then
        tearsUp = tearsUp + 2.0
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_BLOODY_GUST, false) and true then -- Check if TemporaryEffects are not Disabled
        local hits = Math.Clamp(playerData.m_BloodyGustHits, 0, 6)
        tearsUp = tearsUp + (hits * 0.05 * hits + hits * 0.2)
    end

    gFuelWeapon = Seeds.GFuel.GetGFuelWeaponType(player)
    if gFuelWeapon == 2 then
        tearsUp = tearsUp * 0.75
    end

    fireDelay = 30.0 / (tearsUp * player:GetD8FireDelayModifier()) - 1.0
    if player.Variant == 1 then
        local owner = get_found_soul_owner(player)
        if owner and owner:ToPlayer() and not owner:ToPlayer():CanShoot() then
            fireDelay = BASE_FIRE_DELAY
        end
    end

    if player.Variant == 0 and g_Game.Challenge ~= 0 then
        local challengeParams = g_Game:GetChallengeParams()
        if challengeParams.GetMinFireRate() > 0 then
            fireDelay = math.max(challengeParams.GetMinFireRate(), fireDelay)
        end
    end

    player.MaxFireDelay = fireDelay
    Isaac.RunCallback(ModCallbacks.MC_EVALUATE_CACHE, player, CacheFlag.CACHE_FIREDELAY)

    player.MaxFireDelay = math.max(-0.75, fireDelay)

    --- Deathmatch specific stuff, but we don't care about those, nor can we replicate them
end

--#endregion