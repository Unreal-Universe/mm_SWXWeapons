class SFCXAltFire extends tk_ProjectileFire;

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter == None )
		FlashEmitter = Weapon.GetFireMode(0).FlashEmitter;
}

defaultproperties
{
     ProjSpawnOffset=(X=25.000000,Y=9.000000,Z=-12.000000)
     bSplashDamage=True
     bRecommendSplashDamage=True
     bTossed=True
     FireAnim="AltFire"
     FireEndAnim=
     FireSound=SoundGroup'WeaponSounds.FlakCannon.FlakCannonAltFire'
     FireForce="FlakCannonAltFire"
     FireRate=0.800000
     AmmoClass=Class'XWeapons.FlakAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-40.000000)
     ShakeOffsetRate=(X=-2000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'mm_SWXWeapons.SFCXShell'
     BotRefireRate=0.400000
     WarnTargetPct=0.900000
}
