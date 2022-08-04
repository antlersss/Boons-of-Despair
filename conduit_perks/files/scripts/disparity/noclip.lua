
local eid = GetUpdatedEntityID()
local cc_id = EntityGetFirstComponentIncludingDisabled( eid, "ControlsComponent" )
local plcc_id = EntityGetFirstComponentIncludingDisabled( eid, "PlayerCollisionComponent" )
local left = ComponentGetValue2( cc_id, "mButtonDownLeft" )
local right = ComponentGetValue2( cc_id, "mButtonDownRight" )
local x, y = EntityGetTransform( eid )
local ray_one = RaytracePlatforms( x + 3, y, x + 3, y - 8 )
local ray_two = RaytracePlatforms( x - 3, y, x - 3, y - 8 )
local ray_check = ray_two or ray_one
local count = GameGetFrameNum()
local storage_comp = EntityGetFirstComponentIncludingDisabled( eid, "VariableStorageComponent", "noclip_storage" )
local true_count = ComponentGetValue2( storage_comp, "value_int" )

if ray_check and right then
	EntitySetTransform( eid, x + 0.81, y )
	if true_count == 0 then
		ComponentSetValue2( storage_comp, "value_int", count )
		true_count = count 
	end
	local right_count = count - true_count
	if right_count > 120 then
		EntityInflictDamage( eid, 0.00000005 * right_count^2 + 0.04, "DAMAGE_DROWNING", "Noclip Suffocation", "NONE", 0, 0 )
	end
elseif ray_check and left then
	EntitySetTransform( eid, x - 0.81, y )
	if true_count == 0 then
		ComponentSetValue2( storage_comp, "value_int", count )
		true_count = count 
	end
	local left_count = count - true_count
	if left_count > 120 then
		EntityInflictDamage( eid, 0.00000005 * left_count^2, "DAMAGE_DROWNING", "Noclip Suffocation", "NONE", 0, 0 )
	end
elseif not ray_check then
	ComponentSetValue2( storage_comp, "value_int", 0 )
end

ComponentSetValue2( plcc_id, "DEBUG_stuck_in_static_ground", 0 )

