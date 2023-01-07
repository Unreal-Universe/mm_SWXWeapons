class MGPickup extends UTWeaponPickup;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Texture'XEffects.rocketblastmark');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.BioRiflePickup');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Texture'XEffects.rocketblastmark');
}

defaultproperties
{
     MaxDesireability=0.750000
     InventoryType=Class'tk_SWXWeapons.MG'
     PickupMessage="You got the Magma Gun! BURN BABY!"
     PickupSound=Sound'PickupSounds.FlakCannonPickup'
     PickupForce="FlakCannonPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.BioRiflePickup'
     DrawScale=0.700000
     Skins(0)=Texture'tk_SWXWeapons.SWMG.SWMGTex'
}
