#pragma semicolon 1

#include <amxmodx>
#include <reapi>

#define FPSSINIR 180

new const tag[]="TeamTR";

new iFrames[MAX_PLAYERS+1];

public plugin_init() {
	register_plugin("reMaxFps", "1.0", "DPCS/bilalgecer47");
	RegisterHookChain(RG_CBasePlayer_PreThink,"@PlayerPreThink",.post=true);
}
@PlayerPreThink(id) {
	if(!is_user_alive(id)){
		return HC_BREAK;
	}
	iFrames[id]++;
	return HC_BREAK;
}
public client_authorized(id) {
	client_cmd(id, "fps_max 144;");
}
public client_putinserver(id){
	iFrames[id] = 0;
	set_task(1.0, "ShowFps",id+19075, _, _, "b");
}
public client_disconnected(id){
	if(task_exists(id+19075)){
		remove_task(id+19075);
	}
}
public ShowFps(id){
	id -= 19075;
	if(is_user_alive(id) && iFrames[id] >= FPSSINIR){
		new szName[33];
		get_user_name(id, szName, 33);
		client_print_color(0, 0,"^3[ ^4%s ^3] ^4%s Isimli Oyuncuda ^4%dFPS Tespit Edildigi Icin Slaplandi !",tag,szName, iFrames[id]);
		user_slap(id,50);
		client_cmd(id, "fps_max 144;");
	}
	iFrames[id] = 0;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/
