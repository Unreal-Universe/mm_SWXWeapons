class RPSRBeamEffect extends xEmitter;

var Vector HitNormal,ViewOffset;
var coords BoneCoord;
var float VolumeMult;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        HitNormal;
}

function AimAt(Vector hl, Vector hn)
{
    HitNormal = hn;
    mSpawnVecA = hl;
    if (Level.NetMode != NM_DedicatedServer)
        SpawnEffects();
}

simulated function PostNetBeginPlay()
{
    if (Role < ROLE_Authority)
        SpawnEffects();
}

simulated function SpawnImpactEffects(rotator HitRot, vector EffectLoc)
{
    Spawn(class'RPARExplosion',,, EffectLoc, HitRot);
}

simulated function SpawnEffects()
{
    local xWeaponAttachment Attachment;

    if (Instigator != None)
    {
        if ( Instigator.IsFirstPerson() )
        {
			if ( (Instigator.Weapon != None) && (RPSR(Instigator.Weapon).zoomed==False) && (Instigator.Weapon.Instigator == Instigator) )
            {
                BoneCoord=Instigator.Weapon.GetBoneCoords('bEBall');

                SetLocation(BoneCoord.Origin);
            }
			else if (Instigator.Weapon != None)
            {
                ViewOffset=Instigator.location;
                ViewOffset.Z-=0.1;
				SetLocation(ViewOffset);
			}
            else
			    SetLocation(Instigator.Location);
        }
        else
        {
            Attachment = xPawn(Instigator).WeaponAttachment;
            if (Attachment != None && (Level.TimeSeconds - Attachment.LastRenderTime) < 1)
            {
                 SetLocation(RPSRAttachement(Attachment).GetEffectLocation());
            }
            else
                SetLocation(Instigator.Location + Instigator.EyeHeight*Vect(0,0,1) + Normal(mSpawnVecA - Instigator.Location) * 25.0);
        }
    }

    if ( EffectIsRelevant(mSpawnVecA + HitNormal*2,false) && (HitNormal != Vect(0,0,0)) )
		SpawnImpactEffects(Rotator(HitNormal),mSpawnVecA + HitNormal*2);

}

defaultproperties
{
     VolumeMult=1.000000
     mParticleType=PT_Beam
     mMaxParticles=10
     mLifeRange(0)=2.500000
     mRegenDist=150.000000
     mSizeRange(0)=5.000000
     mAttenKa=0.100000
     bReplicateInstigator=True
     bReplicateMovement=False
     RemoteRole=ROLE_SimulatedProxy
     NetPriority=3.000000
     LifeSpan=2.500000
     Texture=Texture'mm_SWXWeapons.RPSR.RPSRBeamTex'
     Skins(0)=Texture'mm_SWXWeapons.RPSR.RPSRBeamTex'
     Style=STY_Additive
}
