class RPAR extends tk_Weapon
    config(TKWeaponsClient);

var bool bLockedOn;

simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();

	if ( (Role < ROLE_Authority) && (Instigator != None) && (Instigator.Controller != None) && (Instigator.Weapon != self) && (Instigator.PendingWeapon != self) )
		Instigator.Controller.ClientSwitchToBestWeapon();
}

simulated function DrawWeaponInfo(Canvas Canvas)
{
	local int Count;
	local float ScaleFactor;

	Count = Min(8,Ammo[1].AmmoAmount);
	ScaleFactor = 99 * Canvas.ClipX/1600;
	Canvas.Style = ERenderStyle.STY_Alpha;
	Canvas.DrawColor = class'HUD'.Default.WhiteColor;
}

function byte BestMode()
{
	if ( (FRand() < 0.25) && (AmmoAmount(1) >= GetFireMode(1).AmmoPerFire) )
		return 1;
    if ( AmmoAmount(0) >= GetFireMode(0).AmmoPerFire )
		return 0;
	return 1;
}

// return false if out of range, can't see target, etc.
function bool CanAttack(Actor Other)
{
    local float Dist, CheckDist;
    local vector HitLocation, HitNormal,X,Y,Z, projStart;
    local actor HitActor;
    local int m;
	local bool bInstantHit;

    if ( ((Instigator == None) || (Instigator.Controller == None)) && bLockedOn == false )
        return false;

    // check that target is within range
    Dist = VSize(Instigator.Location - Other.Location);
    if ( (Dist > GetFireMode(0).MaxRange()) && (Dist > GetFireMode(1).MaxRange()) )
        return false;

    // check that can see target
    if ( !Instigator.Controller.LineOfSightTo(Other) && bLockedOn == false )
        return false;

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
		if ( GetFireMode(m).bInstantHit )
			bInstantHit = true;
		else
		{
			CheckDist = FMax(CheckDist, 0.5 * GetFireMode(m).ProjectileClass.Default.Speed);
	        CheckDist = FMax(CheckDist, 300);
	        CheckDist = FMin(CheckDist, VSize(Other.Location - Location));
		}
	}
    // check that would hit target, and not a friendly
    GetAxes(Instigator.Controller.Rotation, X,Y,Z);
    projStart = GetFireStart(X,Y,Z);
    if ( bInstantHit )
        HitActor = Trace(HitLocation, HitNormal, Other.Location + Other.CollisionHeight * vect(0,0,0.8), projStart, true);
    else
    {
        // for non-instant hit, only check partial path (since others may move out of the way)
        HitActor = Trace(HitLocation, HitNormal,
                projStart + CheckDist * Normal(Other.Location + Other.CollisionHeight * vect(0,0,0.8) - Location),
                projStart, true);
    }

    if ( (HitActor == None) || (HitActor == Other) || (Pawn(HitActor) == None)
		|| (Pawn(HitActor).Controller == None) || !Instigator.Controller.SameTeamAs(Pawn(HitActor).Controller) )
        return true;

    return false;
}

simulated event RenderOverlays( Canvas Canvas )
{
    local vector TargPos;
    local Pawn act,PlayerPawn;
    local float SearchRadius;
	local vector vecPawnView, X, Y, Z;

    SearchRadius = 3000;

    foreach RadiusActors(class 'Pawn', act, SearchRadius, Pawn(owner).Location)
    {
   	          PlayerPawn = Pawn(owner);
              if ((PlayerPawn==None))
  		         return;

 			  vecPawnView = act.Location - PlayerPawn.Location - (PlayerPawn.EyeHeight * vect(0,0,1));
	          GetAxes(PlayerPawn.GetViewRotation(), X, Y, Z);

     	      if ( ((vecPawnView dot X) >= 0.70 ) && (act.Health > 0) && (PlayerPawn != Act) && (Vehicle(act) == none))
              {
                   TargPos = canvas.WorldToScreen(act.Location);

                   Canvas.DrawColor.R = 255;
                   Canvas.DrawColor.G = 0;
                   Canvas.DrawColor.B = 0;

                   if (Instigator.Controller.SameTeamAs(act.Controller))
                   {
                       Canvas.DrawColor.G = 255;
                       bLockedOn = false;
                   }
                   else
                   {
                       Canvas.DrawColor.G = 0;
                       bLockedOn = false;
                   }

                   Canvas.DrawColor.A = 255;
                   Canvas.Style = ERenderStyle.STY_Alpha;

                   Canvas.SetPos(TargPos.X-(Texture'RPARRect'.USize*0.5), TargPos.Y-(Texture'RPARRect'.VSize*0.5));
                   Canvas.DrawTile(Texture'RPARRect', 16*4.0, 16*4.0, 0.0, 0.0, Texture'RPARRect'.USize, Texture'RPARRect'.VSize);

                   Super.RenderOverlays(Canvas);
              }
              else
              {
                   Super.RenderOverlays(Canvas);
                   bLockedOn = false;
              }


    }
}

defaultproperties
{
     FireModeClass(0)=Class'tk_SWXWeapons.RPARProjectileFire'
     FireModeClass(1)=Class'tk_SWXWeapons.RPARAltProjectileFire'
     PutDownAnim="PutDown"
     SelectSound=Sound'WeaponSounds.AssaultRifle.SwitchToAssaultRifle'
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.400000
     CurrentRating=0.400000
     bCanThrow=False
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=70.000000
     Priority=3
     HudColor=(B=192,G=128)
     InventoryGroup=2
     PickupClass=Class'tk_SWXWeapons.RPARPickup'
     PlayerViewOffset=(X=-8.000000,Y=5.000000,Z=-6.000000)
     PlayerViewPivot=(Pitch=400)
     BobDamping=1.700000
     AttachmentClass=Class'tk_SWXWeapons.RPARAttachement'
     IconMaterial=Texture'InterfaceContent.HUD.SkinA'
     IconCoords=(X1=200,Y1=100,X2=321,Y2=189)
     ItemName="Retro-Plasma Assault Rifle"
     LightType=LT_Pulse
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=150
     LightBrightness=150.000000
     LightRadius=4.000000
     LightPeriod=3
     Mesh=SkeletalMesh'Weapons.AssaultRifle_1st'
     Skins(0)=Texture'tk_SWXWeapons.RPAR.RPARTex2'
     UV2Texture=Shader'XGameShaders.WeaponShaders.WeaponEnvShader'
}
