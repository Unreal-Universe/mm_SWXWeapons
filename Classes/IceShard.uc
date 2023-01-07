class IceShard extends Projectile;

var int Links;
var xPawn SlowedPawn;
var	xEmitter SmokeTrail;

replication
{
    unreliable if (bNetInitial && Role == ROLE_Authority)
        Links;
}

simulated function DestroyTrails()
{
	if ( SmokeTrail != None )
		SmokeTrail.Destroy();
}

simulated function Destroyed()
{
    PlaySound(Sound'tk_SWXWeapons.IGShardBreak', SLOT_Misc);

	if ( EffectIsRelevant(Location,false) )
	    Spawn(class'IceDustExplosion',,, Location);

	if ( SmokeTrail != None )
	{
        SmokeTrail.mRegen = false;
        SmokeTrail.SetTimer(1,false);
    }
    if (SlowedPawn != none)
        Thaw();

	super.Destroyed();
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	Velocity = Vector(Rotation);
    Velocity *= Speed;
    SlowedPawn = none;

    if ( Level.NetMode != NM_DedicatedServer )
	{
        SmokeTrail = Spawn(class'IceDustTrail',self);
	}
}

simulated function PostNetBeginPlay()
{

    Acceleration = Normal(Velocity) * 3000.0;

    if ( Level.NetMode == NM_DedicatedServer )
		return;
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	Destroy();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local Vector X, RefNormal, RefDir;
    local float dist;
    local Name bone;

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
		if ( Role == ROLE_Authority && Other != SlowedPawn)
		{
			if ( Instigator == None || Instigator.Controller == None )
				Other.SetDelayedDamageInstigatorController( InstigatorController );
			Other.TakeDamage(Damage * (1.0 + float(Links)),Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
		}

		if ( Other.IsA('xPawn') && (!Instigator.Controller.SameTeamAs(Pawn(Other).Controller) && Other != SlowedPawn) )
		{
            Velocity = vect(0,0,0);
            Speed = 0;
            X = Normal(Velocity);
            SetPhysics(PHYS_None);
            bone = Other.GetClosestBone( HitLocation, Velocity, dist);
            other.AttachToBone(self, bone);


		    SlowedPawn = xPawn(Other);
		    SlowDown();
	    }
		else
            Explode(HitLocation, vect(0,0,1));
	}
}

function SlowDown()
{
    SlowedPawn.AirControl *= 0.6;
    SlowedPawn.GroundSpeed *= 0.6;
    SlowedPawn.WaterSpeed *= 0.6;
    SlowedPawn.AirSpeed *= 0.6;
    SlowedPawn.JumpZ *= 0.6;
}

function Thaw()
{
    SlowedPawn.AirControl /= 0.6;
    SlowedPawn.GroundSpeed /= 0.6;
    SlowedPawn.WaterSpeed /= 0.6;
    SlowedPawn.AirSpeed /= 0.6;
    SlowedPawn.JumpZ /= 0.6;
}

defaultproperties
{
     Speed=5000.000000
     MaxSpeed=16000.000000
     Damage=10.000000
     DamageRadius=0.000000
     MomentumTransfer=30000.000000
     MyDamageType=Class'tk_SWXWeapons.DamTypeSWIGShard'
     ExplosionDecal=Class'XEffects.LinkBoltScorch'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_SWXWeapons.SWIC.IceShard'
     bDynamicLight=True
     AmbientSound=Sound'WeaponSounds.LinkGun.LinkGunProjectile'
     LifeSpan=8.000000
     DrawScale3D=(X=0.070000,Y=0.070000,Z=0.070000)
     SoundVolume=255
     SoundRadius=50.000000
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
     ForceType=FT_Constant
     ForceRadius=10.000000
     ForceScale=5.000000
}
