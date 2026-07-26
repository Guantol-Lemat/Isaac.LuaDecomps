---@class Decomp.Collectible.BookOfVirtues
local BookOfVirtues = {}

---@param player Decomp.Object.EntityPlayer
---@param useFlags UseFlag | integer
local function CanSpawnWispOnUse(player, useFlags)
    if (useFlags & UseFlag.USE_ALLOWWISPSPAWN) ~= 0 then
        return true
    end

    if player.m_Variant ~= PlayerVariant.PLAYER then
        return false
    end

    if (useFlags & UseFlag.USE_NOANIM) == 0 then
        return true
    end

    return false
end

--#region Module

BookOfVirtues.CanSpawnWispOnUse = CanSpawnWispOnUse

--#endregion

return BookOfVirtues