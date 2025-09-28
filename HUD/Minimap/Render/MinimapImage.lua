--#region Dependencies

local MySprite = require("HUD.Minimap.Sprite.MinimapIcon")
local GraphicsAdmin = require("Admin.Graphics.Admin")
local ANM2Admin = require("General.ANM2.Admin")
local BlendMode = require("Admin.Graphics.BlendMode")
local GameUtils = require("Game.Utils")
local LevelUtils = require("Level.Utils")
local VectorUtils= require("General.Math.VectorUtils")
local MirrorRules = require("Level.Dimension.Mirror.Rules")
local MineshaftRules = require("Level.Dimension.Mineshaft.Rules")
local PickupUtils = require("Entity.Pickup.Utils")

local Enums = require("General.Enums")
local MathUtils = require("Math.Math")
local BitsetUtils = require("General.Bitset")
local TableUtils = require("General.Table")

local eDoorFlags = Enums.eDoorFlags
local eDisplayFlags = Enums.eDisplayFlags
local eRoomFlags = Enums.eRoomFlags

local MyAnimations = MySprite.Animations
local eRoomIcon = MySprite.eRoomIcon
local eRoomContentIcon = MySprite.eRoomContentIcon
local eHeartIcon = MySprite.eHeartIcon
local eCoinIcon = MySprite.eCoinIcon
local eBombIcon = MySprite.eBombIcon
local eKeyIcon = MySprite.eKeyIcon
local eChestIcon = MySprite.eChestIcon
local eBatteryIcon = MySprite.eBatteryIcon
local ePillIcon = MySprite.ePillIcon
local eSlotIcon = MySprite.eSlotIcon
local eBeggarIcon = MySprite.eBeggarIcon

local VEC_ZERO = VectorUtils.VectorZero
local VEC_ONE = VectorUtils.VectorOne

--#endregion

---@class MinimapConfigRender
local Module = {}

local SHAPE_RENDER_OFFSET = {
    [RoomShape.ROOMSHAPE_1x1] = Vector(1, 1),
    [RoomShape.ROOMSHAPE_IH] = Vector(1, 1),
    [RoomShape.ROOMSHAPE_IV] = Vector(1, 1),
    [RoomShape.ROOMSHAPE_1x2] = Vector(1, 2),
    [RoomShape.ROOMSHAPE_IIV] = Vector(1, 2),
    [RoomShape.ROOMSHAPE_2x1] = Vector(2, 1),
    [RoomShape.ROOMSHAPE_IIH] = Vector(2, 1),
    [RoomShape.ROOMSHAPE_2x2] = Vector(2, 2),
    [RoomShape.ROOMSHAPE_LTR] = Vector(2, 2),
    [RoomShape.ROOMSHAPE_LBL] = Vector(2, 2),
    [RoomShape.ROOMSHAPE_LBR] = Vector(2, 2),
    [RoomShape.ROOMSHAPE_LTL] = Vector(0, 2),
}

local HIDE_UNVISITED = TableUtils.CreateDictionary({
    RoomType.ROOM_SECRET, RoomType.ROOM_SUPERSECRET, RoomType.ROOM_ULTRASECRET
})

local LOCKED_ROOM = TableUtils.CreateDictionary({
    RoomType.ROOM_SHOP, RoomType.ROOM_ARCADE, RoomType.ROOM_LIBRARY,
    RoomType.ROOM_ISAACS, RoomType.ROOM_BARREN, RoomType.ROOM_CHEST,
    RoomType.ROOM_DICE, RoomType.ROOM_PLANETARIUM,
})

local eRoomContentFlag = {
    PICKUP_HEART = 1 << 0,
    PICKUP_COIN = 1 << 1,
    PICKUP_POOP = 1 << 2,
    PICKUP_KEY = 1 << 3,
    PICKUP_BOMB = 1 << 4,
    PICKUP_TAROTCARD = 1 << 5,
    PICKUP_COLLECTIBLE = 1 << 6,
    PICKUP_PILL = 1 << 7,
    PICKUP_LIL_BATTERY = 1 << 8,
    PICKUP_CHEST = 1 << 9,
    PICKUP_TRINKET = 1 << 10,
    SLOT = 1 << 11,
    PICKUP_RUNE = 1 << 12,
    SLOT_BEGGAR = 1 << 13,
    GRID_STAIRS = 1 << 14,
}

