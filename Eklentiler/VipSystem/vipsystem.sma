#pragma semicolon 1

#include <amxmodx>
#include <reapi>

#define yetki ADMIN_RESERVATION

new const cuce[] = "models/player/cuce/cuce.mdl";

new bool:damagex[MAX_CLIENTS+1];

public plugin_init() {
	register_plugin("V.I.P Sistemi", "1.0", "BİLΛL YILMΛZ");
	
	register_clcmd("say /vipbilgi","@bilgilendir");
	
	RegisterHookChain(RG_CBasePlayer_Spawn,"@oyuncudogdu",.post=true);
	RegisterHookChain(RG_CBasePlayer_TakeDamage, "@rTakeDamage", .post = false);
	set_task(25.0,"@bilgiver",1453);
}
public plugin_precache()
{
	precache_model(cuce);
	
}
public client_putinserver(id) {
	if(get_user_flags(id) & yetki){
		damagex[id]=true;
	}
}
public client_disconnected(id) {
	remove_task(id);
	damagex[id]=false;
}
@oyuncudogdu(id){
	if(!is_user_alive(id)) {
		return;
	}
	if(get_user_flags(id) & yetki){
		if(get_member(id,m_iTeam)==TEAM_TERRORIST){
			set_task(1.0,"@canver",id);
			rg_set_user_model(id,  "cuce");
			damagex[id]=true;
		}
	}
}
@canver(id){
	set_entvar(id, var_health, Float:get_entvar(id, var_health) +  250);
}
@rTakeDamage(victim,inflictor,attacker,Float:damage,damage_bits){
	#pragma unused inflictor,damage_bits
	if(is_user_connected(attacker) && is_user_connected(victim) && victim!=attacker){
		
		if(damagex[attacker]){
			SetHookChainArg(4,ATYPE_FLOAT,damage*1.5);
		}
	}  
}
@bilgilendir(id){
	static motd[1280],len;
	len = formatex(motd, 1279,"<body bgcolor=black><font color=white><pre>");
	len += formatex(motd[len],1279-len,"<div style='color:blue;''><br><br><br>V.I.P fiyati 30Tl'dir.<br>");
	len += formatex(motd[len],1279-len,"V.I.P Ozellikleri asagida yazmaktadir.<br>");
	len += formatex(motd[len],1279-len,"V.I.P Modeli ile dogarsiniz.<br>");
	len += formatex(motd[len],1279-len,"V.I.P 250 Hp ile dogarsiniz.<br>");
	len += formatex(motd[len],1279-len,"V.I.P Ozel 1.5 kat hasar ozelliginiz olur.<br><br</div>");
	show_motd(id, motd, "V.I.P Hakkinda Bilgi");
}
@bilgiver() {
	client_print_color(0, 0, "^3[^4Bilgi^3] ^3Bu serverde V.I.P sistemi Vardir.");
	client_print_color(0, 0, "^3[^4Bilgi^3] ^3Bilgi almak icin /vipbilgi yazabilirsiniz.");
	set_task(25.0,"@bilgiver",1453);
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg1254\\ deff0\\ deflang1055{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ f0\\ fs16 \n\\ par }
*/
