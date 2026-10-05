---@class Interface.ANM2
local Interface = require("Isaac.Interface.ANM2")

---@class Interface.Sprite.LayerState
local Interface_LayerState = Interface.LayerState

--#region Stub

local Stub = {}

function Stub.BeginReflectionRendering() end

function Stub.EndReflectionRendering() end

function Stub.BeginLightRendering() end

function Stub.EndLightRendering() end

function Stub.EnableScreenShaking() end

function Stub.DisableScreenShaking() end

function Stub.EnableGlitchRendering() end

function Stub.DisableGlitchRendering() end

---@param color Color
function Stub.PushColorOverride(color) end

function Stub.PopColorOverride() end

---@param sprite Component.Sprite
---@param color Color
function Stub.SetColor(sprite, color) end

---@param sprite Component.Sprite
---@return Color
function Stub.GetColor(sprite) end

---@param sprite Component.Sprite
---@return boolean
function Stub.GetFlipX(sprite) end

---@param sprite Component.Sprite
---@return boolean
function Stub.GetFlipY(sprite) end

---@param sprite Component.Sprite
---@return Component.Sprite
function Stub.constructor(sprite) end

---@param right Component.Sprite
---@return Component.Sprite
function Stub.construct_from_copy(sprite, right) end

---@param sprite Component.Sprite
---@param param_1 Component.Sprite
---@return Component.Sprite
function Stub.ChangeANM2(sprite, param_1) end

---@param sprite Component.Sprite
function Stub.Reset(sprite) end

---@param sprite Component.Sprite
function Stub.Destructor(sprite) end

---@param sprite Component.Sprite
function Stub.Update(sprite) end

---@param sprite Component.Sprite
---@param Position Vector
---@param TopLeftClamp Vector
---@param BottomRightClamp Vector
function Stub.Render(sprite, Position, TopLeftClamp, BottomRightClamp) end

---@param sprite Component.Sprite
---@param LayerId integer
---@param position Vector
---@param topleftclamp Vector
---@param bottomrightclamp Vector
function Stub.RenderLayer(sprite, LayerId, position, topleftclamp, bottomrightclamp) end

---@param sprite Component.Sprite
---@param position Vector
function Stub.RenderShadowLayer(sprite, position) end

---@param sprite Component.Sprite
---@param Seed integer
function Stub.PlayRandom(sprite, Seed) end

---@param sprite Component.Sprite
---@param AnimationName string
---@param Force boolean
function Stub.Play_Name(sprite, AnimationName, Force) end

---@param sprite Component.Sprite
---@param animIndex integer
function Stub.Play_Idx(sprite, animIndex) end

---@param sprite Component.Sprite
---@param AnimationName string
---@return boolean
function Stub.IsPlaying(sprite, AnimationName) end

---@param sprite Component.Sprite
---@param AnimationName string
---@return boolean
function Stub.IsFinished(sprite, AnimationName) end

---@param sprite Component.Sprite
---@param name string
---@param restart boolean
---@return boolean
function Stub.SetAnimation(sprite, name, restart) end

---@param sprite Component.Sprite
---@param AnimName string
---@param frame number
function Stub.SetFrame(sprite, AnimName, frame) end

---@param sprite Component.Sprite
---@return number
function Stub.GetFramePrecise(sprite)
end

---@param sprite Component.Sprite
---@param Frame integer
function Stub.SetFramePrecise_int(sprite, Frame) end

---@param sprite Component.Sprite
---@param param_2 number
function Stub.SetFramePrecise_float(sprite, param_2) end

---@param sprite Component.Sprite
function Stub.SetLastFrame(sprite) end

---@param sprite Component.Sprite
---@return integer
function Stub.GetFrame(sprite) end

---@param sprite Component.Sprite
---@return number
function Stub.GetAnimationFrame(sprite) end

---@param sprite Component.Sprite
---@param layerId integer
---@return integer
function Stub.GetLayerFrame(sprite, layerId)
end

---@param sprite Component.Sprite
---@param layerID integer
---@param frame integer
function Stub.SetLayerFrame(sprite, layerID, frame) end

