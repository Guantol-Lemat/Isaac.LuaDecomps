---@class Decomp.Room.Type.DiceRoom
local DiceRoom = {}
Decomp.Room.Type.Dice = DiceRoom

local g_Game = Game()
local DiceRoomFloor = require("Entity.Effect.DiceRoomFloor")

---@param room Room
function DiceRoom.OnFirstVisit(room)
    local rng = RNG()
    rng:SetSeed(room:GetSpawnSeed(), 35)

    local subType = DiceRoomFloor.GetRandomSubType(rng)
    local diceFloor = g_Game:Spawn(DiceRoomFloor.TYPE, DiceRoomFloor.VARIANT, room:GetCenterPos(), Vector(0, 0), nil, subType, Random())
    diceFloor:Update()
end