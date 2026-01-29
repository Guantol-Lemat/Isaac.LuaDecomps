---@class EntityPlayerComponent : EntityComponent
---@field m_playerType PlayerType | integer
---@field m_playerIndex integer
---@field m_babySkin BabySubType | integer
---@field m_maxFireDelay number
---@field m_shotSpeed number
---@field m_damageCooldown integer
---@field m_blinkTime integer
---@field m_tearDisplacement integer
---@field m_controllerIndex integer
---@field m_controlsEnabled boolean
---@field m_controlsCooldown integer
---@field m_maxHearts integer
---@field m_redHearts integer
---@field m_soulHearts integer
---@field m_boneHearts integer
---@field m_numCoins integer
---@field m_numKeys integer
---@field m_damage number
---@field m_weapons WeaponComponent[]
---@field m_itemState CollectibleType
---@field m_aimDirection Vector
---@field m_headDirection Direction
---@field m_collectibleRNG RNG[]
---@field m_trinketRNG RNG[]
---@field m_temporaryEffects TemporaryEffectsComponent
---@field m_twinPlayer EntityPtrComponent
---@field m_backupPlayer EntityPlayerComponent?
---@field m_hasUnlistedState boolean
---@field m_unlistedState GameStatePlayerComponent -- used to trigger effects that would occur when restoring this player (since this doesn't exist before replacement)
---@field m_replacedPlayer EntityPlayerComponent?
---@field m_isCoopGhost boolean
---@field m_isPlayingExtraAnimation boolean
---@field m_isPlayingItemNullAnimation boolean
---@field m_eden_damage number
---@field m_eden_speed number
---@field m_eden_maxFireDelay number
---@field m_eden_range number
---@field m_eden_shotSpeed number
---@field m_eden_luck number
---@field m_markedTarget EntityComponent?
---@field m_peeBurstCooldown integer
---@field m_maxPeeBurstCooldown integer
---@field m_suplexState integer
---@field m_epiphoraCharge integer

--#region Dependencies



--#endregion

---@class EntityPlayerComponentModule
local Module = {}

---@return EntityPlayerComponent
local function Create()
end

--#region Module

Module.Create = Create

--#endregion

return Module