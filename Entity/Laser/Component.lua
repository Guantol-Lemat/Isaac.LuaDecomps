---@class EntityLaserComponent : EntityComponent
---@field m_disableFollowParent boolean

---@class HomingLaserComponent
---@field m_entity EntityPtrComponent : 0x0
---@field m_origin Vector : 0x4
---@field m_endPoint Vector : 0xc
---@field m_unkFloat1 number : 0x14
---@field m_sampleNum integer : 0x18
---@field m_samples Vector[] : 0x1c
---@field m_nonOptimizedSamples Vector[] : 0x28
---@field m_unkVec Vector[] : 0x34
---@field m_isRing integer : 0x40
---@field m_unkFloat2 number : 0x44
---@field m_bezier BezierPointComponent[] : 0x48

---@class BezierPointComponent
---@field anchor Vector 0x0
---@field incomingHandle Vector 0x8
---@field outgoingHandle Vector 0x10