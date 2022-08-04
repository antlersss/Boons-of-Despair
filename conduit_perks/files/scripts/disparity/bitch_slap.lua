dofile_once("mods/conduit_perks/lib/conduit.lua")

function shot( projectile_id )
local frame_num = GameGetFrameNum()
local stored_wait = GetValueNumber( "bitch_slap", 0 )
if stored_wait > frame_num then
	return
end
local mult = GlobalsGetValue( "DISPARITY_PICKED_BITCH_SLAP_PICKUP_COUNT", 0 )
local chance = math.min(5 * mult, 100)
	if Random( 1, 100 ) <= chance then
		local eid = EntityLoad( "mods/conduit_perks/files/entities/hitfx_bitch_slap.xml" )
		EntityAddChild( projectile_id, eid )
		SetValueNumber( "bitch_slap", frame_num + 900 )
	end
end