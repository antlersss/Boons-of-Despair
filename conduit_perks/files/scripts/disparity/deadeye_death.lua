local entity_id = GetUpdatedEntityID()
local proj_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "ProjectileComponent" )
local whom = ComponentGetValue2( proj_comp, "mWhoShot" )
local last_frame = ComponentGetValue2( proj_comp, "mLastFrameDamaged" )
if last_frame ~= -1024 then
	return
end
local mult = GlobalsGetValue( "DISPARITY_PICKED_DEADEYE_PICKUP_COUNT", 0 )
mult = mult/10
local dtypes = { "projectile", "melee", "ice", "slice", "electricity", "fire" }
local enums = { "DAMAGE_PROJECTILE", "DAMAGE_MELEE", "DAMAGE_ICE", "DAMAGE_SLICE", "DAMAGE_ELECTRICITY", "DAMAGE_FIRE" }
for i, kind in ipairs(dtypes) do
	local v = ComponentObjectGetValue2( proj_comp, "damage_by_type", kind )
	if kind == "projectile" then
		local damage = ComponentGetValue2( proj_comp, "damage")
		v = damage
	end
	v = v * mult
	EntityInflictDamage( whom, v, enums[i], "Deadeye's Curse", "NONE", 0, 0, whom )
end
