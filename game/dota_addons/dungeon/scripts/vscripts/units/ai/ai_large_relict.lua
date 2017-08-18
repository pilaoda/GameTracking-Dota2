
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hRelictProjectile = thisEntity:FindAbilityByName( "relict_projectile" )

	thisEntity.fSearchRadius = thisEntity:GetAcquisitionRange()

	thisEntity:SetContextThink( "LargeRelictThink", LargeRelictThink, 1 )
end

--------------------------------------------------------------------------------

function LargeRelictThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity.hRelictProjectile ~= nil and thisEntity.hRelictProjectile:IsChanneling() then
		return 0.5
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.fSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

	if #hEnemies == 0 then
		return 1
	end

	if thisEntity.hRelictProjectile ~= nil and thisEntity.hRelictProjectile:IsFullyCastable() then
		return CastRelictProjectile( hEnemies[ RandomInt( 1, #hEnemies ) ] )
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastRelictProjectile( enemy )
	if enemy == nil then
		return
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hRelictProjectile:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

