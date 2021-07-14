#pragma semicolon 1

#include <amxmodx>
#include <amxmisc>
#include <reapi>

new vipyetki = ADMIN_LEVEL_E,yonetici = ADMIN_IMMUNITY;

enum _:tags {
	tag,
	serverip,
	menuusttag
};
new const g_sztags[tags][] = {
	"TeamTR",
	"213.238.173.77",
	"TeamTR Community"
};
enum _:sesler {
	sayfa,
	yetersiz,
	satinal
};
new const g_szSounds[sesler][] = {
	"skb_sounds/page.wav",
	"skb_sounds/yetersizsoun.wav",
	"skb_sounds/buy.wav"
};
new const bicakmodel[][][]={
	{"Default","models/v_knife.mdl",0},
	{"Ursus Knife","models/bilalgecer47/v_ursus_crimson.mdl",10},
	{"M9 Bayonet","models/bilalgecer47/v_m9_doppler.mdl",10},
	{"Karambit","models/bilalgecer47/v_karambit_auto.mdl",10},
	{"Kelebek","models/bilalgecer47/v_butterfly_marble.mdl",10},
	{"Flip Knife","models/bilalgecer47/v_flip_lore.mdl",10}
	/* Ornek Bicak ekleme{"Menudeki ismi","Bicak Model Yolu",Parasi}*/
};
new const akmodel[][][]={
	{"Normal Ak-47","models/bilalgecer47/saklambac_def_ak47.mdl"},
	{"Vip Ak-47","models/bilalgecer47/saklambac_vip_ak47.mdl"}
};
new para[MAX_CLIENTS+1],bool:vipengel[MAX_CLIENTS+1],gorunum[MAX_CLIENTS+1],akswitch[MAX_CLIENTS+1],g_cvars[12];

public plugin_init(){
	register_plugin("Bos Menu","0.1","bilalgecer47");
	
	new const menuclcmd[][]={
		"nightvision","say /saklambacmenu","say !saklambacmenu","say .saklambacmenu","say_team /saklambacmenu",
		"say_team !saklambacmenu","say_team .saklambacmenu", "say /jbmenu","say .jbmenu","say /csg","say /bbmenu"
	};
	for(new i;i<sizeof(menuclcmd);i++){
		register_clcmd(menuclcmd[i],"@anamenu");
	}
	
	RegisterHookChain(RG_CBasePlayerWeapon_DefaultDeploy, "@bicakdeis", .post = false);
	RegisterHookChain(RG_CBasePlayer_Killed,"@oldun",.post=true);
	RegisterHookChain(RG_CBasePlayer_Spawn,"@oyuncudogdu",.post=true);
	RegisterHookChain(RG_RoundEnd,"@elsonu",.post=true);
	
	bind_pcvar_num(create_cvar("godmode_para", "10"), g_cvars[1]);
	bind_pcvar_num(create_cvar("speed_para", "10"), g_cvars[2]);
	bind_pcvar_num(create_cvar("can_para", "5"), g_cvars[3]);
	bind_pcvar_num(create_cvar("donduran_para", "10"), g_cvars[4]);
	bind_pcvar_num(create_cvar("usp_para", "10"), g_cvars[5]);
	bind_pcvar_num(create_cvar("ak47_para", "20"), g_cvars[6]);
	bind_pcvar_num(create_cvar("vipbonus_para", "5"), g_cvars[7]);
	bind_pcvar_num(create_cvar("vip_godmode", "5"), g_cvars[8]);
	bind_pcvar_num(create_cvar("vip_donduran", "7"), g_cvars[9]);
	bind_pcvar_num(create_cvar("vip_ak47", "15"), g_cvars[10]);
	bind_pcvar_num(create_cvar("oldurme_parasi", "1"), g_cvars[11]);
	
	register_concmd("amx_paraver","@paraver");
}

