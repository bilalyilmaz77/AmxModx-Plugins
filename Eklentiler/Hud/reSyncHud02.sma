#pragma semicolon 1

#include <amxmodx>
#include <reapi>

new yasayan[MAX_STRING_LENGTH],olen[MAX_STRING_LENGTH],hudsync,g_szMapName[MAX_MAPNAME_LENGTH],g_elbasi=false;

public plugin_init(){
	register_plugin("Ustyazi", "1.0", "BİLΛL YILMΛZ");
	RegisterHookChain(RG_CSGameRules_RestartRound, "@CSGameRules_RestartRound", .post = false);
	bind_pcvar_string(register_cvar("yasayan_reklam", "TeamTR Community JailBreak"), yasayan, charsmax(yasayan));
	bind_pcvar_string(register_cvar("olen_reklam", "Bol yetkili slotluk ve komutculuk icin /ts3 yaziniz"), olen, charsmax(olen));
	hudsync =CreateHudSyncObj();
	rh_get_mapname(g_szMapName, charsmax(g_szMapName));
}
public client_putinserver(id){
	set_task(0.5, "@hud", id, .flags = "b");
}
public client_disconnected(id) {
	remove_task(id);
}
@CSGameRules_RestartRound() {
	g_elbasi = true;
	set_task(6.0,"@eski");
}
@eski(){
	g_elbasi = false;
}
@hud(id){
	new gun = get_member_game(m_iNumCTWins)+get_member_game(m_iNumTerroristWins)+1;
	new at,act;
	rg_initialize_player_counts(at,act);
	if(!g_elbasi){
		if(is_user_alive(id)){
			set_dhudmessage(255, 255, 255, -1.0, 0.0, 0, 0.0, 1.0, 2.0, 1.0);
			ShowSyncHudMsg(id, hudsync, "- %s - ^n CT : %d GUN [ - %i - ] T : %d",yasayan,act,gun, at);
		}
		else{
			set_dhudmessage(170, 170, 255, -1.0, 0.15, 1, 2.0, 1.0);
			ShowSyncHudMsg(id, hudsync,"- %s - ^n CT : %d GUN [ - %i - ] T : %d",olen,act,gun, at);
		}
	}
	else{
		set_dhudmessage(170, 170, 255, -1.0,0.18, 0, 4.0, 6.0);
		ShowSyncHudMsg(id,hudsync, "%s^nAktif Oyuncu: TE (%d) || CT (%d)^n%s^nOynanan Harita: %s",yasayan,at, act,olen, g_szMapName);
	}
}
