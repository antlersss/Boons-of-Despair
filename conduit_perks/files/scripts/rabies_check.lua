
if GameHasFlagRun("DISPARITY_PICKED_RABIES") then
	local entity_id = GetUpdatedEntityID()
	local player = EntityGetRootEntity( entity_id )
	if EntityHasTag( player, "HAS_DISP_RABIES" ) then
		local gec_id = EntityGetFirstComponentIncludingDisabled( entity_id, "GameEffectComponent" )
		ComponentSetValue2( gec_id, "effect", "RADIOACTIVE" )
	end
end