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

---@enum Decomp.Enum.eShopItemType
Enums.eShopItemType = {
    HEART_FULL = 0,
    BOMB_SINGLE = 1,
    PILL = 2,
    KEY_SINGLE = 3,
    SOUL_HEART = 4,
    LIL_BATTERY = 5,
    CARD = 6,
    GRAB_BAG = 7,
    COLLECTIBLE = 8,
    COLLECTIBLE_BOSS = 9,
    COLLECTIBLE_TREASURE = 10,
    TRINKET = 11,
    COLLECTIBLE_DEVIL = 12,
    COLLECTIBLE_ANGEL = 13,
    COLLECTIBLE_SECRET = 14,
    HEART_SPECIAL = 15, -- Black, Eternal, Bone or Rotten
    RUNE = 16,
    COLLECTIBLE_SHOP = 17,
    COLLECTIBLE_BABY_SHOP = 18,
    HEART_ETERNAL = 19,
    HOLY_CARD = 20
}

---@enum Decomp.Enum.eRoomConfigFlag
Enums.eRoomConfigFlag = {
    MINESHAFT_CHASE = 1 << 1,
}

return Enums