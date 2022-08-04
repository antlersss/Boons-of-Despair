ModLuaFileAppend( "data/scripts/gun/procedural/gun_procedural.lua", "mods/conduit_perks/files/gp_appends.lua" )
ModLuaFileAppend( "data/scripts/biomes/temple_altar.lua", "mods/conduit_perks/files/temple_appends.lua" )
ModLuaFileAppend( "data/scripts/biomes/boss_arena.lua", "mods/conduit_perks/files/temple_appends.lua" )
ModLuaFileAppend( "data/scripts/items/heart_fullhp_temple.lua", "mods/conduit_perks/files/heart_appends.lua" )
ModLuaFileAppend( "data/scripts/perks/perk_reroll.lua", "mods/conduit_perks/files/reroll_appends.lua" )

local content = ModTextFileGetContent("data/translations/common.csv")
ModTextFileSetContent("data/translations/common.csv", content .. [[
DISP_AGORA,"Spells range from 125% to 75% as powerful dependent on how many enemies are nearby",,,,,,,,,,,,,
DISP_DECK,"Most wands have greatly increased stats, but become shuffle",,,,,,,,,,,,,
DISP_CHUNKED,"Your spells are twice as powerful and can pierce, but wands can't handle this power for long",,,,,,,,,,,,,
DISP_DEADEYE,"Your spells have increased damage, but missing deals damage to you",,,,,,,,,,,,,
DISP_LAVA_BLOOD,"You are immune to fire and lava, but take damage from water",,,,,,,,,,,,,
DISP_NOCLIP,"You move through walls, but take an exponetial damage while doing so",,,,,,,,,,,,,
DISP_ROCK_START,"You gain the power of the 4 Elemental Stones",,,,,,,,,,,,,
DISP_NUKE,"You know what this does. At least you’ll have explosion immunity",,,,,,,,,,,,,
DISP_IRON_COAT,"You feel more... robotic",,,,,,,,,,,,,
DISP_IRON_BALLS,"You take 50% less damage from YOUR OWN spells, but it weighs you down",,,,,,,,,,,,,
DISP_SPOILED_VITALITY,"Gain 1% of your max hp per second, but healing effects instead applies haste",,,,,,,,,,,,,
DISP_RISKY_BUSINESS,"Gain 2 gold on hitting something, but lose a percent of it concurrent to health lost",,,,,,,,,,,,,
DISP_RABIES,"Water is toxic to you, but your inner rage is insatiable",,,,,,,,,,,,,
DISP_PAPER_WIND,"You move faster, but take 1.5x more damage",,,,,,,,,,,,,
DISP_BITCH_SLAP,"Periodically charm foes on hit, you heartless bastard",,,,,,,,,,,,,
DISP_SOUL_STEAL,"Steal hp from foes. -67% hp",,,,,,,,,,,,,
DISP_BLESSING_OF_SIGHT,"After killing an enemy you gain temporary ASE followed by blindness",,,,,,,,,,,,,
DISP_GOLD_EGO,"Kill everything in 1 hit, but you'll die in 1 hit",,,,,,,,,,,,,
DISP_MEGALOMANIAC,"Enemy attacks deal 1 damage, but gain piercing",,,,,,,,,,,,,
DISP_SNS_BOOST,"Damage is stored and dealt per second",,,,,,,,,,,,,
DISP_CERAMIC,"5 flat reduction, but overall 1.2x damage received",,,,,,,,,,,,,
DISP_STAR_CHILD,"Enemies drop small stars on death",,,,,,,,,,,,,
DAMAGE_STAR_CHILD,"Valo Lapsi",,,,,,,,,,,,,
]])

local nxml = dofile_once("mods/conduit_perks/lib/nxml.lua")
local content = ModTextFileGetContent("data/entities/player_base.xml")
local xml = nxml.parse(content)
xml:add_child(nxml.parse([[
	<Entity name="toimari_head_ent">
	
	<SpriteComponent
		_tags="toimari_head"
		image_file="mods/conduit_perks/files/entities/toimari_head.png"
		next_rect_animation=""
		offset_x="5"
		offset_y="6"
		rect_animation="walk"
		z_index="0.59"
		_enabled="0"
	></SpriteComponent>
	
	<InheritTransformComponent
		parent_hotspot_tag="cape_root"
	>/<InheritTransformComponent>
	
	</Entity>
]]))
ModTextFileSetContent("data/entities/player_base.xml", tostring(xml))

content = ModTextFileGetContent("data/entities/misc/effect_regeneration.xml")
xml= nxml.parse(content)
xml:add_child(nxml.parse([[
	<LuaComponent
		remove_after_executed="1"
		script_source_file="mods/conduit_perks/files/scripts/spoiled_vit_check.lua"
	></LuaComponent>
]]))
ModTextFileSetContent("data/entities/misc/effect_regeneration.xml", tostring(xml))

content = ModTextFileGetContent("data/entities/misc/effect_wet.xml")
xml= nxml.parse(content)
xml:add_child(nxml.parse([[
	<LuaComponent
		remove_after_executed="1"
		script_source_file="mods/conduit_perks/files/scripts/rabies_check.lua"
	></LuaComponent>
]]))
ModTextFileSetContent("data/entities/misc/effect_wet.xml", tostring(xml))

content = ModTextFileGetContent("data/entities/misc/effect_charm.xml")
xml= nxml.parse(content)
xml:add_child(nxml.parse([[
	<LuaComponent
		remove_after_executed="1"
		script_source_file="mods/conduit_perks/files/scripts/bitch_check.lua"
	></LuaComponent>
]]))
ModTextFileSetContent("data/entities/misc/effect_charm.xml", tostring(xml))

dofile_once("mods/conduit_perks/files/scripts/disparity/disparity.lua")
function OnPlayerSpawned( player )
	-- LIST OF DISPARITIES:  AGORA  NOCLIP  CHUNKED  LAVA_BLOOD  IRON_BALLS  IRON_COAT  DEADEYE  DECK_OF_CARDS  TOIMARI  ROCKY_START  REVENGE_NUKE  RISKY_BUSINESS  SPOILED_VITALITY  RABIES  PAPER_WIND  BITCH_SLAP
	if GameHasFlagRun("CONDUIT_DISPARITY_INIT") then return end
	if ModSettingGet( "conduit_perks.disparity_bool" ) then
		local x, y = EntityGetTransform( player )
		if ModSettingGet( "conduit_perks.disp_random_bool" ) then
			local rnd = Random( 1, #disparity_list )
			local identity = disparity_list[rnd].id
			disparity_spawn( x, y, identity )
		else
			local identity = ModSettingGet( "conduit_perks.disp_select" )
			disparity_spawn( x, y, identity )
		end
	end
	GameAddFlagRun( "CONDUIT_DISPARITY_INIT" )
end
