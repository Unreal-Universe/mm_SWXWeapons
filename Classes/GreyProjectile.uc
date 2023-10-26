class GreyProjectile extends Projectile;

var	xEmitter SmokeTrail;

var() float	FlockRadius;
var() float	FlockStiffness;
var() float FlockMaxForce;
var() float	FlockCurlForce;
var float closest;
var vector Dir;

simulated function Destroyed()
{
	if ( SmokeTrail != None )
    {
        SmokeTrail.LifeSpan = 5;
        SmokeTrail.mRegen = false;
    }
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
		SmokeTrail = Spawn(class'RocketTrailSmoke',self);

	Dir = vector(Rotation);
	Velocity = speed * Dir;
    if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}

    closest = -1;

	SetTimer(0.15, true);
}

simulated function Timer()
{
    local vector ForceDir;
    local float VelMag, Dist;
    local Pawn act, targ;
    local bool bIsFollowing;
    local vehicle V;

    foreach VisibleActors(class 'Pawn', act, 1050)
    {

        if (act == None)
        {
            closest = -1;
            bIsFollowing = false;
            return;
        }else
        {
             Dist = VSize(Location - act.Location);
             closest = 1600;
        }

        if ((closest > Dist) && (act != Instigator) && (act.Health > 0))
        {
               closest = Dist;
               targ = act;
               V = Vehicle(targ);
               bIsFollowing = true;
        }

        if (targ != none && !Instigator.Controller.SameTeamAs(targ.Controller) && bIsFollowing == true && V == None)
	    {
            // do normal guidance to target.
	        ForceDir = Normal(targ.Location - location);
            VelMag = VSize(Velocity);
            ForceDir = Normal(ForceDir * 1.4 * VelMag + Velocity);
	        Velocity =  VelMag * ForceDir;
	        Acceleration += 14 * ForceDir;

            // Update proj so it faces in the direction its going.
            SetRotation(rotator(Velocity));
        }
        else if (V != none && V.Team != Instigator.PlayerReplicationInfo.Team.TeamIndex && bIsFollowing == true)
        {
            // do normal guidance to target.
	        ForceDir = Normal(V.Location - location);
            VelMag = VSize(Velocity);
            ForceDir = Normal(ForceDir * 1.4 * VelMag + Velocity);
	        Velocity =  VelMag * ForceDir;
	        Acceleration += 14 * ForceDir;

            // Update proj so it faces in the direction its going.
            SetRotation(rotator(Velocity));
       }
    }
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) && !Other.IsA('DarkProjectile') )
		Explode(HitLocation,Vect(0,0,1));
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(class'RocketExplosion',,,HitLocation + HitNormal*16,rotator(HitNormal));
		spawn(class'RocketSmokeRing',,,HitLocation + HitNormal*16, rotator(HitNormal) );
		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
    }

	BlowUp(HitLocation);
    DestroyTrails();
	Destroy();
}

simulated function DestroyTrails()
{
	if ( SmokeTrail != None )
		SmokeTrail.Destroy();
}

defaultproperties
{
     Speed=2500.000000
     MaxSpeed=5000.000000
     Damage=80.000000
     MomentumTransfer=80000.000000
     MyDamageType=Class'mm_SWXWeapons.DamTypeBWGXGrey'
     ExplosionDecal=Class'XEffects.RocketMark'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     StaticMesh=StaticMesh'WeaponStaticMesh.LinkProjectile'
     bDynamicLight=True
     AmbientSound=Sound'WeaponSounds.RocketLauncher.RocketLauncherProjectile'
     LifeSpan=15.000000
     AmbientGlow=96
     SoundVolume=255
     SoundRadius=100.000000
     bFixedRotationDir=True
     RotationRate=(Roll=80000)
     DesiredRotation=(Roll=45000)
     ForceType=FT_Constant
     ForceRadius=30.000000
     ForceScale=5.000000
}
