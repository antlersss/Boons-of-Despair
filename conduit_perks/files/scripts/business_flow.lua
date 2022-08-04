
function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	local eid = GetUpdatedEntityID()
	local root = EntityGetRootEntity( eid )
	if EntityGetName( root ) ~= "" and damage > 0 then
		local wallet_comp = EntityGetFirstComponentIncludingDisabled( entity_thats_responsible, "WalletComponent" )
		local current = ComponentGetValue2( wallet_comp, "money" )
		ComponentSetValue2( wallet_comp, "money", current + 7 )
	end
	EntityKill( eid )
	return damage, critical_hit_chance
end