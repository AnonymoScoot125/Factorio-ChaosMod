require("scripts/library-math")
require("scripts/library-modifier")

addChaosEffect({

    name = "mapgen-cliff-richness",
    gain = -1,
    description = { "chaos-description.mapgen-cliff-richness" },
    effectFunction = function()
        local surface = game.players[#game.players].surface
        local modifyingValue = modifier.applyMapGenSettingsModifier(surface, "cliff_settings", "cliff_elevation_interval",
            "cliff_elevation_interval")
        return {
            modifyingValue = modifyingValue,
            description = { "chaos-description.mapgen-cliff-richness", modifyingValue },
        }
    end,

})
