class LightProjectile extends Projectile;

var bool bCanHitOwner;
var bool bStartSeek;
var int nBounce;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    if ( Role == ROLE_Authority )
    {
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
    }
    destroy();
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

    nBounce=0;

	Velocity = Speed * Vector(Rotation);

    SetTimer(0.15, true);
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
    local projectile dumbproj;
	local DestroyableObjective HealObjective;
	local Vehicle V;

    HealObjective = DestroyableObjective(Other);
    V = Vehicle(Other);
    if ( HealObjective == None )
	    HealObjective = DestroyableObjective(Other.Owner);


    if (Other.IsA('DarkProjectile'))
    {
        dumbproj = Spawn( class 'GreyProjectile',owner,, location, rotation);
        Destroy();
    }
    else if ( HealObjective != None && HealObjective.TeamLink(Instigator.GetTeamNum()) )
    {
		if (!HealObjective.HealDamage(Damage*5, Instigator.Controller, MyDamageType))
		{
//		    do Not Explode
        }
        destroy();
    }
    else if ( Pawn(Other) != None && (Other != Instigator || bCanHitOwner) && (!Other.IsA('Projectile') || Other.bProjTarget) )
    {
		if ( Role == ROLE_Authority )
			Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
		Explode(HitLocation, Normal(HitLocation-Other.Location));
    }
}

simulated function Landed( vector HitNormal )
{
    HitWall( HitNormal, None );
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    local Vector VNorm;
     if (Wall.IsA('Vehicle') && Vehicle(Wall).Team == Instigator.PlayerReplicationInfo.Team.TeamIndex)
     {
		if (!Vehicle(Wall).HealDamage(Damage*5, Instigator.Controller, MyDamageType))
		{
        }
        destroy();
     }
     else if ( !Wall.bStatic && !Wall.bWorldGeometry
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
    {
        if ( Level.NetMode != NM_Client )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController( InstigatorController );
            Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
        Destroy();
        return;
    }

    // Reflect off Wall
    VNorm = (Velocity dot HitNormal) * HitNormal;
    Velocity = -VNorm + (Velocity - VNorm);
    bCanHitOwner=True;
    nBounce++;
    if (nBounce>=5)
       Destroy();
}

defaultproperties
{
     Speed=9000.000000
     MaxSpeed=9000.000000
     bSwitchToZeroCollision=True
     Damage=5.000000
     DamageRadius=3.000000
     MomentumTransfer=130000.000000
     MyDamageType=Class'mm_SWXWeapons.DamTypeBWGXLight'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=43
     LightSaturation=255
     LightBrightness=140.000000
     LightRadius=20.000000
     DrawType=DT_Sprite
     bDynamicLight=True
     bNetTemporary=False
     bOnlyDirtyReplication=True
     AmbientSound=Sound'WeaponSounds.ShockRifle.ShockRifleProjectile'
     LifeSpan=6.000000
     Texture=Texture'AWGlobal.Cubes.Briteface1'
     DrawScale=0.300000
     Skins(0)=Texture'AWGlobal.Cubes.Briteface1'
     Style=STY_Translucent
     SoundVolume=255
     SoundRadius=70.000000
     CollisionRadius=3.000000
     CollisionHeight=3.000000
     bAlwaysFaceCamera=True
     bBounce=True
     ForceType=FT_Constant
     ForceRadius=40.000000
     ForceScale=5.000000
}
