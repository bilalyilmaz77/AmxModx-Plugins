#pragma semicolon 1

#include <amxmodx>
#include <amxmisc>

static const admin = ADMIN_RESERVATION;

public plugin_init() {
	register_plugin("Admin Chat-Duyuru", "1.0", "BİLΛL YILMΛZ");
	
	register_concmd("amx_x","@yazdirt",admin,"Yazi yaz");
	
	register_clcmd("say /x", "@okut",admin);
	register_clcmd("admin_chat", "@yazdirt",admin);
}
@yazdirt(const id, const level, const cid){
	if(!cmd_access(id, level, cid, 2))
	{
		return PLUGIN_HANDLED;
	}
	new arg[64];
	read_args(arg, sizeof(arg) - 1);
	remove_quotes(arg);
	if(equal(arg, "")){
	return PLUGIN_HANDLED;
	}
	new players[MAX_PLAYERS], iNum, idx;
	get_players(players, iNum);
	
	for(new i = 0; i < iNum; i++) {
		idx = players[i];
		if(get_user_flags(idx) & admin){
			client_print_color(idx,idx,"^4Admin Chat ^3- %s : ^1%s",name(id),arg);
		}
	}
	return PLUGIN_HANDLED;
}
name(const id){
	static name[32];
	get_user_name(id, name, charsmax(name));
	return name;
}
@okut(const id, const level, const cid){
	if(!cmd_access(id, level, cid, 2))
	{
		return PLUGIN_HANDLED;
	}
	client_cmd(id, "messagemode admin_chat");
	return PLUGIN_HANDLED;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg1254\\ deff0\\ deflang1055{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ f0\\ fs16 \n\\ par }
*/
