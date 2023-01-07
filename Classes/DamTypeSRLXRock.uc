class DamTypeSRLXRock extends WeaponDamageType
      abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';

    if( VictemHealth <= 0 && FRand() < 0.2 )
        HitEffects[1] = class'HitFlameBig';
    else if ( FRand() < 0.8 )
        HitEffects[1] = class'HitFlame';
}

defaultproperties
{
     WeaponClass=Class'tk_SWXWeapons.SRLX'
     DeathString="%o is a pile of bloddy gibs thanks to %k's super rocket."
     FemaleSuicide="%o fired her rocket up her ass."
     MaleSuicide="%o fired his rocket up his ass."
     bDetonatesGoop=True
     KDamageImpulse=20000.000000
}