---@param level LevelComponent
---@param room RoomDescriptorComponent
local function should_render_outline(level, room, x, y)
    ---@type RoomDataComponent
    local data = room.m_data
    if not (level.m_stage == LevelStage.STAGE7 and data.m_type == RoomType.ROOM_BOSS) then
        return true
    end

    local defaultResult = true
    local roomIdx = x + y * 13
    local dimensionLookup = level.m_currentDimensionLookup
    local listIdx = dimensionLookup[roomIdx]

    local shape = data.m_shape
    if shape == RoomShape.ROOMSHAPE_2x2 then
        -- test if this gridIdx is the source position, by checking if the two neighbors are this room
        local doorFlags = room.m_allowedDoors
        local neighbor1 = 0
        local neighbor2 = 0

        if BitsetUtils.HasAny(doorFlags, eDoorFlags.DOOR_LEFT0 | eDoorFlags.DOOR_UP0) then
            neighbor1 = roomIdx + 1
            neighbor2 = roomIdx + 13
        elseif BitsetUtils.HasAny(doorFlags, eDoorFlags.DOOR_UP1 | eDoorFlags.DOOR_RIGHT0) then
            neighbor1 = roomIdx - 1
            neighbor2 = roomIdx + 13
        elseif BitsetUtils.HasAny(doorFlags, eDoorFlags.DOOR_LEFT1 | eDoorFlags.DOOR_DOWN0) then
            neighbor1 = roomIdx + 1
            neighbor2 = roomIdx - 13
        elseif BitsetUtils.HasAny(doorFlags, eDoorFlags.DOOR_DOWN1 | eDoorFlags.DOOR_RIGHT1) then
            neighbor1 = roomIdx - 1
            neighbor2 = roomIdx - 13
        else
            return defaultResult
        end

        if not (0 <= neighbor1 and neighbor1 < 169) then
            return false
        end

        if not (0 <= neighbor2 and neighbor2 < 169) then
            return false
        end

        return dimensionLookup[neighbor1] == listIdx and dimensionLookup[neighbor2] == listIdx
    end

    if shape == RoomShape.ROOMSHAPE_1x2 then
        -- test if this gridIdx is the source position, by checking if the two neighbors are this room
        local doorFlags = room.m_allowedDoors
        local neighbor = 0

        if BitsetUtils.HasAny(doorFlags, eDoorFlags.DOOR_LEFT0 | eDoorFlags.DOOR_RIGHT0 | eDoorFlags.DOOR_UP0) then
            neighbor = roomIdx + 13
        elseif BitsetUtils.HasAny(doorFlags, eDoorFlags.DOOR_LEFT1 | eDoorFlags.DOOR_RIGHT1 | eDoorFlags.DOOR_DOWN0) then
            neighbor = roomIdx - 13
        else
            return defaultResult
        end

        if not (0 <= neighbor and neighbor < 169) then
            return false
        end

        return dimensionLookup[neighbor] == listIdx
    end

    if shape == RoomShape.ROOMSHAPE_2x1 then
        -- test if this gridIdx is the source position, by checking if the two neighbors are this room
        local doorFlags = room.m_allowedDoors
        local neighbor = 0

        if BitsetUtils.HasAny(doorFlags, eDoorFlags.DOOR_LEFT0 | eDoorFlags.DOOR_UP0 | eDoorFlags.DOOR_DOWN0) then
            neighbor = roomIdx + 1
        elseif BitsetUtils.HasAny(doorFlags, eDoorFlags.DOOR_RIGHT0 | eDoorFlags.DOOR_UP1 | eDoorFlags.DOOR_DOWN1) then
            neighbor = roomIdx - 1
        else
            return defaultResult
        end

        if not (0 <= neighbor and neighbor < 169) then
            return false
        end

        return dimensionLookup[neighbor] == listIdx
    end

    return defaultResult
end

---@param context Context
---@param config MinimapConfigComponent
---@param roomX integer
---@param roomY integer
---@param renderPosition Vector
local function render_room_outline(context, config, roomX, roomY, renderPosition)
    local level = context:GetLevel()
    local roomIdx = roomY * 13 + roomX
    local dimensionLookup = level.m_currentDimensionLookup

    if roomIdx > 168 then
        return
    end

    -- use lua 1-indexed arrays
    local listIdx = dimensionLookup[roomIdx + 1]
    if listIdx < 0 then
        return
    end

    local room = level.m_roomList[listIdx + 1]
    if room.m_displayFlags == eDisplayFlags.DISPLAY_NONE then
        return
    end

    local data = room.m_data
    if data == nil then
        return
    end

    config.m_renderAreaTopLeftPixel.X = math.min(config.m_renderAreaTopLeftPixel.X, renderPosition.X)
    config.m_renderAreaTopLeftPixel.Y = math.min(config.m_renderAreaTopLeftPixel.Y, renderPosition.Y)

    local padding = (config.m_borderPadding + config.m_cellPixelDistance) * 2
    local bottomRightRenderPosition = renderPosition + config.m_cellPixelSize + padding
    config.m_imageBottomRightPixel.X = math.max(config.m_imageBottomRightPixel.X, bottomRightRenderPosition.X)
    config.m_imageBottomRightPixel.Y = math.max(config.m_imageBottomRightPixel.Y, bottomRightRenderPosition.Y)

    local shouldRender = should_render_outline(level, room)

    config.m_sprite:SetFrame(MyAnimations.ROOM_OUTLINE, 0)
    if shouldRender then
        config.m_sprite:Render(renderPosition, Vector(0, 0), Vector(0, 0))
    end
end

