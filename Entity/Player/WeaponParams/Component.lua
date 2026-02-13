--#region Dependencies



--#endregion

---@class TearHitParamsComponent
---@field tearVariant TearVariant | integer : 0x0
---@field bombVariant BombVariant | integer : 0x4
---@field tearColor Color : 0x8
---@field tearFlags TearFlags | BitSet128 : 0x38
---@field tearDamage number : 0x48
---@field tearScale number : 0x4c
---@field tearHeight number : 0x50
---@field knockback number : 0x54
---@field height number : 0x58
---@field speed number : 0x5c
---@field unk3 integer : 0x60
---@field velocityMultiplier number : 0x64

---@class MultiShotParamsComponent
---@field numTears integer : 0x0
---@field numLanesPerEye integer : 0x2
---@field spreadAngleTears number : 0x4
---@field spreadAngleLaser number : 0x8 -- eye pos + shoot dir +- this value
---@field spreadAngleTechX number : 0xc
---@field spreadAngleKnives number : 0x10
---@field numEyesActive integer : 0x14 -- 2 for 1 wiz\, 3 for 2 wiz\, 1 for quadShot & others
---@field multiEyeAngle number : 0x18 -- 45 for the Wiz
---@field isCrossEyed boolean : 0x1c
---@field isShootingBackwards boolean : 0x1d
---@field isShootingSideways boolean : 0x1e
---@field numRandomTears integer : 0x20 -- tears shot in random directions by eye sore item

---@return TearHitParamsComponent
local function NewTearHitParams()
    ---@type TearHitParamsComponent
    return {
        tearVariant = TearVariant.BLUE,
        bombVariant = BombVariant.BOMB_NORMAL,
        tearColor = Color(),
        tearFlags = BitSet128(),
        tearDamage = 3.5,
        tearScale = 1.0,
        tearHeight = -23.75,
        knockback = 1.0,
        height = 1.7,
        speed = 1.0,
        unk3 = 0,

        -- no proper initialization in game
        velocityMultiplier = 0.0,
    }
end

---@return MultiShotParamsComponent
local function NewMultiShotParams()
    ---@type MultiShotParamsComponent
    return {
        numTears = 0,
        numLanesPerEye = 0,
        spreadAngleTears = 0.0,
        spreadAngleLaser = 0.0,
        spreadAngleTechX = 0.0,
        spreadAngleKnives = 0.0,
        numEyesActive = 1,
        multiEyeAngle = 0.0,
        isCrossEyed = false,
        isShootingBackwards = false,
        isShootingSideways = false,
        numRandomTears = 0,
    }
end

local Module = {}

--#region Module

Module.NewTearHitParams = NewTearHitParams
Module.NewMultiShotParams = NewMultiShotParams

--#endregion

return Module