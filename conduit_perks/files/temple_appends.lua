RegisterSpawnFunction( 0xffFF9195, "spawn_disparity" )
dofile( "mods/conduit_perks/files/scripts/disparity/disparity.lua" )

extol_old_visualizer = spawn_spell_visualizer
function spawn_spell_visualizer( x, y )
	extol_old_visualizer( x, y )
	LoadPixelScene( "mods/conduit_perks/files/pixel_scenes/altar.png", "mods/conduit_perks/files/pixel_scenes/altar_visual.png", x + 167, y - 17, "", true )
end

function spawn_disparity( x, y )
	disparity_spawn_random( x, y )
end