---@param context Context
---@param config MinimapConfigComponent
---@param roomX integer
---@param roomY integer
---@param renderPosition Vector
---@param currentRoom RoomDescriptorComponent
---@param gridRenderOffset Vector
local function render_room(context, config, roomX, roomY, renderPosition, currentRoom, gridRenderOffset)
    local level = context:GetLevel()
    local roomIdx = roomY * 13 + roomX
    local dimensionLookup = level.m_currentDimensionLookup

    if not (0 <= roomIdx and roomIdx < 169) then
        return
    end

    -- use lua 1-indexed arrays
    local listIdx = dimensionLookup[roomIdx + 1]
    if listIdx < 0 then
        return
    end

    local roomList = level.m_roomList
    local room = roomList[listIdx + 1]

    local gridIdx = room.m_gridIdx
    ---@type RoomDataComponent -- assumed to exist will crash if it doesn't
    local data = room.m_data
    local shape = data.m_shape

    -- guarantee a bigger shape is rendered only once
    if not (gridIdx == roomIdx or (gridIdx + 1 == roomIdx and shape == RoomShape.ROOMSHAPE_LTL)) then
        return
    end

    local renderOffset = SHAPE_RENDER_OFFSET[shape]
    if not renderOffset then
        context:LogMessage(3, string.format("invalid room shape id: %d\n", shape))
        renderOffset = Vector(1, 1)
    end

    local renderX, renderY = renderPosition.X, renderOffset.Y

    if shape == RoomShape.ROOMSHAPE_LTL then
        renderX = renderX - gridRenderOffset.X
    end

    if level.m_stage == LevelStage.STAGE7 and data.m_type == RoomType.ROOM_BOSS then
        if shape == RoomShape.ROOMSHAPE_1x2 then
            if BitsetUtils.HasAny(room.m_allowedDoors, eDoorFlags.DOOR_DOWN0 | eDoorFlags.DOOR_LEFT1 | eDoorFlags.DOOR_RIGHT1) then
                renderY = renderY + gridRenderOffset.Y
            end
        end

        if shape == RoomShape.ROOMSHAPE_2x1 then
            if BitsetUtils.HasAny(room.m_allowedDoors, eDoorFlags.DOOR_RIGHT0 | eDoorFlags.DOOR_UP1 | eDoorFlags.DOOR_DOWN1) then
                renderX = renderX + gridRenderOffset.X
            end
        end

        if shape == RoomShape.ROOMSHAPE_2x2 then
            if BitsetUtils.HasAny(room.m_allowedDoors, eDoorFlags.DOOR_RIGHT0 | eDoorFlags.DOOR_UP1) then
                renderX = renderX + gridRenderOffset.X
            elseif BitsetUtils.HasAny(room.m_allowedDoors, eDoorFlags.DOOR_DOWN0 | eDoorFlags.DOOR_LEFT1) then
                renderY = renderY + gridRenderOffset.Y
            elseif BitsetUtils.HasAny(room.m_allowedDoors, eDoorFlags.DOOR_RIGHT1 | eDoorFlags.DOOR_DOWN1) then
                renderX = renderX + gridRenderOffset.X
                renderY = renderY + gridRenderOffset.Y
            end
        end

        renderOffset = Vector(1, 1)
    end

    local sprite = config.m_sprite

    local flags = room.m_flags
    if BitsetUtils.HasAny(flags, eRoomFlags.FLAG_RED_ROOM) then
        sprite.Color:SetTint(255/255, 75/255, 75/255, 255/255)
    end

    local originalRenderPosition = renderPosition
    renderPosition = Vector(renderX, renderY)

    if currentRoom.m_listIdx == listIdx then
        sprite:SetFrame(MyAnimations.ROOM_CURRENT, shape)
        sprite:Render(renderPosition, VEC_ZERO, VEC_ZERO)
        local temp = (config.m_cellPixelDistance + config.m_borderPadding)
        config.m_centerCurrentRoom = originalRenderPosition + (renderOffset * config.m_cellPixelSize * 0.5) + temp
    else
        local displayFlags = room.m_displayFlags
        if BitsetUtils.HasAny(displayFlags, eDisplayFlags.DISPLAY_ROOM) then
            if BitsetUtils.HasAny(flags, eRoomFlags.FLAG_CLEAR) then
                sprite:SetFrame(MyAnimations.ROOM_VISITED, shape)
                sprite:Render(renderPosition, VEC_ZERO, VEC_ZERO)
            elseif data and not HIDE_UNVISITED(data.m_type) then
                sprite:SetFrame(MyAnimations.ROOM_UNVISITED, shape)
                sprite:Render(renderPosition, VEC_ZERO, VEC_ZERO)
            end
        end
    end
end

---@alias SWITCH_RoomTypeIcon fun(context: Context, room: RoomDescriptorComponent, data: RoomDataComponent): string?

local switch_room_type_icon = {
    ---@type SWITCH_RoomTypeIcon
    [RoomType.ROOM_DEFAULT] = function (context, room, data)
        local level = context:GetLevel()
        if room.m_visitedCount == 0 or level.m_dimension == Dimension.DEATH_CERTIFICATE then
            return nil
        end

        local subtype = data.m_subtype
        if subtype == RoomSubType.DOWNPOUR_MIRROR then
            if not MirrorRules.LevelHasMirrorDimension(context, context:GetGame(), level) then
                return nil
            end

            return eRoomIcon.MIRROR
        end

        if subtype == RoomSubType.MINES_MINESHAFT_ENTRANCE then
            if not MineshaftRules.LevelHasAbandonedMineshaft(context, level) then
                return
            end

            return eRoomIcon.MINECART
        end

        return nil
    end,
    [RoomType.ROOM_SHOP] = function ()
        return eRoomIcon.SHOP
    end,
    ---@type SWITCH_RoomTypeIcon
    [RoomType.ROOM_TREASURE] = function (context, room, _)
        local level = context:GetLevel()
        if GameUtils.IsGreedMode(context:GetGame()) and level.m_greedGoldTreasureIdx ~= room.m_gridIdx then
            return eRoomIcon.TREASURE_GREED
        end

        if BitsetUtils.HasAny(room.m_flags, eRoomFlags.FLAG_DEVIL_TREASURE) then
            return eRoomIcon.TREASURE_RED
        end

        return eRoomIcon.TREASURE
    end,
    [RoomType.ROOM_BOSS] = function ()
        return eRoomIcon.BOSS
    end,
    [RoomType.ROOM_MINIBOSS] = function ()
        return eRoomIcon.MINIBOSS
    end,
    [RoomType.ROOM_SECRET] = function ()
        return eRoomIcon.SECRET
    end,
    [RoomType.ROOM_SUPERSECRET] = function ()
        return eRoomIcon.SUPERSECRET
    end,
    [RoomType.ROOM_ARCADE] = function ()
        return eRoomIcon.ARCADE
    end,
    [RoomType.ROOM_CURSE] = function ()
        return eRoomIcon.CURSE
    end,
    ---@type SWITCH_RoomTypeIcon
    [RoomType.ROOM_CHALLENGE] = function (_, _, data)
        return data.m_subtype == 1 and eRoomIcon.BOSS_AMBUSH or eRoomIcon.AMBUSH
    end,
    [RoomType.ROOM_LIBRARY] = function ()
        return eRoomIcon.LIBRARY
    end,
    [RoomType.ROOM_SACRIFICE] = function ()
        return eRoomIcon.SACRIFICE
    end,
    [RoomType.ROOM_DEVIL] = function ()
        return eRoomIcon.DEVIL
    end,
    [RoomType.ROOM_ANGEL] = function ()
        return eRoomIcon.ANGEL
    end,
    [RoomType.ROOM_ISAACS] = function ()
        return eRoomIcon.ISAACS
    end,
    [RoomType.ROOM_BARREN] = function ()
        return eRoomIcon.BARREN
    end,
    [RoomType.ROOM_CHEST] = function ()
        return eRoomIcon.CHEST
    end,
    [RoomType.ROOM_DICE] = function ()
        return eRoomIcon.DICE
    end,
    [RoomType.ROOM_PLANETARIUM] = function ()
        return eRoomIcon.PLANETARIUM
    end,
    [RoomType.ROOM_TELEPORTER] = function ()
        return eRoomIcon.TELEPORTER
    end,
    [RoomType.ROOM_TELEPORTER_EXIT] = function ()
        return eRoomIcon.TELEPORTER
    end,
    [RoomType.ROOM_ULTRASECRET] = function ()
        return eRoomIcon.ULTRASECRET
    end
}

