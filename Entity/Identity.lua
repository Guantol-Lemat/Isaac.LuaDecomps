---@class EntityIdentity
local Module = {}

---@enum eKnifeSubType
Module.eKnifeSubType = {
    BASE = 0,
    PROJECTILE = 1,
    SUBTYPE_3 = 3,
    CLUB_HITBOX = 4,
}

---@enum eFirePlaceVariant
Module.eFirePlaceVariant = {
    FIRE_PLACE = 0,
    RED_FIRE_PLACE = 1,
    BLUE_FIRE_PLACE = 2,
    PURPLE_FIRE_PLACE = 3,
    WHITE_FIRE_PLACE = 4
}

---@enum eBabyVariant
Module.eBabyVariant = {
    BABY = 0,
    ANGELIC_BABY = 1,
    ULTRA_PRIDE_BABY = 2,
    WRINKLY_BABY = 3,
}

---@enum eFallenVariant
Module.eFallenVariant = {
    THE_FALLEN = 0,
    KRAMPUS = 1,
}

---@enum eVisageVariant
Module.eVisageVariant = {
    VISAGE_HEART = 0,
    VISAGE_MASK = 1,
    VISAGE_CHAIN = 10,
    VISAGE_PLASMA = 20,
}

---@enum eSingeVariant
Module.eSingeVariant = {
    SINGE = 0,
    SINGE_BALL = 1,
}

---@enum eCultistVariant
Module.eCultistVariant = {
    CULTIST = 0,
    BLOOD_CULTIST = 1,
    BONE_TRAP = 10,
}

return Module