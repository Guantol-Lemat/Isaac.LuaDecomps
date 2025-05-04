---@class Decomp.IGlobalAPI
---@field Manager Decomp.IManager
---@field Game Decomp.IGame
---@field Level Decomp.ILevel
---@field Room Decomp.IRoom
---@field RoomDescriptor Decomp.IRoomDescriptor
---@field ItemPool Decomp.IItemPool
---@field ItemConfig Decomp.IItemConfig
---@field SFXManager Decomp.ISFXManager
---@field MusicManager Decomp.IMusicManager
---@field PlayerManager Decomp.IPlayerManager
---@field PersistentGameData Decomp.IPersistentGameData
---@field Entity Decomp.IEntity
---@field EntityPlayer Decomp.IEntityPlayer
---@field TemporaryEffects Decomp.ITemporaryEffects

---@class Decomp.IEnvironment
---@class Decomp.IGameObject
---@class Decomp.ILevelObject
---@class Decomp.IRoomObject
---@class Decomp.IRoomDescObject
---@class Decomp.IItemPoolObject
---@class Decomp.IPlayerManagerObject
---@class Decomp.IPersistentGameDataObject
---@class Decomp.IItemConfigObject
---@class Decomp.IEntityObject
---@class Decomp.IEntityPlayerObject : Decomp.IEntityObject
---@class Decomp.ITemporaryEffectsObject

---@class Decomp.IManager
---@field GetGame fun(env: Decomp.IEnvironment): Decomp.IGameObject
---@field GetItemConfig fun(env: Decomp.IEnvironment): Decomp.IItemConfigObject
---@field GetPersistentGameData fun(env: Decomp.IEnvironment): Decomp.IPersistentGameDataObject
---@field LogMessage fun(logType: integer, message: string, ...)

---@class Decomp.IGame
---@field GetLevel fun(game: Decomp.IGameObject): Decomp.ILevelObject
---@field GetRoom fun(game: Decomp.IGameObject): Decomp.IRoomObject
---@field GetCurrentRoomDesc fun(game: Decomp.IGameObject): Decomp.IRoomDescObject
---@field GetItemPool fun(game: Decomp.IGameObject): Decomp.IItemPoolObject
---@field GetPlayerManager fun(game: Decomp.IGameObject): Decomp.IPlayerManagerObject
---@field IsGreedMode fun(game: Decomp.IGameObject): boolean

---@class Decomp.ILevel
---@field GetStateFlag fun(level: Decomp.ILevelObject, flag: LevelStateFlag): boolean

---@class Decomp.IRoom
---@field GetRoomType fun(room: Decomp.IRoomObject): RoomType | integer
---@field GetRoomDescriptor fun(room: Decomp.IRoomObject): Decomp.IRoomDescObject
---@field GetRoomGridIdx fun(room: Decomp.IRoomObject): GridRooms | integer
---@field GetTemporaryEffects fun(room: Decomp.IRoomObject): Decomp.ITemporaryEffectsObject
---@field GetSeededCollectible fun(room: Decomp.IRoomObject, seed: integer, advanceRNG: boolean): CollectibleType | integer

---@class Decomp.IRoomDescriptor
---@field GetGridIdx fun(roomDesc: Decomp.IRoomDescObject): GridRooms | integer
---@field GetRoomData fun(roomDesc: Decomp.IRoomDescObject): RoomConfigRoom
---@field GetDecorationSeed fun(roomDesc: Decomp.IRoomDescObject): integer
---@field GetAwardSeed fun(roomDesc: Decomp.IRoomDescObject): integer
---@field SetAwardSeed fun(roomDesc: Decomp.IRoomDescObject, seed: integer)
---@field HasFlags fun(roomDesc: Decomp.IRoomDescObject, flags: integer): boolean

---@class Decomp.IItemPool
---@field GetCollectible fun(itemPool: Decomp.IItemPoolObject, poolType: ItemPoolType | integer, decrease: boolean, seed: integer, defaultItem: CollectibleType | integer, flags: GetCollectibleFlag | integer): CollectibleType | integer
---@field GetTrinket fun(itemPool: Decomp.IItemPoolObject, dontAdvanceRNG: boolean): TrinketType | integer
---@field GetCard fun(itemPool: Decomp.IItemPoolObject, seed: integer, playing: boolean, rune: boolean, onlyRunes: boolean): Card | integer
---@field GetCardEx fun(itemPool: Decomp.IItemPoolObject, seed: integer, specialChance: integer, runeChance: integer, suitChance: integer, allowNonCards: boolean): Card | integer
---@field GetPill fun(itemPool: Decomp.IItemPoolObject, seed: integer): PillColor | integer

---@class Decomp.IItemConfig
---@field GetCollectible fun(itemConfig: Decomp.IItemConfigObject, collectible: CollectibleType | integer): ItemConfigItem?
---@field GetTrinket fun(itemConfig: Decomp.IItemConfigObject, trinket: TrinketType | integer): ItemConfigItem?
---@field GetCard fun(itemConfig: Decomp.IItemConfigObject, card: Card | integer): ItemConfigCard?
---@field GetPillEffect fun(itemConfig: Decomp.IItemConfigObject, pill: PillEffect | integer): ItemConfigPillEffect?

---@class Decomp.IPlayerManager
---@field GetPlayer fun(playerManager: Decomp.IPlayerManagerObject, index: integer): Decomp.IEntityPlayerObject
---@field GetNumPlayers fun(playerManager: Decomp.IPlayerManagerObject): integer
---@field GetNumCollectibles fun(playerManager: Decomp.IPlayerManagerObject, collectible: CollectibleType | integer): integer
---@field AnyoneIsPlayerType fun(playerManager: Decomp.IPlayerManagerObject, playerType: PlayerType | integer): boolean
---@field AnyoneHasCollectible fun(playerManager: Decomp.IPlayerManagerObject, collectible: CollectibleType | integer): boolean
---@field AnyoneHasTrinket fun(playerManager: Decomp.IPlayerManagerObject, trinket: TrinketType | integer): boolean
---@field AnyPlayerTypeHasBirthright fun(playerManager: Decomp.IPlayerManagerObject, playerType: PlayerType | integer): boolean

---@class Decomp.IPersistentGameData
---@field Unlocked fun(persistentGameData: Decomp.IPersistentGameDataObject, achievement: Achievement | integer): boolean

---@class Decomp.IEntity
---@field GetVariant fun(entity: Decomp.IEntityObject): integer
---@field GetParent fun(entity: Decomp.IEntityObject): Decomp.IEntityObject?

---@class Decomp.IEntityPlayer
---@field IsCoopGhost fun(player: Decomp.IEntityPlayerObject): boolean
---@field GetHealthType fun(player: Decomp.IEntityPlayerObject): HealthType
---@field GetEffectiveMaxHearts fun(player: Decomp.IEntityPlayerObject): integer
---@field GetSoulHearts fun(player: Decomp.IEntityPlayerObject): integer
---@field IsHologram fun(player: Decomp.IEntityPlayerObject): boolean
---@field HasInstantDeathCurse fun(player: Decomp.IEntityPlayerObject): boolean

---@class Decomp.ITemporaryEffects
---@field HasCollectibleEffect fun(effects: Decomp.ITemporaryEffectsObject, collectible: CollectibleType | integer): boolean