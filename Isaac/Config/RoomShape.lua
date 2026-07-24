--#region Dependencies



--#endregion

local SCORE_SHEET_VISIT_COUNT = {
    [RoomShape.ROOMSHAPE_1x1] = 1,
    [RoomShape.ROOMSHAPE_IH] = 1,
    [RoomShape.ROOMSHAPE_IV] = 1,
    [RoomShape.ROOMSHAPE_1x2] = 1,
    [RoomShape.ROOMSHAPE_IIV] = 1,
    [RoomShape.ROOMSHAPE_2x1] = 1,
    [RoomShape.ROOMSHAPE_IIH] = 1,
    [RoomShape.ROOMSHAPE_2x2] = 2,
    [RoomShape.ROOMSHAPE_LTL] = 2,
    [RoomShape.ROOMSHAPE_LTR] = 2,
    [RoomShape.ROOMSHAPE_LBL] = 2,
    [RoomShape.ROOMSHAPE_LBR] = 2,
}

---@param shape RoomShape | integer
---@return integer
local function GetScoreSheetVisitCount(shape)
    return SCORE_SHEET_VISIT_COUNT[shape]
end

---@class Data.RoomShape
local Module = {}

--#region Module

Module.GetScoreSheetVisitCount = GetScoreSheetVisitCount

--#endregion

return Module