dofile_once("data/scripts/lib/utilities.lua")

function shot( entity_id )
	local comps = EntityGetComponent( entity_id, "ProjectileComponent" )
	local mult = GlobalsGetValue( "DISPARITY_PICKED_DEADEYE_PICKUP_COUNT", 0 )
	mult = 1.5^mult
	if( comps ~= nil ) then
		for i,comp in ipairs(comps) do
			local damage = ComponentGetValue2( comp, "damage" )
			damage = damage * 1.5
			ComponentSetValue2( comp, "damage", damage )
			
			local dtypes = { "projectile", "slice", "explosion", "ice", "fire", "electricity", "melee" }
			for a,b in ipairs(dtypes) do
				local v = tonumber(ComponentObjectGetValue( comp, "damage_by_type", b ))
				v = v * 1.5
				ComponentObjectSetValue( comp, "damage_by_type", b, tostring(v) )
			end
			
			local v = tonumber(ComponentObjectGetValue( comp, "config_explosion", "damage" ))
			v = v * 1.5
			ComponentObjectSetValue( comp, "config_explosion", "damage", tostring(v) )
		end
	end
	
	EntityAddComponent( entity_id, "LuaComponent", { execute_on_removed = "1", execute_every_n_frame = "-1", script_source_file = "mods/conduit_perks/files/scripts/disparity/deadeye_death.lua" } )
end


