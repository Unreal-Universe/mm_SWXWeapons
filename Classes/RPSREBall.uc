class RPSREBall extends xEmitter;

simulated function SoundChange(float Change)
{
    SoundVolume=FMin(255,default.SoundVolume*Change);
    SoundPitch=FMin(255,default.SoundPitch*Change);
    SoundRadius=FMin(255,default.SoundRadius*Change*Change);
}

defaultproperties
{
     mStartParticles=0
     mLifeRange(0)=0.005000
     mLifeRange(1)=0.005000
     mRegenRange(0)=200.000000
     mRegenRange(1)=200.000000
     mSpeedRange(0)=0.000000
     mSpeedRange(1)=0.000000
     mSpinRange(0)=-15.000000
     mSpinRange(1)=15.000000
     mSizeRange(0)=4.000000
     mSizeRange(1)=6.000000
     mGrowthRate=-10.000000
     mColorRange(1)=(B=0,G=0,R=0,A=0)
     mAttenKa=0.500000
     mAttenFunc=ATF_None
     mNumTileColumns=4
     mNumTileRows=4
     LightType=LT_Steady
     LightHue=100
     LightSaturation=100
     LightBrightness=160.000000
     LightRadius=24.000000
     AmbientSound=Sound'tk_SWXWeapons.RPSRhum'
     Texture=Texture'EmitterTextures.MultiFrame.Effect_A'
     Skins(0)=Texture'EmitterTextures.MultiFrame.Effect_A'
     Style=STY_Translucent
     SoundVolume=130
     SoundRadius=100.000000
}
