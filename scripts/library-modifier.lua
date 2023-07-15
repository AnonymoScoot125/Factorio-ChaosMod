modifier = {}

function modifier.applyForceModifier(mod)
    local pick = math.random()
    local distanceToBottom = math.abs(game.forces.player[mod] - modifier[mod].minValue)
    local minValue = 0
    local maxValue = 0

    if pick < 0.5 and distanceToBottom - modifier[mod].increment >= 0 then
        minValue = -distanceToBottom
        maxValue = -modifier[mod].increment
    else
        minValue = modifier[mod].increment
        maxValue = distanceToBottom +
            math.clamp(modifier[mod].exceedValue - distanceToBottom, 0, modifier[mod].exceedValue)
    end

    local randomValue = math.randomRange(minValue, maxValue)
    randomValue = math.roundTo(randomValue, modifier[mod].increment)

    local modifyingValue = math.clampBottom(
        math.roundTo(game.forces.player[mod] + randomValue, modifier[mod].increment), modifier[mod].minValue)

    game.forces.player[mod] = modifyingValue

    return modifyingValue
end

function modifier.revertForceModifier(mod, value)
    game.forces.player[mod] = math.clampBottom(
        math.roundTo(game.forces.player[mod] - value, modifier[mod].increment),
        modifier[mod].minValue)
end

modifier["manual_mining_speed_modifier"] = {
    minValue = -1,
    exceedValue = 2,
    increment = 0.1,
}
modifier["manual_crafting_speed_modifier"] = {
    minValue = -1,
    exceedValue = 2,
    increment = 0.1,
}
modifier["laboratory_speed_modifier"] = {
    minValue = -1,
    exceedValue = 2,
    increment = 0.1,
}
modifier["laboratory_productivity_bonus"] = {
    minValue = -1,
    exceedValue = 2,
    increment = 0.1,
}
modifier["worker_robots_speed_modifier"] = {
    minValue = -0.9,
    exceedValue = 2,
    increment = 0.1,
}
modifier["worker_robots_battery_modifier"] = {
    minValue = -0.9,
    exceedValue = 2,
    increment = 0.1,
}
modifier["worker_robots_storage_bonus"] = {
    minValue = 0,
    exceedValue = 3,
    increment = 1,
}
modifier["inserter_stack_size_bonus"] = {
    minValue = 0,
    exceedValue = 3,
    increment = 1,
}
modifier["stack_inserter_capacity_bonus"] = {
    minValue = 0,
    exceedValue = 3,
    increment = 1,
}
modifier["character_trash_slot_count"] = {
    minValue = 0,
    exceedValue = 100,
    increment = 10,
}
modifier["maximum_following_robot_count"] = {
    minValue = 1,
    exceedValue = 10,
    increment = 1,
}
modifier["following_robots_lifetime_modifier"] = {
    minValue = 0,
    exceedValue = 2,
    increment = 0.1,
}
modifier["character_running_speed_modifier"] = {
    minValue = -0.9,
    exceedValue = 2,
    increment = 0.1,
}
modifier["artillery_range_modifier"] = {
    minValue = 0,
    exceedValue = 2,
    increment = 0.1,
}
modifier["character_build_distance_bonus"] = {
    minValue = 0,
    exceedValue = 2,
    increment = 0.1,
}
modifier["character_item_drop_distance_bonus"] = {
    minValue = 0,
    exceedValue = 2,
    increment = 0.1,
}
modifier["character_reach_distance_bonus"] = {
    minValue = 0,
    exceedValue = 2,
    increment = 0.1,
}
modifier["character_resource_reach_distance_bonus"] = {
    minValue = 0,
    exceedValue = 2,
    increment = 0.1,
}
modifier["character_item_pickup_distance_bonus"] = {
    minValue = 0,
    exceedValue = 2,
    increment = 0.1,
}
modifier["character_loot_pickup_distance_bonus"] = {
    minValue = 0,
    exceedValue = 2,
    increment = 0.1,
}
modifier["character_inventory_slots_bonus"] = {
    minValue = 0,
    exceedValue = 100,
    increment = 10,
}
modifier["character_health_bonus"] = {
    minValue = 0,
    exceedValue = 1000,
    increment = 100,
}
modifier["mining_drill_productivity_bonus"] = {
    minValue = 0,
    exceedValue = 2,
    increment = 0.1,
}
modifier["train_braking_force_bonus"] = {
    minValue = 0,
    exceedValue = 2,
    increment = 0.1,
}
