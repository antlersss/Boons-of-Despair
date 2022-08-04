
function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance ) 
	local effect_id = GetUpdatedEntityID()
	local gec_id = EntityGetFirstComponentIncludingDisabled( effect_id, "GameEffectComponent" )
	local caster_id = ComponentGetValue2( gec_id, "mCaster" )
	local casters_dmc = EntityGetFirstComponentIncludingDisabled( caster_id, "DamageModelComponent" )
	local caster_max = ComponentGetValue2( casters_dmc, "max_hp" )
	local caster_current = ComponentGetValue2( casters_dmc, "hp" )
	local root_ent = EntityGetRootEntity( effect_id )
	local root_dmc = EntityGetFirstComponentIncludingDisabled( root_ent, "DamageModelComponent" )
	local root_hp = ComponentGetValue2( root_dmc, "hp" )
	local heal_amount = 0
	if root_hp < damage then
		heal_amount = root_hp
	else
		heal_amount = damage
	end
	heal_amount = math.min( heal_amount + caster_current, caster_max )
	ComponentSetValue2( casters_dmc, "hp", heal_amount )
	EntityKill( effect_id )
	return damage, critical_hit_chance
end