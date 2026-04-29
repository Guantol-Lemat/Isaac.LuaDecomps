--#region Dependencies

local ReverseExplosion = require("Mechanics.Room.ReverseExplosion")

--#endregion

---@param ctx Context.Player.UseCard
local function UseReverseTower(ctx)
    local card_rng = ctx.card_rng
    local player = ctx.player
    local seed = card_rng:Next()
    ReverseExplosion.TriggerEffect(ctx, player, seed)
end

---@class Mechanics.Player.CardEffects
local Module = {}

--#region Module

Module.UseReverseTower = UseReverseTower

--#endregion

return Module