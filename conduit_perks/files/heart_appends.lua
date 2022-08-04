extol_old_item_pickup = item_pickup

function item_pickup( entity_item, entity_who_picked, name )
	local dmc_id = EntityGetFirstComponentIncludingDisabled( entity_who_picked, "DamageModelComponent" )
	if tonumber(GlobalsGetValue("DISPARITY_PICKED_GOLD_EGO_PICKUP_COUNT", "0" )) > 0 then
		ComponentSetValue2(dmc_id, "hp", 0.04)
		return
	end
	extol_old_item_pickup( entity_item, entity_who_picked, name )
	local max_hp = ComponentGetValue2( dmc_id, "max_hp" )
	local count = tonumber(GlobalsGetValue( "DISPARITY_PICKED_SPOILED_VITALITY_PICKUP_COUNT", "0" ))
	if count > 0 then
		max_hp = max_hp * count
		local vsc_id = EntityGetFirstComponentIncludingDisabled( entity_who_picked, "VariableStorageComponent", "spoiled_vit_storage" )
		ComponentSetValue2( vsc_id, "value_float", max_hp )
	end
end
