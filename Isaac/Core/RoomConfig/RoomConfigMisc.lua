--#region Dependencies

local Log = require("General.Log")

--#endregion

---@param spawn Component.RoomConfig.Spawn
---@param randomFloat number
---@return Component.RoomConfig.Spawn.Entry
local function Spawn_PickEntry(spawn, randomFloat)
    local targetWeight = randomFloat * spawn.sumWeights
    local sumWeights = 0.0

    for i = 1, #spawn.entries, 1 do
        local entry = spawn.entries[i]
        sumWeights = sumWeights + entry.weight
        if sumWeights > targetWeight then
            return entry
        end
    end

    -- not terminate properly
    local entry = spawn.entries[1]
    Log.LogMessage(Log.eLogType.INFO, string.format("[warn] RoomConfig::Spawn::PickEntry did not terminate properly. Picking first entry: (%d, %d, %d, %f)\n", entry.type, entry.variant, entry.subType, entry.weight))
    return entry
end

---@class Gameplay.RoomConfig.Misc
local Module = {}

--#region Module

Module.Spawn_PickEntry = Spawn_PickEntry

--#endregion

return Module