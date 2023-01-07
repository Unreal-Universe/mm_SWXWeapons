class SWIGFire extends tk_ProjectileFire;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

    p = Super.SpawnProjectile(Start,Dir);
	return p;
}

defaultproperties
{
     ProjSpawnOffset=(X=24.000000,Y=8.000000,Z=-3.000000)
     TransientSoundVolume=0.400000
     FireAnim="AltFire"
     FireAnimRate=1.500000
     FireSound=SoundGroup'WeaponSounds.ShockRifle.ShockRifleAltFire'
     FireForce="ShockRifleAltFire"
     FireRate=0.360000
     AmmoClass=Class'tk_SWXWeapons.SWIGAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=60.000000,Y=20.000000)
     ShakeRotRate=(X=1000.000000,Y=1000.000000)
     ShakeRotTime=2.000000
     ProjectileClass=Class'tk_SWXWeapons.IceShard'
     BotRefireRate=0.260000
     FlashEmitterClass=Class'XEffects.ShockProjMuzFlash'
}
