--#region Dependencies

local FlipStateGraphics = require("Mechanics.Pickup.FlipState.Graphics")

--#endregion

---@class StaticContext
---@field FLIP_COLLECTIBLE_FLICKER_RNG RNG
---@field WEAPON_TEARS_TECH_LASERS EntityLaserComponent[]

---@class StaticContextUtils
local Module = {}

---@param key string
---@param initFunction function
---@param getters table<string, function>
---@param setters table<string, function>
local function create_static_variable(key, initFunction, getters, setters)
    local GUARD = false
    local variable = nil

    local function get_var()
        if not GUARD then
            variable = initFunction()
            GUARD = true
        end

        return variable
    end

    local function set_var(value)
        variable = value
        GUARD = true
    end

    getters[key] = get_var
    setters[key] = set_var
end

---@return StaticContext
local function Create()
    local getters = {}
    local setters = {}

    create_static_variable("FLIP_COLLECTIBLE_FLICKER_RNG", FlipStateGraphics.__init_flicker_rng, getters, setters)
    create_static_variable("WEAPON_TEARS_TECH_LASERS", function() return {} end, getters, setters)

    local context = {}
    setmetatable(context, {
        __index = function(_, key)
            local getter = getters[key]
            if getter then
                return getter()
            end

            error(string.format("Invalid static variable: %s", key), 2)
        end,

        __newindex = function(_, key, value)
            local setter = setters[key]
            if setter then
                return setter(value)
            end

            error(string.format("Invalid static variable: %s", key), 2)
        end,
    })

    return context
end

--#region Module

Module.Create = Create

--#endregion

return Module