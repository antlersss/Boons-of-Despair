dofile_once("data/scripts/lib/utilities.lua")

function shot( entity_id )
	local comps = EntityGetComponent( entity_id, "ProjectileComponent" )
	if( comps ~= nil ) then
		local x, y = EntityGetTransform( entity_id )
		local enemies = EntityGetInRadiusWithTag( x, y, 120, "enemy" )
		local mult = 1.25
		if #enemies ~= 0 then
			mult = (( 50 / (( 100 * #enemies ) + 1 )) + 0.75 )
		end
		local count = GlobalsGetValue( "DISPARITY_PICKED_AGORA_PICKUP_COUNT", 0 )
		mult = mult^count
		for i,comp in ipairs(comps) do
			local damage = ComponentGetValue2( comp, "damage" )
			damage = damage * mult
			ComponentSetValue2( comp, "damage", damage )
		
			local dtypes = { "projectile", "explosion", "melee", "ice", "slice", "electricity", "fire" }
			for a,b in ipairs(dtypes) do
				local v = tonumber(ComponentObjectGetValue( comp, "damage_by_type", b ))
				v = v * mult
				ComponentObjectSetValue( comp, "damage_by_type", b, tostring(v) )
			end
		
			local etypes = { "explosion_radius", "ray_energy", "sparks_count_max", "camera_shake", "damage", "material_sparks_count_max", "stains_radius" }
			for a,b in ipairs(etypes) do
				local v = tonumber(ComponentObjectGetValue( comp, "config_explosion", b ))
				v = v * mult
				ComponentObjectSetValue( comp, "config_explosion", b, tostring(v) )
			end
		end
	end
end

