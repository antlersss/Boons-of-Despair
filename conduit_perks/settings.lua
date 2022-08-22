dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.

function mod_setting_bool_custom( mod_id, gui, in_main_menu, im_id, setting )
	local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
	local text = setting.ui_name .. " - " .. GameTextGet( value and "$option_on" or "$option_off" )

	if GuiButton( gui, im_id, mod_setting_group_x_offset, 0, text ) then
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), not value, false )
	end

	mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
end

function mod_setting_change_callback( mod_id, gui, in_main_menu, setting, old_value, new_value  )
	print( tostring(new_value) )
end

local mod_id = "conduit_perks"
mod_settings_version = 1 
mod_settings = 
{
	{
		category_id = "group_of_settings",
		ui_name = "Starting Disparity",
		settings = {
			{
				id = "disparity_bool",
				ui_name = "Start with Disparity",
				ui_description = "",
				value_default = false,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
			},
			{
				id = "disp_random_bool",
				ui_name = "Random Disparity",
				ui_description = "Will randomly select a disparity to start with. (Overrides Select Disparity)",
				value_default = false,
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				id = "disp_select",
				ui_name = "Select Disparity",
				ui_description = "Will randomly select a disparity to start with.",
				value_default = "AGORA",
				values = {
					{"AGORA","Agoraphobia"},
					{"BITCH_SLAP","Bitch Slap"},
					{"BLESSING_OF_SIGHT","Blessing Of Sight"},
					{"CERAMIC_ARMOR","Ceramic Armor"},
					{"CHUNKED","Chunked"},
					{"DEADEYE","Deadeye"},
					{"DECK_OF_CARDS","Deck of Cards"},
					{"GOLD_EGO","Golden Ego"},
					{"IRON_BALLS","Iron Balls"},
					{"IRON_COAT","Iron Coating"},
					{"LAVA_BLOOD","Lava Blood"},
					{"MEGALOMANIAC","Megalomaniac"},
					{"NOCLIP","Noclip"},
					{"PAPER_WIND","Paper Wind"},
					{"RABIES","Rabies"},
					{"ROCKY_START","Rocky Start"},
					{"REVENGE_NUKE","Revenge Nuke"},
					{"RISKY_BUSINESS","Risky Business"},
					{"SANDBOX", "Sandbox"},
					{"SNS_BOOST","SNS Booster"},
					{"SOUL_STEAL","Soul Stealer"},
					{"SPOILED_VITALITY","Spoiled Vitality"},
					{"STAR_CHILD", "Star Child"},
					{"TOIMARI","Toimari"},
				},
				scope = MOD_SETTING_SCOPE_RUNTIME, 
				ui_fn=function( mod_id, gui, in_main_menu, im_id, setting )
					local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
					if type(value) ~= "string" then value = setting.value_default or "" end
					local value_id = 1
					for i,val in ipairs(setting.values) do
						if val[1] == value then
							value_id = i
							break
						end
					end
					local text = setting.ui_name .. ": " .. setting.values[value_id][2]
					local clicked,right_clicked = GuiButton( gui, im_id, mod_setting_group_x_offset, 0, text )
					if clicked then
						local value_old = value
						value_id = value_id + 1
						if value_id > #(setting.values) then
							value_id = 1
						end
						value = setting.values[value_id][1]
						ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), value, false  )
						mod_setting_handle_change_callback( mod_id, gui, in_main_menu, setting, value_old, value )
					end
					if right_clicked and setting.value_default then
						local value_old = value
						value_id = value_id - 1
						if value_id < 1 then
							value_id = #(setting.values)
						end
						value = setting.values[value_id][1]
						ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), value, false  )
						mod_setting_handle_change_callback( mod_id, gui, in_main_menu, setting, value_old, value )
					end
					mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
				end,
			},
		}
	}
}
function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id )
	mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end
