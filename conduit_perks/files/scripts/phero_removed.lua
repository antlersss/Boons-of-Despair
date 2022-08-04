
local eid = GetUpdatedEntityID()
local root = EntityGetRootEntity( eid )
local aaic_id = EntityGetFirstComponentIncludingDisabled( root, "AnimalAIComponent" )
if aaic_id ~= nil and not EntityHasTag( eid, "disp_prev_friend" ) then
	ComponentSetValue2( aaic_id, "dont_counter_attack_own_herd", false )
end