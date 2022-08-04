dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/conduit_perks/lib/conduit.lua")

function shot( entity_id )
	local comps = EntityGetComponent( entity_id, "ProjectileComponent" )
	local vc_id = EntityGetFirstComponentIncludingDisabled( entity_id, "VelocityComponent" )
	local mult = GlobalsGetValue( "DISPARITY_PICKED_CHUNKED_PICKUP_COUNT" )
	mult = 2^mult
	if( comps ~= nil ) then
		for i,comp in ipairs(comps) do
			local damage = ComponentGetValue2( comp, "damage" )
			damage = damage * mult
			ComponentSetValue2( comp, "damage", damage )
			ComponentSetValue2( comp, "penetrate_entities", true )
			ComponentSetValue2( comp, "damage_every_x_frames", -1 )
			local dtypes = { "projectile", "slice", "explosion", "ice", "fire", "electricity", "melee" }
			for a,b in ipairs(dtypes) do
				local v = tonumber(ComponentObjectGetValue( comp, "damage_by_type", b ))
				v = v * mult
				ComponentObjectSetValue( comp, "damage_by_type", b, tostring(v) )
			end
			local v = tonumber(ComponentObjectGetValue( comp, "config_explosion", "damage" ))
			v = v * mult
			ComponentObjectSetValue( comp, "config_explosion", "damage", tostring(v) )
			ComponentSetValue2( comp, "penetrate_entities", true )
			ComponentSetValue2( comp, "damage_every_x_frames", -1 )
		end
		local slow_down = ComponentGetValue2( vc_id, "air_friction" )
		ComponentSetValue2( vc_id, "air_friction", slow_down + 2.5 )
		EntityAddComponent2( entity_id, "LuaComponent", { execute_every_n_frame = 20, script_source_file = "mods/conduit_perks/files/scripts/disparity/chunked_hit.lua" })
	end
end

function wand_fired( gun_entity_id )

	local x, y, theta = EntityGetTransform(gun_entity_id)
	local ac_id = EntityGetFirstComponentIncludingDisabled( gun_entity_id, "AbilityComponent" )
	local shot_count = ComponentGetValue2( ac_id, "stat_times_player_has_shot" )
	local root_ent = EntityGetRootEntity( gun_entity_id )
	local player_cdc = EntityGetFirstComponentIncludingDisabled( root_ent, "CharacterDataComponent" )
	local pvx, pvy = ComponentGetValue2( player_cdc, "mVelocity" )
	local vel_x_add = 69 * math.cos(theta)
	local vel_y_add = 69 * math.sin(theta)
	pvx = pvx - vel_x_add
	pvy = pvy - vel_y_add
	ComponentSetValueVector2( player_cdc, "mVelocity", pvx, pvy )
	if not EntityHasTag( gun_entity_id, "chunked_limit" ) then
		local add_me = gaussian(75, 9, x, y) + shot_count
		EntityAddComponent2( gun_entity_id, "VariableStorageComponent", {_tags="stored_chunked_limit", value_int= add_me })
		EntityAddTag( gun_entity_id, "chunked_limit" )
	end
	
	local vsc_id = EntityGetFirstComponentIncludingDisabled( gun_entity_id, "VariableStorageComponent", "stored_chunked_limit" )
	local check_count = ComponentGetValue2( vsc_id, "value_int" )
	if shot_count >= check_count then
		EntityLoad("data/entities/projectiles/deck/fireblast.xml", x, y )
		local children = EntityGetAllChildren( gun_entity_id )
		if children ~= nil then
			for i, child in ipairs(children) do
				local iac_id = EntityGetFirstComponentIncludingDisabled( child, "ItemActionComponent" )
				local card_id = ComponentGetValue2( iac_id, "action_id" )
				local ic_id = EntityGetFirstComponentIncludingDisabled( child, "ItemComponent" )
				local uses_left = ComponentGetValue2( ic_id, "uses_remaining" )
				EntityKill(child)
				local eid = CreateItemActionEntity( card_id, x, y )
				ic_id = EntityGetFirstComponentIncludingDisabled( eid, "ItemComponent" )
				ComponentGetValue2( ic_id, "uses_remaining", uses_left )
				local vc_id = EntityGetFirstComponentIncludingDisabled( eid, "VelocityComponent" )
				ComponentSetValueVector2( vc_id, "mVelocity", Random(-250, 250), Random(5, 60) )
			end
		end
		if Random( 1, 100) > 95 then
			EntityLoad( "data/entities/items/pickup/broken_wand.xml", x, y + 8 )
		end
		EntityKill(gun_entity_id)
	end
end