---@param sprite Component.Sprite
function Stub.Stop(sprite) end

---@param sprite Component.Sprite
---@param AnimationName string
---@param Force boolean
function Stub.PlayOverlay(sprite, AnimationName, Force) end

---@param sprite Component.Sprite
function Stub.StopOverlay(sprite) end

---@param sprite Component.Sprite
---@param AnimationName string
---@return boolean
function Stub.IsOverlayPlaying(sprite, AnimationName) end

---@param sprite Component.Sprite
---@param AnimationName string
---@return boolean
function Stub.IsOverlayFinished(sprite, AnimationName) end

---@param sprite Component.Sprite
---@param AnimationName string
---@param Reset boolean
---@return boolean
function Stub.SetOverlayAnimation(sprite, AnimationName, Reset) end

---@param sprite Component.Sprite
---@param name string
---@param frame number
function Stub.SetOverlayFrame_AnimName(sprite, name, frame) end

---@param sprite Component.Sprite
---@param frame number
function Stub.SetOverlayFrame(sprite, frame) end

---@param sprite Component.Sprite
---@return integer
function Stub.GetOverlayFrame(sprite) end

---@param sprite Component.Sprite
function Stub.RemoveOverlay(sprite) end

---@param sprite Component.Sprite
---@param param_1 string
---@return boolean
function Stub.IsEventTriggered(sprite, param_1) end

---@param sprite Component.Sprite
---@param name string
---@return boolean
function Stub.WasEventTriggered(sprite, name) end

---@param sprite Component.Sprite
---@param name string
---@return integer
function Stub.GetNullId(sprite, name)
end

---@param sprite Component.Sprite
---@param idx integer
---@return Component.Sprite.NullLayer
function Stub.GetNull(sprite, idx)
end

---@param sprite Component.Sprite
---@param param_1 string
---@param param_2 string
---@param frame integer
---@return Component.Sprite.NullFrame
function Stub.GetNullFrame_AnimLayerName(sprite, param_1, param_2, frame) end

---@param sprite Component.Sprite
---@param id integer
---@return Component.Sprite.NullFrame
function Stub.GetNullFrame(sprite, id) end

---@param sprite Component.Sprite
---@param param_1 string
---@return Component.Sprite.NullFrame
function Stub.GetNullFrame_AnimName(sprite, param_1) end

---@param sprite Component.Sprite
---@param layer integer
---@return Component.Sprite.LayerState?
function Stub.GetLayer_Idx(sprite, layer) end

---@param sprite Component.Sprite
---@param layer integer
---@return Component.Sprite.LayerState?
function Stub.GetLayerState(sprite, layer) end

---@param sprite Component.Sprite
---@param layerName string
---@return Component.Sprite.LayerState?
function Stub.GetLayer_Name(sprite, layerName) end

---@param sprite Component.Sprite
---@param SamplePos_qqq Vector
---@param RenderPos_qqq Vector
---@param AlphaThreshold number
---@param LayerId integer
---@return KColor
function Stub.GetTexel(sprite, SamplePos_qqq, RenderPos_qqq, AlphaThreshold, LayerId) end

---@param sprite Component.Sprite
function Stub.BeginBatches(sprite) end

---@param sprite Component.Sprite
function Stub.EndBatches(sprite) end

---@param sprite Component.Sprite
---@param param_1 string
---@return Component.Sprite.AnimationData
function Stub.GetAnimationData(sprite, param_1) end

---@param sprite Component.Sprite
---@param ANM2Path string
---@param LoadGraphics boolean
function Stub.Load(sprite, ANM2Path, LoadGraphics) end

---@param sprite Component.Sprite
function Stub.Reload(sprite) end

---@param sprite Component.Sprite
---@param LayerId integer
---@param PngFilename string
function Stub.ReplaceSpritesheet(sprite, LayerId, PngFilename) end

---@param sprite Component.Sprite
function Stub.LoadGraphics(sprite) end

---@param sprite Component.Sprite
function Stub.load_graphics(sprite) end

