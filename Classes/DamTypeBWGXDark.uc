class DamTypeBWGXDark extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     WeaponClass=Class'tk_SWXWeapons.BWGX'
     DeathString="%o has joined the dark side thanks to %k."
     FemaleSuicide="%o tried to catch her dark ball."
     MaleSuicide="%o tried to catch his dark ball."
     FlashFog=(X=700.000000)
}
