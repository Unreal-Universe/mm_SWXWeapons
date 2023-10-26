class RPSRAttachement extends xWeaponAttachment;

var() RPSREBall EBall;
var() rotator RotAdjust;

//self.PlayAnim

simulated function PostBeginPlay()
{
    playanim('idle');
    RotAdjust=Rotation;
    RotAdjust.Yaw=RotAdjust.Yaw+16384;
    SetRotation(RotAdjust);

    super.PostBeginPlay();
}

simulated function Vector GetTipLocation()
{
    local Coords C;
    C = GetBoneCoords('bBase');
    return C.Origin;
}

simulated function Vector GetEffectLocation()
{
    local Coords C;
    C = GetBoneCoords('bEBall');
    return C.Origin;
}

simulated function Destroyed()
{
    if (EBall != None)
        EBall.Destroy();

    Super.Destroyed();
}

simulated event ThirdPersonEffects()
{
    if ( Level.NetMode != NM_DedicatedServer )
    {
        if (EBall == None)
        {
            EBall = Spawn(class'RPSREBall',self);
            AttachToBone(EBall,'bEBall');
            EBall.SoundVolume=0;
        }
        WeaponLight();
    }

    Super.ThirdPersonEffects();
}

defaultproperties
{
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=100
     LightSaturation=100
     LightBrightness=160.000000
     LightRadius=24.000000
     Mesh=SkeletalMesh'mm_SWXWeapons.RPSCmesh3rd'
     DrawScale=0.100000
}
