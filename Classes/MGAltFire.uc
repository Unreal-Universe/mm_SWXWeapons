class MGAltFire extends tk_ProjectileFire;

var int MGAmmoCount;

simulated function PostBeginPlay()
{
    MGAmmoCount = 0;
    super.PostBeginPlay();
}
function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

event ModeDoFire()
{
    if (!AllowFire())
        return;

    if (MaxHoldTime > 0.0)
        HoldTime = FMin(HoldTime, MaxHoldTime);

    // server
    if (Weapon.Role == ROLE_Authority)
    {
        Weapon.ConsumeAmmo(ThisModeNum, Load);
        DoFireEffect();
        if ( (Instigator == None) || (Instigator.Controller == None) )
			return;
        if ( AIController(Instigator.Controller) != None )
            AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);
        Instigator.SpawnTime = -100000;
    }

    // client
    if (Instigator.IsLocallyControlled())
    {
        ShakeView();
        PlayFiring();
    }
    else // server
    {
        ServerPlayFiring();
    }

    Weapon.IncrementFlashCount(ThisModeNum);

    MGAmmoCount=MGAmmoCount+1;
    if (MGAmmoCount==2)
    {
        Load = 1;
        MGAmmoCount = 0;
    }
    else
        Load = 0;
    HoldTime = 0;

    if (Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != None)
    {
        bIsFiring = false;
        Weapon.PutDown();
    }
}

defaultproperties
{
     ProjSpawnOffset=(X=20.000000,Y=9.000000,Z=-6.000000)
     bSplashDamage=True
     FireAnim="AltFire"
     FireAnimRate=1.500000
     FireRate=0.100000
     AmmoClass=Class'tk_SWXWeapons.MGAmmo'
     ShakeRotMag=(X=60.000000,Y=20.000000)
     ShakeRotRate=(X=1000.000000,Y=1000.000000)
     ShakeRotTime=2.000000
     ProjectileClass=Class'tk_SWXWeapons.MGFlame'
     BotRefireRate=0.100000
}
