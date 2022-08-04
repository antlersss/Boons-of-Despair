local eid = GetUpdatedEntityID()
local root = EntityGetRootEntity(eid)
EntityConvertToMaterial(root, "gold_b2")
EntityKill(root)