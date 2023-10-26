class RPARProjectile extends Projectile;

var xEmitter FlareTrail;
var xEmitter SparkleTrail;
var	xEmitter SmokeTrail;

var() int ComboAmmoCost;

var Vector tempStartLoc;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    if ( Role == ROLE_Authority )
    {
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
    }
    SetCollisionSize(0.0, 0.0);
}

simulated event PreBeginPlay()
{
    Super.PreBeginPlay();

    if( (Owner != None) && Owner.IsA( 'Pawn' ) )
        Instigator = Pawn( Owner );
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
	{
        SmokeTrail = Spawn(class'RPTrailSmoke',self);
	}

	Velocity = Speed * Vector(Rotation);

    SetTimer(0.4, false);
    tempStartLoc = Location;
}

function Timer()
{
    SetCollisionSize(1, 1);
}

simulated function Destroyed()
{
    if (FlareTrail != None)
    {
        FlareTrail.mRegen = false;
    }
    if (SparkleTrail != None)
    {
        SparkleTrail.mStartParticles = 12;
        SparkleTrail.mLifeRange[0] *= 2.0;
        SparkleTrail.mLifeRange[1] *= 2.0;
        SparkleTrail.mRegen = false;
    }
	if ( SmokeTrail != None )
		SmokeTrail.mRegen = False;
	Super.Destroyed();
}

simulated function DestroyTrails()
{
    if (FlareTrail != None)
        FlareTrail.Destroy();
    if (SparkleTrail != None)
        SparkleTrail.Destroy();
	if ( SmokeTrail != None )
		SmokeTrail.Destroy();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local Vector X, RefNormal, RefDir;
    local Vehicle V;
	local DestroyableObjective O;

	if (Other == Instigator) return;
    if (Other == Owner) return;

    V = Vehicle(Other);
    O = DestroyableObjective(Other);

    if ((V != none) || (O != none))
        Damage=Default.Damage*0.1;

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
		if ( Role == ROLE_Authority )
		{
        	if ( Instigator == None || Instigator.Controller == None )
				Other.SetDelayedDamageInstigatorController( InstigatorController );
			if (V != none)
                V.Driver.TakeDamage(Default.Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
            Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
		}
        Explode(HitLocation, Normal(HitLocation-Other.Location));
    }
    if ( Instigator.HasUDamage() )
        Damage=Default.Damage*2;
    Else
        Damage=Default.Damage;
}

defaultproperties
{
     Speed=10000.000000
     MaxSpeed=10000.000000
     bSwitchToZeroCollision=True
     Damage=25.000000
     DamageRadius=1.000000
     MomentumTransfer=7000.000000
     MyDamageType=Class'mm_SWXWeapons.DamTypeRPARPri'
     ImpactSound=Sound'WeaponSounds.ShockRifle.ShockRifleExplosion'
     ExplosionDecal=Class'XEffects.ShockAltDecal'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=100
     LightSaturation=100
     LightBrightness=160.000000
     LightRadius=12.000000
     DrawType=DT_Sprite
     bDynamicLight=True
     bNetTemporary=False
     bOnlyDirtyReplication=True
     AmbientSound=Sound'WeaponSounds.ShockRifle.ShockRifleProjectile'
     LifeSpan=10.000000
     Texture=Texture'mm_SWXWeapons.RPARProj_t'
     DrawScale=0.100000
     Style=STY_Translucent
     SoundVolume=255
     SoundRadius=100.000000
     CollisionRadius=1.000000
     CollisionHeight=1.000000
     bCollideWorld=False
     bProjTarget=True
     bAlwaysFaceCamera=True
     ForceType=FT_Constant
     ForceRadius=40.000000
     ForceScale=4.000000
}
