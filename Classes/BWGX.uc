class BWGX extends tk_Weapon;

#EXEC OBJ LOAD FILE="Resources/tk_SWXWeapons_rc.u" PACKAGE="tk_SWXWeapons"

var() int Links;
var() bool Linking;
var bool bBotLinkUp;
var(FirstPerson) float NewEffectOffset;
var	bool bWaitForCombo;

simulated function vector GetEffectStart()
{
    local Vector X,Y,Z;

	if ( Instigator.IsFirstPerson() && (Hand == 0) )
	{
        GetViewAxes(X, Y, Z);
        if ( class'PlayerController'.Default.bSmallWeapons || Level.bClassicView )
			return (Instigator.Location +
				Instigator.CalcDrawOffset(self) +
				SmallEffectOffset.X * X  +
				SmallEffectOffset.Y * Y * Hand -
				NewEffectOffset * Z);
        else
			return (Instigator.Location +
				Instigator.CalcDrawOffset(self) +
				EffectOffset.X * X +
				EffectOffset.Y * Y * Hand +
				EffectOffset.Z * Z);
	}
	return Super.GetEffectStart();
}


function float GetAIRating()
{
	local Bot B;
	local DestroyableObjective O;
	local Vehicle V;

	B = Bot(Instigator.Controller);
	if ( B == None )
		return AIRating;

	V = B.Squad.GetLinkVehicle(B);
	if ( (V != None)
		&& (VSize(Instigator.Location - V.Location) < 1.5 * 1500)
		&& (V.Health < V.HealthMax) && (V.LinkHealMult > 0) )
		return 1.2;

	if ( Vehicle(B.RouteGoal) != None && B.Enemy == None && VSize(Instigator.Location - B.RouteGoal.Location) < 1.5 * 1500
	     && Vehicle(B.RouteGoal).TeamLink(B.GetTeamNum()) )
		return 1.2;

	O = DestroyableObjective(B.Squad.SquadObjective);
	if ( O != None && B.Enemy == None && O.TeamLink(B.GetTeamNum()) && O.Health < O.DamageCapacity
	     && VSize(Instigator.Location - O.Location) < 1.1 * 1500 && B.LineOfSightTo(O) )
		return 1.2;

	return AIRating * FMin(Pawn(Owner).DamageScaling, 1.5);
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
	local Bot B;

	B = Bot(Instigator.Controller);

	if ( B.Enemy.IsA('DestroyableObject') || B.Enemy.IsA('Vehicle') )
		return 0;

    if ( (B != None)  && (VSize(B.Enemy.Location - Instigator.Location) < 700)
          && (B.Enemy.IsA('Vehicle') == false) && (B.Enemy.IsA('DestroyableObject') == false) )
	{
       if ( (FRand() < 0.40) /*&& (Ammo [1] != None)*/ && (AmmoAmount(1) >= FireMode[1].AmmoPerFire) )
           return 1;
       else if ( (FRand() < 0.10) /*&& (Ammo [1] != None)*/ && (AmmoAmount(1) >= FireMode[1].AmmoPerFire) )
           return 1;

       if ( (AmmoAmount(0) >= FireMode[0].AmmoPerFire) && (Ammo [0] != None) )
		   return 0;
	}
    return 0;
}

function float SuggestAttackStyle()
{
	return 0.8;
}

function float SuggestDefenseStyle()
{
    return -0.3;
}
// End AI Interface

defaultproperties
{
     NewEffectOffset=5.000000
     FireModeClass(0)=Class'tk_SWXWeapons.BWGXLightFire'
     FireModeClass(1)=Class'tk_SWXWeapons.BWGXDarkFire'
     PutDownAnim="PutDown"
     IdleAnimRate=0.030000
     SelectSound=Sound'WeaponSounds.LinkGun.SwitchToLinkGun'
     SelectForce="SwitchToLinkGun"
     AIRating=0.680000
     CurrentRating=0.680000
     EffectOffset=(X=100.000000,Y=25.000000,Z=-3.000000)
     DisplayFOV=60.000000
     Priority=6
     HudColor=(B=128,G=128,R=128)
     SmallViewOffset=(X=10.000000,Y=4.000000,Z=-9.000000)
     CenteredOffsetY=-12.000000
     CenteredRoll=3000
     CenteredYaw=-300
     InventoryGroup=5
     PickupClass=Class'tk_SWXWeapons.BWGXPickup'
     PlayerViewOffset=(X=-2.000000,Y=-2.000000,Z=-3.000000)
     PlayerViewPivot=(Yaw=500)
     BobDamping=1.575000
     AttachmentClass=Class'tk_SWXWeapons.BWGXAttachement'
     IconMaterial=Texture'InterfaceContent.HUD.SkinA'
     IconCoords=(X1=200,Y1=190,X2=321,Y2=280)
     ItemName="Black and White Gun X"
     Mesh=SkeletalMesh'Weapons.LinkGun_1st'
     Skins(0)=Texture'tk_SWXWeapons.BWGX.BWGtex0'
     UV2Texture=Shader'XGameShaders.WeaponShaders.WeaponEnvShader'
}
