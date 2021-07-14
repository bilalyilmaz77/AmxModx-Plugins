#include <amxmodx>
#include <reapi>

#define PLUGIN "ezb�r��mme"
#define VERSION "1.0"
#define AUTHOR "bilalgecer"

#define TAG "TeamTR"

new const anases[] = "anases.wav"

new bool:stop[MAX_CLIENTS+1];

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_clcmd("say ezb�rc�me","anayer")
	register_clcmd("say ezb�r��me","anayer")
	register_clcmd("say ezbircime","anayer")
	register_clcmd("say ezbir�ime","anayer")
	
	RegisterHookChain(RG_CBasePlayer_RoundRespawn,"@rRound",.post=true);
}
public plugin_precache(){
	precache_sound(anases)
}
@rRound(id){
	stop[id]=false;
}
public anayer(id){
	if(is_user_alive(id) && !stop[id]){
		stop[id]=true;
		client_print_color(id, id,  "^4%s ^3Aynen karde�im ezb�r��me.",TAG);
		client_cmd(id,"say /ts3");
		rg_send_audio(0, anases);
	}
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/
