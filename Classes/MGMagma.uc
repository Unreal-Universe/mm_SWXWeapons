class MGMagma extends Projectile;


var xEmitter Trail;
var() int BaseDamage;
var() float GloblingSpeed;
var() float RestTime;
var() float TouchDetonationDelay; // gives player a split second to jump to gain extra momentum from blast
var() bool bMergeGlobs;
var() float DripTime;
var() int MaxGoopLevel;
var Actor Other2, nullac;
var vector HitNormal2, nullvec;

var int GoopLevel;
var float GoopVolume;
var Vector SurfaceNormal;
var bool bCheckedSurface;
var int Rand3;
var bool bDrip;
var bool bNoFX2;
var bool bOnMover;

var() Sound ExplodeSound;
var AvoidMarker Fear;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        Rand3;
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    Trail=Spawn(class'SWMGSmoke', self);

    SetOwner(None);

    LoopAnim('flying', 1.0);

    if (Role == ROLE_Authority)
    {
        Velocity = Vector(Rotation) * Speed;
        Velocity.Z += TossZ;
    }

    if (Role == ROLE_Authority)
         Rand3 = Rand(3);
	if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	if ( Instigator != None )
		InstigatorController = Instigator.Controller;
}

simulated function PostNetBeginPlay()
{
    if (Role < ROLE_Authority && Physics == PHYS_None)
    {
        Landed(Vector(Rotation));
    }
}

simulated function Destroyed()
{
	if ( Fear != None )
		Fear.Destroy();
    if (Trail != None)
        {
            Trail.mRegen = false;
            Trail.LifeSpan = 3;
        }
    Super.Destroyed();
}

simulated function MergeWithGlob(int AdditionalGoopLevel)
{
}

auto state Flying
{
    simulated function Landed( Vector HitNormal )
    {
        local Rotator NewRot;
        local int CoreGoopLevel;

        HitNormal2 = HitNormal;

        if ( Level.NetMode != NM_DedicatedServer )
        {
            PlaySound(ImpactSound, SLOT_Misc);
            // explosion effects
        }

        SurfaceNormal = HitNormal;

        // spawn globlings
        CoreGoopLevel = Rand3 + MaxGoopLevel - 3;
        if (GoopLevel > CoreGoopLevel)
        {
            if (Role == ROLE_Authority)
                SplashGlobs(GoopLevel - CoreGoopLevel);
            SetGoopLevel(CoreGoopLevel);
        }
		spawn(class'XEffects.LinkScorch',,,, rotator(-HitNormal));

        bCollideWorld = false;
        SetCollisionSize(GoopVolume*10.0, GoopVolume*10.0);
        bProjTarget = true;

	    NewRot = Rotator(HitNormal);
	    NewRot.Roll += 32768;
        SetRotation(NewRot);
        SetPhysics(PHYS_None);
        bCheckedsurface = false;
        Fear = Spawn(class'AvoidMarker');
        GotoState('OnGround');
    }

    simulated function HitWall( Vector HitNormal, Actor Wall )
    {
        Landed(HitNormal);

        HitNormal2=HitNormal;

        if (Mover(Wall) != None)
        {
            bOnMover = true;
            SetBase(Wall);
            if (Base == None)
                BlowUp(Location);
        }
    }

    simulated function ProcessTouch(Actor Other, Vector HitLocation)
    {
        local MGMagma Glob;

        Other2 = Other;

        Glob = MGMagma(Other);

        if ( Glob != None )
        {
            if (Glob.Owner == None || (Glob.Owner != Owner && Glob.Owner != self))
            {
                if (bMergeGlobs)
                {
                    Glob.MergeWithGlob(GoopLevel); // balancing on the brink of infinite recursion
                    bNoFX2 = true;
                    Destroyed();
                    Destroy();
                }
                else
                {
                    BlowUp(Location);
                }
            }
        }
        else if (Other != Instigator && Other.IsA('Pawn'))
            BlowUp(Location);
    }
}

state OnGround
{
    simulated function BeginState()
    {
        PlayAnim('hit');
        SetTimer(RestTime, false);
    }

    simulated function Timer()
    {
        if (bDrip)
        {
            bDrip = false;
            SetCollisionSize(default.CollisionHeight, default.CollisionRadius);
            Velocity = PhysicsVolume.Gravity * 0.2;
            SetPhysics(PHYS_Falling);
            bCollideWorld = true;
            bCheckedsurface = false;
            bProjTarget = false;
            LoopAnim('flying', 1.0);
            GotoState('Flying');
        }
        else
        {
            BlowUp(Location);
        }
    }

    simulated function ProcessTouch(Actor Other, Vector HitLocation)
    {
        Other2 = Other;

        if (Other.IsA('Pawn'))
        {
            bDrip = false;
            SetTimer(TouchDetonationDelay, false);
        }
    }

    simulated function AnimEnd(int Channel)
    {
        local float DotProduct;

        if (!bCheckedSurface)
        {
            DotProduct = SurfaceNormal dot Vect(0,0,-1);
            if (DotProduct > 0.7)
            {
                PlayAnim('Drip', 0.66);
                bDrip = true;
                SetTimer(DripTime, false);
                if (bOnMover)
                    BlowUp(Location);
            }
            else if (DotProduct > -0.5)
            {
                PlayAnim('Slide', 1.0);
                if (bOnMover)
                    BlowUp(Location);
            }
            bCheckedSurface = true;
        }
    }

    simulated function MergeWithGlob(int AdditionalGoopLevel)
    {
        local int NewGoopLevel, ExtraSplash;
        NewGoopLevel = AdditionalGoopLevel + GoopLevel;
        if (NewGoopLevel > MaxGoopLevel)
        {
            Rand3 = (Rand3 + 1) % 3;
            ExtraSplash = Rand3;
            if (Role == ROLE_Authority)
                SplashGlobs(NewGoopLevel - MaxGoopLevel + ExtraSplash);
            NewGoopLevel = MaxGoopLevel - ExtraSplash;
        }
        SetGoopLevel(NewGoopLevel);
        SetCollisionSize(GoopVolume*10.0, GoopVolume*10.0);

        Trail.mSpeedRange[0]=2.000000*GoopVolume;
        Trail.mSpeedRange[1]=20.000000*GoopVolume;
        Trail.mSizeRange[0]=30.000000*GoopVolume;
        Trail.mSizeRange[1]=50.000000*GoopVolume;

        PlaySound(ImpactSound, SLOT_Misc);
        PlayAnim('hit');
        bCheckedSurface = false;
        SetTimer(RestTime, false);
    }

}

