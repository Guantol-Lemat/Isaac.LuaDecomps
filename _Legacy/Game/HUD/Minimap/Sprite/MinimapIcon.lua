---@class MinimapSprite
local Module = {}

local Animations = {
    ROOM_OUTLINE = "RoomOutline",
    ROOM_CURRENT = "RoomCurrent",
    ROOM_VISITED = "RoomVisited",
    ROOM_UNVISITED = "RoomUnvisited",
}

---@enum eRoomIcon
local eRoomIcon = {
    SHOP = "IconShop",
    TREASURE = "IconTreasureRoom",
    TREASURE_RED = "IconTreasureRoomRed",
    TREASURE_GREED = "IconTreasureRoomGreed",
    BOSS = "IconBoss",
    MINIBOSS = "IconMiniboss",
    SECRET = "IconSecretRoom",
    SUPERSECRET = "IconSuperSecretRoom",
    ARCADE = "IconArcade",
    CURSE = "IconCurseRoom",
    AMBUSH = "IconAmbushRoom",
    BOSS_AMBUSH = "IconAmbushRoom",
    LIBRARY = "IconLibrary",
    SACRIFICE = "IconSacrificeRoom",
    DEVIL = "IconDevilRoom",
    ANGEL = "IconAngelRoom",
    ISAACS = "IconIsaacsRoom",
    BARREN = "IconBarrenRoom",
    CHEST = "IconChestRoom",
    DICE = "IconDiceRoom",
    PLANETARIUM = "IconPlanetarium",
    TELEPORTER = "IconTeleporterRoom",
    ULTRASECRET = "IconUltraSecretRoom",
    LOCKED = "IconLockedRoom",
    MIRROR = "IconMirrorRoom",
    MINECART = "IconMinecartRoom",
}

---@enum eRoomContentIcon
local eRoomContentIcon = {
    HEART = "IconHeart",
    ITEM = "IconItem",
    TRINKET = "IconTrinket",
    CHEST = "IconChest",
    RUNE = "IconRune",
    CARD = "IconCard",
    PILL = "IconPill",
    KEY = "IconKey",
    BOMB = "IconBomb",
    POOP = "IconPoop",
    COIN = "IconCoin",
    BATTERY = "IconBattery",
    BEGGAR = "IconBeggar",
    SLOT = "IconSlot",
    LADDER = "IconLadder",
}

---@enum eHeartIcon
local eHeartIcon = {
    HEART_HALF = 0,
    HEART_FULL = 1,
    HEART_ROTTEN = 2,
    HEART_HALF_SOUL = 3,
    HEART_BLENDED = 4,
    HEART_SOUL = 5,
    HEART_BLACK = 6,
    HEART_BONE = 7,
    HEART_GOLDEN = 8,
    HEART_ETERNAL = 9,
}

---@enum eCoinIcon
local eCoinIcon = {
    COIN_PENNY = 0,
    COIN_GOLDEN = 1,
}

---@enum eBombIcon
local eBombIcon = {
    BOMB_NORMAL = 0,
    BOMB_GOLDEN = 1,
}

---@enum eKeyIcon
local eKeyIcon = {
    KEY_NORMAL = 0,
    KEY_GOLDEN = 1,
    KEY_CHARGED = 2,
}

---@enum eChestIcon
local eChestIcon = {
    PICKUP_CHEST = 0,
    PICKUP_BOMBCHEST = 1,
    SACK_NORMAL = 2,
    SACK_BLACK = 3,
    PICKUP_MOMSCHEST = 4,
    PICKUP_REDCHEST = 5,
    PICKUP_WOODENCHEST = 6,
    PICKUP_ETERNALCHEST = 7,
    PICKUP_LOCKEDCHEST = 8,
    PICKUP_MEGACHEST = 9,
}

---@enum eBatteryIcon
local eBatteryIcon = {
    BATTERY_NORMAL = 0,
    BATTERY_GOLDEN = 1,
}

---@enum ePillIcon
local ePillIcon = {
    PILL_NORMAL = 0,
    PIIL_GOLD = 1,
}

---@enum eSlotIcon
local eSlotIcon = {
    MOMS_DRESSING_TABLE = 0,
    DONATION_MACHINE = 1,
    SLOT_MACHINE = 2,
    BLOOD_DONATION_MACHINE = 3,
    FORTUNE_TELLING_MACHINE = 4,
    CRANE_GAME = 5,
    SHOP_RESTOCK_MACHINE = 6,
    CONFESSIONAL = 7,
}

---@enum eBeggarIcon
local eBeggarIcon = {
    BEGGAR = 0,
    ROTTEN_BEGGAR = 1,
    DEVIL_BEGGAR = 2,
    KEY_MASTER = 3,
    BOMB_BUM = 4,
    BATTERY_BUM = 5,
}

--#region Module

Module.Animations = Animations
Module.eRoomIcon = eRoomIcon
Module.eRoomContentIcon = eRoomContentIcon
Module.eHeartIcon = eHeartIcon
Module.eCoinIcon = eCoinIcon
Module.eBombIcon = eBombIcon
Module.eKeyIcon = eKeyIcon
Module.eChestIcon = eChestIcon
Module.eBatteryIcon = eBatteryIcon
Module.ePillIcon = ePillIcon
Module.eSlotIcon = eSlotIcon
Module.eBeggarIcon = eBeggarIcon

--#endregion

return Module
