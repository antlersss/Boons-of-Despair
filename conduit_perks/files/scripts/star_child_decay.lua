local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local vsc_id = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
local current = ComponentGetValue2( vsc_id, "value_int" )
if current - 1 == 0 then
	EntityKill(entity_id)
	return
else
	ComponentSetValue2( vsc_id, "value_int", current - 1 )
end
current = current / 7.5
local radius = math.min(math.log( 2.5 + ((current / 40)-9)/9 ) * 4 - 1 , 5)
local closest_star = 0
local close_val = 0
local targets = EntityGetInRadiusWithTag( x, y, math.max(300/radius,16*radius), "DISP_STAR_ENT" )
for i, v in ipairs(targets) do
	if v ~= entity_id then
		local star_vsc = EntityGetFirstComponentIncludingDisabled( v, "VariableStorageComponent" )
		local check_me = ComponentGetValue2( star_vsc, "value_int" )
		local new_x, new_y = EntityGetTransform(v)
		local dist = math.sqrt( ( new_x - x ) ^ 2 + ( new_y - y ) ^ 2 )
		if close_val < dist then
			close_val = dist
			closest_star = v
		end
		if check_me < current * 7.5 and dist < 16*radius then
			EntityAddTag( entity_id, "DISP_BIG_STAR" )
			current = (check_me + (current * 7.5) + 50 + Random(25,75))
			ComponentSetValue2( vsc_id, "value_int", current )
			current = current/7.5
			radius = math.min(math.log( 2.5 + ((current / 40)-9)/9 ) * 4 - 1 , 5)
			EntityKill(v)
		else
			EntityRemoveTag( entity_id, "DISP_BIG_STAR" )
		end
	end
end
if closest_star ~= 0 then
	local cs_fhc_id = EntityGetFirstComponentIncludingDisabled( closest_star, "HomingComponent" )
	ComponentSetValue2( cs_fhc_id, "predefined_target", entity_id )
	ComponentSetValue2( cs_fhc_id, "detect_distance", radius * 150 )
	local ents_fhc_id = EntityGetFirstComponentIncludingDisabled( entity_id, "HomingComponent" )
	ComponentSetValue2( ents_fhc_id, "predefined_target", closest_star )
end
targets = EntityGetInRadiusWithTag( x, y, math.ceil(radius * 29) + 1, "homing_target" )
for i, v in ipairs(targets) do
	if not EntityHasTag( v, "DISP_STAR_CHILD_TARGET" ) and not EntityHasTag( v, "player_unit") then
		EntityAddTag( v, "DISP_STAR_CHILD_TARGET")
		EntityAddComponent2( v, "LuaComponent",{
			script_death="mods/conduit_perks/files/scripts/star_child_target_death.lua",
			execute_every_n_frame=-1,
		})
	end
end
targets = EntityGetInRadiusWithTag( x, y, 13, "pixel_sprite" )
for i, v in ipairs(targets) do
	EntityKill(v)
end

function rgba2uint(r, g, b, a)
  a = a or 1
  local r = bit.lshift(r * 255, 24)
  local g = bit.lshift(g * 255, 16)
  local b = bit.lshift(b * 255, 8)
  local a = a * 255
  return bit.bor( r, g, b, a )
end

local function hslToRgb(h, s, l)
  if s == 0 then return l, l, l end
  local function to(p, q, t)
      if t < 0 then t = t + 1 end
      if t > 1 then t = t - 1 end
      if t < .16667 then return p + (q - p) * 6 * t end
      if t < .5 then return q end
      if t < .66667 then return p + (q - p) * (.66667 - t) * 6 end
      return p
  end
  local q = l < .5 and l * (1 + s) or l + s - l * s
  local p = 2 * l - q
  return to(p, q, h + .33334), to(p, q, h), to(p, q, h - .33334)
end

local function get_color(h, s, l)
  local r, g, b = hslToRgb(h, s, l)
  return {r, g, b}
end

local rgb_list = get_color(current%80 / 80, 0.9, 0.55 )
local final_color = rgba2uint( 0.9, rgb_list[3], rgb_list[2], rgb_list[1] )
local particle_emitters = EntityGetComponentIncludingDisabled( entity_id, "ParticleEmitterComponent" )
for i, v in ipairs(particle_emitters) do
	ComponentSetValue2( v, "color", final_color )
end
local spec_id = EntityGetFirstComponentIncludingDisabled( entity_id, "SpriteParticleEmitterComponent" )
ComponentSetValue2( spec_id, "color", rgb_list[1], rgb_list[2], rgb_list[3], 0.9 )
ComponentSetValue2( spec_id, "scale", radius * 0.17, radius * 0.13)
local adc_id = EntityGetFirstComponentIncludingDisabled( entity_id, "AreaDamageComponent" )
ComponentSetValue2( adc_id, "damage_per_frame", 0.18 * radius)
ComponentSetValue2( adc_id, "entity_responsible", entity_id )
ComponentSetValue2( adc_id, "circle_radius", math.ceil(radius * 21) )
ComponentSetValue2( adc_id, "aabb_min", math.ceil(radius * -21), math.ceil(radius * -21))
ComponentSetValue2( adc_id, "aabb_max", math.ceil(radius * 21), math.ceil(radius * 21))
local magic_conversion_comps = EntityGetComponentIncludingDisabled( entity_id, "MagicConvertMaterialComponent" )
for i, v in ipairs(magic_conversion_comps) do
	if i == 1 and radius > 3.2 then
		ComponentSetValue2( v, "to_material", CellFactory_GetType("lava") )
		if radius > 4.8 then
			ComponentSetValue2( v, "convert_entities", true )
		else
			ComponentSetValue2( v, "convert_entities", false )
		end
	else
		ComponentSetValue2( v, "to_material", CellFactory_GetType("fire") )
		ComponentSetValue2( v, "convert_entities", false )
	end
	ComponentSetValue2( v, "radius", math.ceil(radius * 15 + 2) )
end

local music_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "MusicEnergyAffectorComponent" )
ComponentSetValue2( music_comp, "energy_target", 20 * radius )

local bh_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "BlackHoleComponent" )
if radius > 4 then
	EntitySetComponentIsEnabled( entity_id, bh_comp, true )
	ComponentSetValue2( bh_comp, "damage_probability", 10 * radius )
	ComponentSetValue2( bh_comp, "radius", math.ceil((radius - 0.25) * 26))
	ComponentSetValue2( bh_comp, "particle_attractor_force", radius/1.35)
	ComponentSetValue2( bh_comp, "damage_amount", (radius - 2.5) * 0.1 )
else
	EntitySetComponentIsEnabled( entity_id, bh_comp, false )
end

local did_hit, _, hit_y = RaytraceSurfacesAndLiquiform( x, y, x, y + math.ceil(radius * 19 ))
if did_hit then
	local vc_id = EntityGetFirstComponentIncludingDisabled( entity_id, "VelocityComponent" )
	local vx, vy = ComponentGetValue2( vc_id, "mVelocity" )
	local float_force = math.max(20 - (hit_y - y), 0) / 3 + 1
	vy = vy * 0.9 - ( 0.33 * float_force)
	vx = vx * (0.935 + ProceduralRandomf( x, y, 0, 0.08 )) + (ProceduralRandomf( x, y, -0.15, 0.15 ) * float_force)
	ComponentSetValue2( vc_id, "mVelocity", vx, vy )
end

EntitySetComponentsWithTagEnabled(entity_id, "fire", true)