class BWGXLightFire extends tk_ProjectileFire;

var sound LinkedFireSound;
var string LinkedFireForce;  // jdf

function DrawMuzzleFlash(Canvas Canvas)
{
    if (FlashEmitter != None)
    {
        FlashEmitter.SetRotation(Weapon.Rotation);
        Super.DrawMuzzleFlash(Canvas);
    }
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local LightProjectile Proj;

    Start += Vector(Dir) * 10.0 * BWGX(Weapon).Links;
    Proj = Spawn(Class'mm_SWXWeapons.LightProjectile',,, Start, Dir);

    return Proj;
}

defaultproperties
{
     LinkedFireSound=Sound'WeaponSounds.LinkGun.BLinkedFire'
     LinkedFireForce="BLinkedFire"
     ProjSpawnOffset=(X=25.000000,Y=8.000000,Z=-3.000000)
     FireLoopAnim=
     FireEndAnim=
     FireAnimRate=0.550000
     FireSound=SoundGroup'WeaponSounds.PulseRifle.PulseRifleFire'
     FireForce="TranslocatorFire"
     FireRate=0.180000
     AmmoClass=Class'mm_SWXWeapons.BWGXAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=40.000000)
     ShakeRotRate=(X=2000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(Y=1.000000)
     ShakeOffsetRate=(Y=-2000.000000)
     ShakeOffsetTime=4.000000
     ProjectileClass=Class'mm_SWXWeapons.LightProjectile'
     BotRefireRate=0.990000
     WarnTargetPct=0.100000
     FlashEmitterClass=Class'mm_SWXWeapons.BWGXLightMuz'
}
