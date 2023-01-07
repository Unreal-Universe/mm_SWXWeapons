class SFCXShellB extends SFCXShell;

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    if ( DestroyableObjective(Other) != None)
        Damage = 1;
	if ( Other != Instigator)
	{
 	    SpawnEffects(HitLocation, -1 * Normal(Velocity) );
        Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
    local rotator rot;
    local int i;
    local SFCXChunk NewChunk;

	start = Location + 10 * HitNormal;
	if ( Role == ROLE_Authority )
	{
      	HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);
		    for (i=0; i<6; i++)
		    {
			    rot = Rotation;
			    rot.yaw += FRand()*32000-16000;
			    rot.pitch += FRand()*32000-16000;
			    rot.roll += FRand()*32000-16000;
			    NewChunk = Spawn( class 'SFCXChunk',, '', Start, rot);
		    }

        Destroy();
    }
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	PlaySound (Sound'WeaponSounds.BExplosion1',,0.5*TransientSoundVolume);
	if ( EffectIsRelevant(Location,false) )
	{
		spawn(class'FlakExplosion',,,HitLocation + HitNormal*16 );
		spawn(class'FlashExplosion',,,HitLocation + HitNormal*16 );
		spawn(class'RocketSmokeRing',,,HitLocation + HitNormal*16, rotator(HitNormal) );
		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}
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
            Damage=1;
            Explode(Wall.Location, HitNormal);
		}
        return;
    }
	Landed(HitNormal);
}

defaultproperties
{
     Speed=800.000000
     TossZ=0.000000
     Damage=95.000000
     MomentumTransfer=65000.000000
     LifeSpan=6.000000
     DrawScale=7.000000
     SoundVolume=128
     ForceRadius=55.000000
     ForceScale=5.000000
}
