
function shot( pe_id )
	local x, y = EntityGetTransform( pe_id )
	local eid = EntityLoad( "mods/conduit_perks/files/entities/hitfx_sight_shot.xml", x, y )
	EntityAddChild( pe_id, eid )
end
