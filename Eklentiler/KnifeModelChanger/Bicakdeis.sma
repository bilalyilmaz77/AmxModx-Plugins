#pragma semicolon 1

#include <amxmodx>
#include <reapi>

public plugin_init() {
	register_plugin( "Def Bicak Model", "0.1", "BİLΛL YILMΛZ");
	
	RegisterHookChain(RG_CBasePlayerWeapon_DefaultDeploy, "@CBasePlayerWeapon_DefaultDeploy_Pre", .post = false);
}
public plugin_precache() {
	precache_model(fmt("models/v_ayyildiz.mdl"));
}
@CBasePlayerWeapon_DefaultDeploy_Pre(const pEntity, szViewModel[], szWeaponModel[], iAnim, szAnimExt[], skiplocal) {
	if(get_member(pEntity, m_iId) != WEAPON_KNIFE) {
		return;
	}
	SetHookChainArg(2, ATYPE_STRING, "models/v_ayyildiz.mdl");
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg1254\\ deff0\\ deflang1055{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ f0\\ fs16 \n\\ par }
*/
