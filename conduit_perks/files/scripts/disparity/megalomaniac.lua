local projectiles = EntityGetWithTag("projectile")
local eid = GetUpdatedEntityID()
for i, pid in ipairs(projectiles) do
	if EntityHasTag(pid, "DISP_MEGALOMANIAC_PIERCE") then return end
	EntityAddTag(pid, "DISP_MEGALOMANIAC_PIERCE")
	local projectile_components = EntityGetComponent( pid, "ProjectileComponent" )
	local who = ComponentGetValue2( projectile_components[1], "mWhoShot" )
	if who ~= eid then
		for i, pc_id in ipairs(projectile_components) do
			ComponentSetValue2( pc_id, "on_collision_die", false )
			ComponentSetValue2( pc_id, "friendly_fire", true )
			ComponentSetValue2( pc_id, "collide_with_shooter_frames", 1 )
		end
	end
end