function BlowUp(Vector HitLocation)
{
    local xEmitter FlameX;
    local rotator rot;

    if (Role == ROLE_Authority)
    {
        Damage = BaseDamage + Damage * GoopLevel;
        DamageRadius = DamageRadius * GoopVolume;
        MomentumTransfer = MomentumTransfer * GoopVolume;
        if (Physics == PHYS_Flying) MomentumTransfer *= 0.8;
        DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);

        rot = rotator(HitNormal2);

        FlameX=Spawn(class'MGFlameExpolsion',,, HitLocation, rot);
        FlameX.SetDrawScale(GoopLevel*flameX.default.DrawScale/2);
        FlameX.mSizeRange[1]=FlameX.default.mSizeRange[1]*GoopLevel;
        FlameX.mSizeRange[0]=FlameX.default.mSizeRange[0]*GoopLevel;
        FlameX.mSpeedRange[0]=FlameX.default.mSpeedRange[0]*GoopLevel;
        FlameX.mSpeedRange[1]=FlameX.default.mSpeedRange[1]*GoopLevel;
        FlameX.mGrowthRate=FlameX.default.mGrowthRate*GoopLevel*0.8;


    }

    PlaySound(ExplodeSound, SLOT_Misc, TransientSoundVolume*((GoopLevel/5)+1), ,TransientSoundRadius*GoopLevel);

    Destroy();
}

function SplashGlobs(int NumGloblings)
{
    local int g;
    local MGMagma NewGlob;
    local Vector VNorm;

    for (g=0; g<NumGloblings; g++)
    {
        NewGlob = Spawn(Class, self,, Location+GoopVolume*(CollisionHeight+4.0)*SurfaceNormal);
        if (NewGlob != None)
        {
            NewGlob.Velocity = (GloblingSpeed + FRand()*150.0) * (SurfaceNormal + VRand()*0.8);
            if (Physics == PHYS_Falling)
            {
                VNorm = (Velocity dot SurfaceNormal) * SurfaceNormal;
                NewGlob.Velocity += (-VNorm + (Velocity - VNorm)) * 0.1;
            }
        }
        //else log("unable to spawn globling");
    }
}

state Shriveling
{
    simulated function BeginState()
    {
        bProjTarget = false;
        PlayAnim('shrivel', 1.0);
    }

    simulated function AnimEnd(int Channel)
    {
        Destroy();
    }

    simulated function ProcessTouch(Actor Other, Vector HitLocation)
    {
    }
}

simulated function SetGoopLevel( int NewGoopLevel )
{
    GoopLevel = NewGoopLevel;
    GoopVolume = sqrt(float(GoopLevel));
    SetDrawScale(GoopVolume*default.DrawScale);
    LightBrightness = Min(100 + 15*GoopLevel, 255);
    LightRadius = 1.7 + 0.2*GoopLevel;
    MomentumTransfer = default.MomentumTransfer*GoopLevel;
}

defaultproperties
{
     BaseDamage=20
     GloblingSpeed=200.000000
     RestTime=10.250000
     TouchDetonationDelay=0.150000
     bMergeGlobs=True
     DripTime=1.800000
     MaxGoopLevel=10
     GoopLevel=1
     GoopVolume=1.000000
     ExplodeSound=Sound'WeaponSounds.BaseImpactAndExplosions.BExplosion3'
     Speed=1800.000000
     TossZ=0.000000
     bSwitchToZeroCollision=True
     Damage=23.000000
     DamageRadius=120.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'mm_SWXWeapons.DamTypeMGPri'
     ImpactSound=SoundGroup'WeaponSounds.BioRifle.BioRifleGoo2'
     ExplosionDecal=Class'XEffects.ShockAltDecal'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=10
     LightSaturation=200
     LightBrightness=150.000000
     LightRadius=0.600000
     bDynamicLight=True
     bNetTemporary=False
     bOnlyDirtyReplication=True
     Physics=PHYS_Falling
     LifeSpan=30.000000
     Mesh=VertMesh'XWeapons_rc.GoopMesh'
     DrawScale=1.200000
     Skins(0)=Texture'LavaMLFX.cp_lavarock1ML'
     AmbientGlow=80
     SoundVolume=255
     SoundRadius=100.000000
     CollisionRadius=2.000000
     CollisionHeight=2.000000
}
