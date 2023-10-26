
class MG extends tk_Weapon;

#EXEC OBJ LOAD FILE=InterfaceContent.utx

var bool bIsDoingFire;

function DropFrom(vector StartLocation)
{
	if ( bCanThrow && (Ammo[0].AmmoAmount == 0) )
		Ammo[0].AmmoAmount = 1;
    Super.DropFrom(StartLocation);
}

// AI Interface
function float GetAIRating()
{
	local Bot B;
	local float EnemyDist;
	local vector EnemyDir;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	// if retreating, favor this weapon
	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	if ( EnemyDist > 1500 )
		return 0.1;
	if ( B.IsRetreating() )
		return (AIRating + 0.4);
	if ( -1 * EnemyDir.Z > EnemyDist )
		return AIRating + 0.1;
	if ( (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon )
		return (AIRating + 0.3);
	if ( EnemyDist > 1000 )
		return 0.35;
	return AIRating;
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
	local Bot B;
	local float EnemyDist;

	B = Bot(Instigator.Controller);
	EnemyDist = VSize(B.Enemy.Location - Instigator.Location);

	if ( EnemyDist <= 1000)
	    return 1;
	return 0;
}

function float SuggestAttackStyle()
{
	local Bot B;
	local float EnemyDist;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0.4;

	EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
	if ( EnemyDist > 1000 )
		return 1.0;
	if ( EnemyDist > 400 )
		return 0.4;
	return -0.4;
}

function float SuggestDefenseStyle()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

	if ( VSize(B.Enemy.Location - Instigator.Location) < 250 )
		return -1.0;
	return 0;
}

// End AI Interface

simulated function AnimEnd(int Channel)
{
    local name anim;
    local float frame, rate;
    GetAnimParams(0, anim, frame, rate);

    if (anim == 'AltFire')
        LoopAnim('Hold', 1.0, 0.1);
    else
        Super.AnimEnd(Channel);
}

simulated function ClientStartFire(int mode)
{
    if ( mode == 0)
    {
        AmbientSound=none;
    }
    else if( bIsDoingFire == false )
    {
        AmbientSound=Sound'mm_SWXWeapons.SWMGFlame';
        bIsDoingFire = True;
    }
    Super.ClientStartFire(mode);
}

simulated function ClientStopFire(int mode)
{
    AmbientSound=None;
    bIsDoingFire = False;
    Super.ClientStopFire(mode);
}

defaultproperties
{
     FireModeClass(0)=Class'mm_SWXWeapons.MGPriFire'
     FireModeClass(1)=Class'mm_SWXWeapons.MGAltFire'
     PutDownAnim="PutDown"
     SelectSound=Sound'WeaponSounds.FlakCannon.SwitchToFlakCannon'
     SelectForce="SwitchToFlakCannon"
     AIRating=0.550000
     CurrentRating=0.550000
     EffectOffset=(X=100.000000,Y=32.000000,Z=-20.000000)
     DisplayFOV=60.000000
     Priority=7
     HudColor=(B=255,G=0,R=0)
     SmallViewOffset=(X=19.000000,Y=9.000000,Z=-6.000000)
     CenteredOffsetY=-8.000000
     InventoryGroup=3
     PickupClass=Class'mm_SWXWeapons.MGPickup'
     PlayerViewOffset=(X=7.000000,Y=3.000000)
     BobDamping=2.200000
     AttachmentClass=Class'mm_SWXWeapons.MGAttachement'
     IconMaterial=Texture'InterfaceContent.HUD.SkinA'
     IconCoords=(X1=322,Y1=281,X2=444,Y2=371)
     ItemName="Magma Gun"
     Mesh=SkeletalMesh'Weapons.BioRifle_1st'
     Skins(0)=Texture'mm_SWXWeapons.SWMG.SWMGTex'
     Skins(2)=Texture'mm_SWXWeapons.MG.MGInBub'
     Skins(3)=Texture'mm_SWXWeapons.MG.MGInMagma'
     UV2Texture=Shader'XGameShaders.WeaponShaders.WeaponEnvShader'
}
