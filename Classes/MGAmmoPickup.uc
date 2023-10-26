class MGAmmoPickup extends UTAmmoPickup;

defaultproperties
{
     AmmoAmount=25
     MaxDesireability=0.320000
     InventoryType=Class'mm_SWXWeapons.MGAmmo'
     PickupMessage="You picked up some Magma"
     PickupSound=Sound'PickupSounds.FlakAmmoPickup'
     PickupForce="FlakAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.BioAmmoPickup'
     Skins(1)=Texture'mm_SWXWeapons.MG.MGInMagma'
     CollisionHeight=8.250000
}
