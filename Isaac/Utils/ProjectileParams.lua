--#region Dependencies



--#endregion

---@class Component.Npc.ProjectileParams
---@field gridCollision boolean : 0x0
---@field heightModifier number : 0x4
---@field fallingSpeedModifier number : 0x8
---@field fallingAccelModifier number : 0xc
---@field velocityMulti number : 0x10
---@field scale number : 0x14
---@field circleAngle number : 0x18
---@field homingStrength number : 0x1c
---@field curvingStrength number : 0x20
---@field acceleration number : 0x24
---@field spread number : 0x28
---@field color Color : 0x2c
---@field bulletFlags ProjectileFlags | integer : 0x58
---@field positionOffset Vector : 0x60
---@field targetPosition Vector : 0x68
---@field fireDirectionLimit Vector : 0x70
---@field dotProductLimit number : 0x78
---@field wiggleFrameOffset integer : 0x7c
---@field changeFlags integer : 0x80
---@field changeVelocity number : 0x88
---@field changeTimeout integer : 0x8c
---@field depthOffset number : 0x90
---@field variant integer : 0x94
---@field unk_fallingS_A_modifier boolean : 0x98
---@field damage number : 0x9c
---@field interpFunction function? : 0xa0
---@field unk unknown : 0xa4

---@return Component.Npc.ProjectileParams
local function New()
end

---@class Utils.ProjectileParams
local Module = {}

--#region Module

Module.New = New

--#endregion

return Module