---@param context Context
---@param room RoomDescriptorComponent
---@return string?
local function get_room_type_icon(context, room)
    local data = room.m_data
    if not data then
        return nil
    end

    local displayFlags = room.m_displayFlags
    local displayIcon = BitsetUtils(displayFlags, eDisplayFlags.DISPLAY_ICON)
    local displayLock = BitsetUtils(displayFlags, eDisplayFlags.DISPLAY_LOCK)

    if not displayIcon then
        if not displayLock or room.m_visitedCount ~= 0 then
            return nil
        end

        if not LOCKED_ROOM[data.m_type] then
            return nil
        end

        return eRoomIcon.LOCKED
    end

    ---@type SWITCH_RoomTypeIcon?
    local switch = switch_room_type_icon[data.m_type]
    if not switch then
        return nil
    end

    return switch(context, room, data)
end

local HEART_ICONS = {
    [HeartSubType.HEART_HALF] = eHeartIcon.HEART_HALF,
    [HeartSubType.HEART_SOUL] = eHeartIcon.HEART_SOUL,
    [HeartSubType.HEART_ETERNAL] = eHeartIcon.HEART_ETERNAL,
    [HeartSubType.HEART_BLACK] = eHeartIcon.HEART_BLACK,
    [HeartSubType.HEART_GOLDEN] = eHeartIcon.HEART_GOLDEN,
    [HeartSubType.HEART_HALF_SOUL] = eHeartIcon.HEART_HALF_SOUL,
    [HeartSubType.HEART_BLENDED] = eHeartIcon.HEART_BLENDED,
    [HeartSubType.HEART_BONE] = eHeartIcon.HEART_BONE,
    [HeartSubType.HEART_ROTTEN] = eHeartIcon.HEART_ROTTEN,
}

local COIN_ICONS = {
    [CoinSubType.COIN_GOLDEN] = eCoinIcon.COIN_GOLDEN,
}

local BOMB_ICONS = {
    [BombSubType.BOMB_GOLDEN] = eBombIcon.BOMB_GOLDEN,
}

local KEY_ICONS = {
    [KeySubType.KEY_GOLDEN] = eKeyIcon.KEY_GOLDEN,
    [KeySubType.KEY_CHARGED] = eKeyIcon.KEY_CHARGED,
}

local BATTERY_ICONS = {
    [BatterySubType.BATTERY_GOLDEN] = eBatteryIcon.BATTERY_GOLDEN,
}

local PILL_ICONS = {
    [PillColor.PILL_GOLD] = ePillIcon.PIIL_GOLD
}

local CHEST_ICONS = {
    [PickupVariant.PICKUP_BOMBCHEST] = eChestIcon.PICKUP_BOMBCHEST,
    [PickupVariant.PICKUP_SPIKEDCHEST] = eChestIcon.PICKUP_CHEST,
    [PickupVariant.PICKUP_ETERNALCHEST] = eChestIcon.PICKUP_ETERNALCHEST,
    [PickupVariant.PICKUP_WOODENCHEST] = eChestIcon.PICKUP_WOODENCHEST,
    [PickupVariant.PICKUP_MEGACHEST] = eChestIcon.PICKUP_MEGACHEST,
    [PickupVariant.PICKUP_LOCKEDCHEST] = eChestIcon.PICKUP_LOCKEDCHEST,
    [PickupVariant.PICKUP_REDCHEST] = eChestIcon.PICKUP_REDCHEST,
}

local SACK_ICONS = {
    [SackSubType.SACK_BLACK] = eChestIcon.SACK_BLACK,
}

---@class _RoomContentIcons
---@field bitset integer
---@field count integer
---@field heartIcon eHeartIcon
---@field coinIcon eCoinIcon
---@field bombIcon eBombIcon
---@field keyIcon eKeyIcon
---@field batteryIcon eBatteryIcon
---@field pillIcon ePillIcon
---@field chestIcon eChestIcon
---@field slotIcon eSlotIcon
---@field beggarIcon eBeggarIcon

---@alias _SWITCH_PickupIcon fun(context: Context, pickup: PickupSaveStateComponent, icons: _RoomContentIcons)

