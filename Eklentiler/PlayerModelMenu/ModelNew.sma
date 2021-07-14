#include <amxmodx>
#include <reapi>

new const tag[]="Forum.CSD" ;

new models[MAX_CLIENTS+1];

new const tmodels[][]={
	"Csd_T",              //T Default Model
	"Assasin", 
	"Cj",
	"Matrix",
	"Tommy"
};
new const ctmodels[][]={
	"Gign",                //CT Default Model
	"Creeper",
	"BigSmoke",
	"Trololo"
};

public plugin_init()
{
	register_plugin("Karaktermenu","0.1","BİLΛL YILMΛZ");
	new const menuclcmd[][]={
		"say /karakter","say /karakterler","say /karaktermenu","say /skin"            //  menuye giris cmdleri
	}
	for(new i;i<sizeof(menuclcmd);i++){
		register_clcmd(menuclcmd[i],"@anamenu");
	}	
	register_clcmd("say /anamenu","@anamenu");
	
	RegisterHookChain(RG_CBasePlayer_Spawn,"@RG_CBasePlayer_Spawn_Post",1);
	
}
@RG_CBasePlayer_Spawn_Post(const pPlayer) {
  	if(!is_user_alive(pPlayer)) {
        return;
   	}
	new TeamName:iTeam = get_member(pPlayer, m_iTeam);
	
	switch(iTeam) {
		case TEAM_TERRORIST: {
			rg_set_user_model(pPlayer,  tmodels[models[pPlayer]]);
		}
		case TEAM_CT: {
			rg_set_user_model(pPlayer,  ctmodels[models[pPlayer]]);
		}
	}
}
public plugin_precache()
{
	for(new i;i<sizeof(tmodels);i++) {
		precache_model(fmt("models/player/%s/%s.mdl", tmodels[i], tmodels[i]));
	}
	for(new i;i<sizeof(ctmodels);i++) {
		precache_model(fmt("models/player/%s/%s.mdl", ctmodels[i], ctmodels[i]));
	}
	
}
@anamenu(id) {
	new bool:isTerrorist = bool:(get_member(id, m_iTeam) == TEAM_TERRORIST);
	
	new menu = menu_create(fmt("\d%s \w| \y%s Ozel Model Menu", tag, isTerrorist ? "T" : "CT"), isTerrorist ? "@tmodel_handler" : "@ctmodel_handler");
	
	if(isTerrorist) {
		for(new i = 0; i < sizeof(tmodels); i++) {
			menu_additem(menu, fmt("\d%s \w| \y%s", tag, tmodels[i]), fmt("%d", i));
		}
	}
	else {
		for(new i = 0; i < sizeof(ctmodels); i++) {
			menu_additem(menu, fmt("\d%s \w| \y%s", tag, ctmodels[i]), fmt("%d", i));
		}
	}
	
	menu_setprop(menu, MPROP_EXITNAME, "\yCikis");
	menu_display(id, menu);
}
@tmodel_handler(const id,const  menu,const item) {
	if( item == MENU_EXIT )
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new data[6];menu_item_getinfo(menu,item,_,data,charsmax(data));
	new key = str_to_num(data);  
	models[id] = key;
	rg_set_user_model(id,  tmodels[models[id]]);
	menu_destroy(menu); return PLUGIN_HANDLED;
}
@ctmodel_handler(const id,const  menu,const item) {
	if( item == MENU_EXIT )
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new data[6];menu_item_getinfo(menu,item,_,data,charsmax(data));
	new key = str_to_num(data);  
	models[id] = key;
	rg_set_user_model(id,  ctmodels[models[id]]);
	menu_destroy(menu); return PLUGIN_HANDLED;
}
