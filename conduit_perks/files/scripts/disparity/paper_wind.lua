
function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	-- don't increase healing
	if( damage < 0 ) then return damage, critical_hit_chance end
	
	local count = GlobalsGetValue( "DISPARITY_PICKED_PAPER_WIND_PICKUP_COUNT", 0 )
	count = 1.5^count
	local new_dam = damage * count
	return new_dam, critical_hit_chance
end

