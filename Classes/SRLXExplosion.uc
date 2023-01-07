class SRLXExplosion extends RocketExplosion;

simulated function PostBeginPlay()
{
	Spawn(class'RocketSmokeRing');
	if ( Level.bDropDetail )
		LightRadius = 10.5;
}

defaultproperties
{
     LightRadius=13.500000
     DrawScale=1.500000
}