---@type table<PickupVariant, _SWITCH_PickupIcon>
local switch_pickup_icon = {
    [PickupVariant.PICKUP_HEART] = function(_, pickup, icons)
        local bitset = icons.bitset
        local heartIcon = HEART_ICONS[pickup.subtype] or eHeartIcon.HEART_FULL
        icons.heartIcon = math.max(icons.heartIcon, heartIcon)

        if BitsetUtils.HasAny(bitset, eRoomContentFlag.PICKUP_HEART) then
            icons.bitset = BitsetUtils.Set(bitset, eRoomContentFlag.PICKUP_HEART)
            icons.count = icons.count + 1
        end
    end,
    [PickupVariant.PICKUP_COIN] = function (_, pickup, icons)
        local bitset = icons.bitset
        local coinIcon = COIN_ICONS[pickup.subtype] or eCoinIcon.COIN_PENNY
        icons.coinIcon = math.max(icons.coinIcon, coinIcon)

        if BitsetUtils.HasAny(bitset, eRoomContentFlag.PICKUP_COIN) then
            icons.bitset = BitsetUtils.Set(bitset, eRoomContentFlag.PICKUP_COIN)
            icons.count = icons.count + 1
        end
    end,
    [PickupVariant.PICKUP_POOP] = function(_, _, icons)
        local bitset = icons.bitset
        if BitsetUtils.HasAny(bitset, eRoomContentFlag.PICKUP_POOP) then
            icons.bitset = BitsetUtils.Set(bitset, eRoomContentFlag.PICKUP_POOP)
            icons.count = icons.count + 1
        end
    end,
    [PickupVariant.PICKUP_BOMB] = function(_, pickup, icons)
        local bitset = icons.bitset
        local bombIcon = BOMB_ICONS[pickup.subtype] or eBombIcon.BOMB_NORMAL
        icons.bombIcon = math.max(icons.bombIcon, bombIcon)

        if BitsetUtils.HasAny(bitset, eRoomContentFlag.PICKUP_BOMB) then
            icons.bitset = BitsetUtils.Set(bitset, eRoomContentFlag.PICKUP_BOMB)
            icons.count = icons.count + 1
        end
    end,
    [PickupVariant.PICKUP_KEY] = function(_, pickup, icons)
        local bitset = icons.bitset
        local keyIcon = KEY_ICONS[pickup.subtype] or eKeyIcon.KEY_NORMAL
        icons.keyIcon = math.max(icons.keyIcon, keyIcon)

        if BitsetUtils.HasAny(bitset, eRoomContentFlag.PICKUP_KEY) then
            icons.bitset = BitsetUtils.Set(bitset, eRoomContentFlag.PICKUP_KEY)
            icons.count = icons.count + 1
        end
    end,
    [PickupVariant.PICKUP_TAROTCARD] = function(context, pickup, icons)
        local bitset = icons.bitset
        local itemConfig = context:GetItemConfig()
        local cardList = itemConfig.m_cardList

        local cardConfig = cardList[pickup.subtype + 1]

        local flag = eRoomContentFlag.PICKUP_TAROTCARD
        if cardConfig and cardConfig.m_pocketItemType == 2 then -- rune
            flag = eRoomContentFlag.PICKUP_RUNE
        end

        if BitsetUtils.HasAny(bitset, flag) then
            icons.bitset = BitsetUtils.Set(bitset, flag)
            icons.count = icons.count + 1
        end
    end,
    [PickupVariant.PICKUP_COLLECTIBLE] = function(_, _, icons)
        local bitset = icons.bitset
        if BitsetUtils.HasAny(bitset, eRoomContentFlag.PICKUP_COLLECTIBLE) then
            icons.bitset = BitsetUtils.Set(bitset, eRoomContentFlag.PICKUP_COLLECTIBLE)
            icons.count = icons.count + 1
        end
    end,
    [PickupVariant.PICKUP_TRINKET] = function(_, _, icons)
        local bitset = icons.bitset
        if BitsetUtils.HasAny(bitset, eRoomContentFlag.PICKUP_TRINKET) then
            icons.bitset = BitsetUtils.Set(bitset, eRoomContentFlag.PICKUP_TRINKET)
            icons.count = icons.count + 1
        end
    end,
    [PickupVariant.PICKUP_LIL_BATTERY] = function(_, pickup, icons)
        local bitset = icons.bitset
        local batteryIcon = BATTERY_ICONS[pickup.subtype] or eBatteryIcon.BATTERY_NORMAL
        icons.batteryIcon = math.max(icons.batteryIcon, batteryIcon)

        if BitsetUtils.HasAny(bitset, eRoomContentFlag.PICKUP_LIL_BATTERY) then
            icons.bitset = BitsetUtils.Set(bitset, eRoomContentFlag.PICKUP_LIL_BATTERY)
            icons.count = icons.count + 1
        end
    end,
    [PickupVariant.PICKUP_PILL] = function(_, pickup, icons)
        local bitset = icons.bitset
        local pillColor = pickup.subtype & PillColor.PILL_COLOR_MASK
        local pillIcon = PILL_ICONS[pillColor] or ePillIcon.PILL_NORMAL
        icons.pillIcon = math.max(icons.pillIcon, pillIcon)

        if BitsetUtils.HasAny(bitset, eRoomContentFlag.PICKUP_PILL) then
            icons.bitset = BitsetUtils.Set(bitset, eRoomContentFlag.PICKUP_PILL)
            icons.count = icons.count + 1
        end
    end,
    [PickupVariant.PICKUP_GRAB_BAG] = function(_, pickup, icons)
        local bitset = icons.bitset
        local chestIcon = SACK_ICONS[pickup.subtype] or eChestIcon.SACK_NORMAL
        icons.chestIcon = math.max(icons.chestIcon, chestIcon)

        if BitsetUtils.HasAny(bitset, eRoomContentFlag.PICKUP_CHEST) then
            icons.bitset = BitsetUtils.Set(bitset, eRoomContentFlag.PICKUP_CHEST)
            icons.count = icons.count + 1
        end
    end,
}

---@param context Context
---@param pickup PickupSaveStateComponent
---@param icons _RoomContentIcons
local function get_pickup_icon(context, pickup, icons)
    if pickup.price ~= 0 or VectorUtils.Equals(pickup.position, VEC_ZERO) then
        return
    end

    ---@type PickupVariant
    local variant = pickup.variant

    ---@type _SWITCH_PickupIcon?
    local switch = switch_pickup_icon[variant]
    if switch then
        switch(context, pickup, icons)
        return
    end

    if PickupUtils.IsChest(variant) then
        local bitset = icons.bitset
        local chestIcon = CHEST_ICONS[variant] or eChestIcon.PICKUP_MOMSCHEST
        icons.chestIcon = math.max(icons.chestIcon, chestIcon)

        if BitsetUtils.HasAny(bitset, eRoomContentFlag.PICKUP_CHEST) then
            icons.bitset = BitsetUtils.Set(bitset, eRoomContentFlag.PICKUP_CHEST)
            icons.count = icons.count + 1
        end

        return
    end
