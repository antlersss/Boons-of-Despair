
if GameHasFlagRun("DISPARITY_PICKED_BITCH_SLAP") then
	local entity_id = GetUpdatedEntityID()
	local gec_id = EntityGetFirstComponentIncludingDisabled( entity_id, "GameEffectComponent" )
	local spec_id = EntityGetFirstComponentIncludingDisabled( entity_id, "SpriteParticleEmitterComponent" )
	ComponentSetValue2( gec_id, "effect", "CUSTOM" )
	EntityRemoveComponent( entity_id, spec_id )
end