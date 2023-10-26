class SWGGPriFire extends tk_InstantFire;

// for controlling the roll of the barrel
var() float MaxRollSpeed;
var() float RollSpeed;
var() float BarrelRotationsPerSec;
var() int   RoundsPerRotation;
var() float FireTime;
var() Sound WindingSound;
var() Sound FiringSound;
var SWGG Gun;
var() float WindUpTime;

var() String FiringForce;
var() String WindingForce;

function StartBerserk()
{
    DamageMin = default.DamageMin * 1.5;
    DamageMax = default.DamageMax * 1.5;
}

function StopBerserk()
{
    DamageMin = default.DamageMin;
    DamageMax = default.DamageMax;
}

function StartSuperBerserk()
{
    DamageMin = default.DamageMin * 1.5;
    DamageMax = default.DamageMax * 1.5;
    BarrelRotationsPerSec = Default.BarrelRotationsPerSec * 0.667 * Level.GRI.WeaponBerserk;
    FireRate = 1.f / (RoundsPerRotation * BarrelRotationsPerSec);
    MaxRollSpeed = 65536.f*BarrelRotationsPerSec;
}

function PostBeginPlay()
{
    Super.PostBeginPlay();
    FireRate = 1.f / (RoundsPerRotation * BarrelRotationsPerSec);
    MaxRollSpeed = 65536.f*BarrelRotationsPerSec;
    Gun = SWGG(Owner);
}

function FlashMuzzleFlash()
{
    local rotator r;
    r.Roll = Rand(65536);
    Weapon.SetBoneRotation('Bone_Flash', r, 0, 1.f);
    Super.FlashMuzzleFlash();
}

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'flash');
}

function PlayAmbientSound(Sound aSound)
{
    if ( (SWGG(Weapon) == None) || (Instigator == None) || (aSound == None && ThisModeNum != Gun.CurrentMode) )
        return;

    Instigator.AmbientSound = aSound;
    Gun.CurrentMode = ThisModeNum;
}

function StopRolling()
{
    if (Gun == None || ThisModeNum != Gun.CurrentMode)
        return;

    RollSpeed = 0.f;
    Gun.RollSpeed = 0.f;
}

function PlayPreFire() {}
function PlayStartHold() {}
function PlayFiring() {}
function PlayFireEnd() {}
function StartFiring();
function StopFiring();
function bool IsIdle()
{
	return false;
}

auto state Idle
{
	function bool IsIdle()
	{
		return true;
	}

    function BeginState()
    {
        PlayAmbientSound(None);
        StopRolling();
    }

    function EndState()
    {
        PlayAmbientSound(WindingSound);
    }

    function StartFiring()
    {
        RollSpeed = 0;
		FireTime = (RollSpeed/MaxRollSpeed) * WindUpTime;
        GotoState('WindUp');
    }
}

state WindUp
{
    function BeginState()
    {
        ClientPlayForceFeedback(WindingForce);  // jdf
    }

    function EndState()
    {
        if (ThisModeNum == 0)
        {
            if ( (Weapon == None) || !Weapon.GetFireMode(1).bIsFiring )
                StopForceFeedback(WindingForce);
        }
        else
        {
            if ( (Weapon == None) || !Weapon.GetFireMode(0).bIsFiring )
                StopForceFeedback(WindingForce);
        }
    }

    function ModeTick(float dt)
    {
        FireTime += dt;
        RollSpeed = (FireTime/WindUpTime) * MaxRollSpeed;

        if ( !bIsFiring )
        {
			GotoState('WindDown');
			return;
		}

        if (RollSpeed >= MaxRollSpeed)
        {
            RollSpeed = MaxRollSpeed;
            FireTime = WindUpTime;
            Gun.UpdateRoll(dt, RollSpeed, ThisModeNum);
			GotoState('FireLoop');
            return;
        }

        Gun.UpdateRoll(dt, RollSpeed, ThisModeNum);
    }

    function StopFiring()
    {
        GotoState('WindDown');
    }
}

state FireLoop
{
    function BeginState()
    {
        NextFireTime = Level.TimeSeconds - 0.05; //fire now!
        PlayAmbientSound(FiringSound);
        ClientPlayForceFeedback(FiringForce);  // jdf
        Gun.LoopAnim(FireLoopAnim, FireLoopAnimRate, TweenTime);
        Gun.SpawnShells(RoundsPerRotation*BarrelRotationsPerSec);
    }

    function StopFiring()
    {
        GotoState('WindDown');
    }

    function EndState()
    {
        PlayAmbientSound(WindingSound);
        StopForceFeedback(FiringForce);  // jdf
        Gun.LoopAnim(Gun.IdleAnim, Gun.IdleAnimRate, TweenTime);
        Gun.SpawnShells(0.f);
     }

    function ModeTick(float dt)
    {
        Super.ModeTick(dt);
        Gun.UpdateRoll(dt, RollSpeed, ThisModeNum);
        if ( !bIsFiring )
        {
			GotoState('WindDown');
			return;
		}
    }
}

state WindDown
{
    function BeginState()
    {
        ClientPlayForceFeedback(WindingForce);  // jdf
    }

    function EndState()
    {
        if (ThisModeNum == 0)
        {
            if ( (Weapon == None) || !Weapon.GetFireMode(1).bIsFiring )
                StopForceFeedback(WindingForce);
        }
        else
        {
            if ( (Weapon == None) || !Weapon.GetFireMode(0).bIsFiring )
                StopForceFeedback(WindingForce);
        }
    }

    function ModeTick(float dt)
    {
        FireTime -= dt;
        RollSpeed = (FireTime/WindUpTime) * MaxRollSpeed;

        if (RollSpeed <= 0.f)
        {
            RollSpeed = 0.f;
            FireTime = 0.f;
            Gun.UpdateRoll(dt, RollSpeed, ThisModeNum);
            GotoState('Idle');
            return;
        }

        Gun.UpdateRoll(dt, RollSpeed, ThisModeNum);
    }

    function StartFiring()
    {
        GotoState('WindUp');
    }
}

defaultproperties
{
     BarrelRotationsPerSec=6.000000
     RoundsPerRotation=10
     WindingSound=Sound'WeaponSounds.Minigun.miniempty'
     FiringSound=Sound'mm_SWXWeapons.SWGG.SWGGFire'
     WindUpTime=0.270000
     FiringForce="minialtfireb"
     WindingForce="miniempty"
     DamageType=Class'mm_SWXWeapons.SWGGDamagePri'
     DamageMin=10
     DamageMax=14
     Momentum=1800.000000
     bPawnRapidFireAnim=True
     PreFireTime=0.270000
     FireLoopAnimRate=9.000000
     AmmoClass=Class'mm_SWXWeapons.SWGGAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=70.000000,Y=70.000000,Z=70.000000)
     ShakeRotRate=(X=15000.000000,Y=15000.000000,Z=15000.000000)
     ShakeRotTime=3.000000
     ShakeOffsetMag=(X=2.000000,Y=2.000000,Z=2.000000)
     ShakeOffsetRate=(X=1500.000000,Y=1500.000000,Z=1500.000000)
     ShakeOffsetTime=0.050000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'XEffects.MinigunMuzFlash1st'
     SmokeEmitterClass=Class'XEffects.MinigunAltMuzzleSmoke'
     aimerror=900.000000
     Spread=0.070000
     SpreadStyle=SS_Random
}
