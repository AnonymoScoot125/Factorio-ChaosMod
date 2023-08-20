require("scripts/library-math")
require("scripts/library-modifier")

-- addChaosEffect({

--     name = "mapgen-cliff-richness",
--     description = { "chaos-description.mapgen-cliff-richness" },
--     effectFunction = function()
--         local surface = game.players[#game.players].surface
--         local modifier_mod = "map_gen_size"
--         local fn = function(number)
--             local mapGenSettings = surface.map_gen_settings
--             mapGenSettings["cliff_settings"]["richness"] = number
--             return mapGenSettings
--         end
--         local entry = modifier.applyMapGenSettingsModifier(surface, fn, modifier_mod)
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

-- addChaosEffect({

--     name = "mapgen-cliff-elevation-interval",
--     description = { "chaos-description.mapgen-cliff-elevation-interval" },
--     effectFunction = function()
--         local surface = game.players[#game.players].surface
--         local modifier_mod = "cliff_elevation_interval"
--         local fn = function(number)
--             local mapGenSettings = surface.map_gen_settings
--             mapGenSettings["cliff_settings"]["cliff_elevation_interval"] = number
--             return mapGenSettings
--         end
--         local entry = modifier.applyMapGenSettingsModifier(surface, fn, modifier_mod)
--         local value = modifier[modifier_mod][entry].value
--         local description = modifier[modifier_mod][entry].description
--         return {
--             modifyingValue = value,
--             gain = value < 40 and -2 or
--                 (value == 40 and 0 or 2),
--             description = { "chaos-description.mapgen-cliff-richness", description },
--         }
--     end,

-- })

-- addChaosEffect({

--     name = "mapgen-water-coverage",
--     description = { "chaos-description.mapgen-water-coverage" },
--     effectFunction = function()
--         local surface = game.players[#game.players].surface
--         local modifier_mod = "water_coverage"
--         local fn = function(number)
--             local mapGenSettings = surface.map_gen_settings
--             mapGenSettings["water"] = number
--             return mapGenSettings
--         end
--         local entry = modifier.applyMapGenSettingsModifier(surface, fn, modifier_mod)
--         local value = modifier[modifier_mod][entry].value
--         local description = modifier[modifier_mod][entry].description
--         return {
--             modifyingValue = value,
--             description = { "chaos-description.mapgen-cliff-richness", description },
--         }
--     end,

-- })

-- addChaosEffect({

--     name = "mapgen-water-scale",
--     description = { "chaos-description.mapgen-water-scale" },
--     effectFunction = function()
--         local surface = game.players[#game.players].surface
--         local modifier_mod = "water_scale"
--         local fn = function(number)
--             local mapGenSettings = surface.map_gen_settings
--             mapGenSettings["terrain_segmentation"] = number
--             return mapGenSettings
--         end
--         local entry = modifier.applyMapGenSettingsModifier(surface, fn, modifier_mod)
--         local value = modifier[modifier_mod][entry].value
--         local description = modifier[modifier_mod][entry].description
--         return {
--             modifyingValue = value,
--             description = { "chaos-description.mapgen-cliff-richness", description },
--         }
--     end,

-- })
