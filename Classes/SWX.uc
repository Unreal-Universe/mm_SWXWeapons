class SWX extends Mutator;

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    local int i;
	local WeaponLocker L;

    if ( xWeaponBase(Other) != None )
    {
        if ( xWeaponBase(Other).WeaponType == class'XWeapons.AssaultRifle' )
            xWeaponBase(Other).WeaponType = Class'mm_SWXWeapons.RPAR';
        else if ( xWeaponBase(Other).WeaponType == class'XWeapons.BioRifle' )
            xWeaponBase(Other).WeaponType = Class'mm_SWXWeapons.MG';
        else if ( xWeaponBase(Other).WeaponType == class'XWeapons.LinkGun' )
            xWeaponBase(Other).WeaponType = Class'mm_SWXWeapons.BWGX';
        else if ( xWeaponBase(Other).WeaponType == class'XWeapons.ShockRifle' )
            xWeaponBase(Other).WeaponType = Class'mm_SWXWeapons.SWIG';
        else if ( xWeaponBase(Other).WeaponType == class'XWeapons.RocketLauncher' )
            xWeaponBase(Other).WeaponType = Class'mm_SWXWeapons.SRLX';
        else if ( xWeaponBase(Other).WeaponType == class'XWeapons.FlakCannon' )
            xWeaponBase(Other).WeaponType = Class'mm_SWXWeapons.SFCX';
        else if ( xWeaponBase(Other).WeaponType == class'XWeapons.Minigun' )
            xWeaponBase(Other).WeaponType = Class'mm_SWXWeapons.SWGG';
        else if ( xWeaponBase(Other).WeaponType == class'XWeapons.SniperRifle' || xWeaponBase(Other).WeaponType == class'UTClassic.ClassicSniperRifle')
            xWeaponBase(Other).WeaponType = Class'mm_SWXWeapons.RPSR';
            return true;
    }
    else if (WeaponLocker(Other) != none )
    {
		L = WeaponLocker(Other);
        for (i = 0; i < L.Weapons.Length; i++)
        {
            if ( L.Weapons[i].WeaponClass == class'xWeapons.AssaultRifle' )
                L.Weapons[i].WeaponClass = Class'mm_SWXWeapons.RPAR';
            else if ( L.Weapons[i].WeaponClass == class'xWeapons.Minigun' )
                L.Weapons[i].WeaponClass = Class'mm_SWXWeapons.SWGG';
            else if ( L.Weapons[i].WeaponClass == class'xWeapons.BioRifle' )
                L.Weapons[i].WeaponClass = Class'mm_SWXWeapons.MG';
            else if ( L.Weapons[i].WeaponClass == class'xWeapons.LinkGun' )
                L.Weapons[i].WeaponClass = Class'mm_SWXWeapons.BWGX';
            else if ( L.Weapons[i].WeaponClass == class'xWeapons.ShockRifle' )
                L.Weapons[i].WeaponClass = Class'mm_SWXWeapons.SWIG';
            else if ( L.Weapons[i].WeaponClass == class'xWeapons.RocketLauncher' )
                L.Weapons[i].WeaponClass = Class'mm_SWXWeapons.SRLX';
            else if ( L.Weapons[i].WeaponClass == class'xWeapons.FlakCannon' )
                L.Weapons[i].WeaponClass = Class'mm_SWXWeapons.SFCX';
            else if ( L.Weapons[i].WeaponClass == class'xWeapons.SniperRifle' || L.Weapons[i].WeaponClass == class'ClassicSniperRifle' )
                L.Weapons[i].WeaponClass = Class'mm_SWXWeapons.RPSR';
        }
        return true;
    }
    else if ( WeaponPickup(Other) != None )
    {
        if ( string(Other.Class) == "xWeapons.AssaultRiflePickup" )
            ReplaceWith( Other, "SWX.RPARPickup");
        else if ( string(Other.Class) == "xWeapons.RocketLauncherPickup" )
            ReplaceWith( Other, "SWX.SRLPickup");
        else if ( string(Other.Class) == "xWeapons.FlakCannonPickup" )
            ReplaceWith( Other, "SWX.SFCXPickup");
        else if ( string(Other.Class) == "xWeapons.LinkGunPickup" )
            ReplaceWith( Other, "SWX.BWGXPickup");
        else if ( string(Other.class) == "xWeapons.ShockRiflePickup" )
            ReplaceWith( Other, "SWX.SWIGPickup");
        else if ( string(Other.Class) == "xWeapons.BioRiflePickup" )
            ReplaceWith( Other, "SWX.MGPickup");
        else if ( string(Other.Class) == "xWeapons.MinigunPickup" )
            ReplaceWith( Other, "SWX.SWGGPickup");
        else if ( string(Other.Class) == "xWeapons.SniperRiflePickup" || string(Other.Class) == "UTClassic.ClassicSniperRiflePickup")
            ReplaceWith( Other, "SWX.RPSRPickup");
            return true;
    }
    else if ( Inventory(Other) != none )
    {
        if ( string(Other.Class) == "xWeapons.LinkAmmo")
            ReplaceWith( Other, "SWX.BWGXAmmo");
        else if ( string(Other.Class) == "xWeapons.BioAmmo")
            ReplaceWith( Other, "SWX.MGAmmo");
        else if ( string(Other.class) == "xWeapons.ShockAmmo")
            ReplaceWith( Other, "SWX.SWIGAmmo");
        else if ( string(Other.Class) == "xWeapons.MinigunAmmo")
            ReplaceWith( Other, "SWX.SWGGAmmo");
        else if ( string(Other.Class) == "xWeapons.SniperAmmo" || string(Other.Class) == "UTClassic.ClassicSniperAmmo")
            ReplaceWith( Other, "SWX.RPSRAmmo");
           return true;
    }
    else if ( Pickup(Other) != none )
    {
        if ((string(Other.class) == "XWeapons.BioAmmoPickup"))
            ReplaceWith(Other, "SWX.MGAmmoPickup");
        else if ((string(Other.class) == "XWeapons.LinkAmmoPickup"))
            ReplaceWith(Other, "SWX.BWGXAmmoPickup");
        else if ((string(Other.class) == "XWeapons.ShockAmmoPickup"))
            ReplaceWith(Other, "SWX.SWIGAmmoPickup");
        else if ((string(Other.class) == "XWeapons.MinigunAmmoPickup"))
            ReplaceWith(Other, "SWX.SWGGAmmoPickup");
        else if ((string(Other.class) == "XWeapons.SniperAmmoPickup") || (string(Other.class) == "UTClassic.ClassicSniperAmmoPickup"))
            ReplaceWith(Other, "SWX.RPSRAmmoPickup");
            return true;
    }
    else
        return true;
    return false;
}

function string GetInventoryClassOverride(string InventoryClassName)
{
    if ( InventoryClassName=="XWeapons.AssaultRifle")
        InventoryClassName="SWX.RPAR";

    if ( NextMutator != None )
        return NextMutator.GetInventoryClassOverride(InventoryClassName);

    return InventoryClassName;
}

defaultproperties
{
     DefaultWeapon=Class'mm_SWXWeapons.RPAR'
     DefaultWeaponName="Retro-Plasma Assault Rifle"
     GroupName="SWX"
     FriendlyName="MM_Super Weapons X"
     Description="Play with all available super Weapons X!"
}
