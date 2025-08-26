---@class Enums
local Module = {}

---@enum ePickVelType
Module.ePickVelType = {
    DEFAULT = 0,
    BEGGAR = 1
}

---@enum ePurityState
Module.ePurityState = {
    DAMAGE = 0,
    TEARS = 1,
    SPEED = 2,
    RANGE = 3
}

---@enum eStatModifiers
Module.eStatModifiers = {
    DAMAGE = 1,
    TEARS = 2,
    RANGE = 3,
    SHOT_SPEED = 4,
    SPEED = 5,
    LUCK = 6,
}

---@enum eWeaponModifiers
Module.eWeaponModifiers = {
    CHOCOLATE_MILK = 1 << 0,
    CURSED_EYE = 1 << 1,
    BRIMSTONE = 1 << 2,
    MONSTROS_LUNG = 1 << 3,
    LUDOVICO_TECHNIQUE = 1 << 4,
    ANTI_GRAVITY = 1 << 5,
    TRACTOR_BEAM = 1 << 6,
    SOY_MILK = 1 << 7,
    NEPTUNUS = 1 << 8,
    AZAZELS_SNEEZE = 1 << 9,
    C_SECTION = 1 << 11,
}

---@enum eShopItemType
Module.eShopItemType = {
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

---@enum eGridCollisionClass
Module.eGridCollisionClass = {
    WALLS_X = GridCollisionClass.COLLISION_PIT,
    WALLS_Y = GridCollisionClass.COLLISION_OBJECT,
    NO_PITS = 6,
    PITS_ONLY = 7,
}

---@enum eRoomConfigFlag
Module.eRoomConfigFlag = {
    MINESHAFT_CHASE = 1 << 1,
}

---@enum eSpecialDailyRuns
Module.eSpecialDailyRuns = {
    SATORU_IWATA_S_BIRTHDAY = 18,
    I_FORGOT_DAY = 38,
}

return Module