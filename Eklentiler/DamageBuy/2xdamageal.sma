#pragma semicolon 1

#include <amxmodx>
#include <reapi>

new const tag[]="XX-GaminG";

new bool:damagex[MAX_CLIENTS+1],ucret;

public plugin_init()
{
	register_plugin("damageal", "0.1", "bilalgecer47");
	register_clcmd("say /2xdamage","@2xdamage");
	register_clcmd("say /2x","@2xdamage");
	register_clcmd("say /damage","@2xdamage");
	
	RegisterHookChain(RG_CBasePlayer_TakeDamage,"@rTakeDamage",.post=false);
	RegisterHookChain(RG_CBasePlayer_Spawn,"@rSpawn",.post=true);
	
	bind_pcvar_num(create_cvar("damage_fiyat","5000"), ucret);
}
@rSpawn(id){
	damagex[id] = false;
}
@2xdamage(id){
	if(get_member(id,m_iAccount)>=ucret){
		rg_add_account(id, get_member(id, m_iAccount) - ucret, AS_SET);
		damagex[id]=true;
		client_print_color(id,id,"%s ^1Hey^4, ^1basarili bir sekilde ^3[^4Hasar Katla^3] ^1aldin^4!",tag);
	}
	else{
		client_print_color(id,id,"%s ^1Uzgunum^4, ^1bunu almak icin ^3paran yetersiz^4!",tag);
	}
}
@rTakeDamage(victim,inflictor,attacker,Float:damage,damage_bits){
	#pragma unused inflictor,damage_bits
	if(is_user_connected(attacker) && is_user_connected(victim) && victim!=attacker){
		
		if(damagex[attacker]){
			SetHookChainArg(4,ATYPE_FLOAT,damage*2);
		}
	}  
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg1254\\ deff0\\ deflang1055{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ f0\\ fs16 \n\\ par }
*/
