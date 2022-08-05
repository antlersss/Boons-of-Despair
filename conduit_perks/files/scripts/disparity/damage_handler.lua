function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	local new_dam = damage
	local eid = GetUpdatedEntityID()
	if GameHasFlagRun("DISPARITY_PICKED_CERAMIC_ARMOR") and new_dam > 0 then
		local count = GlobalsGetValue( "DISPARITY_PICKED_CERAMIC_ARMOR_PICKUP_COUNT", 0 )
		count = 1.2 ^ count
		new_dam = math.max((new_dam - 0.2) * count, 0) * count
	end
	if GameHasFlagRun("DISPARITY_PICKED_IRON_BALLS") and eid == entity_thats_responsible and new_dam > 0.0 then
		local count = GlobalsGetValue( "DISPARITY_PICKED_IRON_BALLS_PICKUP_COUNT", 0 )
		count = 0.5^count
		new_dam = new_dam * count
	end
	if GameHasFlagRun("DISPARITY_PICKED_MEGALOMANIAC") and new_dam > 0.04 then
		new_dam = 0.04
	end
	local sns_ent = EntityGetWithName("DISP_SNS_ENT")
	if GameHasFlagRun("DISPARITY_PICKED_SNS_BOOST") then
		local vsc_id = EntityGetFirstComponentIncludingDisabled( sns_ent, "VariableStorageComponent" )
		local total = ComponentGetValue2(vsc_id, "value_float") or 0
		if entity_thats_responsible ~= sns_ent then
			ComponentSetValue2( vsc_id, "value_float", new_dam + total )
			new_dam = 0
		else
			ComponentSetValue2( vsc_id, "value_float", math.max(total - new_dam, 0))
		end
	end
	if GameHasFlagRun("DISPARITY_PICKED_GOLD_EGO") then
		local dmc_id = EntityGetFirstComponentIncludingDisabled( eid, "DamageModelComponent" )
		ComponentSetValue2( dmc_id, "hp", 0.01 )
		new_dam = ComponentGetValue2(dmc_id, "max_hp") * 10000 + new_dam
	end
	return new_dam, critical_hit_chance 
end

