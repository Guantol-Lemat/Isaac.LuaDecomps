---@class Decomp.Lib.PersistentGameData
local Lib_PersistentGameData = {}
Decomp.Lib.PersistentGameData = Lib_PersistentGameData

---@class Decomp.Lib.PersistentGameData.CompletionEvent
---@field eventCounter EventCounter
---@field achievement Achievement

---@enum Decomp.Lib.PersistentGameData.eCompletionEvent
Lib_PersistentGameData.eCompletionEvent = {
    MOMS_HEART = 0,
    ISAAC = 1,
    SATAN = 2,
    BOSS_RUSH = 3,
    BLUE_BABY = 4,
    LAMB = 5,
    MEGA_SATAN = 6,
    ULTRA_GREED = 7,
    GREED_DONATIONS = 8,
    HUSH = 9,
    ALL_HARD_MODE_MARKS = 10,
    ULTRA_GREEDIER = 11,
    DELIRIUM = 12,
    MOTHER = 13,
    BEAST = 14,
    TAINTED_PLAYER = 15,
    BASE_BOSSES = 16,
    RUSH_BOSSES = 17,
    NUM_COMPLETION_EVENTS = 18,
}

local eCompletionEvent = Lib_PersistentGameData.eCompletionEvent

---@type table<PlayerType, table<Decomp.Lib.PersistentGameData.eCompletionEvent, Decomp.Lib.PersistentGameData.CompletionEvent>>
local g_PlayerCompletionEvents = {
    [PlayerType.PLAYER_ISAAC] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_ISAAC,
            achievement = Achievement.LOST_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_ISAAC,
            achievement = Achievement.ISAACS_TEARS,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_ISAAC,
            achievement = Achievement.MOMS_KNIFE,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_ISAAC,
            achievement = Achievement.ISAACS_HEAD,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_ISAAC,
            achievement = Achievement.D20,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_ISAAC,
            achievement = Achievement.MISSING_POSTER,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_ISAAC,
            achievement = Achievement.CRY_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_ISAAC,
            achievement = Achievement.LIL_CHEST,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_ISAAC,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_ISAAC,
            achievement = Achievement.FARTING_BABY,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.BUDDY_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.D1,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_ISAAC,
            achievement = Achievement.D_INFINITY,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_ISAAC,
            achievement = Achievement.MEAT_CLEAVER,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_ISAAC,
            achievement = Achievement.OPTIONS,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_ISAAC,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_MAGDALENE] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_MAGDALENE,
            achievement = Achievement.CUTE_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_MAGDALENE,
            achievement = Achievement.RELIC,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_MAGDALENE,
            achievement = Achievement.GUARDIAN_ANGEL,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_MAGDALENE,
            achievement = Achievement.MAGGYS_BOW,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_MAGDALENE,
            achievement = Achievement.CELTIC_CROSS,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_MAGDALENE,
            achievement = Achievement.MAGGYS_FAITH,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_MAGDALENE,
            achievement = Achievement.RED_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_MAGDALENE,
            achievement = Achievement.CENSER,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_MAGDALENE,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_MAGDALENE,
            achievement = Achievement.PURITY,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.COLORFUL_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.GLYPH_OF_BALANCE,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_MAGDALENE,
            achievement = Achievement.EUCHARIST,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_MAGDALENE,
            achievement = Achievement.YUCK_HEART,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_MAGDALENE,
            achievement = Achievement.CANDY_HEART,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_MAGDALENE,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_CAIN] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_CAIN,
            achievement = Achievement.GLASS_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_CAIN,
            achievement = Achievement.BAG_OF_PENNIES,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_CAIN,
            achievement = Achievement.BAG_OF_BOMBS,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_CAIN,
            achievement = Achievement.CAINS_OTHER_EYE,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_CAIN,
            achievement = Achievement.CAINS_EYE,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_CAIN,
            achievement = Achievement.ABEL,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_CAIN,
            achievement = Achievement.GREEN_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_CAIN,
            achievement = Achievement.EVIL_EYE,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_CAIN,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_CAIN,
            achievement = Achievement.D12,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.PICKY_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SACK_OF_SACKS,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_CAIN,
            achievement = Achievement.SILVER_DOLLAR,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_CAIN,
            achievement = Achievement.GUPPYS_EYE,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_CAIN,
            achievement = Achievement.POUND_OF_FLESH,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_CAIN,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_JUDAS] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_JUDAS,
            achievement = Achievement.SHADOW_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_JUDAS,
            achievement = Achievement.GUILLOTINE,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_JUDAS,
            achievement = Achievement.JUDAS_TONGUE,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_JUDAS,
            achievement = Achievement.JUDAS_SHADOW,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_JUDAS,
            achievement = Achievement.LEFT_HAND,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_JUDAS,
            achievement = Achievement.CURVED_HORN,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_JUDAS,
            achievement = Achievement.BROWN_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_JUDAS,
            achievement = Achievement.MY_SHADOW,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_JUDAS,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_JUDAS,
            achievement = Achievement.BETRAYAL,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.BELIAL_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.EYE_OF_BELIAL,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_JUDAS,
            achievement = Achievement.SHADE,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_JUDAS,
            achievement = Achievement.AKELDAMA,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_JUDAS,
            achievement = Achievement.REDEMPTION,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_JUDAS,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_BLUEBABY] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_BLUE_BABY,
            achievement = Achievement.DEAD_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_BLUE_BABY,
            achievement = Achievement.ISAAC_HOLDS_THE_D6,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_BLUE_BABY,
            achievement = Achievement.FORGET_ME_NOW,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_BLUE_BABY,
            achievement = Achievement.BLUE_BABYS_ONLY_FRIEND,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_BLUE_BABY,
            achievement = Achievement.FATE,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_BLUE_BABY,
            achievement = Achievement.BLUE_BABYS_SOUL,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_BLUE_BABY,
            achievement = Achievement.BLUE_COOP_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_BLUE_BABY,
            achievement = Achievement.CRACKED_DICE,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_BLUE,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_BLUE_BABY,
            achievement = Achievement.FATES_REWARD,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.HIVE_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.MECONIUM,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_BLUE_BABY,
            achievement = Achievement.KING_BABY,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_BLUE_BABY,
            achievement = Achievement.ETERNAL_D6,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_BLUE_BABY,
            achievement = Achievement.MONTEZUMAS_REVENGE,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_BLUE_BABY,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_EVE] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_EVE,
            achievement = Achievement.CROW_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_EVE,
            achievement = Achievement.EVES_BIRD_FOOT,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_EVE,
            achievement = Achievement.RAZOR,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_EVE,
            achievement = Achievement.EVES_MASCARA,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_EVE,
            achievement = Achievement.SACRIFICIAL_DAGGER,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_EVE,
            achievement = Achievement.BLACK_LIPSTICK,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_EVE,
            achievement = Achievement.LIL_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_EVE,
            achievement = Achievement.BLACK_FEATHER,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_EVE,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_EVE,
            achievement = Achievement.ATHAME,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.WHORE_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.CROW_HEART,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_EVE,
            achievement = Achievement.DULL_RAZOR,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_EVE,
            achievement = Achievement.BIRD_CAGE,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_EVE,
            achievement = Achievement.CRACKED_ORB,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_EVE,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_SAMSON] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_SAMSON,
            achievement = Achievement.FIGHTING_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_SAMSON,
            achievement = Achievement.BLOODY_LUST,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_SAMSON,
            achievement = Achievement.BLOOD_RIGHTS,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_SAMSON,
            achievement = Achievement.SAMSONS_CHAINS,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_SAMSON,
            achievement = Achievement.BLOODY_PENNY,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_SAMSON,
            achievement = Achievement.SAMSONS_LOCK,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_SAMSON,
            achievement = Achievement.RAGE_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_SAMSON,
            achievement = Achievement.LUSTY_BLOOD,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_SAMSON,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_SAMSON,
            achievement = Achievement.BLIND_RAGE,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVENGE_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.STEM_CELL,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_SAMSON,
            achievement = Achievement.BLOODY_CROWN,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_SAMSON,
            achievement = Achievement.BLOODY_GUST,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_SAMSON,
            achievement = Achievement.EMPTY_HEART,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_SAMSON,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_AZAZEL] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_AZAZEL,
            achievement = Achievement.BEGOTTEN_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_AZAZEL,
            achievement = Achievement.SATANIC_BIBLE,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_AZAZEL,
            achievement = Achievement.DAEMONS_TAIL,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_AZAZEL,
            achievement = Achievement.NAIL,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_AZAZEL,
            achievement = Achievement.ABADDON,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_AZAZEL,
            achievement = Achievement.DEMON_BABY,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_AZAZEL,
            achievement = Achievement.BLACK_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_AZAZEL,
            achievement = Achievement.LILITH,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_AZAZEL,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_AZAZEL,
            achievement = Achievement.MAW_OF_THE_VOID,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SUCKY_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.BAT_WING,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_AZAZEL,
            achievement = Achievement.DARK_PRINCES_CROWN,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_AZAZEL,
            achievement = Achievement.DEVILS_CROWN,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_AZAZEL,
            achievement = Achievement.LIL_ABADDON,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_AZAZEL,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_LAZARUS] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_LAZARUS,
            achievement = Achievement.WRAPPED_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_LAZARUS,
            achievement = Achievement.LAZARUS_RAGS,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_LAZARUS,
            achievement = Achievement.BROKEN_ANKH,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_LAZARUS,
            achievement = Achievement.MISSING_NO,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_LAZARUS,
            achievement = Achievement.STORE_CREDIT,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_LAZARUS,
            achievement = Achievement.PANDORAS_BOX,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_LAZARUS,
            achievement = Achievement.LONG_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_LAZARUS,
            achievement = Achievement.KEY_BUM,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_LAZARUS,
            achievement = Achievement.EMPTY_VESSEL,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.DRIPPING_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.PLAN_C,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_LAZARUS,
            achievement = Achievement.COMPOUND_FRACTURE,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_LAZARUS,
            achievement = Achievement.TINYTOMA,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_LAZARUS,
            achievement = Achievement.ASTRAL_PROJECTION,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_LAZARUS,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_EDEN] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_EDEN,
            achievement = Achievement.GLITCH_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_EDEN,
            achievement = Achievement.BLANK_CARD,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_EDEN,
            achievement = Achievement.BOOK_OF_SECRETS,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_EDEN,
            achievement = Achievement.UNDEFINED,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_EDEN,
            achievement = Achievement.MYSTERIOUS_PAPER,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_EDEN,
            achievement = Achievement.MYSTERY_SACK,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_EDEN,
            achievement = Achievement.YELLOW_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_EDEN,
            achievement = Achievement.GB_BUG,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_EDEN,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_EDEN,
            achievement = Achievement.EDENS_BLESSING,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.CRACKED_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.METRONOME,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_EDEN,
            achievement = Achievement.EDENS_SOUL,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_EDEN,
            achievement = Achievement.M,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_EDEN,
            achievement = Achievement.EVERYTHING_JAR,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_EDEN,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_THELOST] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_THE_LOST,
            achievement = Achievement.ZERO_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_THE_LOST,
            achievement = Achievement.ISAACS_HEART,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_THE_LOST,
            achievement = Achievement.MIND,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_THE_LOST,
            achievement = Achievement.A_D100,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_THE_LOST,
            achievement = Achievement.BODY,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_THE_LOST,
            achievement = Achievement.SOUL,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_THE_LOST,
            achievement = Achievement.WHITE_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_THE_LOST,
            achievement = Achievement.ZODIAC,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_THE_LOST,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_THE_LOST,
            achievement = Achievement.SWORN_PROTECTOR,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.GODHEAD,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.DADS_LOST_COIN,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_THE_LOST,
            achievement = Achievement.HOLY_CARD,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_THE_LOST,
            achievement = Achievement.LOST_SOUL,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_THE_LOST,
            achievement = Achievement.HUNGRY_SOUL,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_LOST,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_LAZARUS2] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_LAZARUS,
            achievement = Achievement.WRAPPED_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_LAZARUS,
            achievement = Achievement.LAZARUS_RAGS,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_LAZARUS,
            achievement = Achievement.BROKEN_ANKH,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_LAZARUS,
            achievement = Achievement.MISSING_NO,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_LAZARUS,
            achievement = Achievement.STORE_CREDIT,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_LAZARUS,
            achievement = Achievement.PANDORAS_BOX,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_LAZARUS,
            achievement = Achievement.LONG_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_LAZARUS,
            achievement = Achievement.KEY_BUM,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_LAZARUS,
            achievement = Achievement.EMPTY_VESSEL,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.DRIPPING_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.PLAN_C,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_LAZARUS,
            achievement = Achievement.COMPOUND_FRACTURE,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_LAZARUS,
            achievement = Achievement.TINYTOMA,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_LAZARUS,
            achievement = Achievement.ASTRAL_PROJECTION,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_LAZARUS,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_BLACKJUDAS] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_JUDAS,
            achievement = Achievement.SHADOW_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_JUDAS,
            achievement = Achievement.GUILLOTINE,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_JUDAS,
            achievement = Achievement.JUDAS_TONGUE,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_JUDAS,
            achievement = Achievement.JUDAS_SHADOW,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_JUDAS,
            achievement = Achievement.LEFT_HAND,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_JUDAS,
            achievement = Achievement.CURVED_HORN,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_JUDAS,
            achievement = Achievement.BROWN_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_JUDAS,
            achievement = Achievement.MY_SHADOW,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_JUDAS,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_JUDAS,
            achievement = Achievement.BETRAYAL,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.BELIAL_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.EYE_OF_BELIAL,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_JUDAS,
            achievement = Achievement.SHADE,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_JUDAS,
            achievement = Achievement.AKELDAMA,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_JUDAS,
            achievement = Achievement.REDEMPTION,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_JUDAS,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_LILITH] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_LILITH,
            achievement = Achievement.GOAT_HEAD_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_LILITH,
            achievement = Achievement.RUNE_BAG,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_LILITH,
            achievement = Achievement.SERPENTS_KISS,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_LILITH,
            achievement = Achievement.IMMACULATE_CONCEPTION,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_LILITH,
            achievement = Achievement.CAMBION_CONCEPTION,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_LILITH,
            achievement = Achievement.SUCCUBUS,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_LILITH,
            achievement = Achievement.BIG_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_LILITH,
            achievement = Achievement.BOX_OF_FRIENDS,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_LILITH,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_LILITH,
            achievement = Achievement.INCUBUS,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.DARK_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.DUALITY,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_LILITH,
            achievement = Achievement.EUTHANASIA,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_LILITH,
            achievement = Achievement.BLOOD_PUPPY,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_LILITH,
            achievement = Achievement.C_SECTION,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_LILITH,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_KEEPER] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_KEEPER,
            achievement = Achievement.SUPER_GREED_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_KEEPER,
            achievement = Achievement.KEEPER_HOLDS_WOODEN_NICKEL,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_KEEPER,
            achievement = Achievement.KEEPER_HOLDS_STORE_KEY,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_KEEPER,
            achievement = Achievement.STICKY_NICKELS,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_KEEPER,
            achievement = Achievement.DEEP_POCKETS,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_KEEPER,
            achievement = Achievement.KARMA,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_KEEPER,
            achievement = Achievement.NOOSE_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_KEEPER,
            achievement = Achievement.RIB_OF_GREED,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_KEEPER,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_KEEPER,
            achievement = Achievement.KEEPER_HOLDS_A_PENNY,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SALE_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.EYE_OF_GREED,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_KEEPER,
            achievement = Achievement.CROOKED_CARD,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_KEEPER,
            achievement = Achievement.KEEPERS_SACK,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_KEEPER,
            achievement = Achievement.KEEPERS_BOX,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_KEEPER,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_APOLLYON] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_APOLLYON,
            achievement = Achievement.SMELTER,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_APOLLYON,
            achievement = Achievement.LOCUST_OF_WRATH,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_APOLLYON,
            achievement = Achievement.LOCUST_OF_PESTILENCE,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_APOLLYON,
            achievement = Achievement.LOCUST_OF_CONQUEST,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_APOLLYON,
            achievement = Achievement.LOCUST_OF_FAMINE,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_APOLLYON,
            achievement = Achievement.LOCUST_OF_DEATH,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_APOLLYON,
            achievement = Achievement.MORT_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_APOLLYON,
            achievement = Achievement.BROWN_NUGGET,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_APOLLYON,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_APOLLYON,
            achievement = Achievement.HUSHY,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.APOLLYON_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.BLACK_RUNE,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_APOLLYON,
            achievement = Achievement.VOID,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_APOLLYON,
            achievement = Achievement.LIL_PORTAL,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_APOLLYON,
            achievement = Achievement.WORM_FRIEND,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_APOLLYON,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_THEFORGOTTEN] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_THE_FORGOTTEN,
            achievement = Achievement.MARROW,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_THE_FORGOTTEN,
            achievement = Achievement.SLIPPED_RIB,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_THE_FORGOTTEN,
            achievement = Achievement.POINTY_RIB,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_THE_FORGOTTEN,
            achievement = Achievement.DIVORCE_PAPERS,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_THE_FORGOTTEN,
            achievement = Achievement.JAW_BONE,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_THE_FORGOTTEN,
            achievement = Achievement.BRITTLE_BONES,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_THE_FORGOTTEN,
            achievement = Achievement.BOUND_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_THE_FORGOTTEN,
            achievement = Achievement.FINGER_BONE,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_THE_FORGOTTEN,
            achievement = Achievement.HALLOWED_GROUND,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.BONE_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.DADS_RING,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_THE_FORGOTTEN,
            achievement = Achievement.BOOK_OF_THE_DEAD,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_THE_FORGOTTEN,
            achievement = Achievement.BONE_SPURS,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_THE_FORGOTTEN,
            achievement = Achievement.SPIRIT_SHACKLES,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_FORGOTTEN,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_THESOUL] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_THE_FORGOTTEN,
            achievement = Achievement.MARROW,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_THE_FORGOTTEN,
            achievement = Achievement.SLIPPED_RIB,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_THE_FORGOTTEN,
            achievement = Achievement.POINTY_RIB,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_THE_FORGOTTEN,
            achievement = Achievement.DIVORCE_PAPERS,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_THE_FORGOTTEN,
            achievement = Achievement.JAW_BONE,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_THE_FORGOTTEN,
            achievement = Achievement.BRITTLE_BONES,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_THE_FORGOTTEN,
            achievement = Achievement.BOUND_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_THE_FORGOTTEN,
            achievement = Achievement.FINGER_BONE,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_THE_FORGOTTEN,
            achievement = Achievement.HALLOWED_GROUND,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.BONE_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.DADS_RING,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_THE_FORGOTTEN,
            achievement = Achievement.BOOK_OF_THE_DEAD,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_THE_FORGOTTEN,
            achievement = Achievement.BONE_SPURS,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_THE_FORGOTTEN,
            achievement = Achievement.SPIRIT_SHACKLES,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_FORGOTTEN,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_BETHANY] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_BETHANY,
            achievement = Achievement.WISP_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_BETHANY,
            achievement = Achievement.BOOK_OF_VIRTUES,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_BETHANY,
            achievement = Achievement.URN_OF_SOULS,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_BETHANY,
            achievement = Achievement.BETHS_FAITH,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_BETHANY,
            achievement = Achievement.BLESSED_PENNY,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_BETHANY,
            achievement = Achievement.ALABASTER_BOX,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_BETHANY,
            achievement = Achievement.GLOWING_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_BETHANY,
            achievement = Achievement.SOUL_LOCKET,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_BETHANY,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_BETHANY,
            achievement = Achievement.DIVINE_INTERVENTION,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.HOPE_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.VADE_RETRO,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_BETHANY,
            achievement = Achievement.STAR_OF_BETHLEHEM,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_BETHANY,
            achievement = Achievement.REVELATION,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_BETHANY,
            achievement = Achievement.JAR_OF_WISPS,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_BETHANY,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_JACOB] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_JACOB_AND_ESAU,
            achievement = Achievement.DOUBLE_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_JACOB_AND_ESAU,
            achievement = Achievement.STAIRWAY,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_JACOB_AND_ESAU,
            achievement = Achievement.RED_STEW,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_JACOB_AND_ESAU,
            achievement = Achievement.ROCK_BOTTOM,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_JACOB_AND_ESAU,
            achievement = Achievement.BIRTHRIGHT,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_JACOB_AND_ESAU,
            achievement = Achievement.DAMOCLES,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_JACOB_AND_ESAU,
            achievement = Achievement.ILLUSION_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_JACOB_AND_ESAU,
            achievement = Achievement.INNER_CHILD,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_JACOB_AND_ESAU,
            achievement = Achievement.VANISHING_TWIN,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOLOMONS_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.GENESIS,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_JACOB_AND_ESAU,
            achievement = Achievement.SUPLEX,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_JACOB_AND_ESAU,
            achievement = Achievement.MAGIC_SKIN,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_JACOB_AND_ESAU,
            achievement = Achievement.FRIEND_FINDER,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_JACOB,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_ESAU] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_JACOB_AND_ESAU,
            achievement = Achievement.DOUBLE_BABY,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_JACOB_AND_ESAU,
            achievement = Achievement.STAIRWAY,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_JACOB_AND_ESAU,
            achievement = Achievement.RED_STEW,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_JACOB_AND_ESAU,
            achievement = Achievement.ROCK_BOTTOM,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_JACOB_AND_ESAU,
            achievement = Achievement.BIRTHRIGHT,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_JACOB_AND_ESAU,
            achievement = Achievement.DAMOCLES,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_JACOB_AND_ESAU,
            achievement = Achievement.ILLUSION_BABY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_JACOB_AND_ESAU,
            achievement = Achievement.INNER_CHILD,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_JACOB_AND_ESAU,
            achievement = Achievement.VANISHING_TWIN,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOLOMONS_BABY,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.GENESIS,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_JACOB_AND_ESAU,
            achievement = Achievement.SUPLEX,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_JACOB_AND_ESAU,
            achievement = Achievement.MAGIC_SKIN,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_JACOB_AND_ESAU,
            achievement = Achievement.FRIEND_FINDER,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TAINTED_JACOB,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
    },
    [PlayerType.PLAYER_ISAAC_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_ISAAC,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_ISAAC,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_ISAAC,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_ISAAC,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_ISAAC,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_ISAAC,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_ISAAC,
            achievement = Achievement.MEGA_CHEST,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_ISAAC,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_ISAAC,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_ISAAC,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_STARS,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_ISAAC,
            achievement = Achievement.SPINDOWN_DICE,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_ISAAC,
            achievement = Achievement.DICE_BAG,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_ISAAC,
            achievement = Achievement.GLITCHED_CROWN,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.MOMS_LOCK,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_ISAAC,
        },
    },
    [PlayerType.PLAYER_MAGDALENE_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_MAGDALENE,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_MAGDALENE,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_MAGDALENE,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_MAGDALENE,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_MAGDALENE,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_MAGDALENE,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_MAGDALENE,
            achievement = Achievement.QUEEN_OF_HEARTS,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_MAGDALENE,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_MAGDALENE,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_MAGDALENE,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_LOVERS,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_MAGDALENE,
            achievement = Achievement.HYPERCOAGULATION,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_MAGDALENE,
            achievement = Achievement.MOTHERS_KISS,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_MAGDALENE,
            achievement = Achievement.BELLY_JELLY,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.HOLY_CROWN,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_MAGDALENE,
        },
    },
    [PlayerType.PLAYER_CAIN_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_CAIN,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_CAIN,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_CAIN,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_CAIN,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_CAIN,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_CAIN,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_CAIN,
            achievement = Achievement.GOLDEN_PILLS,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_CAIN,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_CAIN,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_CAIN,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_WHEEL_OF_FORTUNE,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_CAIN,
            achievement = Achievement.BAG_OF_CRAFTING,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_CAIN,
            achievement = Achievement.LUCKY_SACK,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_CAIN,
            achievement = Achievement.BLUE_KEY,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.GILDED_KEY,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_CAIN,
        },
    },
    [PlayerType.PLAYER_JUDAS_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_JUDAS,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_JUDAS,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_JUDAS,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_JUDAS,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_JUDAS,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_JUDAS,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_JUDAS,
            achievement = Achievement.BLACK_SACK,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_JUDAS,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_JUDAS,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_JUDAS,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_MAGICIAN,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_JUDAS,
            achievement = Achievement.DARK_ARTS,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_JUDAS,
            achievement = Achievement.NUMBER_MAGNET,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_JUDAS,
            achievement = Achievement.SANGUINE_BOND,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.YOUR_SOUL,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_JUDAS,
        },
    },
    [PlayerType.PLAYER_BLUEBABY_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_BLUE_BABY,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_BLUE_BABY,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_BLUE_BABY,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_BLUE_BABY,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_BLUE_BABY,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_BLUE_BABY,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_BLUE_BABY,
            achievement = Achievement.CHARMING_POOP,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_BLUE_BABY,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_BLUE_BABY,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_BLUE_BABY,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_EMPEROR,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_BLUE_BABY,
            achievement = Achievement.IBS,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_BLUE_BABY,
            achievement = Achievement.RING_CAP,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_BLUE_BABY,
            achievement = Achievement.SWARM,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.DINGLE_BERRY,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_BLUE_BABY,
        },
    },
    [PlayerType.PLAYER_EVE_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_EVE,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_EVE,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_EVE,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_EVE,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_EVE,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_EVE,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_EVE,
            achievement = Achievement.HORSE_PILLS,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_EVE,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_EVE,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_EVE,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_EMPRESS,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_EVE,
            achievement = Achievement.SUMPTORIUM,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_EVE,
            achievement = Achievement.LIL_CLOT,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_EVE,
            achievement = Achievement.HEARTBREAK,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.STRANGE_KEY,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_EVE,
        },
    },
    [PlayerType.PLAYER_SAMSON_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_SAMSON,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_SAMSON,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_SAMSON,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_SAMSON,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_SAMSON,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_SAMSON,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_SAMSON,
            achievement = Achievement.CRANE_GAME,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_SAMSON,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_SAMSON,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_SAMSON,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_STRENGTH,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_SAMSON,
            achievement = Achievement.BERSERK,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_SAMSON,
            achievement = Achievement.SWALLOWED_M80,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_SAMSON,
            achievement = Achievement.LARYNX,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TEMPORARY_TATTOO,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_SAMSON,
        },
    },
    [PlayerType.PLAYER_AZAZEL_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_AZAZEL,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_AZAZEL,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_AZAZEL,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_AZAZEL,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_AZAZEL,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_AZAZEL,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_AZAZEL,
            achievement = Achievement.HELL_GAME,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_AZAZEL,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_AZAZEL,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_AZAZEL,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_DEVIL,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_AZAZEL,
            achievement = Achievement.HEMOPTYSIS,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_AZAZEL,
            achievement = Achievement.AZAZELS_STUMP,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_AZAZEL,
            achievement = Achievement.AZAZELS_RAGE,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.WICKED_CROWN,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_AZAZEL,
        },
    },
    [PlayerType.PLAYER_LAZARUS_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_LAZARUS,
            achievement = Achievement.WOODEN_CHEST,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_JUDGEMENT,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_LAZARUS,
            achievement = Achievement.FLIP,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_LAZARUS,
            achievement = Achievement.TORN_CARD,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_LAZARUS,
            achievement = Achievement.SALVATION,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TORN_POCKET,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_LAZARUS,
        },
    },
    [PlayerType.PLAYER_EDEN_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_EDEN,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_EDEN,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_EDEN,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_EDEN,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_EDEN,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_EDEN,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_EDEN,
            achievement = Achievement.WILD_CARD,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_EDEN,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_EDEN,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_EDEN,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_WORLD,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_EDEN,
            achievement = Achievement.CORRUPTED_DATA,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_EDEN,
            achievement = Achievement.MODELING_CLAY,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_EDEN,
            achievement = Achievement.TMTRAINER,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.NUH_UH,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_EDEN,
        },
    },
    [PlayerType.PLAYER_THELOST_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_THE_LOST,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_THE_LOST,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_THE_LOST,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_THE_LOST,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_THE_LOST,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_THE_LOST,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_THE_LOST,
            achievement = Achievement.HAUNTED_CHEST,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_THE_LOST,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_THE_LOST,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_THE_LOST,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_FOOL,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_THE_LOST,
            achievement = Achievement.GHOST_BOMBS,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_THE_LOST,
            achievement = Achievement.CRYSTAL_KEY,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_THE_LOST,
            achievement = Achievement.SACRED_ORB,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.KIDS_DRAWING,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_LOST,
        },
    },
    [PlayerType.PLAYER_LILITH_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_LILITH,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_LILITH,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_LILITH,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_LILITH,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_LILITH,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_LILITH,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_LILITH,
            achievement = Achievement.FOOLS_GOLD,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_LILITH,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_LILITH,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_LILITH,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_HIGH_PRIESTESS,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_LILITH,
            achievement = Achievement.GELLO,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_LILITH,
            achievement = Achievement.ADOPTION_PAPERS,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_LILITH,
            achievement = Achievement.TWISTED_PAIR,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.THE_TWINS,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_LILITH,
        },
    },
    [PlayerType.PLAYER_KEEPER_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_KEEPER,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_KEEPER,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_KEEPER,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_KEEPER,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_KEEPER,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_KEEPER,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_KEEPER,
            achievement = Achievement.GOLDEN_PENNY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_KEEPER,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_KEEPER,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_KEEPER,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_HANGED_MAN,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_KEEPER,
            achievement = Achievement.KEEPERS_KIN,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_KEEPER,
            achievement = Achievement.CURSED_PENNY,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_KEEPER,
            achievement = Achievement.STRAWMAN,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.KEEPERS_BARGAIN,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_KEEPER,
        },
    },
    [PlayerType.PLAYER_APOLLYON_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_APOLLYON,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_APOLLYON,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_APOLLYON,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_APOLLYON,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_APOLLYON,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_APOLLYON,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_APOLLYON,
            achievement = Achievement.ROTTEN_BEGGAR,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_APOLLYON,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_APOLLYON,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_TOWER,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_APOLLYON,
            achievement = Achievement.ABYSS,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_APOLLYON,
            achievement = Achievement.APOLLYONS_BEST_FRIEND,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_APOLLYON,
            achievement = Achievement.ECHO_CHAMBER,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.CRICKET_LEG,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_APOLLYON,
        },
    },
    [PlayerType.PLAYER_THEFORGOTTEN_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_THE_FORGOTTEN,
            achievement = Achievement.GOLDEN_BATTERY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_BETHANY,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_DEATH,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_THE_FORGOTTEN,
            achievement = Achievement.DECAP_ATTACK,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_THE_FORGOTTEN,
            achievement = Achievement.HOLLOW_HEART,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_THE_FORGOTTEN,
            achievement = Achievement.ISAACS_TOMB,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.POLISHED_BONE,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_FORGOTTEN,
        },
    },
    [PlayerType.PLAYER_BETHANY_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_BETHANY,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_BETHANY,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_BETHANY,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_BETHANY,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_BETHANY,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_BETHANY,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_BETHANY,
            achievement = Achievement.CONFESSIONAL,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_BETHANY,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_BETHANY,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.RESERVED_HEIROPHANT,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_BETHANY,
            achievement = Achievement.LEMEGETON,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_BETHANY,
            achievement = Achievement.BETHS_ESSENCE,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_BETHANY,
            achievement = Achievement.VENGEFUL_SPIRIT,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.EXPANSION_PACK,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_BETHANY,
        },
    },
    [PlayerType.PLAYER_JACOB_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_JACOB_AND_ESAU,
            achievement = Achievement.GOLDEN_TRINKET,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = 403,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_SUN_AND_MOON,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_JACOB_AND_ESAU,
            achievement = Achievement.ANIMA_SOLA,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_JACOB_AND_ESAU,
            achievement = Achievement.FOUND_SOUL,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_JACOB_AND_ESAU,
            achievement = Achievement.ESAU_JR,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.RC_REMOTE,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_JACOB,
        },
    },
    [PlayerType.PLAYER_LAZARUS2_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_LAZARUS,
            achievement = Achievement.WOODEN_CHEST,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_LAZARUS,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_JUDGEMENT,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_LAZARUS,
            achievement = Achievement.FLIP,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_LAZARUS,
            achievement = Achievement.TORN_CARD,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_LAZARUS,
            achievement = Achievement.SALVATION,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.TORN_POCKET,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_LAZARUS,
        },
    },
    [PlayerType.PLAYER_JACOB2_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_JACOB_AND_ESAU,
            achievement = Achievement.GOLDEN_TRINKET,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = 403,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_JACOB_AND_ESAU,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_SUN_AND_MOON,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_JACOB_AND_ESAU,
            achievement = Achievement.ANIMA_SOLA,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_JACOB_AND_ESAU,
            achievement = Achievement.FOUND_SOUL,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_JACOB_AND_ESAU,
            achievement = Achievement.ESAU_JR,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.RC_REMOTE,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_JACOB,
        },
    },
    [PlayerType.PLAYER_THESOUL_B] = {
        [eCompletionEvent.MOMS_HEART] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOMS_HEART_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.ISAAC] = {
            eventCounter = EventCounter.PROGRESSION_KILL_ISAAC_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_SATAN_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.BOSS_RUSH] = {
            eventCounter = EventCounter.PROGRESSION_BOSSRUSH_CLEARED_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.BLUE_BABY] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.LAMB] = {
            eventCounter = EventCounter.PROGRESSION_KILL_THE_LAMB_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.MEGA_SATAN] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MEGA_SATAN_WITH_T_THE_FORGOTTEN,
            achievement = Achievement.GOLDEN_BATTERY,
        },
        [eCompletionEvent.ULTRA_GREED] = {
            eventCounter = EventCounter.PROGRESSION_GREED_MODE_CLEARED_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.GREED_DONATIONS] = {
            eventCounter = EventCounter.GREED_MODE_COINS_DONATED_WITH_T_BETHANY,
            achievement = 0,
        },
        [eCompletionEvent.HUSH] = {
            eventCounter = EventCounter.PROGRESSION_KILL_HUSH_WITH_T_THE_FORGOTTEN,
            achievement = 0,
        },
        [eCompletionEvent.ALL_HARD_MODE_MARKS] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.ULTRA_GREEDIER] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.REVERSED_DEATH,
        },
        [eCompletionEvent.DELIRIUM] = {
            eventCounter = EventCounter.PROGRESSION_KILL_DELIRIUM_WITH_T_THE_FORGOTTEN,
            achievement = Achievement.DECAP_ATTACK,
        },
        [eCompletionEvent.MOTHER] = {
            eventCounter = EventCounter.PROGRESSION_KILL_MOTHER_WITH_T_THE_FORGOTTEN,
            achievement = Achievement.HOLLOW_HEART,
        },
        [eCompletionEvent.BEAST] = {
            eventCounter = EventCounter.PROGRESSION_KILL_BEAST_WITH_T_THE_FORGOTTEN,
            achievement = Achievement.ISAACS_TOMB,
        },
        [eCompletionEvent.TAINTED_PLAYER] = {
            eventCounter = EventCounter.NULL,
            achievement = 0,
        },
        [eCompletionEvent.BASE_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.POLISHED_BONE,
        },
        [eCompletionEvent.RUSH_BOSSES] = {
            eventCounter = EventCounter.NULL,
            achievement = Achievement.SOUL_OF_FORGOTTEN,
        },
    },
}

---@param playerType PlayerType
---@return table<Decomp.Lib.PersistentGameData.eCompletionEvent, Decomp.Lib.PersistentGameData.CompletionEvent>
function Lib_PersistentGameData.GetCompletionEventsDef(playerType)
    return g_PlayerCompletionEvents[playerType]
end