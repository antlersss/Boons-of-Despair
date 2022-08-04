function shot( projectile_id )
	local x, y = EntityGetTransform(projectile_id)
	local leid = EntityLoad("mods/conduit_perks/files/entities/hitfx_gold_ego.xml", x, y )
	EntityAddChild( projectile_id, leid )
end