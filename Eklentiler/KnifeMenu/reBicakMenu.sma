#include <amxmodx>
#include <reapi>

new const tag[]="Csduragi";  //Tagý editleyin

new gorunum[MAX_CLIENTS+1];

new bicakmodel[][][]={
	{"Default","models/v_knife.mdl"},
	{"Ursus Knife","models/bilalgecer47/v_ursus_crimson.mdl"},
	{"M9 Bayonet","models/bilalgecer47/v_m9_doppler.mdl"},
	{"Karambit","models/bilalgecer47/v_karambit_auto.mdl"},
	{"Kelebek","models/bilalgecer47/v_butterfly_marble.mdl"},
	{"Flip Knife","models/bilalgecer47/v_flip_lore.mdl"}
};
public plugin_init() {
	register_plugin( "Bicak Menu", "0.1", "bilalgecer47");
	
	new const menuclcmd[][]={
		"say /bicak","say /knife"
	};
	for(new i;i<sizeof(menuclcmd);i++){
		register_clcmd(menuclcmd[i],"@anamenu");
	}
	
	RegisterHookChain(RG_CBasePlayerWeapon_DefaultDeploy, "@CBasePlayerWeapon_DefaultDeploy_Pre", .post = false);
	
}

public plugin_precache() {
	for(new i = 0; i < sizeof(bicakmodel); i++) {
		precache_model(bicakmodel[i][1]);
	}
}
@CBasePlayerWeapon_DefaultDeploy_Pre(const pEntity, szViewModel[], szWeaponModel[], iAnim, szAnimExt[], skiplocal) {
	
	if(get_member(pEntity, m_iId) != WEAPON_KNIFE) {
		return;
	}
	new pPlayer = get_member(pEntity, m_pPlayer);
	
	SetHookChainArg(2, ATYPE_STRING, bicakmodel[gorunum[pPlayer]][1]);
	
}
@anamenu(const id){
	new menu = menu_create(fmt("\d%s \w| \yBicak Menu", tag), "@anamenu_devam");
	
	for(new i = 0; i < sizeof(bicakmodel); i++) {
		menu_additem(menu, fmt("\d%s \w| \y%s", tag, bicakmodel[i][0]), fmt("%d", i));
	}
	
	menu_setprop(menu, MPROP_EXITNAME, fmt("\d%s \w| \yCikis", tag));
	menu_display(id, menu);
}
@anamenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new data[6];menu_item_getinfo(menu,item,_,data,charsmax(data));
	new key = str_to_num(data);  
	gorunum[id] = key;
	rg_remove_item(id,"weapon_knife");rg_give_item(id,"weapon_knife");
	menu_destroy(menu); return PLUGIN_HANDLED;
}
