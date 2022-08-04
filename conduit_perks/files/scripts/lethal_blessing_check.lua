
function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	local eid = GetUpdatedEntityID()
	local root = EntityGetRootEntity( eid )
	local dmc_id = EntityGetFirstComponentIncludingDisabled( root, "DamageModelComponent" )
	local hit_points = ComponentGetValue2( dmc_id, "hp" )
	if damage > hit_points then
		local children = EntityGetAllChildren( entity_thats_responsible )
		local not_found = true
		local breaker_check = false
		local count = tonumber(GlobalsGetValue( "DISPARITY_PICKED_BLESSING_OF_SIGHT_PICKUP_COUNT", "0" )) + 1
		for i, child in ipairs(children) do
			if EntityGetName( child ) == "sights_blessing" then
				not_found = false
				local gec_id = EntityGetFirstComponentIncludingDisabled( child, "GameEffectComponent" )
				local current_frames = ComponentGetValue2( gec_id, "frames" )
				ComponentSetValue2( gec_id, "frames", count * 300 + current_frames )
			elseif EntityGetName( child ) == "sights_curse" then
				breaker_check = true
				EntityKill( child )
			end
			if not not_found and breaker_check then
				break
			end
		end
		if not_found then
			local x, y = EntityGetTransform( entity_thats_responsible )
			local effect_id = LoadGameEffectEntityTo( entity_thats_responsible, "mods/conduit_perks/files/entities/effect_blind_hope.xml" )
			local gec_id = EntityGetFirstComponentIncludingDisabled( effect_id, "GameEffectComponent" )
			ComponentSetValue2( gec_id, "frames", count * 300 )
		end
	end
	EntityKill( eid )
	return damage, critical_hit_chance
end