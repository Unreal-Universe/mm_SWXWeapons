class DamTypeBWGXLight extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     WeaponClass=Class'mm_SWXWeapons.BWGX'
     DeathString="%o saw %k's light from the wrong perspective."
     FemaleSuicide="%o blinded herself to death."
     MaleSuicide="%o blinded himself to death."
     FlashFog=(X=600.000000)
}
