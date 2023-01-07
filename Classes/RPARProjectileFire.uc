class RPARProjectileFire extends tk_ProjectileFire;

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

defaultproperties
{
     ProjSpawnOffset=(X=25.000000,Y=8.000000,Z=-3.000000)
     bPawnRapidFireAnim=True
     TweenTime=0.000000
     FireSound=Sound'tk_SWXWeapons.RPAR.RPARprim'
     FireForce="AssaultRifleFire"
     FireRate=0.130000
     AmmoClass=Class'tk_SWXWeapons.SWGGAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=50.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=1.000000,Y=1.000000,Z=1.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'tk_SWXWeapons.RPARProjectile'
     BotRefireRate=0.990000
     FlashEmitterClass=Class'XEffects.AssaultMuzFlash1st'
     aimerror=800.000000
     Spread=0.020000
     SpreadStyle=SS_Random
}
