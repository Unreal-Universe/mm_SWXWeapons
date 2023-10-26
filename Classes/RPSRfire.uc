class RPSRfire extends tk_InstantFire;

var() class<RPSRBeamEffect> BeamEffectClass[5];

#exec OBJ LOAD FILE=..\Sounds\WeaponSounds.uax

var bool bIsOpen;
var() float HeadShotDamageMult;
var() float HeadShotRadius;
var() class<DamageType> DamageTypeHeadShot;
var float DamageMult;

simulated function PostBeginPlay()
{
    DamageMult=1;
    super.PostBeginPlay();
}

function DoFireEffect()
{
    local Vector StartTrace,X,Y,Z;
    local Rotator R, Aim;

    Instigator.MakeNoise(1.0);

    StartTrace = Instigator.Location + Instigator.EyePosition();
    if ( PlayerController(Instigator.Controller) != None )
    {
		// for combos - Whatever. Never hurts to keep it here, in case I screw up something if it gets out
	   Weapon.GetViewAxes(X,Y,Z);
		StartTrace = StartTrace + X*class'ShockProjFire'.Default.ProjSpawnOffset.X;
		if ( !Weapon.WeaponCentered() )
			StartTrace = StartTrace + Weapon.Hand * Y*class'ShockProjFire'.Default.ProjSpawnOffset.Y + Z*class'ShockProjFire'.Default.ProjSpawnOffset.Z;
	}

    Aim = AdjustAim(StartTrace, AimError);
	R = rotator(vector(Aim) + VRand()*FRand()*Spread);
    DoTrace(StartTrace, R);
}

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X, End, HitLocation, HitNormal, RefNormal;
    local Actor Other;
    local int Damage;
    local bool bDoReflect;
    local int ReflectNum;
    local float dist;

    ReflectNum = 0;
    while (true)
    {
        bDoReflect = false;
        X = Vector(Dir);
        End = Start + TraceRange * X;

        Other = Trace(HitLocation, HitNormal, End, Start, true);

        if ( Other != None && (Other != Instigator || ReflectNum > 0) )
        {
            if (bReflective && Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, DamageMin*0.25))
            {
                bDoReflect = true;
                HitNormal = Vect(0,0,0);
            }
            else if (!Other.bWorldGeometry)
            {
				Damage = DamageMin;
				if ( (DamageMin != DamageMax) && (FRand() > 0.5) )
					Damage += Rand(1 + DamageMax - DamageMin);
                Damage = Damage * DamageAtten;

				if ( (Pawn(Other) != None) && Other.GetClosestBone( HitLocation, X, dist, 'head', HeadShotRadius + ((DamageMult-1)*2)) == 'head' )
                    Other.TakeDamage(Damage * HeadShotDamageMult * DamageMult, Instigator, HitLocation, Momentum*X, DamageTypeHeadShot);
                else
                    Other.TakeDamage(Damage * DamageMult, Instigator, HitLocation, Momentum*X, DamageType);

                HitNormal = Vect(0,0,0);
            }
            else if ( WeaponAttachment(Weapon.ThirdPersonActor) != None )
				WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
        }
        else
        {
            HitLocation = End;
            HitNormal = Vect(0,0,0);
        }

        SpawnBeamEffect(Start, Dir, HitLocation, HitNormal, ReflectNum);

        if (bDoReflect && ++ReflectNum < 4)
        {
            //Log("reflecting off"@Other@Start@HitLocation);
            Start = HitLocation;
            Dir = Rotator(RefNormal); //Rotator( X - 2.0*RefNormal*(X dot RefNormal) );
        }
        else
        {
            break;
        }
    }
}

function ModeHoldFire()
{
    if (Weapon.AmmoAmount(ThisModeNum) > 0)
    {
        Super.ModeHoldFire();
        GotoState('Hold');
    }
}

simulated function bool AllowFire()
{
    return (Weapon.AmmoAmount(ThisModeNum) > 0 || DamageMult > 1);
}

function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
    local RPSRBeamEffect Beam;

    if (DamageMult>=2)
        Beam = Spawn(BeamEffectClass[4],,, Start, Dir);
    else if (DamageMult>=1.75)
        Beam = Spawn(BeamEffectClass[3],,, Start, Dir);
    else if (DamageMult>=1.50)
        Beam = Spawn(BeamEffectClass[2],,, Start, Dir);
    else if (DamageMult>=1.20)
        Beam = Spawn(BeamEffectClass[1],,, Start, Dir);
    else
        Beam = Spawn(BeamEffectClass[0],,, Start, Dir);

    if (ReflectNum != 0) Beam.Instigator = None; // prevents client side repositioning of beam start
    Beam.AimAt(HitLocation, HitNormal);
    GotoState('');
}

state Hold
{
    simulated function BeginState()
    {
        DamageMult = 1;
        SetTimer(0.125, true);

        Timer();
    }

    simulated function Timer()
    {
        local xWeaponAttachment Attachement;

        Attachement = xPawn(Instigator).WeaponAttachment;

        DamageMult=DamageMult+0.10;

        //Weapon.ConsumeAmmo(ThisModeNum, 1);
        if (DamageMult>=1.50)
            if (!bIsOpen){ Weapon.PlayAnim('Open'); bIsOpen=True; Attachement.PlayAnim('Open'); }

        if (DamageMult == 2)
        {
            //FreezeAnimAt(DamageMult-1/1, 0);
            SetTimer(0.0, false);
            GotoState('');
        }
    }

    simulated function EndState()
    {
        bIsOpen=False;
    }
}

function PlayFiring()
{
    local xWeaponAttachment Attachement;

    Attachement = xPawn(Instigator).WeaponAttachment;

    if (DamageMult >= 1.50)
    {
        Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
        Attachement.PlayAnim(FireAnim, FireAnimRate, TweenTime);
    }

    Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,,Default.FireAnimRate/FireAnimRate*FMin(2,DamageMult),false);
    ClientPlayForceFeedback(FireForce);  // jdf
    DamageMult=1;

    FireCount++;
}

defaultproperties
{
     BeamEffectClass(0)=Class'mm_SWXWeapons.RPSRBeamEffect'
     BeamEffectClass(1)=Class'mm_SWXWeapons.RPSRBeamEffectB'
     BeamEffectClass(2)=Class'mm_SWXWeapons.RPSRBeamEffectC'
     BeamEffectClass(3)=Class'mm_SWXWeapons.RPSRBeamEffectD'
     BeamEffectClass(4)=Class'mm_SWXWeapons.RPSRBeamEffectE'
     HeadShotDamageMult=2.000000
     HeadShotRadius=8.000000
     DamageTypeHeadShot=Class'XWeapons.DamTypeSniperHeadShot'
     DamageType=Class'mm_SWXWeapons.RPSRDamageType'
     DamageMin=60
     DamageMax=75
     TraceRange=17000.000000
     Momentum=600.000000
     bReflective=True
     bFireOnRelease=True
     FireAnim="Close"
     FireSound=Sound'mm_SWXWeapons.RPSRwhoom'
     FireForce="RPARalt"
     FireRate=0.600000
     AmmoClass=Class'mm_SWXWeapons.RPSRAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-8.000000)
     ShakeOffsetRate=(X=-600.000000)
     ShakeOffsetTime=3.200000
     BotRefireRate=0.600000
     aimerror=700.000000
}
