dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "mods/conduit_perks/files/scripts/disparity/disparity_list.lua" )

function disparity_spawn_order( x, y, pw )
	SetRandomSeed( y + pw, x )
	local id_list = {}
	local check_me = GlobalsGetValue( "LAST_DISP_SPAWN", "NONE" )
	for i, disp in ipairs(disparity_list) do
		local stack = disp.stackable
		local flag = get_perk_picked_flag_name( disp.id )
		if not GameHasFlagRun(flag) or stack == true and check_me ~= disp.id then
			table.insert( id_list, disp.id )
		end
	end
	local rand = Random( 1, #id_list )
	return id_list[rand]
end

function disparity_pickup( entity_item, entity_who_picked, item_name, do_cosmetic_fx )
	-- fetch perk info ---------------------------------------------------
	local pos_x, pos_y = EntityGetTransform(entity_item)
	local perk_name = "PERK_NAME_NOT_DEFINED"
	local perk_desc = "PERK_DESCRIPTION_NOT_DEFINED"
	local vsc_id = EntityGetFirstComponentIncludingDisabled( entity_item, "VariableStorageComponent" )
	local perk_id = ComponentGetValue2(vsc_id, "value_string")

	local perk_data = get_perk_with_id( disparity_list, perk_id )
	if perk_data == nil then
		return
	end
	
	local flag_name = get_perk_picked_flag_name( perk_id )
	
	local stack_check = true
	if not perk_data.stackable and GameHasFlagRun( flag_name ) then
		stack_check = false
	end
	if perk_data.func ~= nil and stack_check then
		perk_data.func( entity_item, entity_who_picked, item_name, pickup_count )
	end
	
	-- update how many times the perk has been picked up this run -----------------
	
	local pickup_count = tonumber( GlobalsGetValue( flag_name .. "_PICKUP_COUNT", "0" ) )
	pickup_count = pickup_count + 1
	GlobalsSetValue( flag_name .. "_PICKUP_COUNT", tostring( pickup_count ) )

	-- load perk for entity_who_picked -----------------------------------
	GameAddFlagRun( flag_name )
	
	local no_remove = perk_data.do_not_remove or false

	-- add a game effect or two
	if perk_data.game_effect ~= nil then
		local game_effect_comp,game_effect_entity = GetGameEffectLoadTo( entity_who_picked, perk_data.game_effect, true )
		if game_effect_comp ~= nil then
			ComponentSetValue( game_effect_comp, "frames", "-1" )
			
			if ( no_remove == false ) then
				ComponentAddTag( game_effect_comp, "disp_comp" )
				EntityAddTag( game_effect_entity, "disparity_ent" )
			end
		end
	end
	
	if perk_data.game_effect2 ~= nil then
		local game_effect_comp,game_effect_entity = GetGameEffectLoadTo( entity_who_picked, perk_data.game_effect2, true )
		if game_effect_comp ~= nil then
			ComponentSetValue( game_effect_comp, "frames", "-1" )
			
			if ( no_remove == false ) then
				ComponentAddTag( game_effect_comp, "disp_comp" )
				EntityAddTag( game_effect_entity, "disparity_ent" )
			end
		end
	end
	
	-- particle effect only applied once
	if perk_data.particle_effect ~= nil and ( pickup_count <= 1 ) then
		local particle_id = EntityLoad( "data/entities/particles/perks/" .. perk_data.particle_effect .. ".xml" )
		
		if ( no_remove == false ) then
			EntityAddTag( particle_id, "disparity_ent" )
		end
		
		EntityAddChild( entity_who_picked, particle_id )
	end
	
	-- certain other perks may be marked as picked-up
	if perk_data.remove_other_perks ~= nil then
		for i,v in ipairs( perk_data.remove_other_perks ) do
			local f = get_perk_picked_flag_name( v )
			GameAddFlagRun( f )
		end
	end
	
	perk_name = GameTextGetTranslatedOrNot( perk_data.ui_name )
	perk_desc = GameTextGetTranslatedOrNot( perk_data.ui_description )

	-- add ui icon etc
	local entity_ui = EntityCreateNew( "" )
	EntityAddComponent( entity_ui, "UIIconComponent", 
	{ 
		name = perk_data.ui_name,
		description = perk_data.ui_description,
		icon_sprite_file = perk_data.ui_icon
	})
	
	if ( no_remove == false ) then
		EntityAddTag( entity_ui, "disparity_ent" )
	end
	
	EntityAddChild( entity_who_picked, entity_ui )

	-- cosmetic fx -------------------------------------------------------
	if do_cosmetic_fx then
		local enemies_killed = tonumber( StatsBiomeGetValue("enemies_killed") )
		
		if( enemies_killed ~= 0 ) then
			EntityLoad( "data/entities/particles/image_emitters/perk_effect.xml", pos_x, pos_y )
		else
			EntityLoad( "data/entities/particles/image_emitters/perk_effect_pacifist.xml", pos_x, pos_y )
		end
		
		if stack_check then
			GamePrintImportant( perk_name, perk_desc )
		else
			GamePrint( "Disparity not stackable." )
		end
	end

	local x,y = EntityGetTransform( entity_who_picked )
	

	EntityKill( entity_item ) -- entity item should always be killed, hence we don't kill it in the above loop

end

 -- spawns one perk
function disparity_spawn( x, y, perk_id )
	local perk_data = get_perk_with_id( disparity_list, perk_id )
	---
	local entity_id = EntityLoad( "mods/conduit_perks/files/scripts/disparity/perk.xml", x, y )
	if ( entity_id == nil ) then
		return
	end

	-- init perk item
	EntityAddComponent( entity_id, "SpriteComponent", 
	{ 
		image_file = perk_data.perk_icon or "data/items_gfx/perk.xml",  
		offset_x = "8", 
		offset_y = "8", 
		update_transform = "1" ,
		update_transform_rotation = "0",
	} )

	EntityAddComponent( entity_id, "UIInfoComponent", 
	{ 
		name = perk_data.ui_name,
	} )

	EntityAddComponent( entity_id, "ItemComponent", 
	{ 
		item_name = perk_data.ui_name,
		ui_description = perk_data.ui_description,
		ui_display_description_on_pick_up_hint = "1",
		play_spinning_animation = "0",
		play_hover_animation = "0",
		play_pick_sound = "0",
	} )

	EntityAddComponent( entity_id, "SpriteOffsetAnimatorComponent", 
	{ 
      sprite_id="-1" ,
      x_amount="0" ,
      x_phase="0" ,
      x_phase_offset="0" ,
      x_speed="0" ,
      y_amount="2" ,
      y_speed="3",
	} )

	EntityAddComponent( entity_id, "VariableStorageComponent", 
	{ 
		name = "perk_id",
		value_string = perk_data.id,
	} )
	
	if dont_remove_other_perks then
		EntityAddComponent( entity_id, "VariableStorageComponent", 
		{ 
			name="perk_dont_remove_others",
			value_bool="1",
		} )
	end

	return entity_id
end

-- spawns a random perk
function disparity_spawn_random( x, y )
	local pw = GetParallelWorldPosition( x, y )
	local perk_id = disparity_spawn_order( x, y, pw )

	result_id = disparity_spawn( x, y, perk_id )
	GlobalsSetValue( "LAST_DISP_SPAWN", perk_id )
	return result_id
end

function remove_all_disparities()
	local players = get_players()
	local player_id = players[1]
	
	if ( player_id ~= nil ) then
		for i,perk_data in ipairs( disparity_list ) do
			local perk_id = perk_data.id
			
			local flag_name = get_perk_picked_flag_name( perk_id )
			local pickup_count = tonumber( GlobalsGetValue( flag_name .. "_PICKUP_COUNT", "0" ) )
			
			if ( GameHasFlagRun( flag_name ) or ( pickup_count > 0 ) ) and ( ( perk_data.do_not_remove == nil ) or ( perk_data.do_not_remove == false ) ) then
				GameRemoveFlagRun( flag_name )
				pickup_count = 0
				GlobalsSetValue( flag_name .. "_PICKUP_COUNT", tostring( pickup_count ) )
				
				if ( perk_data.game_effect ~= nil ) then
					local comp = GameGetGameEffect( player_id, perk_data.game_effect )
					
					if ( comp ~= NULL_ENTITY ) then
						ComponentSetValue2( comp, "frames", 1 )
					end
				end
				
				if ( perk_data.game_effect2 ~= nil ) then
					local comp = GameGetGameEffect( player_id, perk_data.game_effect2 )
					
					if ( comp ~= NULL_ENTITY ) then
						ComponentSetValue2( comp, "frames", 1 )
					end
				end
				
				if ( perk_data.func_remove ~= nil ) then
					perk_data.func_remove( player_id )
				end
				
				local c = EntityGetAllChildren( player_id )
				if ( c ~= nil ) then
					for a,child in ipairs( c ) do
						if EntityHasTag( child, "disparity_ent" ) then
							local ikcomp = EntityGetFirstComponent( child, "IKLimbWalkerComponent" )
							if ( ikcomp ~= nil ) then
								ComponentSetValue2( ikcomp, "affect_flying", false )
							end
							
							EntityKill( child )
						end
					end
				end
				
				if ( perk_data.remove_other_perks ~= nil ) then
					for a,b in ipairs( perk_data.remove_other_perks ) do
						local f = get_perk_picked_flag_name( b )
						GameRemoveFlagRun( f )
					end
				end
			end
		end
		
		local comps = EntityGetAllComponents( player_id )
		for i,v in ipairs( comps ) do
			if ComponentHasTag( v, "disp_comp" ) then
				EntityRemoveComponent( player_id, v )
			end
		end
		
		add_halo_level( player_id, 0, 0)
		
		GlobalsSetValue( "PLAYER_RATTINESS_LEVEL", "0" )
		GlobalsSetValue( "PLAYER_FUNGAL_LEVEL", "0" )
		GlobalsSetValue( "PLAYER_GHOSTNESS_LEVEL", "0" )
		GlobalsSetValue( "PLAYER_LUKKINESS_LEVEL", "0" )
		GlobalsSetValue( "PLAYER_HALO_LEVEL", "0" )
		
		EntitySetComponentsWithTagEnabled( player_id, "lukki_enable", false )
		EntitySetComponentsWithTagEnabled( player_id, "player_hat", false )
		
		local hat2 = EntityGetComponent( player_id, "SpriteComponent", "player_hat2" )
		
		if ( hat2 ~= nil ) then
			EntitySetComponentsWithTagEnabled( player_id, "player_hat2_shadow", true )
		end
		
		local minions = EntityGetWithTag( "disparity_ent" )
		for i,v in ipairs( minions ) do
			EntityKill( v )
		end
	end
end
