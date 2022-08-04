local projectiles = EntityGetWithTag("projectile")
local eid = GetUpdatedEntityID()
for i, pid in ipairs(projectiles) do
	local pc_id = EntityGetFirstComponentIncludingDisabled( pid, "ProjectileComponent" )
	local who = ComponentGetValue2( pc_id, "mWhoShot" )
	if who ~= eid then
		local x, y = EntityGetTransform(pid)
		local loaded_ent = EntityLoad( "data/entities/misc/piercing_shot.xml", x, y )
		EntityAddChild( pid, loaded_ent )
	end
end