class BWGXAttachement extends xWeaponAttachment;

var BWGXDarkMuz3rd MuzDark;
var BWGXLightMuz3rd MuzFlash;

simulated function Destroyed()
{
    if (MuzFlash != None)
        MuzFlash.Destroy();

    Super.Destroyed();
}

simulated event ThirdPersonEffects()
{
    if ( Level.NetMode != NM_DedicatedServer && FlashCount > 0 )
	{
        if (FiringMode == 0)
        {
                MuzFlash = Spawn(class'BWGXLightMuz3rd');
                AttachToBone(MuzFlash, 'tip');
        }
        else
        {
                MuzDark = Spawn(class'BWGXDarkMuz3rd');
                AttachToBone(MuzFlash, 'tip');

        }
    }

    Super.ThirdPersonEffects();
}

defaultproperties
{
     bRapidFire=True
     bAltRapidFire=True
     Mesh=SkeletalMesh'Weapons.LinkGun_3rd'
     Skins(0)=Texture'tk_SWXWeapons.BWGX.BWGtex0'
}
