function make_wand_from_gun_data( gun, entity_id, level )
	local is_rare = gun["is_rare"]
	local x, y = EntityGetTransform( entity_id )
	
	local ability_comp = EntityGetFirstComponent( entity_id, "AbilityComponent" )
	
	if GameHasFlagRun("DISPARITY_PICKED_DECK_OF_CARDS") then
		--Normal stats + random benefits
		ComponentObjectSetValue( ability_comp, "gun_config", "actions_per_round", gun["actions_per_round"] + Random( 0, 5 ) )
		ComponentObjectSetValue( ability_comp, "gun_config", "reload_time", gun["reload_time"] - Randomf( 2, 12 ) )
		ComponentObjectSetValue( ability_comp, "gun_config", "deck_capacity", gun["deck_capacity"] + Random( 0, 3 ) )
		ComponentObjectSetValue( ability_comp, "gunaction_config", "fire_rate_wait", gun["fire_rate_wait"] - Randomf( 0.25, 4 ) )
		ComponentObjectSetValue( ability_comp, "gunaction_config", "spread_degrees", gun["spread_degrees"] - Randomf( 0.25, 3 ) )
		ComponentObjectSetValue( ability_comp, "gunaction_config", "speed_multiplier", gun["speed_multiplier"] * Randomf( 1.025, 1.4 ) )
		
		--Rare chances for even larger mana charge
		--You're looking kinda pale. You're looking kinda moody. You need to
		local take_the_d = Random(1, 1000)
		if take_the_d > 876 then
			gun["mana_charge_speed"] = gun["mana_charge_speed"] + Random( 250, 1250 )
		elseif take_the_d > 500 then
			gun["mana_charge_speed"] = gun["mana_charge_speed"] + Random( 50, 250 )
		end
		ComponentSetValue( ability_comp, "mana_charge_speed", gun["mana_charge_speed"] + Random( 25, 100 ) )
		
		--NO MORE SHUFFLE CANCEL
		if GlobalsGetValue( "PERK_NO_MORE_SHUFFLE_WANDS", "0" ) == "1" then
			ComponentObjectSetValue( ability_comp, "gun_config", "shuffle_deck_when_empty", Random( 0, 1 ) )
		else
			ComponentObjectSetValue( ability_comp, "gun_config", "shuffle_deck_when_empty", 1 )
		end
		
		--rare chance of greater mana max
		if Random(1, 1000) > 987 then
			gun["mana_max"] = gun["mana_max"] + Random( 250, 2500 )
		else
			gun["mana_max"] = gun["mana_max"] + Random( 50, 250 )
		end
		ComponentSetValue( ability_comp, "mana_max", gun["mana_max"] )
		ComponentSetValue( ability_comp, "mana", gun["mana_max"])
		
	else --do normal stuff
		ComponentObjectSetValue( ability_comp, "gun_config", "actions_per_round", gun["actions_per_round"] )
		ComponentObjectSetValue( ability_comp, "gun_config", "reload_time", gun["reload_time"] )
		ComponentObjectSetValue( ability_comp, "gun_config", "deck_capacity", gun["deck_capacity"] )
		ComponentObjectSetValue( ability_comp, "gun_config", "shuffle_deck_when_empty", gun["shuffle_deck_when_empty"] )
		ComponentObjectSetValue( ability_comp, "gunaction_config", "fire_rate_wait", gun["fire_rate_wait"] )
		ComponentObjectSetValue( ability_comp, "gunaction_config", "spread_degrees", gun["spread_degrees"] )
		ComponentObjectSetValue( ability_comp, "gunaction_config", "speed_multiplier", gun["speed_multiplier"] )
		ComponentSetValue( ability_comp, "mana_charge_speed", gun["mana_charge_speed"])
		ComponentSetValue( ability_comp, "mana_max", gun["mana_max"])
		ComponentSetValue( ability_comp, "mana", gun["mana_max"])
	end

	ComponentSetValue( ability_comp, "item_recoil_recovery_speed", 15.0 ) -- TODO: implement logic for setting this  EXTOL: uhhh ok devs.

	--purple glow to rare wands
	if( is_rare == 1 ) then
		local light_comp = EntityGetFirstComponent( entity_id, "LightComponent" )
		if( light_comp ~= nil ) then
			ComponentSetValue( light_comp, "update_properties", 1)
			ComponentSetValue( light_comp, "r", 128 )
			ComponentSetValue( light_comp, "g", 0 )
			ComponentSetValue( light_comp, "b", 255 )
		end
		if GameHasFlagRun("DISPARITY_PICKED_DECK_OF_CARDS") then
			ComponentSetValue( light_comp, "r", 255 )
			ComponentSetValue( light_comp, "g", 90 )
		end
	end

	local wand = GetWand( gun )
	
	--this sets the wand sprite... not gonna mess with it ig.
	SetWandSprite( entity_id, ability_comp, wand.file, wand.grip_x, wand.grip_y, (wand.tip_x - wand.grip_x), (wand.tip_y - wand.grip_y) )

end