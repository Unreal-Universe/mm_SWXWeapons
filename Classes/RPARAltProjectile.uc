class RPARAltProjectile extends Projectile;

var	xEmitter SmokeTrail;
var xEmitter Trail;

var int Links;

replication
{
    unreliable if (bNetInitial && Role == ROLE_Authority)
        Links;
}

simulated function Destroyed()
{
	if ( SmokeTrail != None )
	{
		SmokeTrail.mRegen = False;
    }

    if (Trail != None)
    {
        Trail.Destroy();
    }
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
    local Rotator R;

	Super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
        SmokeTrail = Spawn(class'RPTrailSmoke',self);

	Velocity = Vector(Rotation);
    Acceleration = Velocity * 3000.0;
    Velocity *= Speed;

    R = Rotation;
    R.Roll = Rand(65536);
    SetRotation(R);

    if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
}

simulated function LinkAdjust()
{
    local float ls;

    if (Links > 0)
    {
        ls = class'LinkFire'.default.LinkScale[Min(Links,5)];

        SetDrawScale3D(default.DrawScale3D * (ls + 1));

    	if ( Trail != None )
        {
            Trail.mLifeRange[0] *= (ls + 1);
            Trail.mLifeRange[1] = Trail.mLifeRange[0];

            Trail.mSizeRange[0] *= (ls + 1);
            Trail.mSizeRange[1] = Trail.mSizeRange[0];

            Trail.mPosDev.Y *= (ls + 1);
            Trail.mPosDev.Z = Trail.mPosDev.Y;

            Trail.Skins[0] = Texture'XEffectMat.link_muz_yellow';
        }

        Speed = default.Speed + 200*Links;
        MaxSpeed = default.MaxSpeed + 350*Links;
	    Velocity = Speed * Vector(Rotation);

        SetCollisionSize(ls*10, ls*10);

        Skins[0] = FinalBlend'XEffectMat.LinkProjYellowFB';
        LightHue = 40;
    }
}

simulated function PostNetBeginPlay()
{
    if (Role < ROLE_Authority)
        LinkAdjust();
	if ( Level.bDropDetail || Level.DetailMode == DM_Low )
		LightType = LT_None;
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
    if ( Role == ROLE_Authority )   //0.8
    {
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
    }

   	PlaySound(ImpactSound, SLOT_Misc);
	if ( EffectIsRelevant(Location,false) )
	    Spawn(class'RPARExplosion',,, Location);//,rotator(Velocity));

    SetCollisionSize(0.0, 0.0);
	Destroy();
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
            //Log("reflecting off"@Other@X@RefDir);
            Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
        }
        Destroy();
    }
    else if ( !Other.IsA('Projectile') || Other.bProjTarget )
	{
		if ( Role == ROLE_Authority )
		Explode(HitLocation, vect(0,0,1));
	}
}

defaultproperties
{
     Speed=3000.000000
     MaxSpeed=6000.000000
     Damage=70.000000
     DamageRadius=120.000000
     MomentumTransfer=25000.000000
     MyDamageType=Class'mm_SWXWeapons.DamTypeRPARSec'
     ImpactSound=Sound'WeaponSounds.ShockRifle.ShockRifleExplosion'
     ExplosionDecal=Class'XEffects.LinkBoltScorch'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=100
     LightSaturation=100
     LightBrightness=160.000000
     LightRadius=24.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.LinkProjectile'
     bDynamicLight=True
     AmbientSound=Sound'WeaponSounds.LinkGun.LinkGunProjectile'
     LifeSpan=5.000000
     DrawScale=0.800000
     DrawScale3D=(X=2.550000,Y=1.700000,Z=1.700000)
     PrePivot=(X=10.000000)
     AmbientGlow=217
     Style=STY_Additive
     SoundVolume=255
     SoundRadius=250.000000
     bFixedRotationDir=True
     RotationRate=(Roll=80000)
     ForceType=FT_Constant
     ForceRadius=30.000000
     ForceScale=5.000000
}
