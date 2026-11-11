--#region Dependencies

local IsaacUtils = require("Isaac.Utils.Common")
local BitSet128Utils = require("General.VanillaAPI.BitSet128")
local ColorUtils = require("General.VanillaAPI.Color")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityTear = require("Isaac.Interface.Entity_Tear")
local ITearParams = IEntityPlayer.TearParams

local TearHitParams = require("Isaac.Content.Player.TearHitParams")

--#endregion

---@class Player.Blackboard.GetTearHitParams
---@field tearParams Component.Entity.Player.TearParams
---@field player Component.Entity.Player
---@field familiar Component.Entity.Familiar?
---@field weaponType WeaponType | integer
---@field leftEyeBonus boolean
---@field rightEyeBonus boolean
---@field isBloodTear boolean
---@field baseDamage number
---@field scaleMultiplier number

---@param player Component.Entity.Player
---@param weaponType WeaponType | integer
---@param damageScale number
---@param tearDisplacement integer
---@param source Component.Entity?
---@return Component.Entity.Player.TearParams
local function GetTearHitParams(player, weaponType, damageScale, tearDisplacement, source)
    local familiar = source and IEntity.ToFamiliar(source)

    local tearParams = ITearParams.New()
    tearParams.tearVariant = TearVariant.BLUE
    tearParams.tearDamage = player.m_damage * damageScale
    tearParams.tearHeight = player.m_tearHeight
    tearParams.tearFlags = BitSet128Utils.Copy(player.m_tearFlags)
    tearParams.tearColor = ColorUtils.Copy(player.m_tearColor)
    tearParams.tearScale = 1.0
    tearParams.knockback = 1.0
    tearParams.height = 1.7

    ---@type Player.Blackboard.GetTearHitParams
    local ctx = {
        tearParams = tearParams,
        player = player,
        familiar = familiar,
        weaponType = weaponType,
        baseDamage = 0.0, -- uninitialized
        leftEyeBonus = false, -- uninitialized
        rightEyeBonus = false, -- uninitialized
        isBloodTear = false, -- uninitialized
        scaleMultiplier = 1.0 -- uninitialized
    }

    TearHitParams.ApplyBaseModifiers(ctx)

    ctx.baseDamage = tearParams.tearDamage
    ctx.scaleMultiplier = 1.0

    TearHitParams.ApplyPreModifiers(ctx)

    -- init isBloodTear, and eye bonuses
    ctx.isBloodTear = tearParams.tearVariant == TearVariant.BLOOD

    local leftEyeBonus = false
    local rightEyeBonus = false
    tearParams.tearDisplacement = 0

    if tearDisplacement < 0 or (TearHitParams.HasNoLeftEye(ctx) and IsaacUtils.RandomInt(2) == 0) then
        leftEyeBonus = true
        tearParams.tearDisplacement = -1
    elseif tearDisplacement > 0 then
        rightEyeBonus = true
        tearParams.tearDisplacement = 1
    end

    ctx.leftEyeBonus = leftEyeBonus
    ctx.rightEyeBonus = rightEyeBonus

    TearHitParams.ApplyBloodTearsModifiers(ctx)
    TearHitParams.ApplyModifiers(ctx)

    local compressedScale = tearParams.tearScale > 1.0 and math.log(tearParams.tearScale) + 1.0 or tearParams.tearScale
    tearParams.tearScale = (math.sqrt(ctx.baseDamage) * 0.23 + compressedScale * 0.55 + ctx.baseDamage * 0.01) * ctx.scaleMultiplier

    if ctx.isBloodTear then
        tearParams.tearVariant = IEntityTear.GetBloodTearVariant(tearParams.tearVariant)
    end

    TearHitParams.ApplyPostModifiers(ctx)

    return tearParams
end

---@class Player.Stats
local Module = {}

--#region Module

Module.GetTearHitParams = GetTearHitParams

--#endregion

return Module