local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity( entity_id )
if GameHasFlagRun("DISPARITY_PICKED_SPOILED_VITALITY") and EntityHasTag( root, "HAS_DISP_SPOILED_VITALITY" ) then
	local gec_id = EntityGetFirstComponentIncludingDisabled( entity_id, "GameEffectComponent" )
	ComponentSetValue2( gec_id, "effect", "MOVEMENT_FASTER_2X" )
	EntityAddComponent2( entity_id, "GameEffectComponent", {effect="FASTER_LEVITATION", frames=-1 } )
end