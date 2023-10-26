class RPSRAmmoPickup extends UTAmmoPickup;

defaultproperties
{
     AmmoAmount=10
     InventoryType=Class'mm_SWXWeapons.RPSRAmmo'
     PickupMessage="You picked up RPSR Batteries."
     PickupSound=Sound'PickupSounds.SniperAmmoPickup'
     PickupForce="SniperAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.SniperAmmoPickup'
     Skins(0)=Texture'mm_SWXWeapons.RPSR.RPSRAmmoTex'
     CollisionHeight=19.000000
}
