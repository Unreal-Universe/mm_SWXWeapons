class SWIGProj extends Projectile;

var ShockBall ShockBallEffect;

var Vector tempStartLoc;
var bool bSpawnedIce;

var() Weapon Weapon;

simulated event PreBeginPlay()
{
    Super.PreBeginPlay();

    if( Pawn(Owner) != None )
        Instigator = Pawn( Owner );
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
	{
        ShockBallEffect = Spawn(class'ShockBall', self);
        ShockBallEffect.SetBase(self);
	}

	Velocity = Speed * Vector(Rotation); // starts off slower so combo can be done closer

    tempStartLoc = Location;
    bSpawnedIce = false;
}

simulated function PostNetBeginPlay()
{
	local PlayerController PC;

	Super.PostNetBeginPlay();

	if ( Level.NetMode == NM_DedicatedServer )
		return;

	PC = Level.GetLocalPlayerController();
	if ( (Instigator != None) && (PC == Instigator.Controller) )
		return;
	if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	else if ( (PC == None) || (PC.ViewTarget == None) || (VSize(PC.ViewTarget.Location - Location) > 3000) )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
}

function MakeIceChunk()
{
    local Projectile p;
    bSpawnedIce = true;


    MomentumTransfer = 0;
    Damage = 0;
        p = Spawn(class 'IceChunk', owner,, location,);
    p.Velocity = Velocity;
}

simulated function Destroyed()
{

    if (ShockBallEffect != None)
    {
		if ( bNoFX )
			ShockBallEffect.Destroy();
		else
			ShockBallEffect.Kill();
	}

	Super.Destroyed();
    if (bSpawnedIce == false)
       MakeIceChunk();

}

simulated function DestroyTrails()
{
    if (ShockBallEffect != None)
        ShockBallEffect.Destroy();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local Vector X, RefNormal, RefDir;

	if (Other == Instigator) return;
    if (Other == Owner) return;

    if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25))
    {
        if (Role == ROLE_Authority)
        {
            X = Normal(Velocity);
            RefDir = X - 2.0*RefNormal*(X dot RefNormal);
            RefDir = RefNormal;
            Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
        }
        DestroyTrails();
        Destroy();
    }
    else if ( !Other.IsA('Projectile') || Other.bProjTarget )
    {
		Other.TakeDamage(Damage,Instigator, HitLocation, MomentumTransfer * Normal(Velocity),MyDamageType);
		Explode(HitLocation,Normal(Other.Location - HitLocation));
		if ( ShockProjectile(Other) != None )
			ShockProjectile(Other).Explode(HitLocation,Normal(Other.Location - HitLocation));
    }
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
   	PlaySound(ImpactSound, SLOT_Misc);

	if ( EffectIsRelevant(Location,false) )
	{
	    Spawn(class'IceDustExplosionB',,, Location);
	}
    SetCollisionSize(0.0, 0.0);
	Destroy();
}

defaultproperties
{
     Speed=2000.000000
     MaxSpeed=8000.000000
     bSwitchToZeroCollision=True
     Damage=90.000000
     DamageRadius=150.000000
     MyDamageType=Class'tk_SWXWeapons.DamTypeSWIGProj'
     ImpactSound=Sound'WeaponSounds.ShockRifle.ShockRifleExplosion'
     ExplosionDecal=Class'XEffects.ShockImpactScorch'
     MaxEffectDistance=7000.000000
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=195
     LightSaturation=85
     LightBrightness=255.000000
     LightRadius=4.000000
     DrawType=DT_Sprite
     CullDistance=4000.000000
     bDynamicLight=True
     bNetTemporary=False
     bOnlyDirtyReplication=True
     AmbientSound=Sound'WeaponSounds.ShockRifle.ShockRifleProjectile'
     LifeSpan=0.400000
     Texture=Texture'XEffectMat.Shock.shock_core_low'
     DrawScale=0.450000
     Skins(0)=Texture'XEffectMat.Shock.shock_core_low'
     Style=STY_Translucent
     FluidSurfaceShootStrengthMod=8.000000
     SoundVolume=50
     SoundRadius=100.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     bProjTarget=True
     bAlwaysFaceCamera=True
     ForceType=FT_Constant
     ForceRadius=40.000000
     ForceScale=5.000000
}
