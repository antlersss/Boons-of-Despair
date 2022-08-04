local entity_id = GetUpdatedEntityID()
local proj_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "ProjectileComponent" )
local last_frame = ComponentGetValue2( proj_comp, "mLastFrameDamaged" )
local check_me = ComponentGetValue2( proj_comp, "on_collision_die" )
if last_frame == -1024 or not check_me then
	return
elseif last_frame ~= 1024 and EntityHasTag( entity_id, "chunky_proj" ) then
	EntityAddComponent2( entity_id, "VariableStorageComponent", {_tags = "chunked_proj", value_int = last_frame} )
	EntityAddTag( entity_id, "chunked_proj" )
end

local vsc_id = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent", "chunked_proj" )
local new_frame = ComponentGetValue2( vsc_id, "value_int" )
if last_frame ~= new_frame then
	ComponentSetValue2( proj_comp, "penetrate_entities", false )
end