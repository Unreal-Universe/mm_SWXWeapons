class SFCXFire extends tk_ProjectileFire;

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

defaultproperties
{
     ProjPerFire=27
     ProjSpawnOffset=(X=25.000000,Y=5.000000,Z=-6.000000)
     FireEndAnim=
     FireSound=SoundGroup'WeaponSounds.FlakCannon.FlakCannonFire'
     FireForce="FlakCannonFire"
     FireRate=0.550000
     AmmoClass=Class'XWeapons.FlakAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-40.000000)
     ShakeOffsetRate=(X=-2000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'mm_SWXWeapons.SFCXChunk'
     BotRefireRate=0.600000
     FlashEmitterClass=Class'XEffects.FlakMuzFlash1st'
     Spread=2400.000000
     SpreadStyle=SS_Random
}
