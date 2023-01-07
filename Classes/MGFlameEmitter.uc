class MGFlameEmitter extends xEmitter;

var int nCountT;

simulated function timer()
{
    nCountT++;
       SetDrawScale(default.DrawScale/4*(nCountT/2));
	if (nCountT == 14)
       mRegen = false;
    else
   	   SetTimer(0.05,false);
}

simulated function PostNetBeginPlay()
{
    nCountT = 0;
	SetTimer(0.05,false);
	Super.PostNetBeginPlay();
}

defaultproperties
{
     mStartParticles=0
     mMaxParticles=250
     mLifeRange(0)=0.300000
     mLifeRange(1)=0.500000
     mRegenRange(0)=200.000000
     mRegenRange(1)=200.000000
     mPosDev=(X=3.000000,Y=3.000000,Z=3.000000)
     mSpeedRange(0)=0.000000
     mSpeedRange(1)=100.000000
     mMassRange(0)=-1.000000
     mMassRange(1)=-1.200000
     mSizeRange(0)=0.000000
     mSizeRange(1)=45.000000
     mGrowthRate=5.000000
     mAttenKa=0.500000
     mNumTileColumns=4
     mNumTileRows=4
     Physics=PHYS_Trailer
     AmbientSound=Sound'GeneralAmbience.firefx11'
     LifeSpan=1.000000
     Skins(0)=Texture'EmitterTextures.MultiFrame.LargeFlames'
     Style=STY_Translucent
     SoundVolume=255
     SoundRadius=35.000000
}
