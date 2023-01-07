class SFCXShell extends Projectile;

var	xemitter trail;
var vector initialDir;
var bool bIsANode;

simulated function PostBeginPlay()
{
	local Rotator R;

	if ( !PhysicsVolume.bWaterVolume && (Level.NetMode != NM_DedicatedServer) )
		trail = Spawn(class'FlakShellTrail',self);

	Super.PostBeginPlay();
	Velocity = Vector(Rotation) * Speed;
	R = Rotation;
	R.Roll = 32768;
	SetRotation(R);
	Velocity.z += TossZ;
	initialDir = Velocity;


}

simulated function destroyed()
{
	if (trail!=None)
		trail.mRegen=False;
	Super.Destroyed();
}


simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( (Other != Instigator) )
	{
 	    SpawnEffects(HitLocation, -1 * Normal(Velocity) );
        Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	PlaySound (Sound'WeaponSounds.BExplosion1',,3*TransientSoundVolume);
	if ( EffectIsRelevant(Location,false) )
	{
		spawn(class'FlakExplosion',,,HitLocation + HitNormal*16 );
		spawn(class'FlashExplosion',,,HitLocation + HitNormal*16 );
		spawn(class'RocketSmokeRing',,,HitLocation + HitNormal*16, rotator(HitNormal) );
		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}
}

simulated function Landed( vector HitNormal )
{
       SpawnEffects( Location, HitNormal );
   	   Explode(Location,HitNormal);
}

simulated function HitWall (vector HitNormal, actor Wall)
{
    local DestroyableObjective O;
    O = DestroyableObjective(Wall);

    if ( !Wall.bStatic && !Wall.bWorldGeometry
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
    {
        if ( O != None )
            bIsANode = true;
 		else
 		    bIsANode = false;
   }

	Landed(HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
    local rotator rot;
    local int i;
    local SFCXShellB NewShell;
    local int RespawnCount;
    local vector endloc;

    RespawnCount = 0;

	start = Location + 10 * HitNormal;
	if ( Role == ROLE_Authority && bIsANode == false )
	{
		    HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);
		    for (i=0; i<8; i++)
		    {
			       rot = rotator(HitNormal);
                   rot.yaw += (((FRand()-0.5)*27306));
                   rot.pitch += (((FRand()-0.5)*27306));
                   rot.roll += FRand()*65535; //roll is irrelevant in the direction it goes

			       NewShell = Spawn( class 'SFCXShellB',, '', Start, rot);
			       endloc.x=NewShell.location.x*2;
			       endloc.y=NewShell.location.y*2;
			       endloc.z=NewShell.location.z*2;
                   if (FastTrace(NewShell.location+endloc,NewShell.Location))
                   {
                      if (RespawnCount<20)
                      {
                         NewShell.Destroy();
                         i--;
                         RespawnCount++;
                      }
                   }
			}
    }
    else if ( Role == ROLE_Authority && bIsANode == true )
	    HurtRadius(damage*0.75, 220, MyDamageType, MomentumTransfer, HitLocation);

	Destroy();
}

defaultproperties
{
     Speed=2100.000000
     TossZ=200.000000
     Damage=120.000000
     MomentumTransfer=95000.000000
     MyDamageType=Class'tk_SWXWeapons.DamTypeSFCXShell'
     ExplosionDecal=Class'XEffects.RocketMark'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.FlakShell'
     Physics=PHYS_Falling
     AmbientSound=Sound'WeaponSounds.BaseProjectileSounds.BFlakCannonProjectile'
     LifeSpan=8.000000
     DrawScale=9.000000
     AmbientGlow=100
     SoundVolume=255
     SoundRadius=100.000000
     bProjTarget=True
     ForceType=FT_Constant
     ForceRadius=70.000000
     ForceScale=6.000000
}
