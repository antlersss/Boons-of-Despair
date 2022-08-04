dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")
dofile_once("data/scripts/perks/perk_utilities.lua")

local function add_damage_handler( entity_who_picked )
	if not GameHasFlagRun("DISP_DAMAGE_HANDLER") then
		GameAddFlagRun("DISP_DAMAGE_HANDLER")
		EntityAddComponent( entity_who_picked, "LuaComponent", 
		{ 
			_tags = "disp_component",
			script_damage_about_to_be_received = "mods/conduit_perks/files/scripts/disparity/damage_handler.lua",
			execute_every_n_frame = "-1",
		} )
	end
end

STACKABLE_YES = true
STACKABLE_NO = false

STACKABLE_MAX_AMOUNT = true --this is left for mod backwards compatibility

disparity_list =
{
	{
		id = "AGORA",
		ui_name = "Agoraphobia",
		ui_description = "$DISP_AGORA",
		perk_icon = "mods/conduit_perks/files/perk_gfx/agoraphobia.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/agoraphobia.png",
		stackable = STACKABLE_YES,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if not GameHasFlagRun( "DISPARITY_PICKED_AGORA" ) then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{ 
					_tags = "disp_component",
					script_shot = "mods/conduit_perks/files/scripts/disparity/agora.lua",
					script_source_file="mods/conduit_perks/files/scripts/disparity/agora_check.lua",
					execute_every_n_frame = "3",
				} )
				local x, y = EntityGetTransform( entity_who_picked )
				local visual_ent = EntityLoad( "mods/conduit_perks/files/entities/agora_visual.xml", x, y )
				EntityAddChild( entity_who_picked, visual_ent )
			end
		end,
	},
	{
		id = "CERAMIC_ARMOR",
		ui_name = "Ceramic Armor",
		ui_description = "$DISP_CERAMIC",
		perk_icon = "mods/conduit_perks/files/perk_gfx/ceramic_armor.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/ceramic_armor.png",
		stackable = STACKABLE_YES,
		func = function( entity_perk_item, entity_who_picked, item_name )
			add_damage_handler(entity_who_picked)
		end,
	},
	{
		id = "SNS_BOOST",
		ui_name = "SNS Boosters",
		ui_description = "$DISP_SNS_BOOST",
		perk_icon = "mods/conduit_perks/files/perk_gfx/sns_boosters.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/sns_boosters.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			add_damage_handler(entity_who_picked)
			local x, y = EntityGetTransform(entity_who_picked)
			local leid = EntityLoad( "mods/conduit_perks/files/entities/sns_ent.xml", x, y )
			EntityAddChild( entity_who_picked, leid )
		end,
	},
	{
		id = "NOCLIP",
		ui_name = "Noclip",
		ui_description = "$DISP_NOCLIP",
		perk_icon = "mods/conduit_perks/files/perk_gfx/noclip.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/noclip.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				_tags = "disp_component",
				script_source_file = "mods/conduit_perks/files/scripts/disparity/noclip.lua",
			} )
			EntityAddComponent( entity_who_picked, "VariableStorageComponent", 
			{ 
				_tags = "disp_component,noclip_storage",
				value_int="0"
			} )
		end,
	},
	{
		id = "MEGALOMANIAC",
		ui_name = "Megalomaniac",
		ui_description = "$DISP_MEGALOMANIAC",
		perk_icon = "mods/conduit_perks/files/perk_gfx/megalomaniac.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/megalomaniac.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			add_damage_handler( entity_who_picked )
			EntityAddComponent2( entity_who_picked, "LuaComponent",{
				_tags = "disp_component",
				script_source_file = "mods/conduit_perks/files/scripts/disparity/megalomaniac.lua",
			})
		end,
	},
	{
		id = "STAR_CHILD",
		ui_name = "Star Child",
		ui_description = "$DISP_STAR_CHILD",
		perk_icon = "mods/conduit_perks/files/perk_gfx/star_child.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/star_child.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent2( entity_who_picked, "LuaComponent",{
				_tags = "disp_component",
				script_shot = "mods/conduit_perks/files/scripts/disparity/star_child.lua",
			})
		end,
	},
	{
		id = "GOLD_EGO",
		ui_name = "Golden Ego",
		ui_description = "$DISP_GOLD_EGO",
		perk_icon = "mods/conduit_perks/files/perk_gfx/golden_ego.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/golden_ego.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "LuaComponent",{ 
				_tags = "disp_component",
				script_shot = "mods/conduit_perks/files/scripts/disparity/gold_ego.lua",
				execute_every_n_frame = "-1",
			} )
			add_damage_handler(entity_who_picked)
			local dmc_id = EntityGetFirstComponentIncludingDisabled(entity_who_picked, "DamageModelComponent")
			ComponentSetValue2(dmc_id, "max_hp", 0.04)
			ComponentSetValue2(dmc_id, "max_hp_cap", 0.04)
			ComponentSetValue2(dmc_id, "hp", 0.04)
			ComponentSetValue2(dmc_id, "ragdoll_filenames_file", "data/ragdolls/conduit_player_gold/filenames.txt")
			ComponentSetValue2( dmc_id, "ragdoll_material", "gold_b2")
			local sc_id = EntityGetFirstComponentIncludingDisabled(entity_who_picked, "SpriteComponent", "lukki_disable")
			ComponentSetValue2(sc_id, "image_file", "mods/conduit_perks/files/entities/player_gold.xml")
			EntityRefreshSprite(entity_who_picked,sc_id)
			local children = EntityGetAllChildren(entity_who_picked)
			local check_one = false
			local check_two = false
			for i, child in ipairs(children) do
				local name = EntityGetName(child)
				if name == "cape" then
					local vpc_id = EntityGetFirstComponentIncludingDisabled(child, "VerletPhysicsComponent")
					ComponentSetValue2(vpc_id, "cloth_color_edge", 0xff1c7cb8 )
					ComponentSetValue2(vpc_id, "cloth_color", 0xff64c4e0 )
					check_one = true
				elseif name == "arm_r" then
					local arm_sc_id = EntityGetFirstComponentIncludingDisabled(child, "SpriteComponent")
					ComponentSetValue2(arm_sc_id, "image_file", "mods/conduit_perks/files/entities/player_arm_gold.xml")
					check_two = true
					EntityRefreshSprite(child,arm_sc_id)
				end
				if check_one and check_two then break end
			end
			local x, y = EntityGetTransform(entity_who_picked)
			local leid = EntityLoad("data/entities/particles/poof_blue.xml", x, y )
			local pec_id = EntityGetFirstComponentIncludingDisabled(leid, "ParticleEmitterComponent")
			ComponentSetValue2(pec_id, "emitted_material_name", "gold")
		end,
	},
	{
		id = "CHUNKED",
		ui_name = "Chunked",
		ui_description = "$DISP_CHUNKED",
		perk_icon = "mods/conduit_perks/files/perk_gfx/chunked.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/chunked.png",
		stackable = STACKABLE_YES,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if not GameHasFlagRun( "DISPARITY_PICKED_CHUNKED" ) then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{ 
					_tags = "disp_component",
					script_shot = "mods/conduit_perks/files/scripts/disparity/chunked.lua",
					execute_every_n_frame = "-1",
					script_wand_fired = "mods/conduit_perks/files/scripts/disparity/chunked.lua",
				} )
			end
		end,
	},
	{
		id = "LAVA_BLOOD",
		ui_name = "Lava Blood",
		ui_description = "$DISP_LAVA_BLOOD",
		perk_icon = "mods/conduit_perks/files/perk_gfx/lava_blood.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/lava_blood.png",
		game_effect = "PROTECTION_FIRE",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntitySetDamageFromMaterial( entity_who_picked, "lava", 0 )
			EntitySetDamageFromMaterial( entity_who_picked, "water", 0.001 )
			EntitySetDamageFromMaterial( entity_who_picked, "water_ice", 0.0015 )
			EntitySetDamageFromMaterial( entity_who_picked, "mud", 0.0005 )
			EntitySetDamageFromMaterial( entity_who_picked, "swamp", 0.0008 )
			EntitySetDamageFromMaterial( entity_who_picked, "water_swamp", 0.0009 )
			EntitySetDamageFromMaterial( entity_who_picked, "water_salt", 0.00125 )
			EntitySetDamageFromMaterial( entity_who_picked, "snow", 0.0009 )
			local dmc_id = EntityGetFirstComponentIncludingDisabled( entity_who_picked, "DamageModelComponent" )
			ComponentSetValue2( dmc_id, "blood_spray_material", "lava" )
			ComponentSetValue2( dmc_id, "blood_material", "lava" )
			ComponentSetValue2( dmc_id, "wet_status_effect_damage", 0.075 )
		end,
	},
	{
		id = "IRON_BALLS",
		ui_name = "Iron Balls",
		ui_description = "$DISP_IRON_BALLS",
		perk_icon = "mods/conduit_perks/files/perk_gfx/iron_balls.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/iron_balls.png",
		stackable = STACKABLE_YES,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local cpc_id = EntityGetFirstComponentIncludingDisabled( entity_who_picked, "CharacterPlatformingComponent" )
			local sped = ComponentGetValue2( cpc_id, "accel_x" )
			ComponentSetValue2( cpc_id, "accel_x", sped * 0.9 )
			local fly_sped = ComponentGetValue2( cpc_id, "pixel_gravity" )
			ComponentSetValue2( cpc_id, "pixel_gravity", math.max(fly_sped * 1.1, 450 ))
			add_damage_handler(entity_who_picked)
		end,
	},
	{
		id = "BLESSING_OF_SIGHT",
		ui_name = "Blessing of Sight",
		ui_description = "$DISP_BLESSING_OF_SIGHT",
		perk_icon = "mods/conduit_perks/files/perk_gfx/blessing_of_sight.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/blessing_of_sight.png",
		stackable = STACKABLE_YES,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if not GameHasFlagRun("DISPARITY_PICKED_BLESSING_OF_SIGHT") then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{ 
					_tags = "disp_component",
					script_shot = "mods/conduit_perks/files/scripts/disparity/blessing.lua",
					execute_every_n_frame = "-1",
				} )
			end
		end,
	},
	{
		id = "IRON_COAT",
		ui_name = "Iron Coating",
		ui_description = "$DISP_IRON_COAT",
		perk_icon = "mods/conduit_perks/files/perk_gfx/iron_coating.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/iron_coating.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntitySetDamageFromMaterial( entity_who_picked, "magic_liquid_mana_regeneration", 0.0015 )
			local dmc_id = EntityGetFirstComponentIncludingDisabled( entity_who_picked, "DamageModelComponent" )
			local elec_res = ComponentObjectGetValue2( dmc_id, "damage_multipliers", "electricity" )
			local proj_res = ComponentObjectGetValue2( dmc_id, "damage_multipliers", "projectile" )
			ComponentObjectSetValue2( dmc_id, "damage_multipliers", "projectile", proj_res * 0.5 )
			ComponentObjectSetValue2( dmc_id, "damage_multipliers", "slice", 0 )
			ComponentObjectSetValue2( dmc_id, "damage_multipliers", "electricity", proj_res * 2 )
		end,
	},
	{
		id = "SOUL_STEAL",
		ui_name = "Soul Stealer",
		ui_description = "$DISP_SOUL_STEAL",
		perk_icon = "mods/conduit_perks/files/perk_gfx/soul_eater.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/soul_eater.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local dmc_id = EntityGetFirstComponentIncludingDisabled( entity_who_picked, "DamageModelComponent" )
			local hp = ComponentGetValue2( dmc_id, "max_hp" )
			ComponentSetValue2( dmc_id, "hp", hp * 0.33 )
			ComponentSetValue2( dmc_id, "max_hp", hp * 0.33 )
			EntityAddComponent2( entity_who_picked, "LuaComponent", {
				_tags = "disp_component",
				script_shot="mods/conduit_perks/files/scripts/disparity/soul_steal.lua",
				execute_every_n_frame = -1,
			})
		end,
	},
	{
		id = "REVENGE_NUKE",
		ui_name = "Revenge Nuke",
		ui_description = "$DISP_NUKE",
		perk_icon = "mods/conduit_perks/files/perk_gfx/revenge_nuke.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/revenge_nuke.png",
		game_effect = "PROTECTION_EXPLOSION",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "LuaComponent", {
				_tags = "disp_component",
				script_damage_received = "mods/conduit_perks/files/scripts/disparity/nuke.lua",
				execute_every_n_frame = "-1",
			} )
		end,
	},
	{
		id = "RABIES",
		ui_name = "Rabis",
		ui_description = "$DISP_RABIES",
		perk_icon = "mods/conduit_perks/files/perk_gfx/rabies.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/rabies.png",
		game_effect = "BERSERK",
		particle_effect = "critical_hit_boost",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddTag( entity_who_picked, "HAS_DISP_RABIES" )
		end,
	},
	{
		id = "DEADEYE",
		ui_name = "Deadeye",
		ui_description = "$DISP_DEADEYE",
		perk_icon = "mods/conduit_perks/files/perk_gfx/deadeye.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/deadeye.png",
		stackable = STACKABLE_YES,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if not GameHasFlagRun( "DISPARITY_PICKED_DEADEYE" ) then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{ 
					_tags = "disp_component",
					script_shot = "mods/conduit_perks/files/scripts/disparity/deadeye.lua",
					execute_every_n_frame = "-1",
				} )
			end
		end,
	},
	{
		id = "SPOILED_VITALITY",
		ui_name = "Spoiled Vitality",
		ui_description = "$DISP_SPOILED_VITALITY",
		perk_icon = "mods/conduit_perks/files/perk_gfx/spoiled_vit.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/spoiled_vit.png",
		stackable = STACKABLE_YES,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if not GameHasFlagRun( "DISPARITY_PICKED_SPOILED_VITALITY" ) then
				local msc_id = EntityGetFirstComponentIncludingDisabled( entity_who_picked, "MaterialSuckerComponent" )
				ComponentSetValue2( msc_id, "suck_health", false )
				EntityAddTag( entity_who_picked, "HAS_DISP_SPOILED_VITALITY" )
				local dmc_id = EntityGetFirstComponentIncludingDisabled( entity_who_picked, "DamageModelComponent" )
				--ComponentObjectSetValue2( dmc_id, "damage_multipliers", "healing", 0 )
				local max_hp = ComponentGetValue2( dmc_id, "max_hp" )
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{ 
					_tags = "disp_component",
					script_source_file = "mods/conduit_perks/files/scripts/disparity/spoiled_vit.lua",
					script_damage_about_to_be_received = "mods/conduit_perks/files/scripts/disparity/spoiled_vit.lua",
					execute_every_n_frame = "60",
				} )
				EntityAddComponent( entity_who_picked, "VariableStorageComponent", 
				{ 
					_tags = "disp_component,spoiled_vit_storage",
					value_float = max_hp
				} )
			end
			add_halo_level( entity_who_picked, 1 )
		end,
	},
	{
		id = "RISKY_BUSINESS",
		ui_name = "Risky Business",
		ui_description = "$DISP_RISKY_BUSINESS",
		perk_icon = "mods/conduit_perks/files/perk_gfx/risky_business.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/risky_business.png",
		stackable = STACKABLE_YES,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if not GameHasFlagRun( "DISPARITY_PICKED_RISKY_BUSINESS" ) then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{ 
					_tags = "disp_component",
					script_shot = "mods/conduit_perks/files/scripts/disparity/risky_business.lua",
					script_damage_received = "mods/conduit_perks/files/scripts/disparity/risky_business.lua",
					execute_every_n_frame = "-1",
				} )
			end
		end,
	},
	{
		id = "DECK_OF_CARDS",
		ui_name = "Deck of Cards",
		ui_description = "$DISP_DECK",
		perk_icon = "mods/conduit_perks/files/perk_gfx/deck_of_cards.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/deck_of_cards.png",
		stackable = STACKABLE_NO,
	},
	{
		id = "ROCKY_START",
		ui_name = "Rocky Start",
		ui_description = "$DISP_ROCK_START",
		perk_icon = "mods/conduit_perks/files/perk_gfx/rocky_start.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/rocky_start.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x, y = EntityGetTransform( entity_who_picked )
			local eid = EntityLoad( "mods/conduit_perks/files/entities/rocky_start.xml", x, y )
			EntityAddChild( entity_who_picked, eid )
		end,
	},
	{
		id = "PAPER_WIND",
		ui_name = "Paper Wind",
		ui_description = "$DISP_PAPER_WIND",
		perk_icon = "mods/conduit_perks/files/perk_gfx/paper_wind.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/paper_wind.png",
		game_effect = "MOVEMENT_FASTER",
		stackable = STACKABLE_YES,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local cpc_id = EntityGetFirstComponentIncludingDisabled( entity_who_picked, "CharacterPlatformingComponent" )
			local fly_sped = ComponentGetValue2( cpc_id, "pixel_gravity" )
			ComponentSetValue2( cpc_id, "pixel_gravity", math.max(fly_sped * 0.9, 225 ))
			if not GameHasFlagRun( "DISPARITY_PICKED_PAPER_WIND" ) then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{ 
					_tags = "disp_component",
					script_damage_about_to_be_received = "mods/conduit_perks/files/scripts/disparity/paper_wind.lua",
					execute_every_n_frame = "-1",
				} )
			end
		end,
	},
	{
		id = "BITCH_SLAP",
		ui_name = "Bitch Slap",
		ui_description = "$DISP_BITCH_SLAP",
		perk_icon = "mods/conduit_perks/files/perk_gfx/bitch_slap.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/bitch_slap.png",
		stackable = STACKABLE_YES,
		func = function( entity_perk_item, entity_who_picked, item_name )
			if not GameHasFlagRun( "DISPARITY_PICKED_BITCH_SLAP" ) then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{ 
					_tags = "disp_component",
					script_shot = "mods/conduit_perks/files/scripts/disparity/bitch_slap.lua",
					execute_every_n_frame = "-1",
				} )
			end
		end,
	},
	{
		id = "TOIMARI",
		ui_name = "Toimari",
		ui_description = "$animal_scavenger_leader",
		perk_icon = "mods/conduit_perks/files/perk_gfx/cheif.png",
		ui_icon = "mods/conduit_perks/files/ui_gfx/cheif.png",
		game_effect = "ALLERGY_RADIOACTIVE",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local dmc = EntityGetFirstComponentIncludingDisabled( entity_who_picked, "DamageModelComponent" )
			ComponentSetValue( dmc, "max_hp", 11 )
			ComponentSetValue( dmc, "max_hp_cap", 12 )
			ComponentSetValue( dmc, "hp", 11 )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				_tags = "disp_component",
				script_damage_received = "mods/conduit_perks/files/scripts/disparity/toimari.lua",
				execute_every_n_frame = "-1",
			} )
			local children = EntityGetAllChildren(entity_who_picked)
			local toimari_ent = 0
			for i, child in ipairs(children) do
				if EntityGetName(child) == "toimari_head_ent" then
					toimari_ent = child
					break
				end
			end
			EntitySetComponentsWithTagEnabled( toimari_ent, "toimari_head", true )
		end,
	},
}


function get_perk_with_id( perk_list, perk_id )
	local perk_data = nil
	for i,perk in ipairs(perk_list) do
		if perk.id == perk_id then
			perk_data = perk
			break
		end
	end

	return perk_data
end

function get_perk_picked_flag_name( perk_id )
	return "DISPARITY_PICKED_" .. perk_id
end
