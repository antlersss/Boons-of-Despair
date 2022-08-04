local entity_id = GetUpdatedEntityID()
local proj_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "ProjectileComponent" )
local last_frame = ComponentGetValue2( proj_comp, "mLastFrameDamaged" )
if last_frame ~= -1024 then
	return
end

local whom = ComponentGetValue2( proj_comp, "mWhoShot" )
local dmc_id = EntityGetFirstComponentIncludingDisabled( whom, "DamageModelComponent" )
local vsc_id = EntityGetFirstComponentIncludingDisabled( whom, "VariableStorageComponent" )
local count = ComponentGetValue2( vsc_id, "value_int" ) 
count = count + 1
ComponentSetValue2( vsc_id, "value_int", count )

if count < 251 then
	local dm_types = { "curse", "drill", "electricity", "explosion", "fire", "ice", "melee", "physics_hit", "poison", "projectile", "radioactive", "slice" }
	for i, kind in ipairs(dm_types) do
		local v = ComponentObjectGetValue2( dmc_id, "damage_multipliers", kind )
		v = v * 0.996
		ComponentObjectSetValue2( dmc_id, "damage_multipliers", kind, v )
	end 
end