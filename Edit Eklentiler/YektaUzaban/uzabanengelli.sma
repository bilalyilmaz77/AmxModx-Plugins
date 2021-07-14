#pragma semicolon 1

#include <amxmodx>
#include <reapi>

#define yetki ADMIN_BAN

new engel[MAX_CLIENTS+1],g_cvars[1];

public plugin_init(){
	register_plugin("UzaBAN", "1.0", "Yek'-ta - BİLΛL YILMΛZ");
	
	register_clcmd("amx_uzabanmenu", "@uzabanmenu");
	bind_pcvar_num(create_cvar("uzaban_siniri", "3"), g_cvars[0]);
}
public client_putinserver(id){
	engel[id]=0;
}
public client_disconnected(id){
	engel[id]=0;
}
@uzabanmenu(const id){
	if(get_user_flags(id) & yetki){
		if(engel[id] < g_cvars[0]){
			new menu = menu_create(fmt("\yUzaban Menu"), "@uzabanmenu_devam");
			
			for(new idc = 1, szStr[3]; idc <= MaxClients; idc++) {
				if(is_user_connected(idc) && !is_user_bot(idc)) {
					num_to_str(idc, szStr, charsmax(szStr));
					menu_additem(menu, fmt("%n", idc), szStr);
				}
			}
			menu_setprop(menu, MPROP_EXITNAME, "\yCikis");
			menu_display(id, menu);
		}
		else{
			client_print_color(0,0,"%n Adli Oyuncu %i'den fazla Uzaban atmaya calistigi icin banlandi!",id,g_cvars[0]);
			new authid[MAX_AUTHID_LENGTH],address[MAX_IP_LENGTH],userid = get_user_userid(id);
			get_user_ip(id, address, 31, 1);
			get_user_authid(id, authid, 31);
			server_cmd("kick #%d ^"UzaBAN ile banlandiniz^";wait;banid 999999999999 %s;wait;writeid", userid, authid);
		}
	}
	return PLUGIN_HANDLED;
}
@uzabanmenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT){
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new data[6], idc;
	menu_item_getinfo(menu, item, _, data, charsmax(data));
	idc = str_to_num(data);
	if(!is_user_connected(idc)) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	@cmduzaban(id,idc);
	engel[id] ++;
	remove_task(id+3331);
	set_task(60.0,"@bitir",id+3331);
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@cmduzaban(id,banlanan){	
	if (!banlanan){
		return PLUGIN_HANDLED;
	}
	new authid[MAX_AUTHID_LENGTH],address[MAX_IP_LENGTH],userid = get_user_userid(banlanan);
	get_user_ip(banlanan, address, 31, 1);
	get_user_authid(banlanan, authid, 31);
	server_cmd("kick #%d ^"UzaBAN ile banlandiniz^";wait;banid 999999999999 %s;wait;writeid", userid, authid);
	server_cmd("wait;addip ^"9999999999999^" ^"%s^";wait;writeip", address);
	client_print_color(0,0,"^4%s ^4Isimli admin ^4%s ^3Isimli oyuncuya ^4UZABAN ^3atti !", isimver(id), isimver(banlanan));
	log_to_file("Uzaban-Log.txt","%s Isimli admin %s Isimli oyuncuya UZABAN atti !", isimver(id), isimver(banlanan));
	return PLUGIN_HANDLED;
}
public isimver(oyuncu){
	new isim[MAX_NAME_LENGTH];
	get_user_name(oyuncu, isim, 31);
	return isim;
}
@bitir(const task){
	new id = task-3331;
	engel[id] = 0;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/
