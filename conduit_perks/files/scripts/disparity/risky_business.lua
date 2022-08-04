
function shot( entity_id )
	EntityLoadToEntity( "mods/conduit_perks/files/entities/hitfx_business.xml", entity_id )
end

function damage_received( damage, desc, entity_who_caused, is_fatal )
	if not is_fatal then
		local player = GetUpdatedEntityID()
		local wallet_comp = EntityGetFirstComponentIncludingDisabled( player, "WalletComponent" )
		local dmc_id = EntityGetFirstComponentIncludingDisabled( player, "DamageModelComponent" )
		local maximum = ComponentGetValue2( dmc_id, "max_hp" )
		local percentage = (damage / maximum)
		local current = ComponentGetValue2( wallet_comp, "money" )
		local loss = math.max(math.floor(current * percentage), 0 ) 
		local spent = ComponentGetValue2( wallet_comp, "money_spent" )
		ComponentSetValue2( wallet_comp, "money_spent", spent + loss )
		ComponentSetValue2( wallet_comp, "money", current - loss )
	end
end