require("scripts/library-math")
require("scripts/library-modifier")

addChaosEffect({

	gain = -1,
	duration = 60,
	description = { "chaos-description.disable-research" },
	effectFunction = function()
		game.forces.player.disable_research()
	end,
	resetFunction = function()
		game.forces.player.enable_research()
	end,

})

addChaosEffect({

	gain = 1,
	description = { "chaos-description.chart-random-area" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local randomChunkPosition = surface.get_random_chunk()
		local boundingBox = {
			{ randomChunkPosition.x * 32 + math.random(-32, 32) * 32,
				randomChunkPosition.y * 32 +
				math.random(-32, 32) * 32 },
			{ randomChunkPosition.x * 32 + math.random(-32, 32) * 32,
				randomChunkPosition.y * 32 +
				math.random(-32, 32) * 32 },
		}

		game.forces.player.chart(surface, boundingBox)
	end,

})

addChaosEffect({

	gain = -3,
	description = { "chaos-description.clear-chart" },
	effectFunction = function()
		game.forces.player.clear_chart()
	end,

})

addChaosEffect({

	gain = 1,
	description = { "chaos-description.rechart" },
	effectFunction = function()
		game.forces.player.rechart()
	end,

})

addChaosEffect({

	gain = 3,
	description = { "chaos-description.chart-all" },
	effectFunction = function()
		game.forces.player.chart_all()
	end,

})

addChaosEffect({

	gain = -1,
	description = { "chaos-description.unchart-random-chunk" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local randomChunkPosition = surface.get_random_chunk()

		game.forces.player.unchart_chunk(randomChunkPosition, surface)
	end,

})

addChaosEffect({

	gain = -3,
	duration = 600,
	description = { "chaos-description.cease-fire-player" },
	effectFunction = function()
		game.forces.player.set_cease_fire("enemy", true)
	end,
	resetFunction = function()
		game.forces.player.set_cease_fire("enemy", false)
	end,

})

addChaosEffect({

	gain = 3,
	duration = 600,
	description = { "chaos-description.cease-fire-enemy" },
	effectFunction = function()
		game.forces.enemy.set_cease_fire("player", true)
	end,
	resetFunction = function()
		game.forces.enemy.set_cease_fire("player", false)
	end,

})

addChaosEffect({

	gain = 2,
	description = { "chaos-description.kill-all-units" },
	effectFunction = function()
		game.forces.enemy.kill_all_units()
	end,

})

addChaosEffect({

	gain = 0,
	description = { "chaos-description.random-spawn-position" },
	effectFunction = function()
		local surface = game.players[#game.players].surface

		for i = 1, 64 do
			local randomChunkPosition = surface.get_random_chunk()
			local tile = surface.get_tile(randomChunkPosition.x * 32, randomChunkPosition.y * 32)

			if not tile.collides_with("player-layer") then
				game.forces.player.set_spawn_position(tile.position, surface)
				break
			end
		end
	end,

})

addChaosEffect({

	gain = 3,
	description = { "chaos-description.reset-evolution" },
	effectFunction = function()
		game.forces.enemy.reset_evolution()
	end,

})

addChaosEffect({

	gain = 3,
	description = { "chaos-description.research-random-technology" },
	effectFunction = function()
		local technologies = game.forces.player.technologies

		local keys = {}
		for key, _ in pairs(technologies) do
			table.insert(keys, key)
		end

		for i = 1, #technologies do
			local index = math.random(1, #keys)
			local key = keys[index]
			local tech = technologies[key]

			if not tech.researched then
				tech.researched = true
				break
			else
				table.remove(keys, index)
			end
		end
	end,

})

addChaosEffect({

	gain = 2,
	description = { "chaos-description.random-technology-progress" },
	effectFunction = function()
		local technologies = game.forces.player.technologies

		for key, tech in pairs(technologies) do
			if not tech.researched then
				game.forces.player.set_saved_technology_progress(tech, math.random() * 0.99)
			end
		end
	end,

})

addChaosEffect({

	gain = 3,
	description = { "chaos-description.enable-random-recipe" },
	effectFunction = function()
		local recipes = game.forces.player.recipes

		local keys = {}
		for key, _ in pairs(recipes) do
			table.insert(keys, key)
		end

		for i = 1, #recipes do
			local index = math.random(1, #keys)
			local key = keys[index]
			local recipe = recipes[key]

			if not recipe.enabled and not (recipe.name == "electric-energy-interface") then
				recipe.enabled = true
				break
			else
				table.remove(keys, index)
			end
		end
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("manual_mining_speed_modifier")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.mining-speed-decreased" or
				"chaos-description.mining-speed-increased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("manual_mining_speed_modifier", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("manual_crafting_speed_modifier")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.crafting-speed-decreased" or
				"chaos-description.crafting-speed-increased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("manual_crafting_speed_modifier", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("laboratory_speed_modifier")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.laboratory-speed-decreased" or
				"chaos-description.laboratory-speed-increased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("laboratory_speed_modifier", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("laboratory_productivity_bonus")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.laboratory-productivity-increased" or
				"chaos-description.laboratory-productivity-decreased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("laboratory_productivity_bonus", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("worker_robots_speed_modifier")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.worker-robot-speed-increased" or
				"chaos-description.worker-robot-speed-decreased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("worker_robots_speed_modifier", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("worker_robots_battery_modifier")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.worker-robot-battery-increased" or
				"chaos-description.worker-robot-battery-decreased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("worker_robots_battery_modifier", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("worker_robots_storage_bonus")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.worker-robot-storage-increased" or
				"chaos-description.worker-robot-storage-decreased", math.abs(modifyingValue) },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("worker_robots_storage_bonus", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	gain = 0,
	description = { "chaos-description.research-progress-random" },
	effectFunction = function()
		if game.forces.player.current_research then
			game.forces.player.research_progress = math.random()
		end
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("inserter_stack_size_bonus")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.inserter-stack-size-bonus-increased" or
				"chaos-description.inserter-stack-size-bonus-decreased", math.abs(modifyingValue) },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("inserter_stack_size_bonus", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("stack_inserter_capacity_bonus")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.stack-inserter-capacity-bonus-increased" or
				"chaos-description.stack-inserter-capacity-bonus-decreased", math.abs(modifyingValue) },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("stack_inserter_capacity_bonus", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("character_trash_slot_count")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.character-trash-slot-count-increased" or
				"chaos-description.character-trash-slot-count-decreased", math.abs(modifyingValue) },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("character_trash_slot_count", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("maximum_following_robot_count")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.maximum-following-robot-count-increased" or
				"chaos-description.maximum-following-robot-count-decreased", math.abs(modifyingValue) },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("maximum_following_robot_count", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("following_robots_lifetime_modifier")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.following-robots-lifetime-increased" or
				"chaos-description.following-robots-lifetime-decreased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("following_robots_lifetime_modifier", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("character_running_speed_modifier")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.character-running-speed-modifier-increased" or
				"chaos-description.character-running-speed-modifier-decreased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("character_running_speed_modifier", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("artillery_range_modifier")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.artillery-range-modifier-increased" or
				"chaos-description.artillery-range-modifier-decreased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("artillery_range_modifier", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("character_build_distance_bonus")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.character-build-distance-bonus-increased" or
				"chaos-description.character-build-distance-bonus-decreased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("character_build_distance_bonus", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("character_item_drop_distance_bonus")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.character-item-drop-distance-bonus-increased" or
				"chaos-description.character-item-drop-distance-bonus-decreased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("character_item_drop_distance_bonus", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("character_reach_distance_bonus")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.character-reach-distance-bonus-increased" or
				"chaos-description.character-reach-distance-bonus-decreased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("character_reach_distance_bonus", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("character_resource_reach_distance_bonus")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.character-resource-reach-distance-bonus-increased" or
				"chaos-description.character-resource-reach-distance-bonus-decreased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("character_resource_reach_distance_bonus", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("character_item_pickup_distance_bonus")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.character-item-pickup-distance-bonus-increased" or
				"chaos-description.character-item-pickup-distance-bonus-decreased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("character_item_pickup_distance_bonus", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("character_loot_pickup_distance_bonus")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.character-loot-pickup-distance-bonus-increased" or
				"chaos-description.character-loot-pickup-distance-bonus-decreased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("character_loot_pickup_distance_bonus", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("character_inventory_slots_bonus")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.character-inventory-slots-bonus-increased" or
				"chaos-description.character-inventory-slots-bonus-decreased", modifyingValue },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("character_inventory_slots_bonus", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("character_health_bonus")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.character-health-bonus-increased" or
				"chaos-description.character-health-bonus-decreased", modifyingValue },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("character_health_bonus", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("mining_drill_productivity_bonus")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.mining-drill-productivity-bonus-increased" or
				"chaos-description.mining-drill-productivity-bonus-decreased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("mining_drill_productivity_bonus", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local modifyingValue = modifier.applyForceModifier("train_braking_force_bonus")
		return {
			modifyingValue = modifyingValue,
			gain = modifyingValue < 0 and -2 or 2,
			description = {
				modifyingValue < 0 and "chaos-description.train-braking-force-bonus-increased" or
				"chaos-description.train-braking-force-bonus-decreased", modifyingValue * 100 },
		}
	end,
	resetFunction = function(effectFunctionTable)
		modifier.revertForceModifier("train_braking_force_bonus", effectFunctionTable.modifyingValue)
	end,

})

addChaosEffect({

	effectFunction = function()
		local returnTable = {}

		if game.forces.player.research_queue_enabled then
			game.forces.player.research_queue_enabled = false
			returnTable.description = { "chaos-description.research-queue-disabled" }
			returnTable.gain = -1
		else
			game.forces.player.research_queue_enabled = true
			returnTable.description = { "chaos-description.research-queue-enabled" }
			returnTable.gain = 1
		end

		return returnTable
	end,

})

addChaosEffect({

	effectFunction = function()
		local surface = game.players[#game.players].surface
		local randomChunkPosition = surface.get_random_chunk()
		local mapPosition = { randomChunkPosition.x * 32, randomChunkPosition.y * 32 }
		local returnTable = {}
		local pick = math.random(1, 4)
		local randomNumber = 0

		if pick == 1 then
			randomNumber = math.random() * (100 - 50) + 50
			returnTable.description = { "chaos-description.pollute-random-small" }
			returnTable.gain = -1
		elseif pick == 2 then
			randomNumber = math.random() * (500 - 100) + 100
			returnTable.description = { "chaos-description.pollute-random-medium" }
			returnTable.gain = -2
		elseif pick == 3 then
			randomNumber = math.random() * (1000 - 500) + 500
			returnTable.description = { "chaos-description.pollute-random-large" }
			returnTable.gain = -3
		else
			randomNumber = math.random() * (10000 - 1000) + 1000
			returnTable.description = { "chaos-description.pollute-random-very-large" }
			returnTable.gain = -3
		end

		surface.pollute(mapPosition, randomNumber)

		return returnTable
	end,

})

addChaosEffect({

	gain = -1,
	description = { "chaos-description.build-enemy-base-at-random-position" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local randomChunkPosition = surface.get_random_chunk()
		local mapPosition = { randomChunkPosition.x * 32, randomChunkPosition.y * 32 }

		surface.build_enemy_base(mapPosition, math.random() * (30 - 5) + 5, game.forces.enemy)
	end,

})

addChaosEffect({

	gain = -1,
	description = { "chaos-description.mark-deconstruct-random-area" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local randomChunkPosition = surface.get_random_chunk()
		local boundingBox = {
			{ randomChunkPosition.x * 32 + math.random(-32, 32) * 32,
				randomChunkPosition.y * 32 +
				math.random(-32, 32) * 32 },
			{ randomChunkPosition.x * 32 + math.random(-32, 32) * 32,
				randomChunkPosition.y * 32 +
				math.random(-32, 32) * 32 },
		}

		surface.deconstruct_area { area = boundingBox, force = game.forces.player }
	end,

})

addChaosEffect({

	gain = 3,
	description = { "chaos-description.clear-all-pollution" },
	effectFunction = function()
		local surface = game.players[#game.players].surface

		surface.clear_pollution()
	end,

})



addChaosEffect({

	effectFunction = function()
		local surface = game.players[#game.players].surface

		local returnTable = {}

		if surface.always_day then
			surface.always_day = false
			returnTable.description = { "chaos-description.always-day-disabled" }
			returnTable.gain = -2
		else
			surface.always_day = true
			returnTable.description = { "chaos-description.always-day-enabled" }
			returnTable.gain = 2
		end

		return returnTable
	end,

})

addChaosEffect({

	gain = 0,
	description = { "chaos-description.random-time-of-day" },
	effectFunction = function()
		local surface = game.players[#game.players].surface

		surface.daytime = math.random()
	end,

})

addChaosEffect({

	gain = 0,
	duration = 60,
	description = { "chaos-description.random-wind-speed" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local returnTable = {}

		returnTable.wind_speed = surface.wind_speed
		returnTable.wind_orientation_change = surface.wind_orientation_change

		surface.wind_speed = math.random() * (0.5 - 0.25) + 0.25
		surface.wind_orientation_change = math.random() * (0.001 - 0.0001) + 0.0001

		return returnTable
	end,
	resetFunction = function(effectFunctionTable)
		local surface = game.players[#game.players].surface

		surface.wind_speed = effectFunctionTable.wind_speed
		surface.wind_orientation_change = effectFunctionTable.wind_orientation_change
	end,

})

addChaosEffect({

	gain = 3,
	duration = 600,
	description = { "chaos-description.peaceful-mode" },
	effectFunction = function()
		local surface = game.players[#game.players].surface

		surface.peaceful_mode = true
	end,
	resetFunction = function()
		local surface = game.players[#game.players].surface

		surface.peaceful_mode = false
	end,

})

addChaosEffect({

	gain = 0,
	effectFunction = function()
		local surface = game.players[#game.players].surface

		local returnTable = {}

		if surface.freeze_daytime then
			surface.freeze_daytime = false
			returnTable.description = { "chaos-description.unfreeze-daytime" }
		else
			surface.freeze_daytime = true
			returnTable.description = { "chaos-description.freeze-daytime" }
		end

		return returnTable
	end,

})

addChaosEffect({

	gain = 0,
	duration = 60,
	description = { "chaos-description.short-daytime" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local returnTable = {}

		returnTable.ticks_per_day = surface.ticks_per_day

		surface.ticks_per_day = math.random() * (1200 - 600) + 600

		return returnTable
	end,
	resetFunction = function(effectFunctionTable)
		local surface = game.players[#game.players].surface

		surface.ticks_per_day = effectFunctionTable.ticks_per_day
	end,

})

addChaosEffect({

	gain = 0,
	description = { "chaos-description.random-daytime-phase" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local returnTable = {}
		local randomNumber = math.random(1, 4)

		if randomNumber == 1 then
			surface.daytime = surface.dusk
			returnTable.description = { "chaos-description.set-daytime-dusk" }
		elseif randomNumber == 2 then
			surface.daytime = surface.dawn
			returnTable.description = { "chaos-description.set-daytime-dawn" }
		elseif randomNumber == 3 then
			surface.daytime = surface.evening
			returnTable.description = { "chaos-description.set-daytime-evening" }
		else
			surface.daytime = surface.morning
			returnTable.description = { "chaos-description.set-daytime-morning" }
		end

		return returnTable
	end,

})

addChaosEffect({

	gain = 0,
	description = { "chaos-description.random-daytime-phases" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local ticksPerDay = surface.ticks_per_day

		local middleTick = math.floor(math.random() * ((ticksPerDay - 120) - 120) + 120)
		local leftTick = math.floor(math.random() * ((middleTick - 60) - 60) + 60)
		local rightTick = math.floor(math.random() * ((ticksPerDay - 60) - (middleTick + 60)) + (middleTick + 60))

		local duskTick = math.floor(math.random() * (leftTick - 0) + 0)
		local eveningTick = math.floor(math.random() * (middleTick - (leftTick + 1)) + (leftTick + 1))
		local morningTick = math.floor(math.random() * (rightTick - (middleTick + 1)) + (middleTick + 1))
		local dawnTick = math.floor(math.random() * (ticksPerDay - (rightTick + 1)) + (rightTick + 1))

		surface.dusk = 1 / ticksPerDay
		surface.evening = 2 / ticksPerDay
		surface.morning = 3 / ticksPerDay

		surface.dawn = dawnTick / ticksPerDay
		surface.morning = morningTick / ticksPerDay
		surface.evening = eveningTick / ticksPerDay
		surface.dusk = duskTick / ticksPerDay
	end,

})

addChaosEffect({

	duration = 60,
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local returnTable = {}

		local modifyingValue

		if math.random() < 0.5 then
			modifyingValue = math.roundTo(math.random() * (-0.1 - (-1)) + (-1), 0.1)
		else
			modifyingValue = math.roundTo(math.random() * (1 - 0.1) + 0.1, 0.1)
		end

		surface.solar_power_multiplier = surface.solar_power_multiplier + modifyingValue
		returnTable.modifyingValue = modifyingValue

		if modifyingValue > 0 then
			returnTable.description = { "chaos-description.solar-power-increased", modifyingValue * 100 }
			returnTable.gain = 2
		else
			returnTable.description = { "chaos-description.solar-power-decreased", modifyingValue * 100 }
			returnTable.gain = -3
		end

		return returnTable
	end,
	resetFunction = function()
		local surface = game.players[#game.players].surface

		surface.solar_power_multiplier = 1
	end,

})

addChaosEffect({

	duration = 60,
	gain = -1,
	description = { "chaos-description.dark-night" },
	effectFunction = function()
		local surface = game.players[#game.players].surface

		surface.brightness_visual_weights = { 1, 1, 1 }
	end,
	resetFunction = function()
		local surface = game.players[#game.players].surface

		surface.brightness_visual_weights = { 0, 0, 0 }
	end,

})

addChaosEffect({

	gain = 3,
	description = { "chaos-description.turn-enemy-units-to-trees" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local searchTable = game.get_filtered_entity_prototypes({ {
			filter = "type",
			type = "tree"
		} })

		local keys = {}
		for key, _ in pairs(searchTable) do
			table.insert(keys, key)
		end


		for k, entity in pairs(surface.find_entities_filtered {
			type = "unit",
			force = "enemy",
		}) do
			surface.create_entity {
				name = searchTable[keys[math.random(#keys)]].name,
				position = entity.position
			}
		end

		game.forces.enemy.kill_all_units()
	end,

})

addChaosEffect({

	gain = -3,
	description = { "chaos-description.turn-trees-to-enemy-units" },
	effectFunction = function()
		local surface = game.players[#game.players].surface

		local units = {
			"small-biter",
			"medium-biter",
			"big-biter",
			"small-spitter",
			"medium-spitter",
			"big-spitter"
		}

		for k, entity in pairs(surface.find_entities_filtered {
			type = "tree",
		}) do
			surface.create_entity {
				name = units[math.random(#units)],
				position = entity.position
			}
			entity.destroy {}
		end
	end,

})

addChaosEffect({

	gain = 3,
	description = { "chaos-description.convert-all-biters-to-player-force" },
	effectFunction = function()
		local surface = game.players[#game.players].surface

		for k, entity in pairs(surface.find_entities_filtered {
			type = { "unit-spawner", "turret", "unit" },
			force = "enemy"
		}) do
			entity.force = "player"
		end
	end,

})

addChaosEffect({

	gain = -3,
	description = { "chaos-description.convert-all-player-turrets-to-enemy-force" },
	effectFunction = function()
		local surface = game.players[#game.players].surface

		for k, entity in pairs(surface.find_entities_filtered {
			type = { "ammo-turret", "electric-turret", "fluid-turret", "artillery-turret" },
			force = "player"
		}) do
			entity.force = "enemy"
		end
	end,

})

addChaosEffect({

	gain = -3,
	description = { "chaos-description.turn-all-player-turrets-to-worms" },
	effectFunction = function()
		local surface = game.players[#game.players].surface

		local units = {
			"small-worm-turret",
			"medium-worm-turret",
			"big-worm-turret"
		}

		for k, entity in pairs(surface.find_entities_filtered {
			type = { "ammo-turret", "electric-turret", "fluid-turret", "artillery-turret" },
			force = "player"
		}) do
			surface.create_entity {
				name = units[math.random(#units)],
				position = entity.position,
				force = "enemy"
			}
			entity.destroy {}
		end
	end,

})

addChaosEffect({

	gain = 3,
	description = { "chaos-description.convert-all-worms-to-player-force" },
	effectFunction = function()
		local surface = game.players[#game.players].surface

		for k, entity in pairs(surface.find_entities_filtered {
			type = { "turret" },
			force = "enemy"
		}) do
			entity.force = "player"
		end
	end,

})

addChaosEffect({

	gain = 3,
	description = { "chaos-description.convert-all-worms-to-player-force" },
	effectFunction = function()
		local surface = game.players[#game.players].surface

		for k, entity in pairs(surface.find_entities_filtered {
			type = { "turret" },
			force = "enemy"
		}) do
			entity.force = "player"
		end
	end,

})

addChaosEffect({

	gain = 3,
	description = { "chaos-description.remove-all-biters" },
	effectFunction = function()
		local surface = game.players[#game.players].surface

		for k, entity in pairs(surface.find_entities_filtered {
			force = "enemy"
		}) do
			entity.destroy()
		end
	end,

})

addChaosEffect({

	gain = 1,
	description = { "chaos-description.turn-trees-into-resources" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local searchTable = game.get_filtered_entity_prototypes({ {
			filter = "type",
			type = "resource"
		} })

		local keys = {}
		for key, prototype in pairs(searchTable) do
			if prototype.resource_category == "basic-solid" then
				table.insert(keys, key)
			end
		end

		for k, entity in pairs(surface.find_entities_filtered {
			type = "tree",
		}) do
			if entity.valid then
				surface.create_entity {
					name = searchTable[keys[math.random(#keys)]].name,
					position = entity.position,
					amount = math.random() * (1000 - 10) + 10,
					enable_tree_removal = false,
					enable_cliff_removal = false,
					snap_to_tile_center = true
				}

				entity.destroy()
			end
		end
	end,

})

addChaosEffect({

	effectFunction = function()
		local surface = game.players[#game.players].surface
		local multiplier = 1
		local randomNumber = math.random(1, 4)
		local returnTable = {}

		if randomNumber == 1 then
			multiplier = 0.25
			returnTable.description = { "chaos-description.resource-amount-quartered" }
			returnTable.gain = -3
		elseif randomNumber == 2 then
			multiplier = 0.5
			returnTable.description = { "chaos-description.resource-amount-halved" }
			returnTable.gain = -2
		elseif randomNumber == 3 then
			multiplier = 2
			returnTable.description = { "chaos-description.resource-amount-doubled" }
			returnTable.gain = 2
		else
			multiplier = 4
			returnTable.description = { "chaos-description.resource-amount-quadrupled" }
			returnTable.gain = 3
		end

		for k, entity in pairs(surface.find_entities_filtered {
			type = "resource",
		}) do
			if entity.valid then
				entity.amount = math.clamp(math.ceil(entity.amount * multiplier), 1, 4294967295)
			end
		end

		return returnTable
	end,

})

addChaosEffect({

	gain = -2,
	description = { "chaos-description.randomize-resource-deposits" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local searchTable = game.get_filtered_entity_prototypes({ {
			filter = "type",
			type = "resource"
		} })

		local keys = {}
		for key, prototype in pairs(searchTable) do
			if prototype.resource_category == "basic-solid" then
				table.insert(keys, key)
			end
		end

		for i = #keys, 2, -1 do
			local j = math.random(i)
			keys[i], keys[j] = keys[j], keys[i]
		end

		local shuffledTable = {}
		for i, key in ipairs(keys) do
			shuffledTable[key] = keys[math.random(#keys)]
		end

		for k, entity in pairs(surface.find_entities_filtered {
			type = "resource",
		}) do
			if entity.valid and entity.prototype.resource_category == "basic-solid" then
				surface.create_entity {
					name = shuffledTable[entity.name],
					position = entity.position,
					amount = entity.amount,
					enable_tree_removal = false,
					enable_cliff_removal = false,
					snap_to_tile_center = true
				}

				entity.destroy()
			end
		end
	end,

})

addChaosEffect({

	gain = -3,
	description = { "chaos-description.randomize-fluids" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local searchTable = game.get_filtered_fluid_prototypes({ {
			filter = "name",
			name = "fluid-unknown",
			invert = true,
		} })

		local keys = {}
		for key, prototype in pairs(searchTable) do
			table.insert(keys, key)
		end

		for k, entity in pairs(surface.find_entities_filtered {
			type = { "pipe", "storage-tank" },
		}) do
			if entity.valid and entity.fluidbox[1] then
				local fluid = entity.fluidbox[1]
				entity.fluidbox[1] = {
					name = searchTable[keys[math.random(#keys)]].name,
					amount = fluid.amount,
					temperature = fluid.temperature
				}
			end
		end
	end,

})

addChaosEffect({

	gain = -2,
	description = { "chaos-description.randomize-fluids-to-one-fluid" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local searchTable = game.get_filtered_fluid_prototypes({ {
			filter = "name",
			name = "fluid-unknown",
			invert = true,
		} })

		local keys = {}
		for key, prototype in pairs(searchTable) do
			table.insert(keys, key)
		end

		local randomFluid = keys[math.random(#keys)]

		for k, entity in pairs(surface.find_entities_filtered {
			type = { "pipe", "storage-tank" },
		}) do
			if entity.valid and entity.fluidbox[1] then
				local fluid = entity.fluidbox[1]
				entity.fluidbox[1] = { name = randomFluid, amount = fluid.amount, temperature = fluid.temperature }
			end
		end
	end,

})

addChaosEffect({

	gain = -3,
	description = { "chaos-description.turn-enemy-units-to-landmines" },
	effectFunction = function()
		local surface = game.players[#game.players].surface

		for k, entity in pairs(surface.find_entities_filtered {
			type = "unit",
			force = "enemy",
		}) do
			surface.create_entity {
				name = "land-mine",
				position = entity.position,
				force = "enemy"
			}
		end

		game.forces.enemy.kill_all_units()
	end,

})

addChaosEffect({

	gain = -1,
	description = { "chaos-description.turn-trees-to-rocks" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local searchTable = game.get_filtered_entity_prototypes({ {
			filter = "name",
			name = { "sand-rock-big", "rock-big", "rock-huge" },
		} })

		local keys = {}
		for key, prototype in pairs(searchTable) do
			table.insert(keys, key)
		end

		for k, entity in pairs(surface.find_entities_filtered {
			type = "tree",
		}) do
			if entity.valid then
				surface.create_entity {
					name = searchTable[keys[math.random(#keys)]].name,
					position = entity.position
				}

				entity.destroy {}
			end
		end
	end,

})

addChaosEffect({

	gain = 3,
	description = { "chaos-description.insert-random-modules" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local searchTable = game.get_filtered_item_prototypes({ {
			filter = "type",
			type = "module"
		} })

		local keys = {}
		for key, prototype in pairs(searchTable) do
			table.insert(keys, key)
		end

		for k, entity in pairs(surface.find_entities_filtered {
			type = { "assembling-machine", "lab", "furnace", "mining-drill", "beacon", "rocket-silo" },
		}) do
			if entity.valid then
				if entity.prototype.module_inventory_size then
					for i = 1, entity.prototype.module_inventory_size do
						for j = 1, 10 do
							local moduleItem = { name = searchTable[keys[math.random(#keys)]].name, count = 1 }

							if entity.can_insert(moduleItem) then
								entity.insert(moduleItem)
								break
							end
						end
					end
				end
			end
		end
	end,

})

addChaosEffect({

	gain = -3,
	description = { "chaos-description.set-random-recipes" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local searchTable = game.recipe_prototypes

		local keys = {}
		for key, prototype in pairs(searchTable) do
			table.insert(keys, key)
		end

		for k, entity in pairs(surface.find_entities_filtered {
			type = "assembling-machine",
			force = "player"
		}) do
			if entity.valid then
				for i = 1, #keys do
					entity.set_recipe(searchTable[keys[math.random(#keys)]].name)

					if entity.get_recipe() then
						break
					end
				end
			end
		end
	end,

})

addChaosEffect({

	gain = -3,
	description = { "chaos-description.reset-assembler-recipes" },
	effectFunction = function()
		local surface = game.players[#game.players].surface

		for k, entity in pairs(surface.find_entities_filtered {
			type = "assembling-machine",
			force = "player"
		}) do
			if entity.valid then
				entity.set_recipe(nil)
			end
		end
	end,

})

addChaosEffect({

	gain = -3,
	description = { "chaos-description.mix-ore-deposits" },
	effectFunction = function()
		local surface = game.players[#game.players].surface
		local searchTable = game.get_filtered_entity_prototypes({ {
			filter = "type",
			type = "resource"
		} })

		local keys = {}
		for key, prototype in pairs(searchTable) do
			if prototype.resource_category == "basic-solid" then
				table.insert(keys, key)
			end
		end

		for k, entity in pairs(surface.find_entities_filtered {
			type = "resource",
		}) do
			if math.random() < 0.02 then
				if entity.valid and entity.prototype.resource_category == "basic-solid" then
					surface.create_entity {
						name = searchTable[keys[math.random(#keys)]].name,
						position = entity.position,
						amount = entity.amount,
						enable_tree_removal = false,
						enable_cliff_removal = false,
						snap_to_tile_center = true
					}

					entity.destroy()
				end
			end
		end
	end,

})

-- addChaosEffect({

-- 	duration = 60,
-- 	effectFunction = function()
-- 		local minValue = 0.1
-- 		local topValue = 4
-- 		local increment = 0.1
-- 		local modifier = game.difficulty_settings.technology_price_multiplier
-- 		local modifyingValue = calculateModifier(modifier, minValue, topValue, increment)

-- 		game.difficulty_settings.technology_price_multiplier = math.clampBottom(
-- 			math.roundTo(modifier + modifyingValue, increment), minValue)

-- 		local returnTable = {}
-- 		returnTable.modifyingValue = modifyingValue
-- 		returnTable.minValue = minValue
-- 		returnTable.increment = increment

-- 		if modifyingValue > 0 then
-- 			returnTable.description = { "chaos-description.technology-price-increased", modifyingValue * 100 }
-- 			returnTable.gain = -2
-- 		else
-- 			returnTable.description = { "chaos-description.technology-price-decreased", modifyingValue * 100 }
-- 			returnTable.gain = 2
-- 		end

-- 		return returnTable
-- 	end,
-- 	resetFunction = function(effectFunctionTable)
-- 		local minValue = effectFunctionTable.minValue
-- 		local increment = effectFunctionTable.increment
-- 		local modifier = game.difficulty_settings.technology_price_multiplier
-- 		local modifyingValue = effectFunctionTable.modifyingValue

-- 		game.difficulty_settings.technology_price_multiplier = math.clampBottom(
-- 			math.roundTo(modifier - modifyingValue, increment), minValue)
-- 	end,

-- })

addChaosEffect({

	effectFunction = function()
		local modifier = game.difficulty_settings.recipe_difficulty
		local returnTable = {}

		if modifier == defines.difficulty_settings.recipe_difficulty.normal then
			game.difficulty_settings.recipe_difficulty = defines.difficulty_settings.recipe_difficulty.expensive
			returnTable.description = { "chaos-description.recipe-difficulty-expensive" }
			returnTable.gain = -3
		else
			game.difficulty_settings.recipe_difficulty = defines.difficulty_settings.recipe_difficulty.normal
			returnTable.description = { "chaos-description.recipe-difficulty-normal" }
			returnTable.gain = 3
		end

		return returnTable
	end,

})

addChaosEffect({

	effectFunction = function()
		local modifier = game.map_settings.pollution.enabled
		local returnTable = {}

		if modifier then
			game.map_settings.pollution.enabled = false
			returnTable.description = { "chaos-description.pollution-disabled" }
			returnTable.gain = 3
		else
			game.map_settings.pollution.enabled = true
			returnTable.description = { "chaos-description.pollution-enabled" }
			returnTable.gain = -3
		end

		return returnTable
	end,

})

-- addChaosEffect({

-- 	duration = 60,
-- 	effectFunction = function()
-- 		local minValue = 0.001
-- 		local topValue = 0.1
-- 		local increment = 0.01
-- 		local modifier = game.map_settings.pollution.diffusion_ratio
-- 		local modifyingValue = calculateModifier(modifier, minValue, topValue, increment)

-- 		game.map_settings.pollution.diffusion_ratio = math.clampBottom(
-- 			math.roundTo(modifier + modifyingValue, increment), minValue)

-- 		local returnTable = {}
-- 		returnTable.modifyingValue = modifyingValue
-- 		returnTable.minValue = minValue
-- 		returnTable.increment = increment

-- 		if modifyingValue > 0 then
-- 			returnTable.description = { "chaos-description.pollution-diffusion-ratio-increased",
-- 				(modifyingValue / modifier) * 100 }
-- 		else
-- 			returnTable.description = { "chaos-description.pollution-diffusion-ratio-decreased",
-- 				(modifyingValue / modifier) * 100 }
-- 		end

-- 		return returnTable
-- 	end,
-- 	resetFunction = function(effectFunctionTable)
-- 		local minValue = effectFunctionTable.minValue
-- 		local increment = effectFunctionTable.increment
-- 		local modifier = game.map_settings.pollution.diffusion_ratio
-- 		local modifyingValue = effectFunctionTable.modifyingValue

-- 		game.map_settings.pollution.diffusion_ratio = math.clampBottom(
-- 			math.roundTo(modifier - modifyingValue, increment), minValue)
-- 	end,

-- })

-- addChaosEffect({

-- 	duration = 60,
-- 	effectFunction = function()
-- 		local minValue = 5
-- 		local topValue = 100
-- 		local increment = 1
-- 		local modifier = game.map_settings.pollution.min_to_diffuse
-- 		local modifyingValue = calculateModifier(modifier, minValue, topValue, increment)

-- 		game.map_settings.pollution.min_to_diffuse = math.clampBottom(math.roundTo(modifier + modifyingValue, increment),
-- 			minValue)

-- 		local returnTable = {}
-- 		returnTable.modifyingValue = modifyingValue
-- 		returnTable.minValue = minValue
-- 		returnTable.increment = increment

-- 		if modifyingValue > 0 then
-- 			returnTable.description = { "chaos-description.pollution-min-to-diffuse-increased",
-- 				(modifyingValue / modifier) * 100 }
-- 			returnTable.gain = -2
-- 		else
-- 			returnTable.description = { "chaos-description.pollution-min-to-diffuse-decreased",
-- 				(modifyingValue / modifier) * 100 }
-- 			returnTable.gain = 2
-- 		end

-- 		return returnTable
-- 	end,
-- 	resetFunction = function(effectFunctionTable)
-- 		local minValue = effectFunctionTable.minValue
-- 		local increment = effectFunctionTable.increment
-- 		local modifier = game.map_settings.pollution.min_to_diffuse
-- 		local modifyingValue = effectFunctionTable.modifyingValue

-- 		game.map_settings.pollution.min_to_diffuse = math.clampBottom(math.roundTo(modifier - modifyingValue, increment),
-- 			minValue)
-- 	end,

-- })

-- addChaosEffect({

-- 	duration = 60,
-- 	effectFunction = function()
-- 		local minValue = 0.1
-- 		local topValue = 2
-- 		local increment = 0.1
-- 		local modifier = game.map_settings.pollution.ageing
-- 		local modifyingValue = calculateModifier(modifier, minValue, topValue, increment)

-- 		game.map_settings.pollution.ageing = math.clampBottom(math.roundTo(modifier + modifyingValue, increment),
-- 			minValue)

-- 		local returnTable = {}
-- 		returnTable.modifyingValue = modifyingValue
-- 		returnTable.minValue = minValue
-- 		returnTable.increment = increment

-- 		if modifyingValue > 0 then
-- 			returnTable.description = { "chaos-description.pollution-ageing-increased", (modifyingValue / modifier) * 100 }
-- 		else
-- 			returnTable.description = { "chaos-description.pollution-ageing-decreased", (modifyingValue / modifier) * 100 }
-- 		end

-- 		return returnTable
-- 	end,
-- 	resetFunction = function(effectFunctionTable)
-- 		local minValue = effectFunctionTable.minValue
-- 		local increment = effectFunctionTable.increment
-- 		local modifier = game.map_settings.pollution.ageing
-- 		local modifyingValue = effectFunctionTable.modifyingValue

-- 		game.map_settings.pollution.ageing = math.clampBottom(math.roundTo(modifier - modifyingValue, increment),
-- 			minValue)
-- 	end,

-- })
