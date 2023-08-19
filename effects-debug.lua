require("scripts/library-math")
require("scripts/library-modifier")

-- addChaosEffect({

--     name = "mapgen-cliff-richness",
--     description = { "chaos-description.mapgen-cliff-richness" },
--     effectFunction = function()
--         local surface = game.players[#game.players].surface
--         local modifier_mod = "map_gen_size"
--         local entry = modifier.applyMapGenSettingsModifier(surface, "cliff_settings", "richness",
--             modifier_mod)
--         local value = modifier[modifier_mod][entry].value
--         local description = modifier[modifier_mod][entry].description
--         return {
--             modifyingValue = value,
--             gain = value < 1 and 2 or
--                 (value == 1 and 0 or -2),
--             description = { "chaos-description.mapgen-cliff-richness", description },
--         }
--     end,

-- })

addChaosEffect({

    name = "mapgen-cliff-elevation-interval",
    description = { "chaos-description.mapgen-cliff-elevation-interval" },
    effectFunction = function()
        local surface = game.players[#game.players].surface
        local modifier_mod = "cliff_elevation_interval"
        local entry = modifier.applyMapGenSettingsModifier(surface, "cliff_settings", "cliff_elevation_interval",
            modifier_mod)
        local value = modifier[modifier_mod][entry].value
        local description = modifier[modifier_mod][entry].description
        return {
            modifyingValue = value,
            gain = value < 40 and -2 or
                (value == 40 and 0 or 2),
            description = { "chaos-description.mapgen-cliff-richness", description },
        }
    end,

})
