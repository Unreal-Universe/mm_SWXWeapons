class RPSRPickup extends UTWeaponPickup;

simulated function postbeginplay()
{
          playanim('idle');
          super.PostBeginPlay();
}

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'XGameShaders.WeaponEnvShader');
    L.AddPrecacheMaterial(Texture'SniperBorder');
    L.AddPrecacheMaterial(Texture'SniperFocus');
	L.AddPrecacheMaterial(Texture'SniperArrows');
	L.AddPrecacheMaterial(Texture'Engine.WhiteTexture');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'XGameShaders.WeaponEnvShader');
    Level.AddPrecacheMaterial(Texture'SniperBorder');
    Level.AddPrecacheMaterial(Texture'SniperFocus');
	Level.AddPrecacheMaterial(Texture'SniperArrows');
	Level.AddPrecacheMaterial(Texture'Engine.WhiteTexture');
}

defaultproperties
{
     MaxDesireability=0.650000
     InventoryType=Class'mm_SWXWeapons.RPSR'
     PickupMessage="You got the Retro-Plasma Sniper Rifle."
     PickupSound=Sound'PickupSounds.SniperRiflePickup'
     PickupForce="SniperRiflePickup"
     Mesh=SkeletalMesh'mm_SWXWeapons.RPSRmesh'
     DrawScale=0.100000
}
