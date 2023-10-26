class SFCX extends tk_Weapon;

// AI Interface
function float GetAIRating()
{
	local Bot B;
	local float EnemyDist;
	local vector EnemyDir;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	if ( EnemyDist > 750 )
	{
		if ( EnemyDist > 2000 )
		{
			if ( EnemyDist > 3500 )
				return 0.2;
			return (AIRating - 0.3);
		}
		if ( EnemyDir.Z < -0.5 * EnemyDist )
			return (AIRating - 0.3);
	}
	else if ( (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon )
		return (AIRating + 0.35);
	else if ( EnemyDist < 400 )
		return (AIRating + 0.2);
	return FMax(AIRating + 0.2 - (EnemyDist - 400) * 0.0008, 0.2);
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
	local vector EnemyDir;
	local float EnemyDist;
	local bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	if ( EnemyDist > 750 )
	{
		if ( EnemyDir.Z < -0.5 * EnemyDist )
			return 1;
		return 0;
	}
	else if ( (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon )
		return 0;
	else if ( (EnemyDist < 400) || (EnemyDir.Z > 30) )
		return 0;
	else if ( FRand() < 0.65 )
		return 1;
	return 0;
}

function float SuggestAttackStyle()
{
	if ( (AIController(Instigator.Controller) != None)
		&& (AIController(Instigator.Controller).Skill < 3) )
		return 0.4;
    return 0.8;
}

function float SuggestDefenseStyle()
{
    return -0.4;
}
// End AI Interface

defaultproperties
{
     FireModeClass(0)=Class'mm_SWXWeapons.SFCXFire'
     FireModeClass(1)=Class'mm_SWXWeapons.SFCXAltFire'
     SelectAnim="Pickup"
     PutDownAnim="PutDown"
     SelectSound=Sound'WeaponSounds.FlakCannon.SwitchToFlakCannon'
     SelectForce="SwitchToFlakCannon"
     AIRating=0.750000
     CurrentRating=0.750000
     EffectOffset=(X=200.000000,Y=32.000000,Z=-25.000000)
     DisplayFOV=60.000000
     Priority=8
     HudColor=(G=128)
     InventoryGroup=7
     PickupClass=Class'mm_SWXWeapons.SFCXPickup'
     PlayerViewOffset=(X=-7.000000,Y=8.000000)
     PlayerViewPivot=(Yaw=16884,Roll=200)
     BobDamping=1.400000
     AttachmentClass=Class'mm_SWXWeapons.SFCXAttachement'
     IconMaterial=Texture'InterfaceContent.HUD.SkinA'
     IconCoords=(X1=322,Y1=100,X2=444,Y2=200)
     ItemName="Super Flak Cannon X"
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=150
     LightBrightness=150.000000
     LightRadius=4.000000
     Mesh=SkeletalMesh'Weapons.Flak_1st'
     Skins(0)=Texture'mm_SWXWeapons.SFCX.SFCXTex0'
     UV2Texture=Shader'XGameShaders.WeaponShaders.WeaponEnvShader'
}
