class MGPriFire extends tk_ProjectileFire;

function float MaxRange()
{
	return 1500;
}

defaultproperties
{
     ProjSpawnOffset=(X=20.000000,Y=9.000000,Z=-3.000000)
     bSplashDamage=True
     bRecommendSplashDamage=True
     bTossed=True
     FireEndAnim=
     FireSound=SoundGroup'WeaponSounds.BioRifle.BioRifleFire'
     FireForce="BioRifleFire"
     FireRate=0.300000
     AmmoClass=Class'mm_SWXWeapons.MGAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=70.000000)
     ShakeRotRate=(X=1000.000000)
     ShakeRotTime=1.800000
     ShakeOffsetMag=(Z=-2.000000)
     ShakeOffsetRate=(Z=1000.000000)
     ShakeOffsetTime=1.800000
     ProjectileClass=Class'mm_SWXWeapons.MGMagma'
     BotRefireRate=0.700000
}
