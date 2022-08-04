dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile( "mods/conduit_perks/files/scripts/disparity/disparity.lua" )

function item_pickup( entity_item, entity_who_picked, item_name )
	disparity_pickup( entity_item, entity_who_picked, item_name, true )
	EntityRemoveTag(entity_item,"perk")
	local perk_count = math.max(tonumber( GlobalsGetValue( "TEMPLE_PERK_COUNT", "3" ) ) - 1, 1)
	GlobalsSetValue("TEMPLE_PERK_COUNT", tostring(perk_count))
	local nearby_perks = EntityGetWithTag( "perk" )
	local rand = Random(1,#nearby_perks)
	if #nearby_perks > 1 then
		local x,y = EntityGetTransform(nearby_perks[rand])
		EntityLoad("data/entities/particles/poof_blue.xml", x, y )
		EntityKill(nearby_perks[rand])
	end
end
