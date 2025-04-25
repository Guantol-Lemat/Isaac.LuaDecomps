---@class Decomp.Enum
local Enums = {}
Decomp.Enums = Enums

---@enum Decomp.Enum.eBasicEntityType
Enums.eBasicEntityType = {
    ENTITY = 1,
    PLAYER = 2,
    TEAR = 3,
    FAMILIAR = 4,
    BOMB = 5,
    PICKUP = 6,
    SLOT = 7,
    LASER = 8,
    KNIFE = 9,
    PROJECTILE = 10,
    NPC = 11,
    EFFECT = 12,
    TEXT = 13,
}

---@enum Decomp.Enum.ePickVelType
Enums.ePickVelType = {
    DEFAULT = 0,
    BEGGAR = 1
}

---@enum Decomp.Enum.ePurityState
Enums.ePurityState = {
    DAMAGE = 0,
    TEARS = 1,
    SPEED = 2,
    RANGE = 3
}

---@enum Decomp.Enum.eStatModifiers
Enums.eStatModifiers = {
    DAMAGE = 1,
    TEARS = 2,
    RANGE = 3,
    SHOT_SPEED = 4,
    SPEED = 5,
    LUCK = 6,
}

---@enum Decomp.Enum.eWeaponModifiers
Enums.eWeaponModifiers = {
    CHOCOLATE_MILK = 0,
    CURSED_EYE = 1,
    BRIMSTONE = 2,
    MONSTROS_LUNG = 3,
    LUDOVICO_TECHNIQUE = 4,
    ANTI_GRAVITY = 5,
    TRACTOR_BEAM = 6,
    SOY_MILK = 7,
    NEPTUNUS = 8,
    AZAZELS_SNEEZE = 9,
    C_SECTION = 11,
}

return Enums