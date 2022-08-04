
function shot( projectile_id )
	local x, y = EntityGetTransform( projectile_id )
	local eid = EntityLoad( "mods/conduit_perks/files/entities/soul_stealer.xml", x, y )
	EntityAddChild( projectile_id, eid )
end