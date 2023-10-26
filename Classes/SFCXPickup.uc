class SFCXPickup extends UTWeaponPickup;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Texture'XEffects.FlakTrailTex');
    L.AddPrecacheMaterial(Texture'XEffects.fexpt');
    L.AddPrecacheMaterial(Texture'XEffects.ExplosionFlashTex');
    L.AddPrecacheMaterial(Texture'mm_SWXWeapons.SFCXTex0');
    L.AddPrecacheMaterial(Texture'WeaponSkins.FlakTex1');
    L.AddPrecacheMaterial(Texture'WeaponSkins.FlakChunkTex');
    L.AddPrecacheMaterial(Texture'WeaponSkins.FlakSlugTex');
    L.AddPrecacheMaterial(Texture'XGameShaders.flak_flash');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.flakchunk');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.flakshell');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.FlakCannonPickup');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Texture'XEffects.FlakTrailTex');
    Level.AddPrecacheMaterial(Texture'XEffects.fexpt');
    Level.AddPrecacheMaterial(Texture'XEffects.ExplosionFlashTex');
    Level.AddPrecacheMaterial(Texture'mm_SWXWeapons.SFCXTex0');
    Level.AddPrecacheMaterial(Texture'WeaponSkins.FlakTex1');
    Level.AddPrecacheMaterial(Texture'WeaponSkins.FlakChunkTex');
    Level.AddPrecacheMaterial(Texture'WeaponSkins.FlakSlugTex');
    Level.AddPrecacheMaterial(Texture'XGameShaders.flak_flash');
}

simulated function UpdatePrecacheStaticMeshes()
{
	Level.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.flakchunk');
	Level.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.flakshell');
	Super.UpdatePrecacheStaticMeshes();
}

defaultproperties
{
     MaxDesireability=0.750000
     InventoryType=Class'mm_SWXWeapons.SFCX'
     PickupMessage="You got the super Flak Cannon X! GIBS AHOY!!"
     PickupSound=Sound'PickupSounds.FlakCannonPickup'
     PickupForce="FlakCannonPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.FlakCannonPickup'
     DrawScale=0.650000
     Skins(0)=Texture'mm_SWXWeapons.SFCX.SFCX3rdPerson'
}
