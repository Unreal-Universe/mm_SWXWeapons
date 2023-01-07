class BWGXPickup extends UTWeaponPickup;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Texture'tk_SWXWeapons.BWGXLightMuz');
	L.AddPrecacheStaticMesh(StaticMesh'NewWeaponPickups.LinkPickupSM');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Texture'tk_SWXWeapons.BWGX.BWGXLightMuz');
}

simulated function UpdatePrecacheStaticMeshes()
{
	Super.UpdatePrecacheStaticMeshes();
}

defaultproperties
{
     MaxDesireability=0.700000
     InventoryType=Class'tk_SWXWeapons.BWGX'
     PickupMessage="You got the Black and White Gun X. They can fly!"
     PickupSound=Sound'PickupSounds.LinkGunPickup'
     PickupForce="LinkGunPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.LinkGunPickup'
     DrawScale=0.600000
     Skins(0)=Texture'tk_SWXWeapons.BWGX.BWGtex0'
}
