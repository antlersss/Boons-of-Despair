local eid = GetUpdatedEntityID()
local x, y = EntityGetTransform(eid)
local root = EntityGetRootEntity(eid)
if not EntityHasTag(root, "energy_shield") and not EntityHasTag(root, "statue_hand") then
	EntityLoad( "mods/conduit_perks/files/entities/star_child.xml", x, y )
end