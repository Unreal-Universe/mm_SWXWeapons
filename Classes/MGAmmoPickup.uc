class MGAmmoPickup extends UTAmmoPickup;

defaultproperties
{
     AmmoAmount=25
     MaxDesireability=0.320000
     InventoryType=Class'tk_SWXWeapons.MGAmmo'
     PickupMessage="You picked up some Magma"
     PickupSound=Sound'PickupSounds.FlakAmmoPickup'
     PickupForce="FlakAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.BioAmmoPickup'
     Skins(1)=Texture'tk_SWXWeapons.Skins.MGInMagma'
     CollisionHeight=8.250000
}
