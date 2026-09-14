--#region Dependencies

local IPersistentData = require("Isaac.Interface.PersistentGameData")

--#endregion

---@param ctx Context.Common
---@param spentMoney integer
local function MemberCard(ctx, spentMoney)
    local roomDesc = ctx.game.m_level.m_room.m_roomDescriptor
    if not roomDesc then
        return
    end

    roomDesc.m_shopMoneySpent = roomDesc.m_shopMoneySpent + spentMoney
    if roomDesc.m_shopMoneySpent >= 40 then
        IPersistentData.TryUnlock(ctx.manager.m_persistentGameData, ctx, Achievement.MEMBER_CARD)
    end
end

---@class GameEffects.Achievement
local Module = {}

--#region Module

Module.MemberCard = MemberCard

--#endregion

return Module