end

---@type table<SlotVariant, Pair<boolean, eSlotIcon>>
local SLOT_ICONS = {
    [SlotVariant.BLOOD_DONATION_MACHINE] = {true, eSlotIcon.BLOOD_DONATION_MACHINE},
    [SlotVariant.FORTUNE_TELLING_MACHINE] = {true, eSlotIcon.FORTUNE_TELLING_MACHINE},
    [SlotVariant.BEGGAR] = {false, eBeggarIcon.BEGGAR},
    [SlotVariant.SHELL_GAME] = {false, eBeggarIcon.BEGGAR},
    [SlotVariant.DEVIL_BEGGAR] = {false, eBeggarIcon.DEVIL_BEGGAR},
    [SlotVariant.HELL_GAME] = {false, eBeggarIcon.DEVIL_BEGGAR},
    [SlotVariant.KEY_MASTER] = {false, eBeggarIcon.KEY_MASTER},
    [SlotVariant.DONATION_MACHINE] = {true, eSlotIcon.DONATION_MACHINE},
    [SlotVariant.GREED_DONATION_MACHINE] = {true, eSlotIcon.DONATION_MACHINE},
    [SlotVariant.BOMB_BUM] = {false, eBeggarIcon.BOMB_BUM},
    [SlotVariant.SHOP_RESTOCK_MACHINE] = {true, eSlotIcon.SHOP_RESTOCK_MACHINE},
    [SlotVariant.MOMS_DRESSING_TABLE] = {true, eSlotIcon.MOMS_DRESSING_TABLE},
    [SlotVariant.BATTERY_BUM] = {false, eBeggarIcon.BATTERY_BUM},
    [SlotVariant.CRANE_GAME] = {true, eSlotIcon.CRANE_GAME},
    [SlotVariant.CONFESSIONAL] = {true, eSlotIcon.CONFESSIONAL},
    [SlotVariant.ROTTEN_BEGGAR] = {false, eBeggarIcon.ROTTEN_BEGGAR},
}

---@param slot EntitySaveStateComponent
---@param icons _RoomContentIcons
local function get_slot_icon(slot, icons)
    local variant = slot.variant
    if variant == SlotVariant.HOME_CLOSET_PLAYER then
        return
    end

    ---@type Pair<boolean, eSlotIcon>
    local slotIconDesc = SLOT_ICONS[variant] or {true, eSlotIcon.SLOT_MACHINE}
    local bitset = icons.bitset

    local isBeggar = not slotIconDesc[1]
    local flag = isBeggar and eRoomContentFlag.SLOT_BEGGAR or eRoomContentFlag.SLOT

    if isBeggar then
        icons.beggarIcon = math.max(icons.beggarIcon, slotIconDesc[2])
    else
        icons.slotIcon = math.max(icons.slotIcon, slotIconDesc[2])
    end

    if BitsetUtils.HasAny(bitset, flag) then
        icons.bitset = BitsetUtils.Set(bitset, flag)
        icons.count = icons.count + 1
    end
end

---@param context Context
---@param room RoomDescriptorComponent
---@return _RoomContentIcons
local function get_room_content_icons(context, room)
    ---@type _RoomContentIcons
    local icons = {
        bitset = 0,
        count = 0,
        heartIcon = 0,
        coinIcon = 0,
        bombIcon = 0,
        keyIcon = 0,
        batteryIcon = 0,
        pillIcon = 0,
        chestIcon = 0,
        slotIcon = 0,
        beggarIcon = 0,
    }

    if room.m_displayFlags == 0 then
        return icons
    end

    local entities = room.m_entitySaveState
    for i = 1, #entities, 1 do
        local entity = entities[i]
        if entity.type == EntityType.ENTITY_PICKUP then
            ---@cast entity PickupSaveStateComponent
            get_pickup_icon(context, entity, icons)
        elseif entity.type == EntityType.ENTITY_SLOT then
            get_slot_icon(entity, icons)
        end
    end

    local gridEntities = room.m_gridEntitySaveStates
    for i = 1, #gridEntities, 1 do
        local gridEntity = gridEntities[i]
        if gridEntity.m_type == GridEntityType.GRID_STAIRS then
            local bitset = icons.bitset
            if BitsetUtils.HasAny(bitset, eRoomContentFlag.GRID_STAIRS) then
                icons.bitset = BitsetUtils.Set(bitset, eRoomContentFlag.GRID_STAIRS)
                icons.count = icons.count + 1
            end
        end
    end

    return icons
end

local CONTENT_ICON_PRIORITY = {
    {eRoomContentFlag.PICKUP_HEART, eRoomContentIcon.HEART, "heartIcon"},
    {eRoomContentFlag.PICKUP_COLLECTIBLE, eRoomContentIcon.ITEM, nil},
    {eRoomContentFlag.PICKUP_TRINKET, eRoomContentIcon.TRINKET, nil},
    {eRoomContentFlag.PICKUP_CHEST, eRoomContentIcon.CHEST, "chestIcon"},
    {eRoomContentFlag.PICKUP_RUNE, eRoomContentIcon.RUNE, nil},
    {eRoomContentFlag.PICKUP_CARD, eRoomContentIcon.CARD, nil},
    {eRoomContentFlag.PICKUP_PILL, eRoomContentIcon.PILL, "pillIcon"},
    {eRoomContentFlag.PICKUP_KEY, eRoomContentIcon.KEY, "keyIcon"},
    {eRoomContentFlag.PICKUP_BOMB, eRoomContentIcon.BOMB, "bombIcon"},
    {eRoomContentFlag.PICKUP_POOP, eRoomContentIcon.POOP, nil},
    {eRoomContentFlag.PICKUP_COIN, eRoomContentIcon.COIN, "coinIcon"},
    {eRoomContentFlag.PICKUP_LIL_BATTERY, eRoomContentIcon.BATTERY, "batteryIcon"},
    {eRoomContentFlag.SLOT_BEGGAR, eRoomContentIcon.BEGGAR, "beggarIcon"},
    {eRoomContentFlag.SLOT, eRoomContentIcon.SLOT, "slotIcon"},
    {eRoomContentFlag.GRID_STAIRS, eRoomContentIcon.LADDER, nil},
}

