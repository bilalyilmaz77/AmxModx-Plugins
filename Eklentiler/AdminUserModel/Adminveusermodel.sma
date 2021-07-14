#pragma semicolon 1

#include <amxmodx>
#include <reapi>

static const adminyetki = ADMIN_RESERVATION;

new const tmodels[][]={
	"Default Ct Model",
	"Admin T Model"
};
new const ctmodels[][]={
	"Default Ct Model",
	"Admin Ct Model"
};
public plugin_init(){
	register_plugin("Models","0.1","bilalgecer47");
	
	RegisterHookChain(RG_CBasePlayer_Spawn,"@RG_CBasePlayer_Spawn_Post",.post=true);
}
public plugin_precache(){
	for(new i;i<sizeof(tmodels);i++) {
		precache_model(fmt("models/player/%s/%s.mdl", tmodels[i], tmodels[i]));
	}
	for(new i;i<sizeof(ctmodels);i++) {
		precache_model(fmt("models/player/%s/%s.mdl", ctmodels[i], ctmodels[i]));
	}
	
}
@RG_CBasePlayer_Spawn_Post(const pPlayer) {
	if(!is_user_alive(pPlayer)) {
		return;
	}
	new guf;
	new TeamName:iTeam = get_member(pPlayer, m_iTeam);
	guf = get_user_flags(pPlayer);
	
	switch(iTeam) {
		case TEAM_TERRORIST: {
			if(guf & adminyetki){
				rg_set_user_model(pPlayer,tmodels[0]);
			}
			else{
				rg_set_user_model(pPlayer,tmodels[1][0]);
			}
		}
		case TEAM_CT: {
			if(guf & adminyetki){
				rg_set_user_model(pPlayer,ctmodels[0]);
			}
			else{
				rg_set_user_model(pPlayer,ctmodels[1][0]);
			}
		}
	}
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/
