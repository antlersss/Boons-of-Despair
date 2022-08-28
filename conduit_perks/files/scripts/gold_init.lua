local eid = GetUpdatedEntityID()
local root = EntityGetRootEntity(eid)
local dmc = EntityGetFirstComponent( root, "DamageModelComponent" )
ComponentSetValue2( dmc, "ragdoll_material", "gold_b2" )
