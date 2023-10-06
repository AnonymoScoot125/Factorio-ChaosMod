local devMode = false
local REFIRE_INTERVAL

if devMode then
	REFIRE_INTERVAL = 120
else
	REFIRE_INTERVAL = settings.global["chaos-refire-interval"].value * 60
end


global.nextChaosTimerRefire = REFIRE_INTERVAL
global.activeChaosEffects = {}

local chaosEffects = {}

function addChaosEffect(effect)
	if devMode then
		addChaosEffectDev(effect)
		return
	end
	if not effect.name then return end
	if settings.global["chaos-effect-" .. effect.name].value == false then return end
	local effectEntry = effect
	effectEntry.effectFunction = effectEntry.effectFunction or function() game.print("Invalid effect function") end
	effectEntry.resetFunction = effectEntry.resetFunction or nil
	effectEntry.description = effectEntry.description or "Invalid description"
	effectEntry.duration = effectEntry.duration and
		math.roundTo(settings.global["chaos-duration-multiplier"].value * effectEntry.duration, 1) or 1800
	effectEntry.gain = effectEntry.gain or 0
	effectEntry.id = #chaosEffects + 1

	table.insert(chaosEffects, effectEntry)
end

function addChaosEffectDev(effect)
	local effectEntry = effect
	effectEntry.effectFunction = effectEntry.effectFunction or function() game.print("Invalid effect function") end
	effectEntry.resetFunction = effectEntry.resetFunction or nil
	effectEntry.description = effectEntry.description or "Invalid description"
	effectEntry.duration = effectEntry.duration or 60
	effectEntry.gain = effectEntry.gain or 0
	effectEntry.id = #chaosEffects + 1

	table.insert(chaosEffects, effectEntry)
end

if devMode then
	require("effects-debug")
else
	require("effects")
end

function isChaosEffectAlreadyActive(id)
	for _, activeChaosEffect in pairs(global.activeChaosEffects) do
		if id == activeChaosEffect.id then
			return true
		end
	end

	return false
end

function addActiveChaosEffect(chaosEffect, endOnTick, effectFunctionTable)
	local effect = {}
	effect.id = chaosEffect.id
	effect.duration = chaosEffect.duration
	effect.effectFunctionTable = effectFunctionTable
	effect.endOnTick = endOnTick

	table.insert(global.activeChaosEffects, effect)
end

function formatPrintedEffectDescription(chaosEntry, effectFunctionTable)
	local description = effectFunctionTable.description or chaosEntry.description
	local gain = effectFunctionTable.gain or chaosEntry.gain

	gain = (gain < -3 or gain > 3) and 0 or gain

	local gainTable = {}
	gainTable[3] = "[color=0, 255, 0]"
	gainTable[2] = "[color=64, 255, 64]"
	gainTable[1] = "[color=128, 225, 128]"
	gainTable[0] = "[color=200, 200, 200]"
	gainTable[-1] = "[color=225, 128, 128]"
	gainTable[-2] = "[color=255, 64, 64]"
	gainTable[-3] = "[color=255, 0, 0]"

	return { "", gainTable[gain], description, "[/color]" }
end

function pickRandomChaosEffect()
	if #chaosEffects < 1 then return end

	for try = 1, 10 do
		local randomIndex = math.random(#chaosEffects)
		local chaosEntry = chaosEffects[randomIndex]

		if not isChaosEffectAlreadyActive(chaosEntry.id) then
			local effectFunctionTable = chaosEntry.effectFunction() or
				{ gain = chaosEntry.gain, description = chaosEntry.description }

			for id, player in pairs(game.players) do
				if settings.get_player_settings(id)["chaos-messages-in-chat"].value then
					player.print(formatPrintedEffectDescription(chaosEntry, effectFunctionTable))
				end

				addEffectToPlayerGUI(player, chaosEntry, effectFunctionTable)
			end

			addActiveChaosEffect(chaosEntry, game.tick + chaosEntry.duration, effectFunctionTable)

			break
		end
	end
end

function addEffectToPlayerGUI(player, chaosEntry, effectFunctionTable)
	local id = chaosEntry.id

	if player.gui.top.chaos_frame then
		local mainFrame = player.gui.top.chaos_frame

		if mainFrame["effect_" .. id] then return end

		local frame = mainFrame.add { type = "flow", name = "effect_" .. id, direction = "vertical" }
		local style = frame.style
		style.padding = { 0, 10, 0, 10 }
		style.vertical_align = "center"
		style.height = 36
		style.horizontally_stretchable = true

		local label = frame.add { type = "label", name = "effect_" .. id .. "_label", caption = effectFunctionTable
			.description or chaosEntry.description }
		local style = label.style
		style.font = "default-small"


		if chaosEntry.resetFunction then
			local progressbar = frame.add { type = "progressbar", name = "effect_" .. id .. "_progressbar" }
			local style = progressbar.style
			style.bar_width = 6
			style.horizontally_stretchable = true
		end
	end
end

function updatePlayerGUI()
	for _, player in pairs(game.players) do
		if player.gui.top.chaos_frame then
			local mainFrame = player.gui.top.chaos_frame

			if mainFrame.chaos_progressbar then
				mainFrame.chaos_progressbar.value = (game.tick - global.nextChaosTimerRefire + REFIRE_INTERVAL) /
					REFIRE_INTERVAL
			end

			for _, activeChaosEffect in pairs(global.activeChaosEffects) do
				if mainFrame["effect_" .. activeChaosEffect.id] then
					if mainFrame["effect_" .. activeChaosEffect.id]["effect_" .. activeChaosEffect.id .. "_progressbar"] then
						mainFrame["effect_" .. activeChaosEffect.id]["effect_" .. activeChaosEffect.id .. "_progressbar"].value = (activeChaosEffect.endOnTick - game.tick) /
							activeChaosEffect.duration
					end
				end
			end
		end
	end
end

function removeEffectFromPlayerGUI(id)
	for _, player in pairs(game.players) do
		if player.gui.top.chaos_frame then
			local mainFrame = player.gui.top.chaos_frame

			if mainFrame["effect_" .. id] then
				mainFrame["effect_" .. id].destroy()
			end
		end
	end
end

function updateActiveChaosEffects()
	for idEffect, activeChaosEffect in pairs(global.activeChaosEffects) do
		if activeChaosEffect.endOnTick <= game.tick then
			local effect = chaosEffects[activeChaosEffect.id]

			if effect.resetFunction then effect.resetFunction(activeChaosEffect.effectFunctionTable) end

			removeEffectFromPlayerGUI(activeChaosEffect.id)
			table.remove(global.activeChaosEffects, idEffect)
		end
	end
end

script.on_event(defines.events.on_tick, function(event)
	updateActiveChaosEffects()
	updatePlayerGUI()

	if game.tick >= global.nextChaosTimerRefire then
		global.nextChaosTimerRefire = game.tick + REFIRE_INTERVAL

		pickRandomChaosEffect()
	end
end)

script.on_event(defines.events.on_player_created, function(event)
	local player = game.get_player(event.player_index)

	local screen_element = player.gui.top
	local main_frame = screen_element.add { type = "flow", name = "chaos_frame", direction = "vertical" }
	local style = main_frame.style
	style.padding = { 0, 0, 0, 0 }
	style.width = 320
	style.vertical_spacing = 0
	style.height = 376

	local progressbar = main_frame.add { type = "progressbar", name = "chaos_progressbar" }
	local style = progressbar.style
	style.bar_width = 8
	style.horizontally_stretchable = true
	style.margin = { 0, 0, 8, 0 }
end)