---@param sprite Sprite
---@param contentIcons _RoomContentIcons
local function setup_content_icon_sprite(sprite, contentIcons)
    local bitset = contentIcons.bitset

    for i = 1, #CONTENT_ICON_PRIORITY, 1 do
        local contentIconDesc = CONTENT_ICON_PRIORITY[i]
        local flag = contentIconDesc[1]

        if not BitsetUtils.HasAny(bitset, flag) then
            goto continue
        end

        contentIcons.bitset = BitsetUtils.Clear(bitset, flag)
        local iconKey = contentIconDesc[3]
        local icon = iconKey and contentIcons[iconKey] or 0

        sprite:SetFrame(contentIconDesc[2], icon)
        break
        ::continue::
    end
end

---@param context Context
---@param config MinimapConfigComponent
---@param roomX integer
---@param roomY integer
---@param renderPosition Vector
---@param currentRoom RoomDescriptorComponent
---@param gridRenderOffset Vector
local function render_icons(context, config, roomX, roomY, renderPosition, currentRoom, gridRenderOffset)
    local level = context:GetLevel()
    local roomIdx = roomY * 13 + roomX
    local dimensionLookup = level.m_currentDimensionLookup

    if not (0 <= roomIdx and roomIdx < 169) then
        return
    end

    -- use lua 1-indexed arrays
    local listIdx = dimensionLookup[roomIdx + 1]
    if listIdx < 0 then
        return
    end

    local roomList = level.m_roomList
    local room = roomList[listIdx + 1]

    local gridIdx = room.m_gridIdx
    ---@type RoomDataComponent -- assumed to exist will crash if it doesn't
    local data = room.m_data
    local shape = data.m_shape

    -- guarantee a bigger shape is rendered only once
    if not (gridIdx == roomIdx or (gridIdx + 1 == roomIdx and shape == RoomShape.ROOMSHAPE_LTL)) then
        return
    end

    local roomTypeAnimation = get_room_type_icon(context, room)
    local iconCount = roomTypeAnimation and 1 or 0
    local firstContentIconIdx = iconCount + 1

    local contentIcons = get_room_content_icons(context, room)
    iconCount = iconCount + contentIcons.count

    local temp = (config.m_borderPadding + config.m_cellPixelDistance)
    local iconOffsetX, iconOffsetY = temp, temp
    local renderX, renderY = renderPosition.X, renderPosition.Y
    local cellPixelSize = config.m_cellPixelSize

    if level.m_stage == LevelStage.STAGE7 and data.m_type == RoomType.ROOM_BOSS then
        if shape == RoomShape.ROOMSHAPE_1x2 then
            if BitsetUtils.HasAny(room.m_allowedDoors, eDoorFlags.DOOR_DOWN0 | eDoorFlags.DOOR_LEFT1 | eDoorFlags.DOOR_RIGHT1) then
                renderY = renderY + gridRenderOffset.Y
            end
        end

        if shape == RoomShape.ROOMSHAPE_2x1 then
            if BitsetUtils.HasAny(room.m_allowedDoors, eDoorFlags.DOOR_RIGHT0 | eDoorFlags.DOOR_UP1 | eDoorFlags.DOOR_DOWN1) then
                renderX = renderX + gridRenderOffset.X
            end
        end

        if shape == RoomShape.ROOMSHAPE_2x2 then
            if BitsetUtils.HasAny(room.m_allowedDoors, eDoorFlags.DOOR_RIGHT0 | eDoorFlags.DOOR_UP1) then
                renderX = renderX + gridRenderOffset.X
            elseif BitsetUtils.HasAny(room.m_allowedDoors, eDoorFlags.DOOR_DOWN0 | eDoorFlags.DOOR_LEFT1) then
                renderY = renderY + gridRenderOffset.Y
            elseif BitsetUtils.HasAny(room.m_allowedDoors, eDoorFlags.DOOR_RIGHT1 | eDoorFlags.DOOR_DOWN1) then
                renderX = renderX + gridRenderOffset.X
                renderY = renderY + gridRenderOffset.Y
            end
        end
    else
        if shape == RoomShape.ROOMSHAPE_1x2 then
            iconOffsetY = iconOffsetY + cellPixelSize.Y * 0.5
        end

        if shape == RoomShape.ROOMSHAPE_2x1 then
            iconOffsetX = iconOffsetX + cellPixelSize.X * 0.5
        end

        if shape == RoomShape.ROOMSHAPE_2x2 then
            iconOffsetX = iconOffsetX + cellPixelSize.X * 0.5
            iconOffsetY = iconOffsetY + cellPixelSize.Y * 0.5
        end
    end

    iconCount = math.min(config.m_numDisplayedIcons, iconCount)
    local cellPixelSizeX = cellPixelSize.X
    local cellPixelSizeY = cellPixelSize.Y

    local leftX = cellPixelSizeX * 0.25 + iconOffsetX
    local centerX = cellPixelSizeX * 0.5 + iconOffsetX
    local rightX = cellPixelSizeX * 0.75 + iconOffsetX

    local upY = cellPixelSizeY * 0.25 + iconOffsetY
    local centerY = cellPixelSizeY * 0.5 + iconOffsetY
    local downY = cellPixelSizeY * 0.75 + iconOffsetY

    local layout

    if iconCount <= 1 then
        layout = {
            [1] = Vector(centerX, centerY),
        }
    elseif iconCount <= 2 then
        layout = {
            [1] = Vector(leftX, centerY),
            [2] = Vector(rightX, centerY),
        }
    else
        if iconCount > 4 then
            context:LogMessage(3, "currently there are no more than 4 minimap icons supported\n")
        end
        layout = {
            [1] = Vector(leftX, upY),
            [2] = Vector(rightX, upY),
            [3] = Vector(leftX, downY),
            [4] = Vector(rightX, downY),
        }
    end

    local sprite = config.m_sprite
    renderPosition = Vector(renderX, renderY)
    local iconOffset = Vector(iconOffsetX, iconOffsetY)

    if roomTypeAnimation then
        sprite:SetFrame(roomTypeAnimation, 0)
        local iconPosition = layout[1]
        local position = Vector(
            math.floor(renderX + iconPosition.X - 6.0),
            math.floor(renderY + iconPosition.Y - 6.0)
        )
        sprite:Render(position, VEC_ZERO, VEC_ZERO)
    end

    local i = firstContentIconIdx
    local bitset = contentIcons.bitset
    while i <= iconCount and bitset ~= 0 do
        setup_content_icon_sprite(sprite, contentIcons)

        local iconPosition = layout[i]
        local position = Vector(
            math.floor(renderX + iconPosition.X - 6.0),
            math.floor(renderY + iconPosition.Y - 6.0)
        )

        sprite:Render(position, VEC_ZERO, VEC_ZERO)
    end
