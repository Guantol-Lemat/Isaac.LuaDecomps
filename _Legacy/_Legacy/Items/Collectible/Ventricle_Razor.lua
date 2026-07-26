---@class Decomp.Collectible.VentricleRazor
local VentricleRazor = {}
Decomp.Item.Collectible.VentricleRazor = VentricleRazor

require("Data.Level")

local Data = Decomp.Data

---@param level Level
---@param portalIdx integer
---@param gridIdx integer
---@param unk boolean
function VentricleRazor.UpdatePortal(level, portalIdx, gridIdx, unk)
    local levelData = Data.Level.GetData()
    assert(0 <= portalIdx and portalIdx <= 1, "Invalid portal index")

    local portal = levelData.m_Portals[portalIdx]

    portal.m_RoomIdx = level:GetCurrentRoomIndex()
    portal.m_GridIdx = gridIdx
    portal.m_UnkBookOfVirtuesRelated = unk
end