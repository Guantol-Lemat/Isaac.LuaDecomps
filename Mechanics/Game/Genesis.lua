--#region Dependencies

local EntityUtils = require("Entity.Utils")
local PlayerUtils = require("Entity.Player.Utils")
local PlayerInventory = require("Mechanics.Player.Inventory")
local Timer = require("Actor.Other.Timer")
local RoomTransition = require("Game.Transition.RoomTransition.Utils")

--#endregion

local function InitializeGenesisRoom(level)
end

local function give_genesis_wisp(myContext)
end

---@type Player.UseActiveItem.Signature
local function UseGenesis(closure, myContext, player)
    if player.m_variant ~= PlayerVariant.PLAYER then
        closure.animate = closure.ANIMATION_ENABLED
        return
    end

    closure.remove = closure.CAN_REMOVE
    local game = myContext.game
    local level = game.m_level

    InitializeGenesisRoom(level)
    level.m_leaveDoor = DoorSlot.NO_DOOR_SLOT

    local mainTwin = PlayerUtils.GetMainTwin(player)
    RoomTransition.StartRoomTransition(game, GridRooms.ROOM_GENESIS_IDX, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT, mainTwin, Dimension.NORMAL)

    if PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES, false) and closure.ALLOW_WISP_SPAWN then
        local timer = Timer.CreateTimer(give_genesis_wisp, 1, 1, true)
        EntityUtils.SetParent(timer, player)
        closure.animate = closure.ANIMATION_ENABLED
    end
end

local Module = {}

--#region Module

Module.UseGenesis = Module.UseGenesis

--#endregion

return Module