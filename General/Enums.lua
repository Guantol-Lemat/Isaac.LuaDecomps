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

---@enum eDoorFlags
Module.eDoorFlags = {
    DOOR_LEFT0 = 1 << DoorSlot.LEFT0,
    DOOR_RIGHT0 = 1 << DoorSlot.RIGHT0,
    DOOR_UP0 = 1 << DoorSlot.UP0,
    DOOR_DOWN0 = 1 << DoorSlot.DOWN0,
    DOOR_LEFT1 = 1 << DoorSlot.LEFT1,
    DOOR_RIGHT1 = 1 << DoorSlot.RIGHT1,
    DOOR_UP1 = 1 << DoorSlot.UP1,
    DOOR_DOWN1 = 1 << DoorSlot.DOWN1,
}

---@enum eDisplayFlags
Module.eDisplayFlags = {
    DISPLAY_NONE = 0,
    DISPLAY_BOX = 1 << RoomDescriptor.DISPLAY_BOX,
    DISPLAY_LOCK = 1 << RoomDescriptor.DISPLAY_LOCK,
    DISPLAY_ICON =  1 << RoomDescriptor.DISPLAY_ICON,
}

---@enum eShaders
Module.eShaders = {
    COLOR_OFFSET = 0,
    PIXELATION = 1,
    BLOOM = 2,
    COLOR_CORRECTION = 3,
    HQ4X = 4,
    SHOCKWAVE = 5,
    OLD_TV = 6,
    WATER = 7,
    HALLUCINATION = 8,
    COLOR_MOD = 9,
    COLOR_OFFSET_CHAMPION = 10,
    WATER_V2 = 11,
    BACKGROUND = 12,
    WATER_OVERLAY = 13,
    COLOR_OFFSET_DOGMA = 15,
    COLOR_OFFSET_GOLD = 16,
    DIZZY = 17,
    HEAT_WAVE = 18,
    MIRROR = 19,
}

---@enum eAnimationFlags
Module.eAnimationFlags = {
    IGNORE_COLOR_MODIFIERS = 1 << 0,
    GLITCH = 1 << 1,
    IS_LIGHT = 1 << 2,
    APPLY_LAYER_SCALE_TO_SPRITE = 1 << 3,
    CHAMPION = 1 << 4,
    STATIC = 1 << 5,
    IGNORE_GAME_TIME = 1 << 6,
    GOLDEN = 1 << 7,
    USE_SIMPLE_COLOR_OFFSET = 1 << 8, -- unused since there is no 
    PROCEDURAL = 1 << 9,
    HAS_LAYER_LIGHTING = 1 << 10,
    HAS_NULL_LAYER_LIGHTING = 1 << 11,
    GLOW_UNK = 1 << 12,
    UNK_3 = 1 << 13,
}

return Module