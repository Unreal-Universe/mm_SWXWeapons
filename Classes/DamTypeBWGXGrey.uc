class DamTypeBWGXGrey extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     WeaponClass=Class'tk_SWXWeapons.BWGX'
     DeathString="%o never saw %k's big, smoking, hissing, powerfull grey matter comming."
     FemaleSuicide="%o got in the way of her grey matter."
     MaleSuicide="%o got in th way of his grey matter."
     bDetonatesGoop=True
     FlashFog=(X=700.000000)
}
