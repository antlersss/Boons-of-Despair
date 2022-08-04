local eid = GetUpdatedEntityID()
local root = EntityGetRootEntity(eid)
local dmc_id = EntityGetFirstComponentIncludingDisabled( root, "DamageModelComponent" )
local max_hp = ComponentGetValue2( dmc_id, "max_hp" ) * 0.1
local vsc_id = EntityGetFirstComponentIncludingDisabled( eid, "VariableStorageComponent" )
local total = ComponentGetValue2( vsc_id, "value_float" )
local x, y = EntityGetTransform(root)
if total > 0.0 then
	EntityInflictDamage( root, math.min(total, max_hp), "DAMAGE_DROWNING", "SNS Boosters", "NONE", 0, 0, eid, x, y, 0 )
end