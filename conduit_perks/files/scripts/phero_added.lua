
local eid = GetUpdatedEntityID()
local root = EntityGetRootEntity( eid )
local aaic_id = EntityGetFirstComponentIncludingDisabled( root, "AnimalAIComponent" )
local friend = ComponentGetValue2( aaic_id, "dont_counter_attack_own_herd" ) 
if friend and not EntityHasTag( root, "disp_prev_enemy" ) then 
	EntityAddTag( root, "disp_prev_friend" ) 
elseif aaic_id ~= nil then
	EntityAddTag( root, "disp_prev_enemy" )
	ComponentSetValue2( aaic_id, "dont_counter_attack_own_herd", true )
end