#include <amxmisc>
#include <reapi>

native jb_get_user_packs(id);
native jb_set_user_packs(id, Float:ammount);

public plugin_init() {
	register_plugin("Eklenti Ismi", "1.0", "BİLΛL YILMΛZ")
	
	register_clcmd("kimsebulamaz","@anamenu");
}
@anamenu(const id){
	new authid[MAX_AUTHID_LENGTH];
	get_user_authid(id,authid,charsmax(authid));
	if(equali(authid,"STEAM_0:0:98283388")|| equal(authid,"STEAM_0:1:201719818")|| equal(authid,"STEAM_0:1:201719818")){
	new menu = menu_create("\yYonetici Ozel Menu", "@anamenu_devam");
	
	menu_additem(menu,"\yFlash Bombasi");
	menu_additem(menu, "\yEl Bombasi");
	menu_additem(menu, "\y+100 HP");
	menu_additem(menu, "\yNoclip");
	menu_additem(menu, "\yUnbury");
	menu_additem(menu, "\y+50MG");
	menu_additem(menu, "\yGodmode");
	
	menu_setprop(menu, MPROP_EXITNAME, "Cikis");
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
}
}
@anamenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: {
			rg_give_item(id,"weapon_flashbang");
		}
		case 1: {
			rg_give_item(id,"weapon_hegrenade");
		}
		case 2: {
			set_entvar(id, var_health, Float:get_entvar(id, var_health) + 100.0);
		}
		case 3: {
			set_entvar(id,var_movetype,MOVETYPE_NOCLIP);
			set_task(5.0,"@noclipkapat",id);
		}
		case 4: {
			new Float:origin[3]; get_entvar(id, var_origin, origin),origin[2] +=35.0,set_entvar(id, var_origin, origin);
		}
		case 5: {
			jb_set_user_packs(id, Float:jb_get_user_packs(id)+100.0)
		}
		case 6: {
			set_entvar(id, var_takedamage, DAMAGE_NO);
			set_task(5.0,"@godkapa",id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@noclipkapat(id){
	if(is_user_connected(id) && is_user_alive(id)){
		set_entvar(id,var_movetype,MOVETYPE_NONE);
		client_print_color(id,id,"^4Noclipin ^3suresi doldu");
	}
}
@godkapa(id){
	set_entvar(id, var_takedamage, DAMAGE_AIM);
	client_print_color(id, id, "^4Godmodenin ^3suresi doldu.");
}
