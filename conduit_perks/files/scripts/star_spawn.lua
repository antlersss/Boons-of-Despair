local eid = GetUpdatedEntityID()
local x, y = EntityGetTransform( eid )
EntityLoad( "mods/conduit_perks/files/entities/star_child.xml", x, y )