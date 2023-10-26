class SWGGAltFire extends tk_ProjectileFire;

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
     BarrelRotationsPerSec=default.BarrelRotationsPerSec*2;
     RoundsPerRotation=default.RoundsPerRotation*2;

     FireRate = 1.f / (RoundsPerRotation * BarrelRotationsPerSec);
     MaxRollSpeed = 65536.f*BarrelRotationsPerSec;

     WindUpTime=default.WindUpTime/2;
     PreFireTime=default.PreFireTime/2;
}

function StopBerserk()
{
     BarrelRotationsPerSec=BarrelRotationsPerSec/2;
     RoundsPerRotation=RoundsPerRotation/2;

     FireRate = 1.f / (RoundsPerRotation * BarrelRotationsPerSec);
     MaxRollSpeed = 65536.f*BarrelRotationsPerSec;

     WindUpTime=WindUpTime*2;
     PreFireTime=PreFireTime*2;
}


function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

    Dir.Yaw += Spread*(32768)*(FRand()-0.5);
    Dir.Pitch += Spread*(32768)*(FRand()-0.5);
    Dir.Roll += Spread*(32768)*(FRand()-0.5);

    if( ProjectileClass != none )
        p = Spawn(ProjectileClass,,, Start, Dir);

    if( p == None )
        return None;

    p.Damage *= DamageAtten;
    return p;
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
        if (ThisModeNum == 1)
        {
            if ( (Weapon == None) || !Weapon.GetFireMode(0).bIsFiring )
                StopForceFeedback(WindingForce);
        }
        else
        {
            if ( (Weapon == None) || !Weapon.GetFireMode(1).bIsFiring )
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
     BarrelRotationsPerSec=4.000000
     RoundsPerRotation=6
     WindingSound=Sound'WeaponSounds.Minigun.miniempty'
     FiringSound=Sound'WeaponSounds.Minigun.minialtfireb'
     WindUpTime=0.200000
     WindingForce="miniempty"
     ProjSpawnOffset=(X=100.000000,Y=18.000000,Z=-16.000000)
     bSplashDamage=True
     bRecommendSplashDamage=True
     bTossed=True
     PreFireTime=0.200000
     FireAnim="AltFire"
     FireEndAnim=
     FireLoopAnimRate=7.000000
     FireForce="FAssaultRifleAltFire"
     AmmoClass=Class'mm_SWXWeapons.SWGGAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=0.200000
     ProjectileClass=Class'mm_SWXWeapons.SWGGGrenade'
     BotRefireRate=0.100000
     WarnTargetPct=0.750000
     FlashEmitterClass=Class'XEffects.MinigunMuzFlash1st'
     aimerror=350.000000
     Spread=0.025000
     SpreadStyle=SS_Random
}
