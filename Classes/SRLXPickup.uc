class SRLXPickup extends UTWeaponPickup;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'WeaponSkins.RocketShellTex');
    L.AddPrecacheMaterial(Material'XEffects.RocketFlare');
    L.AddPrecacheMaterial(Material'XEffects.SmokeAlphab_t');
    L.AddPrecacheMaterial(Material'EmitterTextures.rockchunks02');
    L.AddPrecacheMaterial(Texture'XGameShaders.MinigunFlash');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.rocketproj');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.RocketLauncherPickup');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'WeaponSkins.RocketShellTex');
    Level.AddPrecacheMaterial(Material'XEffects.RocketFlare');
    Level.AddPrecacheMaterial(Material'XEffects.SmokeAlphab_t');
    Level.AddPrecacheMaterial(Material'EmitterTextures.rockchunks02');
    Level.AddPrecacheMaterial(Texture'XGameShaders.MinigunFlash');
}

simulated function UpdatePrecacheStaticMeshes()
{
	Level.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.rocketproj');
	Super.UpdatePrecacheStaticMeshes();
}

defaultproperties
{
     MaxDesireability=0.780000
     InventoryType=Class'tk_SWXWeapons.SRLX'
     PickupMessage="You got the super Rocket Launcher X. You are now a GOD!"
     PickupSound=Sound'PickupSounds.RocketLauncherPickup'
     PickupForce="RocketLauncherPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.RocketLauncherPickup'
     DrawScale=0.500000
     Skins(0)=Texture'tk_SWXWeapons.SRLX.srlx01'
}
