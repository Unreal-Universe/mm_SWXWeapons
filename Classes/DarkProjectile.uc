class DarkProjectile extends Projectile;

var bool onwall;
var BWGXDarkAura DAura;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    if ( Role == ROLE_Authority )
    {
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
    }
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

	Velocity = Speed * Vector(Rotation);
    onwall = false;
    DAura = Spawn(class'BWGXDarkAura',self);
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{

    if ( Pawn(Other) != None && (Other != Instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) )
    {
		if ( Role == ROLE_Authority )
			Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
		Explode(HitLocation, Normal(HitLocation-Other.Location));
    }
    else if (!Other.IsA('LightProjectile') && !Other.IsA('DarkProjectile') && Other.IsA('Projectile'))
        Other.Destroy();
}

simulated function Landed( vector HitNormal )
{
    HitWall( HitNormal, None );
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    if (onwall!=true)
    {
         SetTimer(5,false);
         onwall=true;
    }
}

simulated function timer()
{
    SetCollisionSize(0.0, 0.0);
    bCollideWorld=True;
    Destroy();
}

simulated function Destroyed()
{
	if ( DAura != None )
	{
        DAura.Destroy();
    }
	Super.Destroyed();
}

defaultproperties
{
     Speed=800.000000
     MaxSpeed=800.000000
     Damage=100.000000
     DamageRadius=100.000000
     MomentumTransfer=-150000.000000
     MyDamageType=Class'mm_SWXWeapons.DamTypeBWGXDark'
     ImpactSound=Sound'WeaponSounds.ShockRifle.ShockRifleExplosion'
     LightType=LT_Steady
     LightHue=255
     LightSaturation=255
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XEffects.EffectsSphere144'
     bNetTemporary=False
     bOnlyDirtyReplication=True
     AmbientSound=Sound'WeaponSounds.ShockRifle.ShockRifleProjectile'
     LifeSpan=25.000000
     Texture=Texture'mm_SWXWeapons.BWGX.BWGXBlack'
     DrawScale=0.787500
     Skins(0)=Texture'mm_SWXWeapons.BWGX.BWGXBlack'
     Style=STY_None
     SoundVolume=255
     SoundRadius=100.000000
     CollisionRadius=35.000000
     CollisionHeight=35.000000
     bProjTarget=True
}
