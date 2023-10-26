class IceDustTrail extends RocketTrailSmoke;

function Timer()
{
    Destroy();
}

defaultproperties
{
     mMaxParticles=200
     mRegenRange(0)=60.000000
     mRegenRange(1)=60.000000
     Skins(0)=Texture'mm_SWXWeapons.IceDust'
}
