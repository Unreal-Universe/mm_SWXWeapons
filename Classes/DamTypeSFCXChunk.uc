class DamTypeSFCXChunk extends WeaponDamageType
	abstract;

var sound FlakMonkey;

static function IncrementKills(Controller Killer)
{
	local xPlayerReplicationInfo xPRI;

	xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	if ( xPRI != None )
	{
		xPRI.flakcount++;
		if ( (xPRI.flakcount == 15) && (UnrealPlayer(Killer) != None) )
			UnrealPlayer(Killer).ClientDelayedAnnouncement(Default.FlakMonkey,15);
	}
}

defaultproperties
{
     FlakMonkey=Sound'AnnouncerMain.FlackMonkey'
     WeaponClass=Class'tk_SWXWeapons.SFCX'
     DeathString="%o was minced by %k's Super Flak Cannon X!"
     FemaleSuicide="%o aimed her Super Flak Cannon at a wall."
     MaleSuicide="%o aimed his Super Flak Cannon at a wall."
}
