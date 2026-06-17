---@class EntityIdentity
local Module = {}

---@enum eKnifeSubType
Module.eKnifeSubType = {
    BASE = 0,
    PROJECTILE = 1,
    SUBTYPE_3 = 3,
    CLUB_HITBOX = 4,
}

---@enum eGaperVariant
Module.eGaperVariant = {
    FROWNING_GAPER = 0,
    GAPER = 1,
    FLAMING_GAPER = 2,
    ROTTEN_GAPER = 3,
}

---@enum eGusherVariant
Module.eGusherVariant = {
    GUSHER = 0,
    PACER = 1
}

---@enum eFattyVariant
Module.eFattyVariant = {
    FATTY = 0,
    PALE_FATTY = 1,
    FLAMING_FATTY = 2,
}

---@enum eConjoinedFattyVariant
Module.eConjoinedFattyVariant = {
    CONJOINED_FATTY = 0,
    BLUE_CONJOINED_FATTY = 1,
}

---@enum eStoneyVariant
Module.eStoneyVariant = {
    STONEY = 0,
    CROSS_STONEY = 10
}

---@enum eFirePlaceVariant
Module.eFirePlaceVariant = {
    FIRE_PLACE = 0,
    RED_FIRE_PLACE = 1,
    BLUE_FIRE_PLACE = 2,
    PURPLE_FIRE_PLACE = 3,
    WHITE_FIRE_PLACE = 4,
    MOVABLE_FIRE_PLACE = 10,
    COAL = 11,
    MOVABLE_BLUE_FIRE_PLACE = 12,
    MOVABLE_PURPLE_FIRE_PLACE = 13,
}

---@enum eBabyVariant
Module.eBabyVariant = {
    BABY = 0,
    ANGELIC_BABY = 1,
    ULTRA_PRIDE_BABY = 2,
    WRINKLY_BABY = 3,
}

---@enum eMomBossColor
Module.eMomBossColor = {
    NORMAL = 0,
    BLUE = 1,
    RED = 2,
    MAUSOLEUM = 3
}

---@enum eMomsHeartBossColor
Module.eMomsHeartBossColor = {
    NORMAL = 0,
    MAUSOLEUM = 1,
}

---@enum eHauntVariant
Module.eHauntVariant = {
    HAUNT = 0,
    LIL_HAUNT = 10,
}

---@enum eHauntSubtype
Module.eHauntSubtype = {
    NORMAL = 0,
    CHAMPION_BLACK = 1,
    CHAMPION_PINK = 2,
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

---@enum eReverseExplosionSubtype
Module.eReverseExplosionSubtype = {
    EXPLOSION = 0,
    DEBRIS = 1,
}

return Module