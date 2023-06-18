
function math.clamp(number, minValue, maxValue)

	if number < minValue then
		return minValue
	elseif number > maxValue then
		return maxValue
	else
		return number
	end
	
end

function math.clampBottom(number, minValue)

	if number < minValue then
		return minValue
	else
		return number
	end
	
end

function math.clampTop(number, maxValue)

    if number > maxValue then
        return maxValue
    else
        return number
    end
	
end

function math.roundTo(number, increment)

	return math.floor(number / increment + 0.5) * increment

end

function math.randomRange(minValue, maxValue)

    return math.random() * (maxValue - minValue) + minValue
	
end

function calculateModifier(modifier, bottomValue, topValue, increment)

	local pick = math.random()
	local distanceToBottom = math.abs(modifier - bottomValue)
	local minValue = 0
	local maxValue = 0
	
	if pick < 0.5 and distanceToBottom - increment >= 0 then
		minValue = -distanceToBottom
		maxValue = -increment
	else
		minValue = increment
		maxValue = distanceToBottom + math.clamp(topValue - distanceToBottom, 0, topValue)
	end

	local randomValue = math.random() * (maxValue - minValue) + minValue
	randomValue = math.floor(randomValue / increment + 0.5) * increment
	
	return randomValue

end
