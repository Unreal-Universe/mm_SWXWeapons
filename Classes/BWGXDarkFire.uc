class BWGXDarkFire extends tk_ProjectileFire;

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

defaultproperties
{
     LinkedFireSound=Sound'WeaponSounds.LinkGun.BLinkedFire'
     LinkedFireForce="BLinkedFire"
     ProjSpawnOffset=(X=30.000000,Y=8.000000,Z=-3.000000)
     FireLoopAnim=
     FireEndAnim=
     FireAnimRate=0.750000
     FireSound=SoundGroup'WeaponSounds.PulseRifle.PulseRifleFire'
     FireForce="TranslocatorFire"
     FireRate=0.580000
     AmmoClass=Class'tk_SWXWeapons.BWGXAmmo'
     AmmoPerFire=5
     ShakeRotMag=(X=40.000000)
     ShakeRotRate=(X=2000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(Y=1.000000)
     ShakeOffsetRate=(Y=-2000.000000)
     ShakeOffsetTime=4.000000
     ProjectileClass=Class'tk_SWXWeapons.DarkProjectile'
     BotRefireRate=0.590000
     WarnTargetPct=0.100000
     FlashEmitterClass=Class'tk_SWXWeapons.BWGXDarkMuz'
}
