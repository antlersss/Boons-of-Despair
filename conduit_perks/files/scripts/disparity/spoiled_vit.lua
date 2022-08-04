local entity_id = GetUpdatedEntityID()

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	local new_dam = damage
	if damage < 0.0 then
		new_dam = 0
		if GameGetGameEffectCount( entity_id, "MOVEMENT_FASTER" ) < 1 then	
			LoadGameEffectEntityTo( entity_id, "data/entities/misc/effect_movement_faster.xml")
		end
	end
	return new_dam, critical_hit_chance
end

local dmc_id = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )
local hp = ComponentGetValue2( dmc_id, "hp" )
local max_hp = ComponentGetValue2( dmc_id, "max_hp" )
local vsc_id = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent", "spoiled_vit_storage" )
local limit = ComponentGetValue2( vsc_id, "value_float" )
if hp < max_hp and limit > 0 then
	local count = GlobalsGetValue( "DISPARITY_PICKED_SPOILED_VITALITY_PICKUP_COUNT", "0" )
	local max_hp = ComponentGetValue2( dmc_id, "max_hp" )
	local mult = (0.0083 * max_hp) * count
	local hp = ComponentGetValue2( dmc_id, "hp" )
	local minimum = limit + hp
	if minimum > max_hp then
		minimum = max_hp
	end
	mult = math.min( mult + hp, minimum )
	ComponentSetValue2( dmc_id, "hp", mult )
	ComponentSetValue2( vsc_id, "value_float", limit - ( mult - hp ) )
end