function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	if EntityHasTag( entity_thats_responsible, "DISP_STAR_ENT") then
		local children = EntityGetAllChildren(GetUpdatedEntityID())
		local found = false
		if children ~= nil then
			for i, child in ipairs(children) do
				if EntityGetName == "DISP_STAR_CHECKER" then
					found = true
					break
				end
			end
		end
		if not found then
			local x, y = EntityGetTransform(GetUpdatedEntityID())
			EntityLoad("mods/conduit_perks/files/entities/star_child.xml", x, y)
		end
		local vscid = EntityGetFirstComponentIncludingDisabled( entity_thats_responsible, "VariableStorageComponent" )
		local value = ComponentGetValue2(vscid, "value_int")
		ComponentSetValue2( vscid, "value_int", value + 15 + Random(0,5))
		local player = EntityGetWithTag( "player_unit" )[1]
		if player == nil then return end
		local wallet = EntityGetFirstComponentIncludingDisabled( player, "WalletComponent" )
		local current = ComponentGetValue2( wallet, "money" )
		local extra = GameGetGameEffectCount( player, "EXTRA_MONEY" )
		extra = 2 ^ (extra + GameGetGameEffectCount( player, "EXTRA_MONEY_TRICK_KILL" ))
		ComponentSetValue2( wallet, "money", 50 * extra + current)
		local x, y = EntityGetTransform(player)
	end
end