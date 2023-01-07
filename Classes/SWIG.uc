class SWIG extends tk_Weapon
    config(TKWeaponsClient);

var ShockProjectile ComboTarget;	// used by AI
var bool			bRegisterTarget;
var	bool			bWaitForCombo;
var vector			ComboStart;
var color			EffectColor;

simulated function PostBeginPlay()
{
	ConstantColor'UT2004Weapons.ShockControl'.Color = EffectColor;
	Super.PostBeginPlay();
}

simulated event RenderOverlays( Canvas Canvas )
{
	local float A;

	A = 128 * (1.0 - FMax(0,FMax((FireMode[0].NextFireTime - Level.TimeSeconds)/FireMode[0].FireRate,
								(FireMode[1].NextFireTime - Level.TimeSeconds)/FireMode[1].FireRate)));
	ConstantColor'UT2004Weapons.ShockControl'.color.A = A;
	Super.RenderOverlays(Canvas);
}

simulated function vector GetEffectStart()
{
	local Coords C;

    if ( Instigator.IsFirstPerson() )
    {
		if ( WeaponCentered() )
			return CenteredEffectStart();
	    C = GetBoneCoords('tip');
		return C.Origin - 15 * C.XAxis;
	}
	return Super.GetEffectStart();
}

simulated function bool WeaponCentered()
{
	return ( bSpectated || (Hand > 1) );
}

// AI Interface
function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	if ( bWaitForCombo )
		return 1.5;
	if ( !B.ProficientWithWeapon() )
		return AIRating;
	if ( B.Stopped() )
	{
		if ( !B.EnemyVisible() && (VSize(B.Enemy.Location - Instigator.Location) < 5000) )
			return (AIRating + 0.5);
		return (AIRating + 0.3);
	}
	else if ( VSize(B.Enemy.Location - Instigator.Location) > 1600 )
		return (AIRating + 0.1);
	else if ( B.Enemy.Location.Z > B.Location.Z + 200 )
		return (AIRating + 0.15);

	return AIRating;
}

function float RangedAttackTime()
{
	local bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

	return FMin(2,0.3 + VSize(B.Enemy.Location - Instigator.Location)/class'ShockProjectile'.default.Speed);
}

function float SuggestAttackStyle()
{
	return -0.4;
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
	local bot B;

	bWaitForCombo = false;
	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

	if (B.IsShootingObjective())
		return 0;

	if ( FRand() < 0.7 )
		return 0;
	return 1;
}
// end AI Interface

defaultproperties
{
     EffectColor=(B=255,R=192,A=128)
     FireModeClass(0)=Class'tk_SWXWeapons.SWIGFire'
     FireModeClass(1)=Class'tk_SWXWeapons.SWIGAltFire'
     SelectAnim="Pickup"
     PutDownAnim="PutDown"
     SelectSound=Sound'WeaponSounds.ShockRifle.SwitchToShockRifle'
     SelectForce="SwitchToShockRifle"
     AIRating=0.630000
     CurrentRating=0.630000
     OldMesh=SkeletalMesh'Weapons.ShockRifle_1st'
     OldPickup="WeaponStaticMesh.ShockRiflePickup"
     OldCenteredOffsetY=-8.000000
     OldPlayerViewOffset=(X=-15.000000,Z=-5.000000)
     OldSmallViewOffset=(X=-8.000000,Y=4.000000,Z=-8.000000)
     OldPlayerViewPivot=(Pitch=1000,Yaw=-800,Roll=-500)
     OldCenteredYaw=-500
     Description="The Super Weapons Ice Gun. Shoots ice spikes that can slow down a target. Also shoots huge ice chunks for big damage."
     EffectOffset=(X=65.000000,Y=14.000000,Z=-10.000000)
     DisplayFOV=70.000000
     Priority=5
     HudColor=(B=255,G=0,R=128)
     SmallViewOffset=(X=11.000000,Y=11.500000,Z=-4.000000)
     CenteredOffsetY=1.000000
     CenteredRoll=1000
     CenteredYaw=-1000
     CustomCrosshair=8
     CustomCrossHairColor=(G=0)
     CustomCrossHairScale=1.333000
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross2"
     InventoryGroup=4
     PickupClass=Class'tk_SWXWeapons.SWIGPickup'
     PlayerViewOffset=(X=4.000000,Y=8.000000,Z=-2.000000)
     PlayerViewPivot=(Pitch=-1000)
     BobDamping=1.800000
     AttachmentClass=Class'XWeapons.ShockAttachment'
     IconMaterial=Texture'HUDContent.Generic.HUD'
     IconCoords=(X1=250,Y1=110,X2=330,Y2=145)
     ItemName="Super Weapons Ice Gun"
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=200
     LightSaturation=70
     LightBrightness=255.000000
     LightRadius=4.000000
     LightPeriod=3
     Mesh=SkeletalMesh'NewWeapons2004.ShockRifle'
     DrawScale=0.700000
     Skins(0)=Texture'tk_SWXWeapons.SWIG.IceGunTex0'
     Skins(1)=FinalBlend'tk_SWXWeapons.SWIG.IceProjTexFinal'
     HighDetailOverlay=Combiner'UT2004Weapons.WeaponSpecMap2'
}
