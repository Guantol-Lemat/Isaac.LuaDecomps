---@class Interface.Global
local Constants = {}

Constants.VECTOR_ZERO = Vector(0.0, 0.0)
Constants.VECTOR_ONE = Vector(1.0, 1.0)

Constants.COLOR_WHITE = KColor(1.0, 1.0, 1.0, 1.0)
Constants.COLOR_BLACK = KColor(0.0, 0.0, 0.0, 1.0)

Constants.COLOR_MOD_WHITE = Color(1.0, 1.0, 1.0, 1.0)
Constants.COLOR_MOD_DEFAULT = Constants.COLOR_MOD_WHITE

Constants.SOURCE_QUAD_FULL = SourceQuad.NewFromRectangle(Constants.VECTOR_ZERO, 1, 1, true)

return Constants