public plugin_precache() {
	for(new i = 0; i < sizeof(bicakmodel); i++) {
		precache_model(bicakmodel[i][1]);
	}
	for(new i = 0; i < sizeof(akmodel); i++) {
		precache_model(akmodel[i][1]);
	}
}
public client_disconnected(id){
	remove_task(id);
	para[id]=0;
	vipengel[id]=false;
}
public client_putinserver(id){
	set_task(1.0,"@gosterabine",id,_,_,"b");
	para[id]+= 3;
}
@oyuncudogdu(const id){
	if(!is_user_alive(id)) {
		return;
	}
	vipengel[id]=false;
	akswitch[id]=0;
}
@elsonu(const id){
	if(!is_user_alive(id)) {
		return;
	}
	client_print_color(id,id,"^3[^4%s^3] Hayatta kaldigin icin ^4Bonus Para ^3kazandin .",g_sztags[tag]);
	para[id]+= 2;
}
@paraver(id){
	if(get_user_flags(id) & yonetici){
		
		new kisi[MAX_NAME_LENGTH],packs[10];
		
		read_argv(1,kisi,charsmax(kisi));
		read_argv(2,packs,charsmax(packs));
		
		new index = cmd_target(id,kisi,0);
		if(!is_str_num(packs)){
			client_print_color(id,id,"^3[^4%s^3] Dalgami geciyon canim?",g_sztags[tag]);
			return PLUGIN_HANDLED;
		}
		else{
			para[id]+= str_to_num(packs);
			client_print_color(0,0,"^4%n ^3Isimli Admin ^4%n ^3adli kisiye ^4%i ^3para vermistir.",id,index,str_to_num(packs));
		}
		
	}
	return PLUGIN_HANDLED;
}
@gosterabine(id){
	set_hudmessage(255, 255, 0, 5.0, 0.80, 0, 1.0, 1.0);
	show_hudmessage(id, "Mevcut Paran : [ %d ] |",para[id]);
	set_task(1.0,"@gosterabine",id);
}
@oldun(const olen, const olduren){
	if(olen==olduren){
		return;
	}
	para[olduren] += g_cvars[11];
	client_print_color(olduren,olduren,"^3[^4%s^3] ^3Adam Vurdugun Icin ^4%d Para ^3Kazandin !", g_sztags[tag], g_cvars[11]);
}
@bicakdeis(const pEntity, szViewModel[], szWeaponModel[], iAnim, szAnimExt[], skiplocal) {
	new pPlayer = get_member(pEntity, m_pPlayer);
	if(get_member(pEntity, m_iId) == WEAPON_KNIFE) {
		SetHookChainArg(2, ATYPE_STRING, bicakmodel[gorunum[pPlayer]][1]);
	}
	else{
		new sw = get_member(pEntity, m_iId);
		switch(sw) {
			case WEAPON_AK47: {
				SetHookChainArg(2, ATYPE_STRING, akmodel[akswitch[pPlayer]][1]);
			}
		}
	}
}
@anamenu(const id){
	new menu = menu_create(fmt("\r%s \w| \ySaklambac Menu^nServer Ip : %s", g_sztags[menuusttag],g_sztags[serverip]), "@anamenu_devam");
	
	menu_additem(menu, fmt("\r%s \w| \yShop \w[\rMarket\w] ^n",  g_sztags[tag]));
	menu_additem(menu, fmt("\r%s \w| \yBicak Menu",  g_sztags[tag]));
	menu_additem(menu, fmt("\r%s \w| \yBilgi Menu",  g_sztags[tag]));
	menu_additem(menu, fmt("\r%s \w| \yDiscord Baglan ^n",  g_sztags[tag]));
	menu_additem(menu, fmt("\r%s \w| \yKendine Arkadan Bak \w[\r3Pers\w]",  g_sztags[tag]));
	menu_additem(menu, fmt("\r%s \w| \yBugdan Kurtul^nCebindeki TL : %i",  g_sztags[tag],para[id]));
	
	menu_setprop(menu, MPROP_EXITNAME, fmt("\d%s \w| \yCikis",  g_sztags[tag]));
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
	rg_send_audio(id , g_szSounds[sayfa]);
}
@anamenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: {
			@shops(id);
		}
		case 1: {
			@bicakmenu(id);
		}
		case 2: {
			@bilgimenu(id);
		}
		case 3: {
			client_cmd(id, "say /dc");
		}
		case 4: {
			client_cmd(id, "say /3pers");
		}
		case 5: {
			client_cmd(id, "say /kurtul");
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@shops(id){
	new menu = menu_create(fmt("\r%s \w| \ySaklambac Menu^nServer Ip : %s", g_sztags[menuusttag],g_sztags[serverip]), "@shops_devam");
	
	menu_additem(menu, fmt("\r%s \w| \yMarket Menu^n",  g_sztags[tag]));
	
	menu_additem(menu, fmt("\r%s \w| \yVip Menu",  g_sztags[tag]));
	
	menu_setprop(menu, MPROP_EXITNAME, fmt("\d%s \w| \yCikis",  g_sztags[tag]));
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
	rg_send_audio(id , g_szSounds[sayfa]);
}
@shops_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !is_user_alive(id)){
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: {
			@marketmenu(id);
		}
		case 1: {
			@vipmenu(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@marketmenu(const id){
	new menu = menu_create(fmt("\r%s \w| \yMarket Menu^nServer Ip : %s", g_sztags[menuusttag],g_sztags[serverip]), "@marketmenu_devam");
	
	menu_additem(menu, fmt("\r%s \w| \y5Sn Godmode \d[%d TL]",  g_sztags[tag],  g_cvars[1]));
	menu_additem(menu, fmt("\r%s \w| \y10Sn Hiz \d[%d TL]",  g_sztags[tag],  g_cvars[2]));
	menu_additem(menu, fmt("\r%s \w| \y+50 Hp \d[%d TL]",  g_sztags[tag],  g_cvars[3]));
	menu_additem(menu, fmt("\r%s \w| \yDondurucu Bomba \d[%d TL]",  g_sztags[tag],  g_cvars[4]));
	if(get_member(id, m_iTeam) == TEAM_CT){
		menu_additem(menu, fmt("\r%s \w| \yUsp \d[%d TL]",  g_sztags[tag],  g_cvars[5]));
		menu_additem(menu, fmt("\r%s \w| \yAk-47 \d[%d TL]",  g_sztags[tag],  g_cvars[6]));
	}
	
	menu_setprop(menu, MPROP_EXITNAME, fmt("\d%s \w| \yCikis",  g_sztags[tag]));
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
	rg_send_audio(id , g_szSounds[sayfa]);
}
@marketmenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !is_user_alive(id)){
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: {
			if(para[id] >= g_cvars[1]){
				set_entvar(id, var_takedamage, DAMAGE_NO);
				set_task(5.0,"@godkapa",id);
				rg_send_audio(id , g_szSounds[satinal]);
				para[id]-= g_cvars[1];
				client_print_color(id, id, "^3[^4%s^3] ^4Basarili bir sekilde^4 5 Saniyelik Godmode ^3Aldin.",g_sztags[tag]);
			}
			else{
				rg_send_audio(id , g_szSounds[yetersiz]);
				@marketmenu(id);
			}
		}
		case 1: {
			if(para[id] >= g_cvars[2]){
				@speed(id);
				rg_send_audio(id , g_szSounds[satinal]);
				client_print_color(id, id, "^3[^4%s^3] ^4Basarili bir sekilde^4 10 Saniyelik Hiz ^3Aldin.",g_sztags[tag]);
				para[id]-= g_cvars[2];
			}
			else{
				rg_send_audio(id , g_szSounds[yetersiz]);
				@marketmenu(id);
			}
		}
		case 2: {
			if(para[id] >= g_cvars[3]){
				set_entvar(id, var_health, Float:get_entvar(id, var_health) + 50.0);
				rg_send_audio(id , g_szSounds[satinal]);
				para[id]-= g_cvars[3];
				client_print_color(id, id, "^3[^4%s^3] ^4Basarili bir sekilde^4 +50 Hp ^3Aldin.",g_sztags[tag]);
			}
			else{
				rg_send_audio(id , g_szSounds[yetersiz]);
				@marketmenu(id);
			}
		}
		case 3: {
			if(para[id] >= g_cvars[4]){
				rg_give_item(id,"weapon_smokegrenade");
				rg_send_audio(id , g_szSounds[satinal]);
				para[id]-= g_cvars[4];
				client_print_color(id, id, "^3[^4%s^3] ^4Basarili bir sekilde^4 Donduran Bomba ^3Aldin.",g_sztags[tag]);
			}
			else{
				rg_send_audio(id , g_szSounds[yetersiz]);
				@marketmenu(id);
			}
		}
		case 4: {
			if(para[id] >= g_cvars[5]){
				rg_give_item(id,"weapon_usp");
				rg_send_audio(id , g_szSounds[satinal]);
				client_print_color(id, id, "^3[^4%s^3] ^4Basarili bir sekilde^4 Usp ^3Aldin.",g_sztags[tag]);
				para[id]-= g_cvars[5];
			}
			else{
				rg_send_audio(id , g_szSounds[yetersiz]);
				@marketmenu(id);
			}
		}
		case 5: {
			if(para[id] >= g_cvars[6]){
				rg_give_item(id,"weapon_ak47");
				rg_send_audio(id , g_szSounds[satinal]);
				para[id]-= g_cvars[6];
				client_print_color(id, id, "^3[^4%s^3] ^4Basarili bir sekilde^4 Ak-47 ^3Aldin.",g_sztags[tag]);
			}
			else{
				rg_send_audio(id , g_szSounds[yetersiz]);
				@marketmenu(id);
			}
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@vipmenu(const id){
	if(vipengel[id]){
		client_print_color(id,id,"^3[^4%s^3] ^3Vip Menuyu Zaten Kullandin.",tag);
		@anamenu(id);
	}
	else if(get_user_flags(id) & vipyetki){
		new menu = menu_create(fmt("\r%s \w| \yVip Menu^nServer Ip : %s", g_sztags[menuusttag],g_sztags[serverip]), "@vipmenu_devam");
		
		menu_additem(menu, fmt("\r%s \w- \yBonus HP \d[50 HP]", g_sztags[tag]));
		menu_additem(menu, fmt("\r%s \w- \yBonus Tl \d[%d TL]", g_sztags[tag],  g_cvars[7]));
		menu_additem(menu, fmt("\r%s \w- \y5sn Godmode  \d[%d TL]", g_sztags[tag],  g_cvars[8]));
		menu_additem(menu, fmt("\r%s \w- \yDonduran Bomba \d[%d TL]^n", g_sztags[tag],  g_cvars[9]));
		if(get_member(id, m_iTeam) == TEAM_CT){
			menu_additem(menu, fmt("\r%s \w- \yVip Ozel Ak-47 \d[%d TL]", g_sztags[tag],  g_cvars[10]));
		}
		
		menu_setprop(menu, MPROP_EXITNAME, fmt("\d%s \w- \yCikis", tag));
		menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
		menu_display(id, menu);
		rg_send_audio(id , g_szSounds[sayfa]);
	}
}
@vipmenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !is_user_alive(id)){
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: {
			set_entvar(id, var_health, Float:get_entvar(id, var_health) + 50.0);
			client_print_color(id, id, "^3[^4%s^3] ^4Basarili bir sekilde^4 +50 Hp ^3Aldin.",g_sztags[tag]);
		}
		case 1: {
			para[id]-= g_cvars[7];
			client_print_color(id, id, "^3[^4%s^3] ^4Basarili bir sekilde^4 5 Bonus Para ^3Aldin.",g_sztags[tag]);
		}
		case 2: {
			if(para[id] >= g_cvars[8]){
				set_entvar(id, var_takedamage, DAMAGE_NO);
				set_task(5.0,"@godkapa",id);
				rg_send_audio(id , g_szSounds[satinal]);
				para[id]-= g_cvars[8];
				client_print_color(id, id, "^3[^4%s^3] ^4Basarili bir sekilde^4 5 Saniyelik Godmode ^3Aldin.",g_sztags[tag]);
			}
			else{
				rg_send_audio(id , g_szSounds[yetersiz]);
				@vipmenu(id);
			}
		}
		case 3: {
			if(para[id] >= g_cvars[9]){
				rg_give_item(id,"weapon_smokegrenade");
				rg_send_audio(id , g_szSounds[satinal]);
				para[id]-= g_cvars[9];
				client_print_color(id, id, "^3[^4%s^3] ^4Basarili bir sekilde^4 Donduran Bomba ^3Aldin.",g_sztags[tag]);
			}
			else{
				rg_send_audio(id , g_szSounds[yetersiz]);
				@vipmenu(id);
			}
		}
		case 4: {
			if(para[id] >= g_cvars[10]){
				akswitch[id]=1;
				rg_give_item(id,"weapon_ak47");
				rg_send_audio(id , g_szSounds[satinal]);
				para[id]-= g_cvars[10];
			}
			else{
				rg_send_audio(id , g_szSounds[yetersiz]);
				@vipmenu(id);
			}
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@bicakmenu(const id){
	new menu = menu_create(fmt("\r%s \w| \yBicak Menu^nServer Ip : %s", g_sztags[menuusttag],g_sztags[serverip]), "@bicakmenu_devam");
	
	for(new i = 0; i < sizeof(bicakmodel); i++) {
		menu_additem(menu, fmt("\r%s \w| \y%s \d[%i Coin]", g_sztags[tag], bicakmodel[i][0],bicakmodel[i][2]));
	}
	menu_setprop(menu, MPROP_EXITNAME, fmt("\r%s \w| \yCikis", g_sztags[tag]));
	menu_display(id, menu);
}
@bicakmenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !is_user_alive(id)) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	if(para[id] >= bicakmodel[item][2][0]){
		para[id] -= bicakmodel[item][2][0];
		gorunum[id]=item;
		rg_remove_item(id,"weapon_knife");rg_give_item(id,"weapon_knife");
		client_print_color(id,id,"^3[^4%s^3] ^4%s Modeli ^3Basarili bir sekilde aktiflestirildi !",g_sztags[tag],bicakmodel[gorunum[id]][0]);
	}
	else{
		client_print_color(id,id,"^3[^4%s^3] ^3Bu bicagi almak icin paran yetersiz.",g_sztags[tag]);
	}
	menu_destroy(menu); return PLUGIN_HANDLED;
}

@godkapa(id){
	set_entvar(id, var_takedamage, DAMAGE_AIM);
	client_print_color(id, id, "^3[^4%s^3] ^4Godmodenin ^3suresi doldu.",g_sztags[tag]);
}
@speed(id){
	set_entvar(id, var_maxspeed, 500.0);
	set_task(10.0,"@speedkapa",id);
}
@speedkapa(id){
	set_entvar(id, var_maxspeed, 250.0);
	client_print_color(id, id, "^3[^4%s^3] ^4Speedin ^3suresi doldu.",g_sztags[tag]);
}
@bilgimenu(id){
	new menu = menu_create(fmt("\r%s \w| \yYardim Menu^nServer Ip : %s", g_sztags[menuusttag],g_sztags[serverip]), "@bilgimenu_devam");
	
	menu_additem(menu, fmt("\r%s \w| \yAdminlik Fiyatlari Menusu",  g_sztags[tag]));
	menu_additem(menu, fmt("\r%s \w| \yServer Kurallari",  g_sztags[tag]));
	menu_additem(menu, fmt("\r%s \w| \yMod Hakkinda",  g_sztags[tag]));
	
	menu_setprop(menu, MPROP_EXITNAME, fmt("\d%s \w| \yCikis",  g_sztags[tag]));
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
	rg_send_audio(id , g_szSounds[sayfa]);
}
@bilgimenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: {
			@fiyatmenu(id);
		}
		case 1: {
			@skbkurallar(id);
		}
		case 2: {
			@modhakkinda(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@skbkurallar(id){
	static motd[1501], len;
	len = format(motd, 1500,"<body bgcolor=#000000><font color=#87cefa><pre>");	
	len += format(motd[len], 1500-len,"<center><h4><font color=^"pink^">[ Saklambac ] ~ [ Server Kurallari ]</font></h4></center>^n^n^n");
	len += format(motd[len], 1500-len,"<left><font color=^"green^">=><font color=^"white^"> Ebe Ile Saklanan Taraf Olmak </color></left><font color=^"red^">Yasaktir!</color></right>^n");
	len += format(motd[len], 1500-len,"<left><font color=^"green^">=><font color=^"white^"> Hile Vb. Acmak </color></left><font color=^"red^">Yasaktir !</color></right>^n");
	len += format(motd[len], 1500-len,"<left><font color=^"green^">=><font color=^"white^"> Argo Ailevi Vb. Seyler</color></left><font color=^"red^">Yasaktir BAN SEBEPI !</color></right>^n");
	len += format(motd[len], 1500-len,"<left><font color=^"green^">=><font color=^"white^"> Bir Kavga Esnasinda VIP Veya Bir Yetkiliye</color></left><font color=^"red^">Danisin !</color></right>^n");
	len += format(motd[len], 1500-len,"<left><font color=^"green^">=><font color=^"white^"> Sunucu Eklenmesini Istediginiz Birsey Varsa By. QuryWesT Beliritin </color></left><font color=^"red^">DC : Can Erdogan#8137</color></right>^n");
	len += format(motd[len], 1500-len,"<left><font color=^"green^">=><font color=^"white^"> Server Kacmak Degil Saklanmak Lazim");
	len += format(motd[len], 1500-len,"<left><font color=^"green^">=><font color=^"white^"> Yetki Istemek Yasaktir DC Gelincek Orada Slot Vb. Alincaktir DISCORD : https://discord.gg/3Y3Zsma");
	len += format(motd[len], 1500-len,"<left><font color=^"green^">=><font color=^"white^"> Toplantilara Katilmak </color></left><font color=^"red^">Zorunludur !</color></right>^n");
	show_motd(id, motd, "@skbkurallar");
	return 0;	
}
@modhakkinda(id){
	static motd[1501], len;
	len = format(motd, 1500,"<body bgcolor=#000000><font color=#87cefa><pre>");	
	len += format(motd[len], 1500-len,"<center><h4><font color=^"pink^">[ Saklambac ] ~ [ Mod Hakkinda ]</font></h4></center>^n^n^n");
	len += format(motd[len], 1500-len,"<left><font color=^"green^">=><font color=^"white^"> Modumuz By. QuryWesT Tarafindan Yazilmistir (Bilalgecer47 Tarafindan Reapilestirilmistir)^n");
	len += format(motd[len], 1500-len,"<left><font color=^"green^">=><font color=^"white^"> Modumuz W*bAi*esi.Com Site Uzerinden Satilmaktadir^n");
	len += format(motd[len], 1500-len,"<left><font color=^"green^">=><font color=^"white^"> Saklambac Modumuz Sunucu Sayisina Gore Ebe Secen Bir Modur^n");
	len += format(motd[len], 1500-len,"<left><font color=^"green^">=><font color=^"white^"> Modumuz Kacmak Degil Saklanmak Lazim [Duvarlara Girilen Gizli Yerler Mevcut]^n");
	len += format(motd[len], 1500-len,"<left><font color=^"green^">=><font color=^"white^"> Modumuzda TE Scout Bulunmakta Ve Extra Hiz Lutfen Bu Konu Uzerine T De Scotumu Olur Gibi Yazilarla Bulunmayin^n");
	len += format(motd[len], 1500-len,"<left><font color=^"green^">=><font color=^"white^"> Serverimiz Bol Neseli Bir Sunucudur Zevkini Cikarin Ýyi Oyunlar. By. QuryWesT^n");
	show_motd(id, motd, "@modhakkinda");
	return 0;	
}
@fiyatmenu(id){
	new menu = menu_create(fmt("\r%s \w| \yVip Fiyat Menu^nServer Ip : %s", g_sztags[menuusttag],g_sztags[serverip]), "@fiyatmenu_devam");
	
	menu_additem(menu, fmt("\r%s \w| \yServer Ortagi \w[\r150 TL\w]",  g_sztags[tag]));
	menu_additem(menu, fmt("\r%s \w| \yServer Captan \w[\r100 TL\w]",  g_sztags[tag]));
	menu_additem(menu, fmt("\r%s \w| \yYonetim Ekibi \w[\r50 TL\w]",  g_sztags[tag]));
	menu_additem(menu, fmt("\r%s \w| \yAsistan \w[\r40 TL\w]",  g_sztags[tag]));
	menu_additem(menu, fmt("\r%s \w| \yVip \w[\r20 TL\w]",  g_sztags[tag]));
	
	menu_setprop(menu, MPROP_EXITNAME, fmt("\d%s \w| \yCikis",  g_sztags[tag]));
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
	rg_send_audio(id , g_szSounds[sayfa]);
}
@fiyatmenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	else{
		@fiyatmenu(id);
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/