---@param sprite Component.Sprite
---@return Vector
function Stub.GetScale(sprite) end

---@param sprite Component.Sprite
---@return number
function Stub.GetRotation(sprite) end

---@param sprite Component.Sprite
---@return Component.Sprite.AnimationState
function Stub.GetOverlayAnimationState(sprite) end

---@param sprite Component.Sprite
---@param Scale Vector
function Stub.SetScale(sprite, Scale) end

---@param sprite Component.Sprite
---@return string
function Stub.GetFilename(sprite, param_1) end

---@param sprite Component.Sprite
---@param RenderFirst boolean
function Stub.SetOverlayRenderPriority(sprite, RenderFirst) end

---@param sprite Component.Sprite
---@param FlipX boolean
function Stub.SetFlipX(sprite, FlipX) end

---@param sprite Component.Sprite
---@param Rotation number
function Stub.SetRotation(sprite, Rotation) end

---@param sprite Component.Sprite
---@return integer
function Stub.GetLayerCount(sprite) end

---@param sprite Component.Sprite
---@param Speed number
function Stub.SetPlaybackSpeed(sprite, Speed) end

---@param sprite Component.Sprite
---@param Offset Vector
function Stub.SetOffset(sprite, Offset) end

---@param sprite Component.Sprite
---@return number
function Stub.GetPlaybackSpeed(sprite) end

---@param sprite Component.Sprite
---@return Vector
function Stub.GetOffset(sprite) end

---@param sprite Component.Sprite
---@return string
function Stub.GetDefaultAnimationName(sprite) end

---@param sprite Component.Sprite
---@param FlipY boolean
function Stub.SetFlipY(sprite, FlipY) end

---@param sprite Component.Sprite
---@return boolean
function Stub.IsLoaded(sprite) end

---@param sprite Component.Sprite
---@param flags AnimRenderFlags | integer
function Stub.AddBitFlags(sprite, flags) end

---@param sprite Component.Sprite
---@param param_1 Color
function Stub.SetChampionColor_qqq(sprite, param_1) end

--#endregion

