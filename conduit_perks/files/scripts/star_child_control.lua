function collision_trigger( colliding_entity_id )
	local entity_id = GetUpdatedEntityID()
	local vsc_id = EntityGetFirstComponent( entity_id, "VariableStorageComponent" )
	local slowdown = math.min(math.log( 2.5 + ((ComponentGetValue2(vsc_id,"value_int")/40)-9)/9 ) * 6 - 1, 4)/6.5
	local vc_id = EntityGetFirstComponent( colliding_entity_id, "VelocityComponent" )
	local vel_x,vel_y = ComponentGetValueVector2( vc_id, "mVelocity" )
	vc_id = EntityGetFirstComponent(entity_id, "VelocityComponent")
	local old_one, old_two = ComponentGetValue2( vc_id, "mVelocity" )
	ComponentSetValue2( vc_id, "mVelocity", vel_x/4/slowdown + old_one, vel_y/6.5/slowdown + old_two )
	EntityKill( colliding_entity_id )
end