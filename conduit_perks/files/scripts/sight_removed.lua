
local eid = GetUpdatedEntityID()
local root = EntityGetRootEntity( eid )
local x, y = EntityGetTransform( root )
local effect_id = EntityLoad( "mods/conduit_perks/files/entities/effect_blind_despair.xml", x, y )
EntityAddChild( root, effect_id )