Interface.BeginReflectionRendering = Stub.BeginReflectionRendering
Interface.EndReflectionRendering = Stub.EndReflectionRendering
Interface.BeginLightRendering = Stub.BeginLightRendering
Interface.EndLightRendering = Stub.EndLightRendering
Interface.EnableScreenShaking = Stub.EnableScreenShaking
Interface.DisableScreenShaking = Stub.DisableScreenShaking
Interface.EnableGlitchRendering = Stub.EnableGlitchRendering
Interface.DisableGlitchRendering = Stub.DisableGlitchRendering
Interface.PushColorOverride = Stub.PushColorOverride
Interface.PopColorOverride = Stub.PopColorOverride
Interface.SetColor = Stub.SetColor
Interface.GetColor = Stub.GetColor
Interface.GetFlipX = Stub.GetFlipX
Interface.GetFlipY = Stub.GetFlipY
Interface.constructor = Stub.constructor
Interface.construct_from_copy = Stub.construct_from_copy
Interface.ChangeANM2 = Stub.ChangeANM2
Interface.Reset = Stub.Reset
Interface.Destructor = Stub.Destructor
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.RenderLayer = Stub.RenderLayer
Interface.RenderShadowLayer = Stub.RenderShadowLayer
Interface.PlayRandom = Stub.PlayRandom
Interface.Play_Name = Stub.Play_Name
Interface.Play_Idx = Stub.Play_Idx
Interface.IsPlaying = Stub.IsPlaying
Interface.IsFinished = Stub.IsFinished
Interface.SetAnimation = Stub.SetAnimation
Interface.SetFrame = Stub.SetFrame
Interface.GetFramePrecise = Stub.GetFramePrecise
Interface.SetFramePrecise_int = Stub.SetFramePrecise_int
Interface.SetFramePrecise_float = Stub.SetFramePrecise_float
Interface.SetLastFrame = Stub.SetLastFrame
Interface.GetFrame = Stub.GetFrame
Interface.GetAnimationFrame = Stub.GetAnimationFrame
Interface.SetLayerFrame = Stub.SetLayerFrame
Interface.Stop = Stub.Stop
Interface.PlayOverlay = Stub.PlayOverlay
Interface.StopOverlay = Stub.StopOverlay
Interface.IsOverlayPlaying = Stub.IsOverlayPlaying
Interface.IsOverlayFinished = Stub.IsOverlayFinished
Interface.SetOverlayAnimation = Stub.SetOverlayAnimation
Interface.SetOverlayFrame_AnimName = Stub.SetOverlayFrame_AnimName
Interface.SetOverlayFrame = Stub.SetOverlayFrame
Interface.GetOverlayFrame = Stub.GetOverlayFrame
Interface.RemoveOverlay = Stub.RemoveOverlay
Interface.IsEventTriggered = Stub.IsEventTriggered
Interface.WasEventTriggered = Stub.WasEventTriggered
Interface.WasEventTriggered = Stub.WasEventTriggered
Interface.GetNull = Stub.GetNull
Interface.GetNullId = Stub.GetNullId
Interface.GetNullFrame = Stub.GetNullFrame
Interface.GetNullFrame = Stub.GetNullFrame
Interface.GetNullFrame_AnimName = Stub.GetNullFrame_AnimName
Interface.GetLayer_Idx = Stub.GetLayer_Idx
Interface.GetLayerState = Stub.GetLayerState
Interface.GetLayer_Name = Stub.GetLayer_Name
Interface.GetTexel = Stub.GetTexel
Interface.BeginBatches = Stub.BeginBatches
Interface.EndBatches = Stub.EndBatches
Interface.GetAnimationData = Stub.GetAnimationData
Interface.Load = Stub.Load
Interface.Reload = Stub.Reload
Interface.ReplaceSpritesheet = Stub.ReplaceSpritesheet
Interface.LoadGraphics = Stub.LoadGraphics
Interface.load_graphics = Stub.load_graphics
Interface.GetScale = Stub.GetScale
Interface.GetRotation = Stub.GetRotation
Interface.GetOverlayAnimationState = Stub.GetOverlayAnimationState
Interface.SetScale = Stub.SetScale
Interface.GetFilename = Stub.GetFilename
Interface.SetOverlayRenderPriority = Stub.SetOverlayRenderPriority
Interface.SetFlipX = Stub.SetFlipX
Interface.SetRotation = Stub.SetRotation
Interface.GetLayerCount = Stub.GetLayerCount
Interface.SetPlaybackSpeed = Stub.SetPlaybackSpeed
Interface.SetOffset = Stub.SetOffset
Interface.GetPlaybackSpeed = Stub.GetPlaybackSpeed
Interface.GetOffset = Stub.GetOffset
Interface.GetDefaultAnimationName = Stub.GetDefaultAnimationName
Interface.SetFlipY = Stub.SetFlipY
Interface.IsLoaded = Stub.IsLoaded
Interface.AddBitFlags = Stub.AddBitFlags
Interface.SetChampionColor_qqq = Stub.SetChampionColor_qqq

--#region Stub LayerState

local Stub_LayerState = {}

---@param layerState Component.Sprite.LayerState
---@param value Vector
function Stub_LayerState.SetSize(layerState, value) end

---@param layerState Component.Sprite.LayerState
---@param value Vector
function Stub_LayerState.SetPosition(layerState, value) end

---@param layerState Component.Sprite.LayerState
---@param value Color
function Stub_LayerState.SetColor(layerState, value) end

---@param layerState Component.Sprite.LayerState
---@param value Engine.BlendMode
function Stub_LayerState.SetBlendMode(layerState, value) end

--#endregion

Interface_LayerState.SetSize = Stub_LayerState.SetSize
Interface_LayerState.SetPosition = Stub_LayerState.SetPosition
Interface_LayerState.SetColor = Stub_LayerState.SetColor
Interface_LayerState.SetBlendMode = Stub_LayerState.SetBlendMode
