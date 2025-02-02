class SWIGAmmoPickup extends UTAmmoPickup;

defaultproperties
{
     AmmoAmount=20
     InventoryType=Class'mm_SWXWeapons.SWIGAmmo'
     PickupMessage="You picked up a Frost Core. Brrr!"
     PickupSound=Sound'PickupSounds.ShockAmmoPickup'
     PickupForce="ShockAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.ShockAmmoPickup'
     DrawScale3D=(X=0.800000,Z=0.500000)
     PrePivot=(Z=32.000000)
     Skins(0)=Texture'mm_SWXWeapons.SWIG.SWIGAmmoTex'
     CollisionHeight=32.000000
}
