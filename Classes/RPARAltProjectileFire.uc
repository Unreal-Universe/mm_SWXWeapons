class RPARAltProjectileFire extends tk_ProjectileFire;

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
    local RPARAltProjectile Proj;

    Start += Vector(Dir) * 10.0;
    Proj = Spawn(Class'tk_SWXWeapons.RPARAltProjectile',,, Start, Dir);
    return Proj;
}

defaultproperties
{
     LinkedFireSound=Sound'WeaponSounds.LinkGun.BLinkedFire'
     LinkedFireForce="BLinkedFire"
     ProjSpawnOffset=(X=25.000000,Y=8.000000,Z=-3.000000)
     FireLoopAnim=
     FireEndAnim=
     FireAnimRate=0.580000
     FireSound=Sound'tk_SWXWeapons.RPAR.RPARalt'
     FireForce="TranslocatorFire"
     FireRate=0.580000
     AmmoClass=Class'XWeapons.LinkAmmo'
     ShakeRotMag=(X=40.000000)
     ShakeRotRate=(X=2000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(Y=1.000000)
     ShakeOffsetRate=(Y=-2000.000000)
     ShakeOffsetTime=4.000000
     ProjectileClass=Class'tk_SWXWeapons.RPARAltProjectile'
     BotRefireRate=0.580000
     WarnTargetPct=0.100000
     FlashEmitterClass=Class'XEffects.LinkMuzFlashProj1st'
}
