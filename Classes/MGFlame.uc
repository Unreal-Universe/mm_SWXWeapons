class MGFlame extends Projectile;

var xEmitter FlameTrail;

var Pawn ComboTarget;		// for AI use

var Vector tempStartLoc;

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
    	if ( !Level.bDropDetail && (Level.DetailMode != DM_Low) )
		   FlameTrail = Spawn(class'MGFlameEmitter', self);
		FlameTrail = Spawn(class'MGFlameEmitter', self);
	}

	Velocity = Speed * Vector(Rotation); // starts off slower so combo can be done closer

    SetTimer(0.4, false);
    tempStartLoc = Location;
}

function Timer()
{
    SetCollisionSize(20, 20);
}

simulated function Destroyed()
{
    if (FlameTrail != None)
    {
        FlameTrail.mRegen = false;
    }
	Super.Destroyed();
}

simulated function DestroyTrails()
{
    if (FlameTrail != None)
        FlameTrail.Destroy();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local Vector X, RefNormal, RefDir;

	if (Other == Instigator) return;
    if (Other == Owner) return;

    if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25)&&Other != Instigator)
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
    else if ( (!Other.IsA('Projectile') || Other.bProjTarget) && Other != Instigator)
    {
		Explode(HitLocation, Normal(HitLocation-Other.Location));
    }
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
    if ( Role == ROLE_Authority )
    {
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
    }

   	PlaySound(ImpactSound, SLOT_Misc);
	if ( EffectIsRelevant(Location,false) )
	    Spawn(class'MGFlameExpolsion',,, HitLocation+HitNormal,rotator(HitNormal));//,rotator(Velocity));

    SetCollisionSize(0.0, 0.0);
	Destroy();
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
    if (DamageType == class'DamTypeMGAlt')
    {
        Instigator = EventInstigator;
    }
}

defaultproperties
{
     Speed=1500.000000
     MaxSpeed=2150.000000
     bSwitchToZeroCollision=True
     Damage=25.000000
     DamageRadius=150.000000
     MomentumTransfer=400.000000
     MyDamageType=Class'tk_SWXWeapons.DamTypeMGAlt'
     ImpactSound=Sound'WeaponSounds.ShockRifle.ShockRifleExplosion'
     ExplosionDecal=Class'XEffects.ShockAltDecal'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=25
     LightSaturation=255
     LightBrightness=200.000000
     LightRadius=8.000000
     DrawType=DT_Sprite
     bDynamicLight=True
     bNetTemporary=False
     bOnlyDirtyReplication=True
     LifeSpan=0.700000
     Texture=None
     DrawScale=0.010000
     Style=STY_Translucent
     SoundVolume=255
     SoundRadius=100.000000
     CollisionRadius=5.000000
     CollisionHeight=5.000000
     bProjTarget=True
     bAlwaysFaceCamera=True
     ForceType=FT_Constant
     ForceRadius=40.000000
     ForceScale=5.000000
}
