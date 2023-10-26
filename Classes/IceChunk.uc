class IceChunk extends Projectile;

var vector initialDir;
var bool bCanHitOwner;
var int MaxTakenDamage;
var int DamageTaken;

simulated function PostBeginPlay()
{
	local PlayerController PC;

	if ( !PhysicsVolume.bWaterVolume && (Level.NetMode != NM_DedicatedServer) )
	{
		PC = Level.GetLocalPlayerController();
	}

    DamageTaken = 0;

	Super.PostBeginPlay();
}

simulated function destroyed()
{
    PlaySound(Sound'mm_SWXWeapons.IGChunkBreak', SLOT_Misc);

	if ( EffectIsRelevant(Location,false) )
	    Spawn(class'IceDustExplosionB',,, Location);

	Super.Destroyed();
}

function AddVelocity( vector NewVelocity )
{
	if ( (NewVelocity == vect(0,0,0)) )
		return;
	Velocity += NewVelocity;

	if ( Physics == PHYS_None)
	{
        Velocity.z += TossZ;
	    SetPhysics(PHYS_Falling);
    }
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
    AddVelocity( Momentum / (Mass) );
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    if ( (Physics == PHYS_Falling) || !(Other == Instigator) )
    {
        speed = VSize(Velocity);
            if ( Role == ROLE_Authority )
			{
				if ( Instigator == None || Instigator.Controller == None )
					Other.SetDelayedDamageInstigatorController( InstigatorController );

                Other.TakeDamage( Max(0, 4*Damage*VSize(Velocity)/Speed), Instigator, HitLocation,
                    (MomentumTransfer * Normal(Velocity)), MyDamageType );
			}
    }
    if (Other.IsA('Pawn') || Other.IsA('Vehicle'))
    {
        Velocity = Other.Velocity*2;
        Velocity.z += TossZ;


        SetPhysics(PHYS_falling);
    }
}

simulated function Landed( vector HitNormal )
{
    // Meh...
}

simulated function HitWall (vector HitNormal, actor Wall)
{
    if ( !Wall.bStatic && !Wall.bWorldGeometry
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
    {
        if ( Level.NetMode != NM_Client )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController( InstigatorController );
            Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
    }

    PlaySound(ImpactSound,,255,,300);
    Speed = VSize(Velocity);

    if (Speed >= 100)
        Velocity = 0.55 * (Velocity - 2.0*HitNormal*(Velocity dot HitNormal));
    Else
        SetPhysics(PHYS_None);

}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    Destroy();
}

defaultproperties
{
     MaxTakenDamage=50
     Speed=1500.000000
     MaxSpeed=12000.000000
     Damage=5.000000
     MomentumTransfer=75000.000000
     MyDamageType=Class'mm_SWXWeapons.DamTypeSWIGChunk'
     ImpactSound=Sound'mm_SWXWeapons.SWIG.IGChunkHit'
     ExplosionDecal=Class'XEffects.ShockAltDecal'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'mm_SWXWeapons.SWIC.IceChunk'
     Physics=PHYS_Falling
     LifeSpan=20.000000
     DrawScale3D=(X=0.500000,Y=0.500000,Z=0.500000)
     CollisionRadius=30.000000
     CollisionHeight=30.000000
     bProjTarget=True
     bBounce=True
     Mass=200.000000
     ForceType=FT_Constant
     ForceRadius=60.000000
     ForceScale=5.000000
}
