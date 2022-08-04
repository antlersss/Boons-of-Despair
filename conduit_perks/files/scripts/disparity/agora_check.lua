local eid = GetUpdatedEntityID()
local x, y = EntityGetTransform( eid )
local enemies = EntityGetInRadiusWithTag( x, y, 120, "enemy" )
local enemy_count = #enemies
enemy_count = math.min( enemy_count, 4 )
enemy_count = math.max( enemy_count, 1 )
local list_o_colors = { "spark_blue", "spark_green", "spark_yellow", "spark_red" }
local children = EntityGetAllChildren( eid )
for i, child in ipairs( children ) do
	if EntityGetName( child ) == "agora_visual"  then
		local pec_comps = EntityGetComponent( child, "ParticleEmitterComponent" )
		for i, comp in ipairs( pec_comps ) do
			ComponentSetValue2( comp, "emitted_material_name", list_o_colors[enemy_count] )
		end
	end
end