end

---@param context Context
---@param config MinimapConfigComponent
local function render(context, config)
    local level = context:GetLevel()

    local currentIdx = level.m_roomIdx
    if currentIdx < 0 then
        return
    end

    local currentDimension = level.m_currentDimensionLookup
    local roomList = level.m_roomList
    local game = context:GetGame()

    if game.m_challenge == Challenge.CHALLENGE_APRILS_FOOL then
        local roomDesc = LevelUtils.GetCurrentRoomDesc(level)
        local rng = RNG(); rng:SetSeed(roomDesc.m_decorationSeed, 1)
        currentIdx = roomList[rng:RandomInt(level.m_roomCount)].m_safeGridIdx
    end
    -- assumed to not be -1 (though it doesn't matter as we would have crashed)
    local currentRoom = roomList[currentDimension[currentIdx] + 1]

    local renderGridWidth = math.min(config.m_renderGridWidth, 13)
    local renderGridHeight = math.min(config.m_renderGridHeight, 13)
    config.m_renderGridWidth = renderGridWidth
    config.m_renderGridHeight = renderGridHeight

    -- center image to currentIdx
    local currentX = currentIdx % 13
    local gridTopLeftX = currentX - renderGridWidth // 2
    gridTopLeftX = MathUtils.Clamp(gridTopLeftX, 0, 13 - renderGridWidth)

    local currentY = currentIdx // 13
    local gridTopLeftY = currentY - renderGridHeight // 2
    gridTopLeftY = MathUtils.Clamp(gridTopLeftY, 0, 13 - renderGridHeight)

    local image = config.m_image
    config.m_renderAreaTopLeftPixel = Vector(image:GetWidth(), image:GetHeight())
    config.m_imageBottomRightPixel = Vector(0, 0)

    local baseRenderPosition = Vector(0, 0)
    local renderPosition = VectorUtils.Copy(baseRenderPosition)
    local gridRenderOffset = config.m_cellPixelSize + config.m_cellPixelDistance

    for itY = 1, renderGridHeight, 1 do
        for itX = 1, renderGridWidth, 1 do
            render_room_outline(context, config, itX + gridTopLeftX - 1, itY + gridTopLeftY - 1, renderPosition)
            renderPosition.X = renderPosition.X + gridRenderOffset
        end
        renderPosition.X = 0
        renderPosition.Y = renderPosition.Y + gridRenderOffset
    end

    local startGridX = gridTopLeftX > 0 and gridTopLeftX - 1 or gridTopLeftX
    local startGridY = gridTopLeftY > 0 and gridTopLeftY - 1 or gridTopLeftY
    local startRenderX = gridTopLeftX > 0 and -gridRenderOffset.X or 0.0
    local startRenderY = gridTopLeftY > 0 and -gridRenderOffset.Y or 0.0

    renderPosition.X = startRenderX
    renderPosition.Y = startRenderY
    local itY = startGridY
    while itY < gridTopLeftY + renderGridHeight do
        local itX = startGridX
        while itY < gridTopLeftX + renderGridWidth do
            render_room(context, config, itX, itY, renderPosition, currentRoom, gridRenderOffset)
            renderPosition.X = renderPosition.X + gridRenderOffset.X
        end
        renderPosition.X = startRenderX
        renderPosition.Y = renderPosition.Y + gridRenderOffset.Y
    end

    renderPosition.X = startRenderX
    renderPosition.Y = startRenderY
    itY = startGridY
    while itY < gridTopLeftY + renderGridHeight do
        local itX = startGridX
        while itY < gridTopLeftX + renderGridWidth do
            render_icons(context, config, itX, itY, renderPosition, currentRoom, gridRenderOffset)
            renderPosition.X = renderPosition.X + gridRenderOffset.X
        end
        renderPosition.X = startRenderX
        renderPosition.Y = renderPosition.Y + gridRenderOffset.Y
    end
end

---@param context Context
---@param config MinimapConfigComponent
local function Render(context, config)
    local anm2Admin = context:GetANM2Manager()
    local graphics = context:GetGraphicsManager()

    ANM2Admin.DisableScreenShaking(anm2Admin)
    GraphicsAdmin.PushRenderTarget(context, graphics)
    graphics:SetRenderTargetTexture(config.m_image, false)
    graphics:Clear()
    GraphicsAdmin.SetBlendMode(graphics, BlendMode.eBlendMode.NORMAL)

    render(context, config)

    GraphicsAdmin.Present(graphics)
    GraphicsAdmin.PopRenderTarget(context, graphics)
    ANM2Admin.EnableScreenShaking(anm2Admin)
end

--#region Module

Module.Render = Render

--#endregion

return Module