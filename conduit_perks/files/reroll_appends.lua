extol_old_reroll_func = item_pickup

function item_pickup( entity_item, entity_who_picked, item_name )
	local disparities = EntityGetWithTag("conduit_disp")
	for i, disp in ipairs(disparities) do
		EntityRemoveTag(disp,"perk")
	end
	extol_old_reroll_func( entity_item, entity_who_picked, item_name )
	for i, disp in ipairs(disparities) do
		EntityAddTag(disp,"perk")
	end
end
