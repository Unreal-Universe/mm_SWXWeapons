class SWGGPickup extends UTWeaponPickup;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Texture'XEffects.TracerT');
    L.AddPrecacheMaterial(Texture'XEffects.ShellCasingTex');
    L.AddPrecacheMaterial(Texture'XGameShaders.MinigunFlash');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.MinigunPickup');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Texture'XEffects.TracerT');
    Level.AddPrecacheMaterial(Texture'XEffects.ShellCasingTex');
    Level.AddPrecacheMaterial(Texture'XGameShaders.MinigunFlash');
}

defaultproperties
{
     MaxDesireability=0.730000
     InventoryType=Class'mm_SWXWeapons.SWGG'
     PickupMessage="You got the Super Weapons Gattling Gun. Holy Swiss cheese Batman!"
     PickupSound=Sound'PickupSounds.MinigunPickup'
     PickupForce="MinigunPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.MinigunPickup'
     DrawScale=0.600000
     Skins(0)=Texture'mm_SWXWeapons.SWGG.SWGGTex'
}
