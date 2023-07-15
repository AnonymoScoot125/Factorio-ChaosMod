local REFIRE_INTERVAL = 120

global.nextChaosTimerRefire = REFIRE_INTERVAL
global.activeChaosEffects = {}

local chaosEffects = {}

function addChaosEffect(effect)
	local effectEntry = effect
	effectEntry.effectFunction = effectEntry.effectFunction or function() game.print("Invalid effect function") end
	effectEntry.resetFunction = effectEntry.resetFunction or nil
	effectEntry.description = effectEntry.description or "Invalid description"
	effectEntry.duration = effectEntry.duration or 60
	effectEntry.gain = effectEntry.gain or 0
	effectEntry.id = #chaosEffects + 1

	table.insert(chaosEffects, effectEntry)
end

require("effects")

function isChaosEffectAlreadyActive(id)
	for k, v in pairs(global.activeChaosEffects) do
		if id == v.id then
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

function addDisplayedChaosEffect(chaosEffect)
	local effect = chaosEffect

	table.insert(global.displayedChaosEffects, effect)
end

-- function getEffectDescription(effectFunctionTable)
-- 	local description = {}
-- 	local modifierTable = effectFunctionTable.modifierTable

-- 	if modifierTable then
-- 		if modifierTable.percentageBased then
-- 			description = { modifierTable.description, effectFunctionTable.modifyingValue * 100 }
-- 		else
-- 			description = { modifierTable.description, effectFunctionTable.modifyingValue }
-- 		end
-- 	end

-- 	return description
-- end

function formatPrintedEffectDescription(chaosEntry, effectFunctionTable)
	local description = effectFunctionTable.description or chaosEntry.description
	local gain = effectFunctionTable.gain or chaosEntry.gain

	-- if effectFunctionTable.modifyingValue then
	-- 	if effectFunctionTable.modifyingValue > 0 then
	-- 		gain = gain.advantage
	-- 		description = description.advantage
	-- 	elseif effectFunctionTable.modifyingValue < 0 then
	-- 		gain = gain.disadvantage
	-- 		description = description.disadvantage
	-- 	end
	-- end

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

function pickRandomChaosEffect(event)
	local randomIndex

	if #chaosEffects < 1 then return end

	for try = 1, 10 do
		randomIndex = math.random(#chaosEffects)
		local chaosEntry = chaosEffects[randomIndex]

		if not isChaosEffectAlreadyActive(chaosEntry.id) then
			local effectFunctionTable = chaosEntry.effectFunction() or
				{ gain = chaosEntry.gain, description = chaosEntry.description }

			for k, v in pairs(game.players) do
				if settings.get_player_settings(k)["chaos-messages-in-chat"].value then
					v.print(formatPrintedEffectDescription(chaosEntry, effectFunctionTable))
				end

				addEffectToPlayerGUI(v, chaosEntry, effectFunctionTable)
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

function updatePlayerGUI(event)
	for _, player in pairs(game.players) do
		if player.gui.top.chaos_frame then
			local mainFrame = player.gui.top.chaos_frame

			if mainFrame.chaos_progressbar then
				mainFrame.chaos_progressbar.value = (event.tick - global.nextChaosTimerRefire + REFIRE_INTERVAL) /
					REFIRE_INTERVAL
			end

			for k, v in pairs(global.activeChaosEffects) do
				if mainFrame["effect_" .. v.id] then
					if mainFrame["effect_" .. v.id]["effect_" .. v.id .. "_progressbar"] then
						mainFrame["effect_" .. v.id]["effect_" .. v.id .. "_progressbar"].value = (v.endOnTick - event.tick) /
							v.duration
					end
				end
			end
		end
	end
end

function removeEffectFromPlayerGUI(event, id)
	for _, player in pairs(game.players) do
		if player.gui.top.chaos_frame then
			local mainFrame = player.gui.top.chaos_frame

			if mainFrame["effect_" .. id] then
				mainFrame["effect_" .. id].destroy()
			end
		end
	end
end

function updateActiveChaosEffects(event)
	for k, v in pairs(global.activeChaosEffects) do
		if v.endOnTick <= game.tick then
			local effect = chaosEffects[v.id]

			if effect.resetFunction then effect.resetFunction(v.effectFunctionTable) end

			removeEffectFromPlayerGUI(event, v.id)
			table.remove(global.activeChaosEffects, k)
		end
	end
end

script.on_event(defines.events.on_tick, function(event)
	updateActiveChaosEffects(event)
	updatePlayerGUI(event)

	if game.tick >= global.nextChaosTimerRefire then
		global.nextChaosTimerRefire = game.tick + REFIRE_INTERVAL

		pickRandomChaosEffect(event)
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

	--local text = main_frame.add{type="label", name="chaos_timer"}
	--text.caption = 0

	local progressbar = main_frame.add { type = "progressbar", name = "chaos_progressbar" }
	local style = progressbar.style
	style.bar_width = 8
	style.horizontally_stretchable = true
	style.margin = { 0, 0, 8, 0 }
end)
