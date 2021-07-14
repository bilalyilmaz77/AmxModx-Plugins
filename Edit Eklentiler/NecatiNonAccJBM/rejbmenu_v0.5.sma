#include <amxmodx>
#include <amxmisc>
#include <reapi>
#include <fakemeta>
#include <engine>

native jb_get_user_packs(id);
native jb_set_user_packs(id, Float:ammount);
 
/****************************** DUZENLENECEKLER ******************************/
///Burayi kendinize gore ayarlayaniz

new const TS3IP[] = "TSIPNIZ";

new const ts64[] = "https://files.teamspeak-services.com/releases/client/3.5.3/TeamSpeak3-Client-win64-3.5.3.exe";
new const ts32[] = "https://files.teamspeak-services.com/releases/client/3.5.3/TeamSpeak3-Client-win32-3.5.3.exe";

new const SERVERISMI[] = "WebA";
new const KISATAG[] = "wA";

const SlotMenu_Yetki  = ADMIN_RESERVATION 	// Slot Yetkisi
const AdminMenu_Yetki =  ADMIN_KICK 			// Admin Yetkisi
const VIPELITMenu_Yetki = ADMIN_LEVEL_H 	// VIPELIT Yetkisi
const YoneticiMenu_Yetki = ADMIN_RCON 		// Yonetici Yetkisi

const AyaklanmaBaskan_Yetki = ADMIN_MAP // Ayaklanma Baskan Yetkisi
const AyaklanmaUye_Yetki = ADMIN_MENU 		// Ayaklanma Uye Yetkisi

/****************************** Model ve Sesler ******************************/

new const VIEW_MODELT[] = { "models/jbmenu/v_yumruk.mdl" };		 /* v_Yumruk */
new const PLAYER_MODELT[] = { "models/jbmenu/p_yumruk.mdl" }; 	/* p_Yumruk */
new const VIEW_Palo[] =  { "models/jbmenu/v_altinkamci.mdl" };


new const VIEW_MODELCT[] = { "models/jbmenu/jopnew.mdl" }; 		/* CT Jop */
new const PLAYER_MODELCT[] = { "models/jbmenu/jopnew2.mdl" };  	/* CT Jop */

new const VIEW_Moto[] = { "models/[Shop]JailBreak/Moto/Moto.mdl" }; 	/* Testere */
new const PLAYER_Moto[] = { "models/[Shop]JailBreak/Moto/Moto2.mdl" }; 	/* Testere */

new const kutu_acilis[] = { "misc/kutu_acilis.wav" };
new const kutu_dolu[] = { "misc/kutu_dolu.wav" };
new const kutu_bos[] = { "misc/kutu_bos.wav" };

new const isl_levelup[] = { "ambience/lv_fruit1.wav" };
new const isl_leveldown[] = { "misc/leveldown.wav" };

new const motocierra_deploy[] = { "[Shop]JailBreak/Moto/MTConvoca.wav" };
new const motocierra_slash[] = { "[Shop]JailBreak/Moto/MTSlash.wav" };
new const motocierra_wall[] = { "[Shop]JailBreak/Moto/MTHitWall.wav" };
new const motocierra_hit1[] = { "[Shop]JailBreak/Moto/MTHit1.wav" };
new const motocierra_hit2[] = { "[Shop]JailBreak/Moto/MTHit2.wav" };
new const motocierra_stab[] = { "[Shop]JailBreak/Moto/MTStab.wav" };
new const t_deploy[] = { "[Shop]JailBreak/T/TConvoca.wav" };
new const t_slash1[] = { "[Shop]JailBreak/T/Slash1.wav" };
new const t_wall[] = { "[Shop]JailBreak/T/THitWall.wav" };
new const t_hit1[] = { "[Shop]JailBreak/Hacha/HHitWall.wav" }; //bicak wall
new const t_hit2[] = { "[Shop]JailBreak/T/THit4.wav" };
new const t_hit3[] = { "[Shop]JailBreak/Hacha/HHit1.wav" }; //bicak hit1
new const t_hit4[] = { "[Shop]JailBreak/Hacha/HHit3.wav" }; //bicak hit2
new const t_stab[] = { "[Shop]JailBreak/T/TStab.wav" };
new const ct_deploy[] = { "[Shop]JailBreak/CT/CTConvoca.wav" };
new const ct_slash1[] = { "[Shop]JailBreak/CT/Slash1.wav" };
new const ct_wall[] = { "[Shop]JailBreak/CT/CTHitWall.wav" };
new const ct_hit1[] = { "[Shop]JailBreak/CT/CTHit1.wav" };
new const ct_stab[] = { "[Shop]JailBreak/CT/CTStab.wav" };
/******************************** TANIMLAR ***********************************/
//static const g_maxclipammo[] = { 0,13,0,10,0,7,0,30,30,0,15,20,25,30,35,25,12,20,10,30,100,8,30,30,20,0,7,30,30,0,50 };
enum _: Data { RankName[MAX_CLIENTS+1],RankXp };
new const isl_rank[][Data] = {
	{"Acemi Isyanci", 0},{"Gelisen Isyanci", 200},{"Kidemli Isyanci", 400},{"Gorevli Isyanci", 700},{"Isyancilar Krali", 1000}
};
enum _: Level { g_level,g_exp };

// Cuzdan Kodu
enum _: eKupon { sifre[32], miktar};
new const chars[] = "abcdefghijklmnopqrstuvwxyz1234567890";
new Array: kuponlar;

//?elik Kasa
new bool:kilitli=false,ucret,kasa_hane,kasa_baslangic,kasa_sifre,para,h_deneme=0,g_deneme[33],engel,g_engel[33],g_name[64],ipucu[33];//,say_reklam;

new Float:TL[MAX_CLIENTS+1],cvars[36],hud,g_seviye[MAX_CLIENTS+1][Level],bool:TCuchillo[MAX_CLIENTS+1],tltransfer[MAX_CLIENTS+1],jbonuskontrol[MAX_CLIENTS+1],kasa[MAX_CLIENTS+1],anahtar[MAX_CLIENTS+1],
kasa_renk[MAX_CLIENTS+1],asalkontrol[MAX_CLIENTS+1],esya_say[MAX_CLIENTS+1],gorev_hayat[MAX_CLIENTS+1],meslegim[MAX_CLIENTS+1],mgtl[MAX_CLIENTS+1],
g_mgisim[MAX_CLIENTS+1],bool:ayaklanma_kontrol,bool:elbasikontrol,bool:ts3baglan[MAX_CLIENTS+1],bool:reklamat[MAX_CLIENTS+1],
bool:Destapador[MAX_CLIENTS+1],bool:Motocierra[MAX_CLIENTS+1],bool:marketkontrol[MAX_CLIENTS+1]/*,bool:ciftziplama[MAX_CLIENTS+1]*/,bool:hasarazalt[MAX_CLIENTS+1],
/*bool:unammo[MAX_CLIENTS+1],*/bool:bonuskontrol[MAX_CLIENTS+1],bool:sanskontrol[MAX_CLIENTS+1],bool:kasakontrol1[MAX_CLIENTS+1],bool:kasakontrol2[MAX_CLIENTS+1],
bool:hasarkatla[MAX_CLIENTS+1],bool:ayaklanmakontrol[MAX_CLIENTS+1],bool:ayaklanmareklami[MAX_CLIENTS+1],bool:menu_tl[MAX_CLIENTS+1],
bool:model_gizle[MAX_CLIENTS+1],bool:hud_ayar[MAX_CLIENTS+1]/*,bool:gorunmezlik[MAX_CLIENTS+1]*/,bool:say_ayar[MAX_CLIENTS+1],bool:uzmanc[MAX_CLIENTS+1],
bool:gorev1[MAX_CLIENTS+1],bool:gorev2[MAX_CLIENTS+1],bool:gorev3[MAX_CLIENTS+1],bool:gorev4[MAX_CLIENTS+1],bool:gorev5[MAX_CLIENTS+1],
bool:gorev6[MAX_CLIENTS+1],bool:gorev7[MAX_CLIENTS+1]/*,bool:anareklam[MAX_CLIENTS+1]*/,soygun[MAX_CLIENTS+1];

public plugin_init() {
	register_plugin("[ReAPI] Gelismis JBMENU", "v0.5", "Necati_DGN");
	
	register_clcmd("say /jbmenu", "anamenu");
	register_clcmd("say_team /jbmenu", "anamenu");
	register_clcmd("chooseteam","dvmgana");
	register_clcmd("nightvision","dvmgana");
	register_clcmd("say /mg", "mgtlver");
	register_clcmd("say_team /mg", "mgtlver");
	register_clcmd("say /tlver", "mgtlver");
	register_clcmd("say_team /tlver", "mgtlver");
	register_clcmd("say /uzman","uzman");
	register_clcmd("TL_MIKTARI", "TL_devam");
	register_clcmd("drop","ac");
	//?elik Kasa
	register_clcmd("say /box","box")
	register_clcmd("say /kasa","box")
	register_clcmd("PW_GIR","checkBoxPw")
	
	//Cuzdan Kodu
	kuponlar = ArrayCreate(eKupon);
	register_clcmd("say /tumkodlar", "getAllValues");
	register_clcmd("say /cuzdankodu", "kuponMenu");
	register_clcmd("say .cuzdankodu", "kuponMenu");
	register_clcmd("KEY_GIR_CEK", "paraCek");
	register_clcmd("PARA_GIR", "otoParaYatir");
	register_clcmd("KEY_MIKTAR_GIR", "ozelParaYatir");

	RegisterHookChain(RG_CBasePlayer_Spawn, "oyuncuspawnoldu",1);
	RegisterHookChain(RG_CBasePlayer_TakeDamage, "TakeDamage",0);
	RegisterHookChain(RG_CBasePlayer_Killed, "CBasePlayer_Killed", 1);
	RegisterHookChain(RG_CSGameRules_FlPlayerFallDamage, "fallDamage",1);
	//RegisterHookChain(RG_CBasePlayer_Jump,"Jump");
	RegisterHookChain(RG_RoundEnd, "elsonu", 1);
	register_event_ex("HLTV", "elbasi", RegisterEvent_Global, "1=0", "2=0");
	//register_clcmd("bosaugrasmajb","bosaugrasmajb");
	register_event_ex("CurWeapon", "Event_Change_Weapon", RegisterEvent_Single | RegisterEvent_OnlyAlive, "1=1");

	register_event_ex("SpecHealth2","spec_target", RegisterEvent_Single | RegisterEvent_OnlyDead);
	hud=CreateHudSyncObj();

	register_forward(FM_ClientKill, "fwd_FM_ClientKill");
	register_forward(FM_EmitSound, "Fwd_EmitSound"); //?
	//register_forward(FM_AddToFullPack, "fwdAddToFullPack_Post", 1); //?

	/* cvars */
	cvars[1] = register_cvar("jb_yumruk1", "-0.49");			// EmanetMenu - Doping
	cvars[2] = register_cvar("jb_testere2", "49.944");		// EmanetMenu - Testere

	cvars[3] = register_cvar("jb_hp1", "12.999");				//IsyanMenu - 100HP
	cvars[4] = register_cvar("jb_unbury2", "99.999");			//IsyanMenu - Unbury
	cvars[5] = register_cvar("jb_godmode3", "119.99");		//IsyanMenu - Godmode
	cvars[6] = register_cvar("jb_hasar4", "19.999");			//IsyanMenu - HasarAzalt
	//cvars[7] = register_cvar("jb_cziplama5", "22.99");		//IsyanMenu - CiftZipla
	cvars[8] = register_cvar("jb_elektrik6", "60.15");		//IsyanMenu - Elektrik

	cvars[9] = register_cvar("jb_flash1", "9.999");			//CephaneMenu - Flash
	cvars[10] = register_cvar("jb_bombahe2", "12.50");		//CephaneMenu - ElBombasi
	cvars[11] = register_cvar("jb_awp3", "59.999");			//CephaneMenu - AWP
	cvars[12] = register_cvar("jb_bombaseti4", "25.25");		//CephaneMenu - BombaSeti
	cvars[13] = register_cvar("jb_unammo5", "31.00");			//CephaneMenu - Unammo
	cvars[14] = register_cvar("jb_glock6", "74.499");			//CephaneMenu - Glock

	cvars[15] = register_cvar("jb_mahkumhp1", "49.99");		//TaarruzMenu - Mahkum+50HP
	cvars[16] = register_cvar("jb_tsisbomba2", "62.00");		//TaarruzMenu - MahkumSis
	cvars[17] = register_cvar("jb_ctflash3", "70.25");		//TaarruzMenu - GardiyanFlashla
	cvars[18] = register_cvar("jb_ctgom4", "79.999");			//TaarruzMenu - GardiyanGom
	cvars[19] = register_cvar("jb_ctdrug5", "90.999");			//TaarruzMenu - GardiyanDrug
	cvars[20] = register_cvar("jb_tbomba6", "100.999");		//TaarruzMenu - MahkumBomba

	cvars[21] = register_cvar("jb_sansmenu1", "4.98");		//Sansli Asal Sayi
	cvars[22] = register_cvar("jb_sansmenu2", "20.00");		//Klasik Sans Kutusu

	cvars[23] = register_cvar("jb_kasafiyat", "2.99");		//CS:GO Kasa Fiyati
	cvars[24] = register_cvar("jb_anahtarfiyat", "19.99");	//CS:GO Anahtar Fiyati

	cvars[25] = register_cvar("jb_dKnifeT", "15");		//Dopingsiz Hasar
	cvars[26] = register_cvar("jb_dKnifeCT", "50");		//CT Jop Hasar
	cvars[27] = register_cvar("jb_dKnife1", "25");		//Dopingli Hasar
	cvars[28] = register_cvar("jb_dKnife4", "200");		//Testere Hasar
	cvars[29] = register_cvar("jb_dHsKnifeT", "30");		//Dopingsiz HS Hasar
	cvars[30] = register_cvar("jb_dHsKnifeCT", "80");		//CT Jop HS Hasar
	cvars[31] = register_cvar("jb_dhsKnife1", "45");		//Dopingli HS Hasar

	cvars[32] = register_cvar("isl_killdeathxp","25");		//Olunce ve oldurunce giden/gelen isyan puani

	cvars[33] = register_cvar("tl_baslangic", "3.777");		//Baslangic Parasi
	cvars[34] = register_cvar("tl_killcekince", "2.49");		//Kill cekince gelen para
	cvars[35] = register_cvar("max_mgtl", "100.00");			//CT'nin en fazla verebilecegi TL

	//?elik Kasa Cvars
	engel = register_cvar("kasa_koruma","1");
	ucret = register_cvar("kasa_ucret","1");
	kasa_hane = register_cvar("kasa_hane","2");
	kasa_baslangic = register_cvar("kasa_baslangic","45");
	//say_reklam = register_cvar("kasa_bilgi","1");
	register_concmd("amx_ayaklanmabaslat","ayaklanmabaslat",AyaklanmaBaskan_Yetki,"Ayaklanma Baslat < 1/Baslat 0/Kapat >");


	
}

public client_putinserver(id) { 

	TL[id]=get_pcvar_float(cvars[33]);
	g_seviye[id][g_exp]=0,g_seviye[id][g_level]=0;
	esya_say[id]=0,gorev_hayat[id]=0,meslegim[id]=0,ts3baglan[id]=false;
	gorev1[id]=false,gorev2[id]=false,gorev3[id]=false,gorev4[id]=false,gorev5[id]=false,gorev6[id]=false,gorev7[id]=false;
	menu_tl[id]=false,model_gizle[id]=false,hud_ayar[id]=false,say_ayar[id]=false;
	soygun[id]=0;

	g_deneme[id] = 0;ipucu[id] = false;g_engel[id] = 1;//if(get_pcvar_num(say_reklam)) set_task(120.0, "Amad",id , _, _, "b");
	if(get_pcvar_num(engel)) set_task(60.0,"aktifet",id);

	

	/********************************** ********** **********************************/


}

/********************************** MENULER **********************************/

public anamenu(id) {
	new players[32],num; get_players(players, num, "acehi", "TERRORIST");
	if(!is_user_alive(id)) client_print_color(id,id,"^1[^3%s^1] ^4Bu menuye oluyken giris yapamazsin.",SERVERISMI);
	else if(get_user_team(id)!=1) client_print_color(id,id,"^1[^3%s^1] ^4Bu menuye sadece ^1mahkumlar ^4giris yapabilir.",SERVERISMI);
	else if(num<=1) client_print_color(id,id,"^1[^3%s^1] ^4Sona kalan mahkum bu menuye giremez.",SERVERISMI);
	else {
			new ndmenu[128];

			formatex(ndmenu,charsmax(ndmenu),"\y%s \d` \yJailbreak Menu^n\dCebinizdeki TL: \r%.2f^n\r[\d/ts3 & %s\r]", SERVERISMI, TL[id],TS3IP);
			
			new Menu = menu_create(ndmenu,"anamenu2");

			formatex(ndmenu,charsmax(ndmenu),"\r%s \y` %s",KISATAG, marketkontrol[id] ? "\dEmanetler":"\wEmaneti Cek");
			menu_additem(Menu,ndmenu,"1");
			formatex(ndmenu,charsmax(ndmenu),"\r%s \y` %sAlisveris Yap",KISATAG, godmode_sorgu() ? "\d":"\w");
			menu_additem(Menu,ndmenu,"2");
			formatex(ndmenu,charsmax(ndmenu),"\r%s \y` %s",KISATAG, bonuskontrol[id] ? "\dBonus Menu":"\wBonus Menu");
			menu_additem(Menu,ndmenu,"3");
			if(get_user_flags(id) & AyaklanmaUye_Yetki || get_user_flags(id) & AyaklanmaBaskan_Yetki) {
				if(!ayaklanmakontrol[id] && ayaklanma_kontrol) formatex(ndmenu,charsmax(ndmenu),"\r%s \w` \yAyaklanma Baslatildi! \r[\wACIK\r]",KISATAG);
				else {
					formatex(ndmenu,charsmax(ndmenu),"\r%s \w` %s",KISATAG, ayaklanmakontrol[id] ? "\yAyaklanma Baslatildi! \r[\dKAPALI\r]":"\yAyaklanma Baslat! \r[\dKAPALI\r]");
				}
			} else {
				formatex(ndmenu,charsmax(ndmenu),"\r%s \w` \yAyaklanma Baslat%s",KISATAG, ayaklanma_kontrol ? "ildi! \r[\wUYE DEGILSIN\r]":"! \r[\dUYE DEGILSIN\r]");
			}
			menu_additem(Menu,ndmenu,"4");
			formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wMeslek Menu",KISATAG);
			menu_additem(Menu,ndmenu,"5");
			formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wIsyanci Gorevleri",KISATAG);
			menu_additem(Menu,ndmenu,"6");
			formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wEkstra Menu",KISATAG);
			menu_additem(Menu,ndmenu,"7");

			menu_setprop(Menu, MPROP_EXITNAME,( "\yCikis"));
			menu_setprop(Menu,MPROP_NUMBER_COLOR,"\d");
			menu_display(id, Menu);
		}
	return PLUGIN_HANDLED;
}
public anamenu2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1 : emanetmenu(id);
		case 2 : alisveris(id);
		case 3 : yetkilimenum(id);
		case 4 : ayaklanmamenum(id);
		case 5 : meslekmenum(id);
		case 6 : isyancigorevmenum(id);
		case 7 : exxtra(id);
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
new bool:kanbagis[MAX_CLIENTS+1];
public exxtra(id) {
	new ndmenu[128];
	formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yEkstra Menu",SERVERISMI);
	new Menu = menu_create(ndmenu,"exxtra2");

	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wTL Transfer Menu",KISATAG);
	menu_additem(Menu,ndmenu,"1");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wHP Bagislama Menu %s",KISATAG, kanbagis[id] ? "\dKAPALI":"\yACIK");
	menu_additem(Menu,ndmenu,"2");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wCuzdan Menu",KISATAG);
	menu_additem(Menu,ndmenu,"3");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wAyar Menu",KISATAG);
	menu_additem(Menu,ndmenu,"7");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wAramiza Katil^n",KISATAG);
	menu_additem(Menu,ndmenu,"9");
		
	if(!menu_tl[id]) formatex(ndmenu,charsmax(ndmenu),"\yCebinizdeki TL \d- \r[ %0.2f ]",TL[id]),menu_addtext(Menu, ndmenu);
	
	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);
}
public exxtra2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1 : tltransfermenum(id);
		case 2 : kanbagisla(id);
		case 3 : kuponMenu(id);
		case 7 : ayarmenum(id);
		case 9 : ts3menu(id);
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public kanbagisla(id) {
	if(kanbagis[id]) client_print_color(id, id, "^1[^3%s^1] ^4HP bagisini her round ^1bir kere^4 kullanabilirsin.",SERVERISMI),exxtra(id);
	else {
		new ndmenu[128];
		formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yHP Bagisla",SERVERISMI);
		new Menu = menu_create(ndmenu,"kanbagisla2");

		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w50 HP Bagisla \yOdul 3.99 TL",KISATAG);
		menu_additem(Menu,ndmenu,"1");
		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w75 HP Bagisla \yOdul 6.49 TL",KISATAG);
		menu_additem(Menu,ndmenu,"2");
		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w99 HP Bagisla \yOdul 8.99 TL",KISATAG);
		menu_additem(Menu,ndmenu,"3");
		if(!menu_tl[id]) formatex(ndmenu,charsmax(ndmenu),"\yCebinizdeki TL \d- \r[ %0.2f ]",TL[id]),menu_addtext(Menu, ndmenu);
		
		menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
		menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
		menu_display(id, Menu, 0);
	}
}
public kanbagisla2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	new Float:hp=get_entvar(id, var_health);
	switch(key) {
		case 1 : {
			if(Float:hp>50.0) {
				set_entvar(id, var_health, Float:hp-50.0), TL[id]+=3.99;
				client_print_color(id, id, "^1[^3%s^1] ^4HP Bagislama menusunden^1 50 HP ^4bagislayip^1 3.99 TL ^4kazandiniz.",SERVERISMI),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli ^1HP'niz^4 yok.",SERVERISMI),kanbagisla(id);
		}
		case 2 : {
			if(Float:hp>75.0) {
				set_entvar(id, var_health, Float:hp-75.0), TL[id]+=6.49;
				client_print_color(id, id, "^1[^3%s^1] ^4HP Bagislama menusunden^1 75 HP ^4bagislayip^1 6.49 TL ^4kazandiniz.",SERVERISMI),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli ^1HP'niz^4 yok.",SERVERISMI),kanbagisla(id);
		}
		case 3 : {
			if(Float:hp>99.0) {
				set_entvar(id, var_health, Float:hp-99.0), TL[id]+=8.99;
				client_print_color(id, id, "^1[^3%s^1] ^4HP Bagislama menusunden^1 99 HP ^4bagislayip^1 8.99 TL ^4kazandiniz.",SERVERISMI),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli ^1HP'niz^4 yok.",SERVERISMI),kanbagisla(id);
		}
	}
	kanbagis[id]=true;
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public ts3menu(id) {
	new ndmenu[128];
	formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yAramiza Katil",SERVERISMI);
	new Menu = menu_create(ndmenu,"ts3menu2");

	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wTS3 \r64\w-Bit Indir",KISATAG);
	menu_additem(Menu,ndmenu,"1");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wTS3 \r32\w-Bit Indir",KISATAG);
	menu_additem(Menu,ndmenu,"2");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wTS3 Baglan \r[\d%s\r]^n",KISATAG,TS3IP);
	menu_additem(Menu,ndmenu,"3");

	menu_addtext(Menu, "\yAilemize Katilmak icin tek yapman gereken \rTS3 sunucumuza \ygelmek.");
	menu_addtext(Menu, "\yTS3 sunucumuza gelerek \rucretsiz bir sekilde yetki \yde alabilirsin.");
	menu_addtext(Menu, "\yAdminlik ucretlerimiz de gayet \ruygun fiyatlarda \yseni bekliyor. ");
	menu_addtext(Menu, "\yUnutma! \rSen yoksan bir kisi eksigiz. \ySeni aramizda gormek isteriz \r:)");
	
	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);
}
public ts3menu2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1 : ts3indir(id, 1);
		case 2 : ts3indir(id, 0);
		case 3 : {
			if(is_user_steam(id)) {
				client_print_color(id, print_team_red, "^1[^3%s^1] ^4Steam oyuncu oldugunuz icin ^1ts3 serverimize^4 dogrudan ^3baglanamiyorsunuz.",SERVERISMI);
				client_print_color(id, print_team_blue, "^1[^3%s^1] ^4TS3 IP ^1> ^3%s",SERVERISMI,TS3IP);
			} else client_cmd(id, "say /ts3");
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public ts3indir(id, surum) {
	if(is_user_steam(id)) {
		client_print_color(id, print_team_red, "^1[^3%s^1] ^4Steam oyuncu oldugunuz icin ^1ts3 programini^4 dogrudan ^3indiremiyorsunuz.",SERVERISMI);
		client_print_color(id, print_team_blue, "^1[^3%s^1] ^4Indirme linki ^1> ^3https://www.teamspeak.com/tr/downloads/",SERVERISMI);
	} else {
		new motd[642],bit[32];
		formatex(motd, charsmax(motd),"<html><head><meta http-equiv=^"Refresh^" content=^"0;url=%s^"></head>\
		<body text=^"#C0C0C0^" bgcolor=^"#000000^"><p align=^"center^"><font size=^"5^" face=^"Trebuchet MS^">Direkt setup dosyasi bilgisayariniza yuklenecektir.\
		</font><br><font size=^"3^" color=^"#808080^" face=^"Trebuchet MS^">OK tusuna basarak bu menuden cikabilirsiniz!</font>\
		<br><br><font size=^"4^" color=^"#FF0000^" face=^"Trebuchet MS^">[ Iyi Oyunlar Dileriz.. ] </font></font></p></body></html>"\
		,surum ? ts64:ts32);
		formatex(bit, charsmax(bit), "TS3 %s-Bit indiriliyor...", surum ? "64":"32")
		show_motd(id, motd, bit);
	}
}
public emanetmenu(id) {
	if(marketkontrol[id]) client_print_color(id,id,"^1[^3%s^1] ^4Her roundda ^1bir kere^4 girebilirsin.",SERVERISMI),anamenu(id);
	else {
		new ndmenu[128];
		formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yEmanetler",SERVERISMI);
		new Menu = menu_create(ndmenu,"emanetmenu2");

		if(get_pcvar_float(cvars[1]) < 0.0) formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wAltin Kamci \d[\r+%0.2f TL Bahsis\d]",KISATAG,get_pcvar_float(cvars[1])-(get_pcvar_float(cvars[1])*2));
		else if(get_pcvar_float(cvars[1]) == 0.0) formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wAltin Kamci \d[\rUcretsiz\d]",KISATAG);
		else if(get_pcvar_float(cvars[1]) > 0.0) formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wAltin Kamci \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[1]));
		menu_additem(Menu,ndmenu,"1");
		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wTestere + Bomba \d[\r%.2f TL\d]^n",KISATAG,get_pcvar_float(cvars[2]));
		menu_additem(Menu,ndmenu,"2");
		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` %s",KISATAG, reklamat[id] ? "\dReklam At \r[\dKullandin\r]":"\wReklam At \d[\r+0.50 TL Bahsis\d]");
		menu_additem(Menu,ndmenu,"3");
		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w8001 $ Bozdur \d[\r+10.00 TL\d]",KISATAG);
		menu_additem(Menu,ndmenu,"4");
		if(!is_user_steam(id)) {
			formatex(ndmenu,charsmax(ndmenu),"\r%s \y` %s",KISATAG, ts3baglan[id] ? "\dTeamspeak3 Baglan \r[\dKullandin\r]":"\wTeamspeak3 Baglan \d[\r+2.49 TL Bahsis\d]");
		} else {
			formatex(ndmenu,charsmax(ndmenu),"\r%s \y` %s",KISATAG, ts3baglan[id] ? "\dTeamspeak3 Baglan \r[\dKullandin\r]":"\wTeamspeak3 Baglan \d[\r+2.49 TL Bahsis\d]");
		}
		menu_additem(Menu,ndmenu,"5");
		if(!menu_tl[id]) formatex(ndmenu,charsmax(ndmenu),"\yCebinizdeki TL \d- \r[ %0.2f ]",TL[id]),menu_addtext(Menu, ndmenu);

		menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
		menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
		menu_display(id, Menu, 0);
	}
	return PLUGIN_HANDLED;
}

public emanetmenu2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1 : {
			if(TL[id] >= get_pcvar_float(cvars[1])) {
				TL[id]-=get_pcvar_float(cvars[1]);
				TCuchillo[id]=false,Destapador[id]=true,Motocierra[id]=false,marketkontrol[id]=true;
				rg_remove_item(id, "weapon_knife"),rg_give_item(id, "weapon_knife");
				//set_task(0.1,"bugs",id)
				//set_task(4.0,"yurmuk",id);
				client_print_color(id, id, "^1[^3%s^1] ^4Emanet menusunden ^1Altin Kamci ^4aldin.",SERVERISMI);
				anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[1])),emanetmenu(id);
		}
		case 2 : {
			if(TL[id] >= get_pcvar_float(cvars[2])) {
				TL[id]-=get_pcvar_float(cvars[2]);
				TCuchillo[id]=false,Destapador[id]=false,Motocierra[id]=true,marketkontrol[id]=true;
				rg_remove_item(id, "weapon_knife"),rg_give_item(id, "weapon_knife"),rg_give_item(id, "weapon_hegrenade");
				client_print_color(id, id, "^1[^3%s^1] ^4Emanet menusunden ^1Testere + Bomba ^4aldin.",SERVERISMI);
				anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[2])),emanetmenu(id);
		}
		case 3 : {
			if(!reklamat[id]) {
				client_print_color(0, 0, "^1[^3%s^1] ^4Sizde ailemize katilmak isterseniz say'a ^1/ts3 ^4yazabilirsiniz.",SERVERISMI);
				//client_print_color(id, id, "^1[^3%s^1] ^4Reklam atarak^1 0.50 TL ^4kazandin.",SERVERISMI);
				reklamat[id]=true,TL[id]+=0.50,emanetmenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Her roundda ^1bir kere^4 kullanabilirsin.",SERVERISMI),emanetmenu(id);
		}
		case 4 : {
			if(get_member(id, m_iAccount) > 8001) {
				rg_add_account(id, get_member(id, m_iAccount) - 8001, AS_SET),TL[id]+=10.00;
				client_print_color(id, id, "^1[^3%s^1]^4 8001 $ bozdurarak^1 10 TL^4 kazandin.",SERVERISMI);
				emanetmenu(id);
			} else client_print_color(id, id, "^1[^3%s^1]^4 Maalesef yeterli paraniz yok. ^1Gereken ^3$8001",SERVERISMI),emanetmenu(id);
		}
		case 5 : {
			if(!ts3baglan[id]) {
				if(is_user_steam(id)) client_print_color(0, 0, "^1[^3%s^1] ^4Teamspeak 3 IP : ^1%s ^3|| ^1/ts3",SERVERISMI,TS3IP),client_print_color(0, 0, "^1[^3%s^1] ^4Teamspeak 3 IP : ^1%s ^3|| ^1/ts3",SERVERISMI,TS3IP);
				else client_cmd(id,"say /ts3"),client_print_color(0, 0, "^1[^3%s^1] ^4Teamspeak 3 IP : ^1%s ^3|| ^1/ts3",SERVERISMI,TS3IP);
				//client_print_color(id, id, "^1[^3%s^1]^4 Emanet menusunden^1 3.49 TL ^4kazandin.",SERVERISMI);
				ts3baglan[id]=true,TL[id]+=2.49;
				emanetmenu(id);
			} else client_print_color(id, id, "^1[^3%s^1]^4 Her mapta ^1bir kere^4 kullanabilirsin.",SERVERISMI),emanetmenu(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public alisveris(id) {
	new ndmenu[64];
	formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yAlisveris Menusu",SERVERISMI);
	new Menu = menu_create(ndmenu,"alisveris2");

	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wIsyan Menu",KISATAG);
	menu_additem(Menu,ndmenu,"1");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wCephane Menu",KISATAG);
	menu_additem(Menu,ndmenu,"2");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wTaarruz Menu",KISATAG);
	menu_additem(Menu,ndmenu,"3");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wSans Menuleri",KISATAG);
	menu_additem(Menu,ndmenu,"4");
	if(!menu_tl[id]) formatex(ndmenu,charsmax(ndmenu),"\yCebinizdeki TL \d- \r[ %0.2f ]",TL[id]),menu_addtext(Menu, ndmenu);

	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);

	return PLUGIN_HANDLED;
}
public alisveris2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1 : isyanmenum(id);
		case 2 : cephanemenum(id);
		case 3 : saldirimenum(id);
		case 4 : sansmenum(id);
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public isyanmenum(id) {
	new ndmenu[128];
	formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yIsyan Menu",SERVERISMI);
	new Menu = menu_create(ndmenu,"isyanmenum2");

	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w100 HP Satin Al \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[3]));
	menu_additem(Menu,ndmenu,"1");
	/*formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wCift Ziplama \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[7]));
	menu_additem(Menu,ndmenu,"5");*/
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wAnti Soygun \d(5 El Soyulmazsin) \d[\r9.99 TL\d]^n",KISATAG);
	menu_additem(Menu,ndmenu,"7");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wKendini Kaldir \d(Unbury) [\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[4]));
	menu_additem(Menu,ndmenu,"2");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wAlacagin Hasari Yariya Dusur \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[6]));
	menu_additem(Menu,ndmenu,"3");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w3 Saniye Godmode \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[5]));
	menu_additem(Menu,ndmenu,"4");
	if(!menu_tl[id]) formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wElektrikleri 5sn Kes \d[\r%0.2f TL\d]^n\yCebinizdeki TL \d- \r[ %0.2f ]",KISATAG,get_pcvar_float(cvars[8]),TL[id]);
	else formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wElektrikleri 5sn Kes \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[8]));
	menu_additem(Menu,ndmenu,"6");

	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);

	return PLUGIN_HANDLED;
}
public isyanmenum2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1 : {
			if(TL[id] >= get_pcvar_float(cvars[3])) {
				if(Float:get_entvar(id, var_health) < 950.0) {
					TL[id]-=get_pcvar_float(cvars[3]),set_entvar(id, var_health, Float:get_entvar(id, var_health)+100.0),esya_say[id]++;
					client_print_color(id, id, "^1[^3%s^1] ^4Isyan menusunden^1 100 HP ^4aldin.",SERVERISMI),anamenu(id);
				} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef^1 950 HP^4 'den fazla HP ^3cekemezsin!",SERVERISMI),isyanmenum(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[3])),isyanmenum(id);
		}
		case 2 : {
			if(TL[id] >= get_pcvar_float(cvars[4])) {
				TL[id]-=get_pcvar_float(cvars[4]),esya_say[id]++;
				new Float:origin[3]; get_entvar(id, var_origin, origin),origin[2] +=35.0,set_entvar(id, var_origin, origin);
				client_print_color(id, id, "^1[^3%s^1] ^4Isyan menusunden^1 Kendini Kaldir ^3(Unbury) ^4aldin.",SERVERISMI),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[4])),isyanmenum(id);
		}
		case 3 : {
			if(TL[id] >= get_pcvar_float(cvars[6])) {
				TL[id]-=get_pcvar_float(cvars[6]),hasarazalt[id]=true,esya_say[id]++;
				client_print_color(id, id, "^1[^3%s^1] ^4Isyan menusunden^1 Hasar Azalt ^4aldin.",SERVERISMI),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[6])),isyanmenum(id);
		}
		case 4 : {
			if(TL[id] >= get_pcvar_float(cvars[5])) {
				TL[id]-=get_pcvar_float(cvars[5]),set_entvar(id, var_takedamage, DAMAGE_NO),set_task(3.0,"godres",id),esya_say[id]++;
				client_print_color(id, id, "^1[^3%s^1] ^4Isyan menusunden^1 3 saniye Godmode ^4aldin.",SERVERISMI),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[5])),isyanmenum(id);
		}
		/*case 5 : {
			if(TL[id] >= get_pcvar_float(cvars[7])) {
				TL[id]-=get_pcvar_float(cvars[7]),ciftziplama[id]=true,esya_say[id]++;
				client_print_color(id, id, "^1[^3%s^1] ^4Isyan menusunden^1 Cift Ziplama ^4aldin.",SERVERISMI),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[7])),isyanmenum(id);
		}*/
		case 6 : {
			if(TL[id] >= get_pcvar_float(cvars[8])) {
				TL[id]-=get_pcvar_float(cvars[8]),set_lights("a"),set_task(6.0,"elektrikac"),esya_say[id]++;
				client_print_color(0, 0, "^1[^3%s^1] ^4Bir mahkum ^1Elektrikleri 5 Saniye^4 kesti.",SERVERISMI),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[8])),isyanmenum(id);
		}
		case 7 : {
			if(TL[id] >= 9.99) {
				if(soygun[id]<1) {
					TL[id]-=9.99; soygun[id]=5,esya_say[id]++;
					client_print_color(id, id, "^1[^3%s^1] ^4Isyan menusunden^1 Anti Soygun ^4aldin.^3 %d El Kimse seni soyamaz!",SERVERISMI,soygun[id]),anamenu(id);
				} else client_print_color(id, id, "^1[^3%s^1] ^4Zaten ^1Anti Soygun ^4 satin almissin.^1 Kalan El > ^3%d",SERVERISMI,soygun[id]),isyanmenum(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar^3 9.99 TL",SERVERISMI),isyanmenum(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public godres(id) set_entvar(id, var_takedamage, DAMAGE_AIM),client_print_color(id, id, "^1[^3%s^1] ^4Isyan Menuden aldigin^1 Godmode ^4sona erdi.",SERVERISMI);
public elektrikac() set_lights("l"),client_print_color(0, 0, "^1[^3%s^1] ^4Elektrik kesintisi sona erdi.",SERVERISMI);
public cephanemenum(id) {
	new ndmenu[64];
	formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yCephane Menu",SERVERISMI);
	new Menu = menu_create(ndmenu,"cephanemenum2");

	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wFlash Bombasi \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[9]));
	menu_additem(Menu,ndmenu,"1");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wEl Bombasi \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[10]));
	menu_additem(Menu,ndmenu,"2");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wBomba Seti \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[12]));
	menu_additem(Menu,ndmenu,"4");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wHasari 2'ye katla \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[13]));
	menu_additem(Menu,ndmenu,"5");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wTek Mermili AWP \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[11]));
	menu_additem(Menu,ndmenu,"3");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wTek Sarjor Glock \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[14]));
	menu_additem(Menu,ndmenu,"6");
	if(!menu_tl[id]) formatex(ndmenu,charsmax(ndmenu),"\yCebinizdeki TL \d- \r[ %0.2f ]",TL[id]),menu_addtext(Menu, ndmenu);

	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);

	return PLUGIN_HANDLED;
}
public cephanemenum2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1 : {
			if(TL[id] >= get_pcvar_float(cvars[9])) {
				TL[id]-=get_pcvar_float(cvars[9]),rg_give_item(id,"weapon_flashbang"),esya_say[id]++;
				client_print_color(id, id, "^1[^3%s^1] ^4Cephane menusunden^1 Flash Bombasi ^4aldin.",SERVERISMI),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[9])),cephanemenum(id);
		}
		case 2 : {
			if(TL[id] >= get_pcvar_float(cvars[10])) {
				TL[id]-=get_pcvar_float(cvars[10]),rg_give_item(id,"weapon_hegrenade"),esya_say[id]++;
				client_print_color(id, id, "^1[^3%s^1] ^4Cephane menusunden^1 El Bombasi ^4aldin.",SERVERISMI),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[10])),cephanemenum(id);
		}
		case 3 : {
			if(TL[id] >= get_pcvar_float(cvars[11])) {
				TL[id]-=get_pcvar_float(cvars[11]),esya_say[id]++;
				rg_give_item(id, "weapon_awp");
				rg_set_user_ammo(id, WEAPON_AWP, 0),rg_set_user_bpammo(id, WEAPON_AWP, 1);
				//set_member(rg_give_item(id, "weapon_awp"), m_Weapon_iClip, 1);
				client_print_color(id, id, "^1[^3%s^1] ^4Cephane menusunden^1 Tek Mermili AWP ^4aldin.",SERVERISMI),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[11])),cephanemenum(id);
		}
		case 4 : {
			if(TL[id] >= get_pcvar_float(cvars[12])) {
				TL[id]-=get_pcvar_float(cvars[12]),rg_give_item(id,"weapon_hegrenade"),rg_give_item(id,"weapon_flashbang"),rg_give_item(id,"weapon_smokegrenade"),esya_say[id]++;
				client_print_color(id, id, "^1[^3%s^1] ^4Cephane menusunden^1 Bomba Seti ^4aldin.",SERVERISMI),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[12])),cephanemenum(id);
		}
		case 5 : {
			if(TL[id] >= get_pcvar_float(cvars[13])) {
				TL[id]-=get_pcvar_float(cvars[13]),hasarkatla[id]=true,/* unammo[id]=true,*/esya_say[id]++;
				client_print_color(id, id, "^1[^3%s^1] ^4Cephane menusunden^1 Hasar 2'ye katla ^4aldin.",SERVERISMI),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[13])),cephanemenum(id);
		}
		case 6 : {
			if(TL[id] >= get_pcvar_float(cvars[14])) {
				TL[id]-=get_pcvar_float(cvars[14]),esya_say[id]++;
				rg_give_item(id,"weapon_glock18");
				client_print_color(id, id, "^1[^3%s^1] ^4Cephane menusunden^1 Tek Sarjorlu Glock ^4aldin.",SERVERISMI),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[14])),cephanemenum(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public saldirimenum(id) {
	new ndmenu[64];
	formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yTaarruz Menu",SERVERISMI);
	new Menu = menu_create(ndmenu,"saldirimenum2");

	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wMahkumlara +50 HP Ver \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[15]));
	menu_additem(Menu,ndmenu,"1");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wMahkumlara Sis Bombasi Ver \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[16]));
	menu_additem(Menu,ndmenu,"2");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wGardiyanlari Flasla \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[17]));
	menu_additem(Menu,ndmenu,"3");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wGardiyanlari 3sn. Gom \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[18]));
	menu_additem(Menu,ndmenu,"4");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wGardiyanlara 10sn. Drug Ver \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[19]));
	menu_additem(Menu,ndmenu,"5");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wMahkumlara El Bombasi Ver \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[20]));
	menu_additem(Menu,ndmenu,"6");
	if(!menu_tl[id]) formatex(ndmenu,charsmax(ndmenu),"\yCebinizdeki TL \d- \r[ %0.2f ]",TL[id]),menu_addtext(Menu, ndmenu);

	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);

	return PLUGIN_HANDLED;
}
public saldirimenum2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32],players[32], inum, ids;
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	get_user_name(id, iname, charsmax(iname));
	new key=str_to_num(data);
	switch(key) {
		case 1 : {
			if(TL[id] >= get_pcvar_float(cvars[15])) {
				TL[id]-=get_pcvar_float(cvars[15]),esya_say[id]++;
				get_players_ex(players, inum, GetPlayers_ExcludeDead | GetPlayers_MatchTeam, "TERRORIST"); 
				//get_players(players,inum,"acehi","TERRORIST"); 

				for(new i=0; i<inum; i++) ids=players[i],set_entvar(ids, var_health, Float:get_entvar(ids, var_health)+50.0);
				client_print_color(0, 0, "^1[^3%s^1] ^4Mahkumlardan^1 %s ^4tum mahkumlara taarruz menusunden ^1+50 HP ^4verdi.",SERVERISMI,iname),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[15])),saldirimenum(id);
		}
		case 2 : {
			if(TL[id] >= get_pcvar_float(cvars[16])) {
				TL[id]-=get_pcvar_float(cvars[16]),esya_say[id]++;
				get_players_ex(players, inum, GetPlayers_ExcludeDead | GetPlayers_MatchTeam, "TERRORIST"); 
				//get_players(players,inum,"acehi","TERRORIST"); +c

				for(new i=0; i<inum; i++) ids=players[i],rg_give_item(ids,"weapon_smokegrenade");
				client_print_color(0, 0, "^1[^3%s^1] ^4Mahkumlardan^1 %s ^4tum mahkumlara taarruz menusunden ^1Sis Bombasi ^4verdi.",SERVERISMI,iname),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[16])),saldirimenum(id);
		}
		case 3 : {
			if(TL[id] >= get_pcvar_float(cvars[17])) {
				TL[id]-=get_pcvar_float(cvars[17]),esya_say[id]++;
				get_players_ex(players, inum, GetPlayers_ExcludeDead | GetPlayers_MatchTeam, "CT"); 
				//get_players(players,inum,"acehi","CT"); +c

				for(new i=0; i<inum; i++) {
					ids=players[i];
					message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},ids);
					write_short(1<<15); write_short(1<<10); write_short(1<<12);
					write_byte(255); write_byte(255); write_byte(255); write_byte(255);
					message_end();
					emit_sound(ids, CHAN_AUTO, "weapons/flashbang-2.wav", VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
				}
				client_print_color(0, 0, "^1[^3%s^1] ^4Mahkumlardan^1 %s ^4gardiyanlari taarruz menusuyle ^1Flashladi.",SERVERISMI,iname),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[17])),saldirimenum(id);
		}
		case 4 : {
			if(TL[id] >= get_pcvar_float(cvars[18])) {
				TL[id]-=get_pcvar_float(cvars[18]),esya_say[id]++;
				get_players_ex(players, inum, GetPlayers_ExcludeDead | GetPlayers_MatchTeam, "CT"); 
				//get_players(players,inum,"acehi","CT"); +c

				for(new i=0; i<inum; i++) {
					new Float:origin[3]; ids=players[i];
					get_entvar(ids, var_origin, origin),origin[2] -=35.0,set_entvar(ids, var_origin, origin);
					set_task(3.0,"tkaldir",ids);
				}
				client_print_color(0, 0, "^1[^3%s^1] ^4Mahkumlardan^1 %s ^4gardiyanlari taarruz menusuyle^1 3 saniye Gomdu.",SERVERISMI,iname),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[18])),saldirimenum(id);
		}
		case 5 : {
			if(TL[id] >= get_pcvar_float(cvars[19])) {
				TL[id]-=get_pcvar_float(cvars[19]),esya_say[id]++;
				get_players_ex(players, inum, GetPlayers_ExcludeDead | GetPlayers_MatchTeam, "CT"); 
				//get_players(players,inum,"acehi","CT"); //+c

				for(new i=0; i<inum; i++) {
					ids=players[i];
					message_begin(MSG_ONE, get_user_msgid("SetFOV"), {0,0,0}, ids);
					write_byte(180);
					message_end();
					set_task(8.0,"drugyenile",ids);
				}
				client_print_color(0, 0, "^1[^3%s^1] ^4Mahkumlardan^1 %s ^4gardiyanlara taarruz menusunden ^1Drug^4 verdi.",SERVERISMI,iname),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[19])),saldirimenum(id);
		}
		case 6 : {
			if(TL[id] >= get_pcvar_float(cvars[20])) {
				TL[id]-=get_pcvar_float(cvars[20]),esya_say[id]++;
				get_players_ex(players, inum, GetPlayers_ExcludeDead | GetPlayers_MatchTeam, "TERRORIST"); 
				//get_players(players,inum,"acehi","TERRORIST"); //+c

				for(new i=0; i<inum; i++) ids=players[i],rg_give_item(ids,"weapon_hegrenade");
				client_print_color(0, 0, "^1[^3%s^1] ^4Mahkumlardan^1 %s, ^4tum mahkumlara taarruz menusunden ^1El Bombasi ^4verdi.",SERVERISMI,iname),anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[20])),saldirimenum(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public tkaldir(id) { new Float:origin[3]; get_entvar(id, var_origin, origin),origin[2] +=35.0,set_entvar(id, var_origin, origin); }
public drugyenile(id) message_begin(MSG_ONE, get_user_msgid("SetFOV"), {0,0,0}, id),write_byte(100),message_end();
public tltransfermenum(id) {
	new ndmenu[64];
	formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yTL Transfer Menu",SERVERISMI);
	new Menu = menu_create(ndmenu,"tltransfermenum2");

	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w15 TL Transfer Et \d[\r3 TL Kesinti\d]",KISATAG);
	menu_additem(Menu,ndmenu,"1");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w30 TL Transfer Et \d[\r6 TL Kesinti\d]",KISATAG);
	menu_additem(Menu,ndmenu,"2");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w50 TL Transfer Et \d[\r10 TL Kesinti\d]",KISATAG);
	menu_additem(Menu,ndmenu,"3");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w75 TL Transfer Et \d[\r15 TL Kesinti\d]",KISATAG);
	menu_additem(Menu,ndmenu,"4");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w100 TL Transfer Et \d[\rKesinti Yok\d]",KISATAG);
	menu_additem(Menu,ndmenu,"5");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w200 TL Transfer Et \d[\rKesinti Yok\d]",KISATAG);
	menu_additem(Menu,ndmenu,"6");
	if(!menu_tl[id]) formatex(ndmenu,charsmax(ndmenu),"\yCebinizdeki TL \d- \r[ %0.2f ]",TL[id]),menu_addtext(Menu, ndmenu);

	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);

	return PLUGIN_HANDLED;
}
public tltransfermenum2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1 : {
			if(TL[id] >= 15.00) {
				tltransfer[id]=15,oyuncusec(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar^3 15.00 TL",SERVERISMI),tltransfermenum(id);
		}
		case 2 : {
			if(TL[id] >= 30.00) {
				tltransfer[id]=30,oyuncusec(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar^3 30.00 TL",SERVERISMI),tltransfermenum(id);
		}
		case 3 : {
			if(TL[id] >= 50.00) {
				tltransfer[id]=50,oyuncusec(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar^3 50.00 TL",SERVERISMI),tltransfermenum(id);
		}
		case 4 : {
			if(TL[id] >= 75.00) {
				tltransfer[id]=75,oyuncusec(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar^3 75.00 TL",SERVERISMI),tltransfermenum(id);
		}
		case 5 : {
			if(TL[id] >= 100.00) {
				tltransfer[id]=100,oyuncusec(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar^3 100.00 TL",SERVERISMI),tltransfermenum(id);
		}
		case 6 : {
			if(TL[id] >= 200.00) {
				tltransfer[id]=200,oyuncusec(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar^3 200.00 TL",SERVERISMI),tltransfermenum(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public oyuncusec(id) {
	new ndmenu[64],namee[32],sznum[6],players[32],inum,ids;
	formatex(ndmenu, charsmax(ndmenu),"\w%s Ailesi \d|| \yTransfer Kime Yapilsin?\d",SERVERISMI);
	new Menu = menu_create(ndmenu, "oyuncusec2");

	get_players_ex(players, inum, GetPlayers_MatchTeam, "TERRORIST"); 
	//get_players(players,inum,"cehi","TERRORIST"); //+c
	for(new i=0; i<inum; i++) {
		ids=players[i];
		if(ids==id) continue;
		num_to_str(ids,sznum,charsmax(sznum)); get_user_name(ids,namee,charsmax(namee));
		formatex(ndmenu,charsmax(ndmenu),"\w%s \d[\r%.2f TL\d]",namee,TL[ids]);
		menu_additem(Menu,ndmenu,sznum);
	}
	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_BACKNAME, "\yOnceki Menu");
	menu_setprop(Menu, MPROP_NEXTNAME, "\yDiger Menu");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu);
}
public oyuncusec2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32],tname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new tempid = str_to_num(data);
	get_user_name(id, iname, charsmax(iname));
	get_user_name(tempid, tname, charsmax(tname));

	switch(tltransfer[id]) {
		case 15: {
			if(TL[id] >= 15.00) {
				TL[id]-=15.00,TL[tempid]+=12.00,anamenu(id);
				client_print_color(tempid, tempid, "^1[^3%s^1] ^4Mahkum ^1%s^4 size^1 12.00 TL^4 transfer etti.",SERVERISMI,iname);
				client_print_color(id, id, "^1[^3%s^1] ^4TL Transfer menuyle ^1%s ^4adli kisiye^1 12.00 TL^4 gonderdin.",SERVERISMI,tname);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar^3 15.00 TL",SERVERISMI),anamenu(id);
		}
		case 30: {
			if(TL[id] >= 30.00) {
				TL[id]-=30.00,TL[tempid]+=24.00,anamenu(id);
				client_print_color(tempid, tempid, "^1[^3%s^1] ^4Mahkum ^1%s^4 size^1 24.00 TL^4 transfer etti.",SERVERISMI,iname);
				client_print_color(id, id, "^1[^3%s^1] ^4TL Transfer menuyle ^1%s^4 adli kisiye^1 24.00 TL^4 gonderdin.",SERVERISMI,tname);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar^3 30.00 TL",SERVERISMI),anamenu(id);
		}
		case 50: {
			if(TL[id] >= 50.00) {
				TL[id]-=50.00,TL[tempid]+=40.00,anamenu(id);
				client_print_color(tempid, tempid, "^1[^3%s^1] ^4Mahkum ^1%s^4 size^1 40.00 TL^4 transfer etti.",SERVERISMI,iname);
				client_print_color(id, id, "^1[^3%s^1] ^4TL Transfer menuyle ^1%s ^4adli kisiye^1 40.00 TL^4 gonderdin.",SERVERISMI,tname);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar^3 50.00 TL",SERVERISMI),anamenu(id);
		}
		case 75: {
			if(TL[id] >= 75.00) {
				TL[id]-=75.00,TL[tempid]+=60.00,anamenu(id);
				client_print_color(tempid, tempid, "^1[^3%s^1] ^4Mahkum ^1%s^4 size^1 60.00 TL^4 transfer etti.",SERVERISMI,iname);
				client_print_color(id, id, "^1[^3%s^1] ^4TL Transfer menuyle ^1%s ^4adli kisiye^1 60.00 TL^4 gonderdin.",SERVERISMI,tname);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar^3 75.00 TL",SERVERISMI),anamenu(id);
		}
		case 100: {
			if(TL[id] >= 100.00) {
				TL[id]-=100.00,TL[tempid]+=100.00,anamenu(id);
				client_print_color(tempid, tempid, "^1[^3%s^1] ^4Mahkum ^1%s^4 size^1 100.00 TL^4 transfer etti.",SERVERISMI,iname);
				client_print_color(id, id, "^1[^3%s^1] ^4TL Transfer menuyle ^1%s ^4adli kisiye^1 100.00 TL^4 gonderdin.",SERVERISMI,tname);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar^3 100.00 TL",SERVERISMI),anamenu(id);
		}
		case 200: {
			if(TL[id] >= 200.00) {
				TL[id]-=200.00,TL[tempid]+=200.00,anamenu(id);
				client_print_color(tempid, tempid, "^1[^3%s^1] ^4Mahkum ^1%s^4 size^1 200.00 TL^4 transfer etti.",SERVERISMI,iname);
				client_print_color(id, id, "^1[^3%s^1] ^4TL Transfer menuyle ^1%s^4 adli kisiye^1 200.00 TL^4 gonderdin.",SERVERISMI,tname);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar^3 200.00 TL",SERVERISMI),anamenu(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public yetkilimenum(id) {
	if(bonuskontrol[id]) client_print_color(id, id, "^1[^3%s^1] ^4Her round da ^1bir kere^4 kullanabilirsin.",SERVERISMI),anamenu(id);
	else {
		new ndmenu[64];
		formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yBonus Menu",SERVERISMI);
		new Menu = menu_create(ndmenu,"yetkilimenum2");
		if(get_user_flags(id) & ADMIN_USER){ 
			formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wUserlar icin +50 Armor",KISATAG);
			menu_additem(Menu,ndmenu,"1");
	}
		else{ 
			formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wUser Menu \d[\rKAPALI\d]",KISATAG);
			menu_additem(Menu,ndmenu,"6");
	}

		if(get_user_flags(id) & SlotMenu_Yetki && ~get_user_flags(id) & AdminMenu_Yetki){
		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wSlot Menu \d[\yACIK\d]",KISATAG);
		menu_additem(Menu,ndmenu,"2");
	}
		else{ 
			formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wSlot Menu \d[\rKAPALI\d]",KISATAG);
			menu_additem(Menu,ndmenu,"6");
		}

		if(get_user_flags(id) & AdminMenu_Yetki && ~get_user_flags(id) & VIPELITMenu_Yetki){
		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wAdmin Menu \d[\yACIK\d]",KISATAG);
		menu_additem(Menu,ndmenu,"3");
	}
		else{
		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wAdmin Menu \d[\rKAPALI\d]",KISATAG);
		menu_additem(Menu,ndmenu,"6");
	}

		if(get_user_flags(id) & VIPELITMenu_Yetki && ~get_user_flags(id) & YoneticiMenu_Yetki){
			formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wVIP-ELIT Menu \d[\yACIK\d]",KISATAG);
			menu_additem(Menu,ndmenu,"4");
		}
		else{
			formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wVIP-ELIT Menu \d[\rKAPALI\d]",KISATAG);
			menu_additem(Menu,ndmenu,"6");
		}


		if(get_user_flags(id) & YoneticiMenu_Yetki){
			formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wYonetici Menu \d[\yACIK\d]^n",KISATAG);
			menu_additem(Menu,ndmenu,"5");
		}
		else{ 
			formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wYonetici Menu \d[\rKAPALI\d]^n",KISATAG);
			menu_additem(Menu,ndmenu,"6");
	}

		if(get_user_flags(id) & ADMIN_USER) menu_additem(Menu, "\yYetkili Olmak Istiyorsan \rTIKLA", "6");

		menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
		menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
		menu_display(id, Menu, 0);
	}
	return PLUGIN_HANDLED;
}
public yetkilimenum2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1 : {
			set_entvar(id, var_armorvalue, Float:get_entvar(id, var_armorvalue)+50.0),bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4Oyuncu Bonus Menusunden userlere ozel^1 +50 Armor ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 2 : slotmenum(id);
		case 3 : adminmenum(id);
		case 4 : vipelitmenum(id);
		case 5 : yoneticimenum(id);
		case 6 : { 
			if(is_user_steam(id) || get_user_flags(id) & ADMIN_RESERVATION) client_print_color(id, id, "^1[^3%s^1] ^4Teamspeak 3 IP : ^1%s ^3|| ^1/ts3",SERVERISMI,TS3IP);
			else client_cmd(id,"say /ts3");
			yetkilimenum(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public slotmenum(id) {
	new ndmenu[64];
	formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \ySLOT Menu",SERVERISMI);
	new Menu = menu_create(ndmenu,"slotmenum2");

	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w75 Zirh Al",KISATAG);
	menu_additem(Menu,ndmenu,"1");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w20 HP Al",KISATAG);
	menu_additem(Menu,ndmenu,"2");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wSmoke Bombasi Al",KISATAG);
	menu_additem(Menu,ndmenu,"3");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wHasar Azalt Al",KISATAG);
	menu_additem(Menu,ndmenu,"4");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wSansina Gore Bonus Al",KISATAG);
	menu_additem(Menu,ndmenu,"5");

	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);

	return PLUGIN_HANDLED;
}
public slotmenum2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1 : {
			set_entvar(id, var_armorvalue, Float:get_entvar(id, var_armorvalue)+75.0),bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4Slot menusunden^1 +75 Armor ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 2 : {
			set_entvar(id, var_health, Float:get_entvar(id, var_health)+20.0),bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4Slot menusunden^1 +20 HP ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 3 : {
			rg_give_item(id,"weapon_smokegrenade"),bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4Slot menusunden^1 Smoke Bombasi ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 4 : {
			hasarazalt[id]=true,bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4Slot menusunden^1 Hasar Azalt ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 5 : {
			if(jbonuskontrol[id]<0) client_print_color(id, id, "^1[^3%s^1] ^4JB Bonusu 3 elde 1 kere alabilirsin.",SERVERISMI),slotmenum(id);
			else bonuskontrol[id]=true,jbonuskontrol[id]=-3,jbonusmenum(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public adminmenum(id) {
	new ndmenu[64];
	formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yADMIN Menu",SERVERISMI);
	new Menu = menu_create(ndmenu,"adminmenum2");

	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w100 Zirh Al",KISATAG);
	menu_additem(Menu,ndmenu,"1");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w50 HP Al",KISATAG);
	menu_additem(Menu,ndmenu,"2");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wFlash Bombasi Al",KISATAG);
	menu_additem(Menu,ndmenu,"3");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wHasar Azalt Al",KISATAG);
	menu_additem(Menu,ndmenu,"4");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wSansina Gore Bonus Al",KISATAG);
	menu_additem(Menu,ndmenu,"5");

	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);

	return PLUGIN_HANDLED;
}
public adminmenum2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1 : {
			set_entvar(id, var_armorvalue, Float:get_entvar(id, var_armorvalue)+100.0),bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4Admin menusunden^1 +100 Armor ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 2 : {
			set_entvar(id, var_health, Float:get_entvar(id, var_health)+50.0),bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4Admin menusunden^1 +50 HP ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 3 : {
			rg_give_item(id,"weapon_flashbang"),bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4Admin menusunden^1 Flash Bombasi ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 4 : {
			hasarazalt[id]=true,bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4Admin menusunden^1 Hasar Azalt ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 5 : {
			if(jbonuskontrol[id]<0) client_print_color(id, id, "^1[^3%s^1] ^4JB Bonusu 3 elde 1 kere alabilirsin.",SERVERISMI),adminmenum(id);
			else bonuskontrol[id]=true,jbonuskontrol[id]=-3,jbonusmenum(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public vipelitmenum(id) {
	new ndmenu[64];
	formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yVIP-ELIT Menu",SERVERISMI);
	new Menu = menu_create(ndmenu,"vipelitmenum2");

	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w150 Zirh Al",KISATAG);
	menu_additem(Menu,ndmenu,"1");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w75 HP Al",KISATAG);
	menu_additem(Menu,ndmenu,"2");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wEl Bombasi Al",KISATAG);
	menu_additem(Menu,ndmenu,"3");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wHasar Azalt Al",KISATAG);
	menu_additem(Menu,ndmenu,"4");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wSansina Gore Bonus Al",KISATAG);
	menu_additem(Menu,ndmenu,"5");

	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);

	return PLUGIN_HANDLED;
}
public vipelitmenum2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1 : {
			set_entvar(id, var_armorvalue, Float:get_entvar(id, var_armorvalue)+150.0),bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4VIP-ELIT menusunden^1 +150 Armor ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 2 : {
			set_entvar(id, var_health, Float:get_entvar(id, var_health)+75.0),bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4VIP-ELIT menusunden^1 +75 HP ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 3 : {
			rg_give_item(id,"weapon_hegrenade"),bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4VIP-ELIT menusunden^1 El Bombasi ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 4 : {
			hasarazalt[id]=true,bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4VIP-ELIT menusunden^1 Hasar Azalt ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 5 : {
			if(jbonuskontrol[id]<0) client_print_color(id, id, "^1[^3%s^1] ^4JB Bonusu 3 elde 1 kere alabilirsin.",SERVERISMI),vipelitmenum(id);
			else bonuskontrol[id]=true,jbonuskontrol[id]=-3,jbonusmenum(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public yoneticimenum(id) {
	new ndmenu[64];
	formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yYONETICI Menu",SERVERISMI);
	new Menu = menu_create(ndmenu,"yoneticimenum2");

	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w200 Zirh Al",KISATAG);
	menu_additem(Menu,ndmenu,"1");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \w100 HP Al",KISATAG);
	menu_additem(Menu,ndmenu,"2");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wBomba Seti Al",KISATAG);
	menu_additem(Menu,ndmenu,"3");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wHasar Azalt Al",KISATAG);
	menu_additem(Menu,ndmenu,"4");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wSansina Gore Bonus Al",KISATAG);
	menu_additem(Menu,ndmenu,"5");

	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);

	return PLUGIN_HANDLED;
}
public yoneticimenum2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1 : {
			set_entvar(id, var_armorvalue, Float:get_entvar(id, var_armorvalue)+200.0),bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4Yonetici menusunden^1 +200 Armor ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 2 : {
			set_entvar(id, var_health, Float:get_entvar(id, var_health)+100.0),bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4Yonetici menusunden^1 +100 HP ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 3 : {
			rg_give_item(id,"weapon_smokegrenade"),rg_give_item(id,"weapon_hegrenade"),rg_give_item(id,"weapon_flashbang"),bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4Yonetici menusunden^1 Bomba Seti ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 4 : {
			hasarazalt[id]=true,bonuskontrol[id]=true;
			client_print_color(id, id, "^1[^3%s^1] ^4Yonetici menusunden^1 Hasar Azalt ^4aldin.",SERVERISMI),anamenu(id);
		}
		case 5 : {
			if(jbonuskontrol[id]<0) client_print_color(id, id, "^1[^3%s^1] ^4JB Bonusu^1 3 elde 1 ^4kere alabilirsin.",SERVERISMI),yoneticimenum(id);
			else bonuskontrol[id]=true,jbonuskontrol[id]=-3,jbonusmenum(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public jbonusmenum(id) {
	new mnum=random_num(1,4);
	switch(mnum) {
		case 1: TL[id]+=4.99,client_print_color(id, id, "^1[^3%s^1] ^4Sansina gore bonustan ^1+4.99 TL ^4kazandin.",SERVERISMI);
		case 2: TL[id]+=0.99,client_print_color(id, id, "^1[^3%s^1] ^4Sansina gore bonustan ^1+0.99 TL ^4kazandin.",SERVERISMI);
		case 3: TL[id]+=20.50,client_print_color(id, id, "^1[^3%s^1] ^4Sansina gore bonustan ^1+20.50 TL ^4kazandin.",SERVERISMI);
		case 4: TL[id]+=7.31,client_print_color(id, id, "^1[^3%s^1] ^4Sansina gore bonustan ^1+7.31 TL ^4kazandin.",SERVERISMI);
	}
	anamenu(id);
}
public sansmenum(id) {
	if(sanskontrol[id]) client_print_color(id,id,"^1[^3%s^1] ^4Suanda menuye giris yapamazsin.",SERVERISMI);
	else {
		new ndmenu[72];
		formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \ySans Menuleri",SERVERISMI);
		new Menu = menu_create(ndmenu,"sansmenum2");
		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wSansli Asal Sayi \d[\r%0.2f TL\d] \yOdul 20.00 TL",KISATAG,get_pcvar_float(cvars[21]));
		menu_additem(Menu,ndmenu,"1");
		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wKlasik Sans Kutusu \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[22]));
		menu_additem(Menu,ndmenu,"2");
		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wCS:GO Kasa-Anahtar Menu",KISATAG);
		menu_additem(Menu,ndmenu,"3");
		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wSifreli Celik Kasa",KISATAG);
		menu_additem(Menu,ndmenu,"4");

		if(!menu_tl[id]) formatex(ndmenu,charsmax(ndmenu),"\yCebinizdeki TL \d- \r[ %0.2f ]",TL[id]),menu_addtext(Menu, ndmenu);

		menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
		menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
		menu_display(id, Menu, 0);
	}
	return PLUGIN_HANDLED;
}
public sansmenum2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1 : {
			if(TL[id] >= get_pcvar_float(cvars[21]) && asalkontrol[id]<5) {
				TL[id]-=get_pcvar_float(cvars[21]);
				new asal=random_num(8,100); new asall=1;
				for(new i=7; i>1; i--) if(asal%i == 0) asall=0;
				if(asall) TL[id]+=20.00,client_print_color(id,id,"^1[^3%s^1] ^4Sansiniza gelen sayi ^1[^3%d^1] ^4asal sayidir. ^1Odulunuz^3 20.00 TL",SERVERISMI,asal);
				else if(!asall) client_print_color(id,id,"^1[^3%s^1] ^4Sansiniza gelen sayi ^1[^3%d^1] ^4asal sayi degildir. Odul alamadiniz.",SERVERISMI,asal);
				asalkontrol[id]++,anamenu(id);
			} else if(asalkontrol[id]>4) client_print_color(id, id, "^1[^3%s^1] ^4Sansli asal sayi oyununu ^1her elde 5 kere^4 kullanabilirsiniz.",SERVERISMI),sansmenum(id);
			else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[21])),sansmenum(id);
		}
		case 2 : {
			if(TL[id] >= get_pcvar_float(cvars[22])) {
				TL[id]-=get_pcvar_float(cvars[22]);
				new mnum=random_num(1,5);
				switch(mnum) {
					case 1: {
						set_entvar(id, var_health, Float:get_entvar(id, var_health)+150.0);
						client_print_color(id, id, "^1[^3%s^1] ^4Klasik Sans kutusundan^1 +150 HP ^4kazandin.",SERVERISMI);
					}
					case 2: {
						set_entvar(id, var_armorvalue, Float:get_entvar(id, var_armorvalue)+100.0);
						client_print_color(id, id, "^1[^3%s^1] ^4Klasik Sans kutusundan^1 +100 Armor ^4kazandin.",SERVERISMI);
					}
					case 3: {
						TL[id]+=50.00;
						client_print_color(id, id, "^1[^3%s^1] ^4Klasik Sans kutusundan^1 +50.00 TL ^4kazandin.",SERVERISMI);
					}
					case 4: {
						TL[id]=0.00;
						client_print_color(id, id, "^1[^3%s^1] ^4Klasik Sans kutusundan^1 Iflas ^4cikti :)",SERVERISMI);
					}
					case 5: {
						rg_give_item(id,"weapon_hegrenade"),TL[id]+=30.00;
						client_print_color(id, id, "^1[^3%s^1] ^4Klasik Sans kutusundan^1 El Bombasi + 30.00 TL ^4kazandin.",SERVERISMI);
					}
				}
				anamenu(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[22])),sansmenum(id);
		}
		case 3 : csgokasam(id);
		case 4 : box(id); 
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public csgokasam(id) {
	new ndmenu[64];
	formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yCS:GO Kasa-Anahtar Menusu",SERVERISMI);
	new Menu = menu_create(ndmenu,"csgokasam2");

	if(kasa[id] > 0 && anahtar[id] > 0) formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wKasa AC",KISATAG);
	else if(kasa[id] > 0 && anahtar[id] < 1) formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wKasa Acamazsin. \yAnahtar Eksik!",KISATAG);
	else if(kasa[id] < 1 && anahtar[id] > 0) formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wKasa Acamazsin. \yKasa Eksik!",KISATAG);
	else if(kasa[id] < 1 && anahtar[id] < 1) formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wKasa Acamazsin. \yKasa ve Anahtar Eksik!",KISATAG);
	menu_additem(Menu,ndmenu,"1");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wKasa Satin Al \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[23]));
	menu_additem(Menu,ndmenu,"2");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wAnahtar Satin Al \d[\r%0.2f TL\d]",KISATAG,get_pcvar_float(cvars[24]));
	menu_additem(Menu,ndmenu,"3");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wKasadaki Esyalar^n",KISATAG);
	menu_additem(Menu,ndmenu,"4");
	formatex(ndmenu,charsmax(ndmenu),"\yKasa Adedi \d- \r[ %d ]",kasa[id]);
	menu_addtext(Menu,ndmenu);
	formatex(ndmenu,charsmax(ndmenu),"\yAnahtar Adedi \d- \r[ %d ]",anahtar[id]);
	menu_addtext(Menu,ndmenu);
	if(!menu_tl[id]) formatex(ndmenu,charsmax(ndmenu),"\yCebinizdeki TL \d- \r[ %0.2f ]",TL[id]),menu_addtext(Menu, ndmenu);

	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);

	return PLUGIN_HANDLED;
}
public csgokasam2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1: {
			if(kasa[id] > 0 && anahtar[id] > 0){
				kasa[id]--,anahtar[id]--,sanskontrol[id]=true,kasakontrol1[id]=true;
				set_task(3.8,"azalan",id),set_task(1.2,"fade",id),set_task(6.1,"kapat",id);
				client_print_color(id, id, "^1[^3%s^1] ^4Kasaniz aciliyor.",SERVERISMI);
				emit_sound(id, CHAN_AUTO, kutu_acilis, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
				message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},id);
				write_short(1<<14); write_short(1<<9); write_short(1<<11);
				write_byte(255); write_byte(255); write_byte(255); write_byte(255);
				message_end();
			} else client_print_color(id, id, "^1[^3%s^1] ^4Eksik esyaniz var.",SERVERISMI),csgokasam(id);
		}
		case 2: {
			if(TL[id] >= get_pcvar_float(cvars[23])) {
				TL[id]-=get_pcvar_float(cvars[23]),kasa[id]++;
				client_print_color(id, id, "^1[^3%s^1] ^4CS:GO Kasa Menusunden ^1Kasa ^4aldin.",SERVERISMI),csgokasam(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[23])),csgokasam(id);
		}
		case 3: {
			if(TL[id] >= get_pcvar_float(cvars[24])) {
				TL[id]-=get_pcvar_float(cvars[24]),anahtar[id]++;
				client_print_color(id, id, "^1[^3%s^1] ^4CS:GO Kasa Menusunden ^1Anahtar ^4aldin.",SERVERISMI),csgokasam(id);
			} else client_print_color(id, id, "^1[^3%s^1] ^4Maalesef yeterli paraniz yok. ^1Gereken miktar ^3%0.2f TL",SERVERISMI,get_pcvar_float(cvars[24])),csgokasam(id);
		}
		case 4: kasaicerik(id);
		case 5: csgokasam(id);
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public fade(id) {
	if(kasakontrol1[id]) {	
		message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},id);
		write_short(~0); write_short(~0); write_short(1<<12);
		write_byte(random_num(0,255)); write_byte(random_num(0,255)); write_byte(random_num(0,255)); write_byte(random_num(70,200));
		message_end();
		set_task(0.2,"fade",id);
	}
}
public azalan(id) kasakontrol1[id]=false,kasakontrol2[id]=true,set_task(1.0,"renkx",id);
public renkx(id) {
	if(kasakontrol2[id]) {
		new mnum=random_num(1,6); set_task(1.0,"renkx",id);
		switch(mnum) {
			case 1: {
				kasa_renk[id]=1; //sari item
				message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},id);
				write_short(~0); write_short(~0); write_short(1<<12);
				write_byte(255); write_byte(255); write_byte(0); write_byte(100);
				message_end();
			}
			case 2: {
				kasa_renk[id]=2; //kirmizi item
				message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},id);
				write_short(~0); write_short(~0); write_short(1<<12);
				write_byte(255); write_byte(0); write_byte(0); write_byte(100);
				message_end();
			}
			case 3: {
				kasa_renk[id]=5; // mavi item
				message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},id);
				write_short(~0); write_short(~0); write_short(1<<12);
				write_byte(0); write_byte(127); write_byte(255); write_byte(100);
				message_end();
			}
			case 4: {
				kasa_renk[id]=3; // pembe item
				message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},id);
				write_short(~0); write_short(~0); write_short(1<<12);
				write_byte(255); write_byte(0); write_byte(212); write_byte(100);
				message_end();
			}
			case 5: {
				kasa_renk[id]=4; // beyaz item 
				message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},id);
				write_short(~0); write_short(~0); write_short(1<<12);
				write_byte(255); write_byte(255); write_byte(255); write_byte(100);
				message_end();	
			}
			case 6: {
				kasa_renk[id]=6; // siyah item 
				message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},id);
				write_short(~0); write_short(~0); write_short(1<<12);
				write_byte(0); write_byte(0); write_byte(0); write_byte(100);
				message_end();
			}
		}
	}
}
public kapat(id) kasakontrol2[id]=false,set_task(0.5,"ekrana",id);
public ekrana(id) {
	new name[32]; get_user_name(id,name,charsmax(name));
	switch(kasa_renk[id]) {
		case 1: {
			client_print_color(id, id, "^1[^3%s^1] ^4CS:GO Kasasindan^1 Sari item ^4kazandin.",SERVERISMI);
			client_print_color(0, 0, "^1[^3%s^1] ^4Mahkumlardan ^1%s ^4CS:GO Kasasindan ^1Sari item ^4cikardi.",SERVERISMI,name);
			rg_give_item(id,"weapon_hegrenade"),rg_give_item(id,"weapon_flashbang"),rg_give_item(id,"weapon_smokegrenade"),sanskontrol[id]=false;

			emit_sound(id, CHAN_AUTO, kutu_dolu, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},id);
			write_short(1<<14); write_short(1<<9); write_short(1<<11);
			write_byte( 255 ); write_byte( 255 ); write_byte( 0 ); write_byte( 255 );
			message_end();	
		}
		case 2: {
			client_print_color(id, id, "^1[^3%s^1] ^4CS:GO Kasasindan^1 Kirmizi item ^4kazandin.",SERVERISMI);
			client_print_color(0, 0, "^1[^3%s^1] ^4Mahkumlardan ^1%s ^4CS:GO Kasasindan ^1Kirmizi item ^4cikardi.",SERVERISMI,name);
			kasa[id]+=2,sanskontrol[id]=false,TL[id]+=50.00;

			emit_sound(id, CHAN_AUTO, kutu_dolu, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},id);
			write_short(1<<14); write_short(1<<9); write_short(1<<11);
			write_byte( 255 ); write_byte( 0 ); write_byte( 0 ); write_byte( 255 );
			message_end();
		}
		case 3: {
			client_print_color(id, id, "^1[^3%s^1] ^4CS:GO Kasasindan^1 Mor item ^4kazandin.",SERVERISMI);
			client_print_color(0, 0, "^1[^3%s^1] ^4Mahkumlardan ^1%s ^4CS:GO Kasasindan ^1Mor item ^4cikardi.",SERVERISMI,name);		
			anahtar[id]+=2,sanskontrol[id]=false;

			emit_sound(id, CHAN_AUTO, kutu_dolu, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},id);
			write_short(1<<14); write_short(1<<9); write_short(1<<11);
			write_byte( 255 ); write_byte( 0 ); write_byte( 255); write_byte( 255 );
			message_end();	
		}
		case 4: {
			client_print_color(id, id, "^1[^3%s^1] ^4CS:GO Kasasindan^1 Hicbir sey ^4kazanamadin :(",SERVERISMI);
			client_print_color(0, 0, "^1[^3%s^1] ^4Mahkumlardan ^1%s ^4CS:GO Kasasindan ^1Beyaz item ^4cikardi.",SERVERISMI,name);	
			sanskontrol[id]=false;

			emit_sound(id, CHAN_AUTO, kutu_bos, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},id); 
			write_short(1<<14); write_short(1<<9); write_short(1<<11);
			write_byte( 255 ); write_byte( 255 ); write_byte( 255); write_byte(255);
			message_end();	
		}
		case 5: {	
			client_print_color(id, id, "^1[^3%s^1] ^4CS:GO Kasasindan^1 Mavi item ^4kazandin",SERVERISMI);
			client_print_color(0, 0, "^1[^3%s^1] ^4Mahkumlardan ^1%s ^4CS:GO Kasasindan ^1Mavi item ^4cikardi.",SERVERISMI,name);
			rg_give_item(id,"weapon_usp"),hasarazalt[id]=true,sanskontrol[id]=false;

			emit_sound(id, CHAN_AUTO, kutu_dolu, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},id);
			write_short(1<<14); write_short(1<<9); write_short(1<<11);
			write_byte( 0 ); write_byte(127); write_byte(255); write_byte(255 );
			message_end();	
		}
		case 6: {
			client_print_color(id, id, "^1[^3%s^1] ^4CS:GO Kasasindan^1 Siyah item ^4cikardiniz.",SERVERISMI);
			new mnum=random_num(1,2);
			switch(mnum) {
				case 1: client_print_color(id, id, "^1[^3%s^1] ^4Tum paran alindi. Teselli icin ^1 bir tane kasa^4 kazandin :)",SERVERISMI),kasa[id]++;
				case 2: client_print_color(id, id, "^1[^3%s^1] ^4Tum paran alindi.",SERVERISMI);
			}
			client_print_color(0, 0, "^1[^3%s^1] ^4Mahkumlardan ^1%s ^4CS:GO Kasasindan ^1Siyah item ^4cikardi.",SERVERISMI,name);	
			sanskontrol[id]=false,TL[id]=0.00;

			emit_sound(id, CHAN_AUTO, kutu_bos, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},id);
			write_short(1<<14); write_short(1<<9); write_short(1<<11);
			write_byte(0); write_byte(0); write_byte(0); write_byte(255);
			message_end();
		}
	}
	kasa_renk[id]=0;
}
public kasaicerik(id) {
	new ndmenu[64];
	formatex(ndmenu,charsmax(ndmenu),"\w%s Aiesli \d|| \yCS:GO Kasasindaki Itemler",SERVERISMI);
	new Menu = menu_create(ndmenu,"csgokasam2");

	menu_additem(Menu, "\dCS:GO Kasa Menusune Don.^n","5");
	menu_addtext(Menu,"\rMavi Item : \wUSP + Hasar Azalt");
	menu_addtext(Menu,"\rKirmizi Item : \w50.00 TL + 2 Kasa");
	menu_addtext(Menu,"\rSari Item : \wBomba Paketi");
	menu_addtext(Menu,"\rMor Item : \w+2 Anahtar");
	menu_addtext(Menu,"\rBeyaz Item : \wBos Kasa");
	menu_addtext(Menu,"\rSiyah Item : \wIflas Kasasi");

	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);

	return PLUGIN_HANDLED;
}
public ayaklanmamenum(id) {
	if(!(get_user_flags(id) & AyaklanmaBaskan_Yetki) && !(get_user_flags(id) & AyaklanmaUye_Yetki)) {
		#if defined TS3IP
			client_print_color(id, id, "^1[^3%s^1] ^4Ayaklanma Uyesi degilsin. Aramiza katilmak istersen ^1/ts3^4 yazabilirsin.",SERVERISMI);
		#else
			client_print_color(id, id, "^1[^3%s^1] ^4Ayaklanma Uyesi degilsin. Aramiza katilmak istersen ^1/dc^4 yazabilirsin.",SERVERISMI);
		#endif
		anamenu(id);
	} else if(!ayaklanma_kontrol) client_print_color(id, id, "^1[^3%s^1] ^4Suanda herhangi bir ayaklanma yok.^3 Baskaninla gorus.",SERVERISMI),anamenu(id);
	else if(ayaklanmakontrol[id]) client_print_color(id, id, "^1[^3%s^1] ^4Ayaklanma menusunu her round da ^1bir kere ^4kullanabilirsin.",SERVERISMI),anamenu(id);
	else {
		new baskanim=0,uyem=0,players[32], inum, ids; get_players(players,inum,"cehi","TERRORIST"); //+c
		for(new i=0; i<inum; i++) {
			ids=players[i];
			if(get_user_flags(ids) & AyaklanmaBaskan_Yetki) baskanim++;
			else if(get_user_flags(ids) & AyaklanmaUye_Yetki) uyem++;
		}
		new ndmenu[128];
		formatex(ndmenu,charsmax(ndmenu),"\w%s Clan \d|| \yAyaklanma Menusu^n\dMahkumlarda suan \r%i\d baskan, \r%i\d tane uye aktif.",SERVERISMI,baskanim,uyem);
		new Menu = menu_create(ndmenu,"ayaklanmamenum2");

		if(get_user_flags(id) & AyaklanmaBaskan_Yetki) menu_additem(Menu,"\yAyaklanma Baskan Menusu \r[ \dAcik \r]^n","1");
		else menu_additem(Menu,"\yBaskan Menusu \r[ \dSadece Baskanlar Girebilir \r]^n","1");	
		menu_additem(Menu,"\yHasari Ikiye Katla \r[ \dUyelere Ozel \r]","2");
		if(!ayaklanmareklami[id]) menu_additem(Menu,"\yAyaklanma Reklami At \r[ \d+10 HP Hediye \r]^n","3");
		else menu_additem(Menu,"\yAyaklanma Reklami Attin^n","3");
		menu_addtext(Menu,"\wBu menu sadece Ayaklanma Uyelerine Ozeldir.");

		menu_setprop(Menu, MPROP_EXITNAME, "\yCikis");
		menu_display(id, Menu, 0);
	}
	return PLUGIN_HANDLED;
}
public ayaklanmamenum2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1 : {
			if(get_user_flags(id) & AyaklanmaBaskan_Yetki) baskanmenum(id);
			else client_print_color(id, id, "^1[^3%s^1] ^4Bu menuye sadece Ayaklanma Baskanlari girebilir.",SERVERISMI),ayaklanmamenum(id);
		}
		case 2 : hasarkatla[id]=true,ayaklanmakontrol[id]=true,anamenu(id),client_print_color(id, id, "^1[^3%s^1] ^4Ayaklanma menusunden ^1Hasari Ikiye Katla ^4aldin.",SERVERISMI);
		case 3 : {
			if(!ayaklanmareklami[id]) {
				ayaklanmareklami[id]=true,set_entvar(id, var_health, Float:get_entvar(id, var_health)+10.0),ayaklanmamenum(id);
				#if defined TS3IP
					client_print_color(0, 0, "^1[^3%s^1] ^4Suanda ayaklanma devam ediyor. Katilmak icin ^1/ts3 ^4adresimize gelebilirsiniz.",SERVERISMI);
				#else 
					client_print_color(0, 0, "^1[^3%s^1] ^4Suanda ayaklanma devam ediyor. Katilmak icin ^1/dc ^4adresimize gelebilirsiniz.",SERVERISMI);
				#endif
			} else ayaklanmamenum(id),client_print_color(id, id, "^1[^3%s^1] ^4Her roundda ^1bir defa^4 kullanabilirsin.",SERVERISMI);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public baskanmenum(id) {
	if(!ayaklanma_kontrol) client_print_color(id, id, "^1[^3%s^1] ^4Suanda herhangi bir ayaklanma yok. Baskaninla gorus.",SERVERISMI),anamenu(id);
	else if(ayaklanmakontrol[id]) client_print_color(id, id, "^1[^3%s^1] ^4Ayaklanma menusunu her round da ^1bir kere ^4kullanabilirsin.",SERVERISMI),anamenu(id);
	else {
		new baskanim=0,uyem=0,players[32], inum, ids; get_players(players,inum,"cehi","TERRORIST"); //+c
		for(new i=0; i<inum; i++) {
			ids=players[i];
			if(get_user_flags(ids) & AyaklanmaBaskan_Yetki) baskanim++;
			else if(get_user_flags(ids) & AyaklanmaUye_Yetki) uyem++;
		}
		new ndmenu[128];
		formatex(ndmenu,charsmax(ndmenu),"\w%s Clan \d|| \yAyaklanma Baskan Menusu^n\dMahkumlarda suan \r%i\d baskan, \r%i\d tane uye aktif.",SERVERISMI,baskanim,uyem);
		new Menu = menu_create(ndmenu,"baskanmenum2");

		formatex(ndmenu,charsmax(ndmenu),"\d[\r%s\d] \w- \yTakimina 50 Armor Ver",KISATAG);
		menu_additem(Menu,ndmenu,"1");
		formatex(ndmenu,charsmax(ndmenu),"\d[\r%s\d] \w- \yTakimina 25 HP Ver",KISATAG);
		menu_additem(Menu,ndmenu,"2");
		formatex(ndmenu,charsmax(ndmenu),"\d[\r%s\d] \w- \yTakimina Sis Bombasi Ver",KISATAG);
		menu_additem(Menu,ndmenu,"3");
		formatex(ndmenu,charsmax(ndmenu),"\d[\r%s\d] \w- \yTakiminin Alacagi Hasari Azalt",KISATAG);
		menu_additem(Menu,ndmenu,"4");
		formatex(ndmenu,charsmax(ndmenu),"\d[\r%s\d] \w- \yTakimina 5.49 TL Dagit^n",KISATAG);
		menu_additem(Menu,ndmenu,"5");
		menu_addtext(Menu, "\wDagittiklarin sadece sana ve ayaklanma uyelerine gider.");

		menu_setprop(Menu, MPROP_EXITNAME, "\yCikis");
		menu_display(id, Menu, 0);
	}
	return PLUGIN_HANDLED;
}
public baskanmenum2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32],players[32], inum, ids; 
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	get_user_name(id,iname,charsmax(iname));
	new key=str_to_num(data);
	switch(key) {
		case 1 : {
			ayaklanmakontrol[id]=true,client_print_color(0, 0, "^1[^3%s^1] ^4Ayaklanma baskani ^1%s^4 tum ayaklanma uyelerine ^1+50 Armor^4 dagitti.",SERVERISMI,iname);
			get_players(players,inum,"acehi","TERRORIST"); //+c
			for(new i=0; i<inum; i++) {
				ids=players[i]; 
				if(get_user_flags(ids) & AyaklanmaUye_Yetki) set_entvar(ids, var_armorvalue, Float:get_entvar(ids, var_armorvalue)+50.0);
			}
		}
		case 2 : {
			ayaklanmakontrol[id]=true,client_print_color(0, 0, "^1[^3%s^1] ^4Ayaklanma baskani ^1%s^4 tum ayaklanma uyelerine ^1+25 HP^4 dagitti.",SERVERISMI,iname);
			get_players(players,inum,"acehi","TERRORIST"); //+c
			for(new i=0; i<inum; i++) {
				ids=players[i]; 
				if(get_user_flags(ids) & AyaklanmaUye_Yetki) set_entvar(ids, var_health, Float:get_entvar(ids, var_health)+25.0);
			}
		}
		case 3 : {
			ayaklanmakontrol[id]=true,client_print_color(0, 0, "^1[^3%s^1] ^4Ayaklanma baskani ^1%s^4 tum ayaklanma uyelerine ^1Sis bombasi^4 dagitti.",SERVERISMI,iname);
			get_players(players,inum,"acehi","TERRORIST"); //+c
			for(new i=0; i<inum; i++) {
				ids=players[i]; 
				if(get_user_flags(ids) & AyaklanmaUye_Yetki) rg_give_item(ids,"weapon_smokegrenade");
			}
		}
		case 4 : {
			ayaklanmakontrol[id]=true,client_print_color(0, 0, "^1[^3%s^1] ^4Ayaklanma baskani ^1%s^4 tum ayaklanma uyelerine ^1Hasar Azaltici^4 dagitti.",SERVERISMI,iname);
			get_players(players,inum,"acehi","TERRORIST"); //+c
			for(new i=0; i<inum; i++) {
				ids=players[i]; 
				if(get_user_flags(ids) & AyaklanmaUye_Yetki) hasarazalt[ids]=true;
			}
		}
		case 5 : {
			ayaklanmakontrol[id]=true,client_print_color(0, 0, "^1[^3%s^1] ^4Ayaklanma baskani ^1%s^4 tum ayaklanma uyelerine ^1+5.49 TL^4 dagitti.",SERVERISMI,iname);
			get_players(players,inum,"acehi","TERRORIST"); //+c
			for(new i=0; i<inum; i++) {
				ids=players[i]; 
				if(get_user_flags(ids) & AyaklanmaUye_Yetki) TL[ids]+=5.49;
			}
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public isyancigorevmenum(id) {
	new ndmenu[128];
	formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yIsyanci Gorev Sistemi",SERVERISMI);
	new Menu = menu_create(ndmenu,"isyancigorevmenum2");

	if(gorev1[id]) formatex(ndmenu,charsmax(ndmenu),"\dGorevi Tamamladin.");
	else if(g_seviye[id][g_exp]<isl_rank[1][RankXp]) formatex(ndmenu,charsmax(ndmenu),"\wGelisen Isyanci Ol. \d[\r%d/%d\d] [\y25.00 TL\d]",g_seviye[id][g_exp],isl_rank[1][RankXp]);
	else if(g_seviye[id][g_exp]>=isl_rank[1][RankXp]) formatex(ndmenu,charsmax(ndmenu),"\wGorevi Tamamladin. Odulunu almak icin \d[\r1'e\d] \wbas.");
	menu_additem(Menu,ndmenu,"1");

	if(gorev2[id]) formatex(ndmenu,charsmax(ndmenu),"\dGorevi Tamamladin.");
	else if(g_seviye[id][g_exp]<isl_rank[2][RankXp]) formatex(ndmenu,charsmax(ndmenu),"\wKidemli Isyanci Ol. \d[\r%d/%d\d] [\y30.00 TL\d]",g_seviye[id][g_exp],isl_rank[2][RankXp]);
	else if(g_seviye[id][g_exp]>=isl_rank[2][RankXp]) formatex(ndmenu,charsmax(ndmenu),"\wGorevi Tamamladin. Odulunu almak icin \d[\r2'ye\d] \wbas.");
	menu_additem(Menu,ndmenu,"2");

	if(gorev3[id]) formatex(ndmenu,charsmax(ndmenu),"\dGorevi Tamamladin.");
	else if(g_seviye[id][g_exp]<isl_rank[3][RankXp]) formatex(ndmenu,charsmax(ndmenu),"\wGorevli Isyanci Ol. \d[\r%d/%d\d] [\y35.00 TL\d]",g_seviye[id][g_exp],isl_rank[3][RankXp]);
	else if(g_seviye[id][g_exp]>=isl_rank[3][RankXp]) formatex(ndmenu,charsmax(ndmenu),"\wGorevi Tamamladin. Odulunu almak icin \d[\r3'e\d] \wbas.");
	menu_additem(Menu,ndmenu,"3");

	if(gorev4[id]) formatex(ndmenu,charsmax(ndmenu),"\dGorevi Tamamladin.");
	else if(g_seviye[id][g_exp]<isl_rank[4][RankXp]) formatex(ndmenu,charsmax(ndmenu),"\wIsyancilar Krali Ol. \d[\r%d/%d\d] [\y40.00 TL\d]",g_seviye[id][g_exp],isl_rank[4][RankXp]);
	else if(g_seviye[id][g_exp]>=isl_rank[4][RankXp]) formatex(ndmenu,charsmax(ndmenu),"\wGorevi Tamamladin. Odulunu almak icin \d[\r4'e\d] \wbas.");
	menu_additem(Menu,ndmenu,"4");

	if(gorev6[id]) formatex(ndmenu,charsmax(ndmenu),"\dGorevi Tamamladin.");
	else if(esya_say[id]<15) formatex(ndmenu,charsmax(ndmenu),"\wAlisveris Menusunden Esya Al. \d[\r%d/15\d] [\y15.00 TL\d]",esya_say[id]);
	else if(esya_say[id]>=15) formatex(ndmenu,charsmax(ndmenu),"\wGorevi Tamamladin. Odulunu almak icin \d[\r5'e\d] \wbas.");
	menu_additem(Menu,ndmenu,"6");

	new sure=get_user_time(id,1)/60;
	if(gorev7[id]) formatex(ndmenu,charsmax(ndmenu),"\dGorevi Tamamladin. \w[\rOnline Suren : %d\w]",sure);
	else if(sure<30) formatex(ndmenu,charsmax(ndmenu),"\w30 Dakika Isyana Katil. \d[\r%d/30\d] [\y20.00 TL\d]",sure);
	else if(sure>=30) formatex(ndmenu,charsmax(ndmenu),"\wGorevi Tamamladin. Odulunu almak icin \d[\r6'ye\d] \wbas.");
	menu_additem(Menu,ndmenu,"7");

	if(gorev5[id]) formatex(ndmenu,charsmax(ndmenu),"\dGorevi Tamamladin.");
	else if(gorev_hayat[id]<10) formatex(ndmenu,charsmax(ndmenu),"\wHayatta kal. \d[\r%d/10\d] [\y10.00 TL\d]",gorev_hayat[id]);
	else if(gorev_hayat[id]>=10) formatex(ndmenu,charsmax(ndmenu),"\wGorevi Tamamladin. Odulunu almak icin \d[\r7'ya\d] \wbas.");
	menu_additem(Menu,ndmenu,"5");

	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);

	return PLUGIN_HANDLED;
}
public isyancigorevmenum2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1 : {
			if(gorev1[id]) isyancigorevmenum(id);
			else if(g_seviye[id][g_exp]<isl_rank[1][RankXp]) client_print_color(id, id, "^1[^3%s^1] ^4Henuz gorevi tamamlayamadin. ^1[^3 %d/%d ^1]",SERVERISMI,g_seviye[id][g_exp],isl_rank[1][RankXp]),isyancigorevmenum(id);
			else if(g_seviye[id][g_exp]>=isl_rank[1][RankXp]) {
				TL[id]+=25.00,gorev1[id]=true,anamenu(id);
				client_print_color(id, id, "^1[^3%s^1] ^4Isyanci gorev sistemindeki^1 Gelisen Isyanci^4 gorevini tamamladin. ^1Odulun^3 25.00 TL.",SERVERISMI);
			}
		}
		case 2 : {
			if(gorev2[id]) isyancigorevmenum(id);
			else if(g_seviye[id][g_exp]<isl_rank[2][RankXp]) client_print_color(id, id, "^1[^3%s^1] ^4Henuz gorevi tamamlayamadin. ^1[^3 %d/%d ^1]",SERVERISMI,g_seviye[id][g_exp],isl_rank[2][RankXp]),isyancigorevmenum(id);
			else if(g_seviye[id][g_exp]>=isl_rank[2][RankXp]) {
				TL[id]+=30.00,gorev2[id]=true,anamenu(id);
				client_print_color(id, id, "^1[^3%s^1] ^4Isyanci gorev sistemindeki^1 Kidemli Isyanci^4 gorevini tamamladin. ^1Odulun^3 30.00 TL.",SERVERISMI);
			}
		}
		case 3 : {
			if(gorev3[id]) isyancigorevmenum(id);
			else if(g_seviye[id][g_exp]<isl_rank[3][RankXp]) client_print_color(id, id, "^1[^3%s^1] ^4Henuz gorevi tamamlayamadin. ^1[^3 %d/%d ^1]",SERVERISMI,g_seviye[id][g_exp],isl_rank[3][RankXp]),isyancigorevmenum(id);
			else if(g_seviye[id][g_exp]>=isl_rank[3][RankXp]) {
				TL[id]+=35.00,gorev3[id]=true,anamenu(id);
				client_print_color(id, id, "^1[^3%s^1] ^4Isyanci gorev sistemindeki^1 Gorevli Isyanci^4 gorevini tamamladin. ^1Odulun^3 35.00 TL.",SERVERISMI);
			}
		}
		case 4 : {
			if(gorev4[id]) isyancigorevmenum(id);
			else if(g_seviye[id][g_exp]<isl_rank[4][RankXp]) client_print_color(id, id, "^1[^3%s^1] ^4Henuz gorevi tamamlayamadin. ^1[^3 %d/%d ^1]",SERVERISMI,g_seviye[id][g_exp],isl_rank[4][RankXp]),isyancigorevmenum(id);
			else if(g_seviye[id][g_exp]>=isl_rank[4][RankXp]) {
				TL[id]+=40.00,gorev4[id]=true,anamenu(id);
				client_print_color(id, id, "^1[^3%s^1] ^4Isyanci gorev sistemindeki^1 Isyancilar Krali^4 gorevini tamamladin. ^1Odulun^3 40.00 TL.",SERVERISMI);
			}
		}
		case 5 : {
			if(gorev5[id]) isyancigorevmenum(id);
			else if(gorev_hayat[id]<10) client_print_color(id, id, "^1[^3%s^1] ^4Henuz gorevi tamamlayamadin. ^1[^3 %d/10 ^1]",SERVERISMI,gorev_hayat[id]),isyancigorevmenum(id);
			else if(gorev_hayat[id]>=10) {
				TL[id]+=10.00,gorev5[id]=true,anamenu(id);
				client_print_color(id, id, "^1[^3%s^1] ^4Isyanci gorev sistemindeki^1 Hayatta Kal^4 gorevini tamamladin. ^1Odulun^3 10.00 TL.",SERVERISMI);
			}
		}
		case 6 : {
			if(gorev6[id]) isyancigorevmenum(id);
			else if(esya_say[id]<15) client_print_color(id, id, "^1[^3%s^1] ^4Henuz gorevi tamamlayamadin. ^1[^3 %d/15 ^1]",SERVERISMI,esya_say[id]),isyancigorevmenum(id);
			else if(esya_say[id]>=15) {
				TL[id]+=15.00,gorev6[id]=true,anamenu(id);
				client_print_color(id, id, "^1[^3%s^1] ^4Isyanci gorev sistemindeki^1 Esya Al^4 gorevini tamamladin. ^1Odulun^3 15.00 TL.",SERVERISMI);
			}
		}
		case 7 : {
			new sure = get_user_time(id,1)/60;
			if(gorev7[id]) isyancigorevmenum(id);
			else if(sure<30) client_print_color(id, id, "^1[^3%s^1] ^4Henuz gorevi tamamlayamadin. ^1[^3 %d/30 ^1]",SERVERISMI,sure),isyancigorevmenum(id);
			else if(sure>=30) {
				TL[id]+=20.00,gorev7[id]=true,anamenu(id);
				client_print_color(id, id, "^1[^3%s^1] ^4Isyanci gorev sistemindeki^1 30 dakika isyana katil^4 gorevini tamamladin. ^1Odulun^3 20.00 TL.",SERVERISMI);
			} 
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public ayarmenum(id) {
	new ndmenu[64];
	formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yOyuncu Ayar Paneli",SERVERISMI);
	new Menu = menu_create(ndmenu,"ayarmenum2");

	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wHud Goster \d[\r%s\d]",KISATAG,hud_ayar[id] ? "KAPALI":"ACIK");
	menu_additem(Menu,ndmenu,"1");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wMenulerde TL Goster \d[\r%s\d]",KISATAG,menu_tl[id] ? "KAPALI":"ACIK");
	menu_additem(Menu,ndmenu,"2");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wOyuncu Model Kaldir \d[\r%s\d]",KISATAG,model_gizle[id] ? "ACIK":"KAPALI");
	menu_additem(Menu,ndmenu,"3");
	/*formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wAna Menudeki Reklami Kaldir \d[\r%s\d]",KISATAG,anareklam[id] ? "ACIK":"KAPALI");
	menu_additem(Menu,ndmenu,"7");*/
	/*formatex(ndmenu,charsmax(ndmenu),"\yTakimdakileri Gorunmez Yap \w- \d[\r%s\d]",gorunmezlik[id] ? "ACIK":"KAPALI");
	menu_additem(Menu,ndmenu,"4");*/
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wSay Yazilarini Kapat \d[\r%s\d]",KISATAG,say_ayar[id] ? "ACIK":"KAPALI");
	menu_additem(Menu,ndmenu,"5");
	formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wSay Konusmalarini Temizle",KISATAG);

	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);

	return PLUGIN_HANDLED;
}

public ayarmenum2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1: {
			if(hud_ayar[id]) hud_ayar[id]=false,set_task(0.2,"devam",id+100);
			else hud_ayar[id]=true;
			ayarmenum(id);
		}
		case 2: {
			if(menu_tl[id]) menu_tl[id]=false;
			else menu_tl[id]=true;
			ayarmenum(id);
		}
		case 3: {
			if(model_gizle[id]) model_gizle[id]=false,client_cmd(id,"cl_minmodels 1");
			else model_gizle[id]=true,client_cmd(id,"cl_minmodels 0");
			ayarmenum(id);
		}
		/*case 4: {
			if(gorunmezlik[id]) gorunmezlik[id]=false;
			else gorunmezlik[id]=true;
			ayarmenum(id);
		}*/
		case 5: {
			if(say_ayar[id]) say_ayar[id]=false;
			else say_ayar[id]=true;
			client_cmd(id,"hud_saytext"),ayarmenum(id);
		}
		case 6: {
			for(new i=0; i<5; i++) client_print_color(id, id, " ");
			ayarmenum(id);
		}
		/*case 7: {
			if(anareklam[id]) anareklam[id]=false;
			else anareklam[id]=true;
			ayarmenum(id);
		}*/
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public meslekmenum(id) {
	new ndmenu[128],meslok[64];
	switch(meslegim[id]) {
		case 1: meslok = "^n\dSuanki Meslegin = \rSurvivor Hayim";
		case 2: meslok = "^n\dSuanki Meslegin = \rGardiyan Avcisi";
		case 3: meslok = "^n\dSuanki Meslegin = \rTL Canavari";
		case 4: meslok = "^n\dSuanki Meslegin = \rCan Hirsizi";
		case 5: meslok = "^n\dSuanki Meslegin = \rTerminator";
		case 6: meslok = "^n\dSuanki Meslegin = \rIsyan Uzmani";
	}
	formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yMeslek Menu%s",SERVERISMI,meslok);
	new Menu = menu_create(ndmenu,"meslekmenum2");

	menu_additem(Menu,"\wSurvivor Hayim \y` \d[\rDusus hasari yenilenir\d]","1");
	menu_additem(Menu,"\wTL Canavari \y` \d[\rHer 10dk'da +5.00 TL\d]","3");
	if(get_user_flags(id) & SlotMenu_Yetki) menu_additem(Menu,"\wGardiyan Avcisi \y` \d[\rGardiyan oldur +5.00 TL ve +25 HP\d]","2");
	else menu_additem(Menu,"\wGardiyan Avcisi \y` \d[\rSadece Slotlara Ozel\d]","2");

	formatex(ndmenu,charsmax(ndmenu),"%s",gorev2[id] ? "\wCan Hirsizi \y` \d[\rHer 1 dakikada +10 HP\d]":"\wCan Hirsizi \y` \d[\rKidemli isyanci gorevini tamamla\d]");
	menu_additem(Menu,ndmenu,"4");
	formatex(ndmenu,charsmax(ndmenu),"%s",gorev3[id] ? "\wTerminator \y` \d[\rHer el 150 HP ve ARMOR\d]":"\wTerminator \y` \d[\rGorevli isyanci gorevini tamamla\d]");
	menu_additem(Menu,ndmenu,"5");
	formatex(ndmenu,charsmax(ndmenu),"%s",gorev4[id] ? "\wIsyan Uzmani \y` \d[\r3 sn. HIZ+GUC+GODMODE (say /uzman)\d]":"\wIsyan Uzmani \y` \d[\rIsyancilar krali gorevini tamamla\d]");
	menu_additem(Menu,ndmenu,"6");

	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);

	return PLUGIN_HANDLED;
}

public meslekmenum2(id, menu, item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) {
		case 1: {
			if(meslegim[id]==1) client_print_color(id, id, "^1[^3%s^1] ^4Meslegin Zaten : ^1[^3Survivor Hayim^1]",SERVERISMI),meslekmenum(id);
			else {
				meslegim[id]=1; //Hayim
				client_print_color(id, id, "^1[^3%s^1] ^4Yeni Meslegin : ^1[^3Survivor Hayim^1]",SERVERISMI),anamenu(id);
			}
		}
		case 2: {
			if(get_user_flags(id) & SlotMenu_Yetki) {
				if(meslegim[id]==2) client_print_color(id, id, "^1[^3%s^1] ^4Meslegin Zaten : ^1[^3Gardiyan Avcisi^1]",SERVERISMI),meslekmenum(id);
				else {
					meslegim[id]=2; //Avci
					client_print_color(id, id, "^1[^3%s^1] ^4Yeni Meslegin : ^1[^3Gardiyan Avcisi^1]",SERVERISMI),anamenu(id);
				}
			} else {
				client_print_color(id, id, "^1[^3%s^1] ^4Bu meslek slotlara ozeldir. Slotluk almak icin ^1[^3/ts3^1]",SERVERISMI);
				meslekmenum(id);
			}
		}
		case 3: {
			if(meslegim[id]==3) client_print_color(id, id, "^1[^3%s^1] ^4Meslegin Zaten : ^1[^3TL Canavari^1]",SERVERISMI),meslekmenum(id);
			else {
				meslegim[id]=3; //tlcanavar
				set_task(600.0,"tldevam",id);
				client_print_color(id, id, "^1[^3%s^1] ^4Yeni Meslegin : ^1[^3TL Canavari^1]",SERVERISMI),anamenu(id);
			}
		}
		case 4: {
			if(gorev2[id]) {
				if(meslegim[id]==4) client_print_color(id, id, "^1[^3%s^1] ^4Meslegin Zaten : ^1[^3Can Hirsizi^1]",SERVERISMI),meslekmenum(id);
				else {
					meslegim[id]=4; //canhirsiz
					set_task(60.0,"candevam",id);
					client_print_color(id, id, "^1[^3%s^1] ^4Yeni Meslegin : ^1[^3Can Hirsizi^1]",SERVERISMI),anamenu(id);
				}
			} else client_print_color(id, id, "^1[^3%s^1] ^4Oncelikle ^1Kidemli Isyanci^4 gorevini bitirmen gerekiyor.",SERVERISMI),meslekmenum(id);
		}
		case 5: {
			if(gorev3[id]) {
				if(meslegim[id]==5) client_print_color(id, id, "^1[^3%s^1] ^4Meslegin Zaten : ^1[^3Can Hirsizi^1]",SERVERISMI),meslekmenum(id);
				else {
					meslegim[id]=5; //terminator
					client_print_color(id, id, "^1[^3%s^1] ^4Yeni Meslegin : ^1[^3Terminator^1]",SERVERISMI),anamenu(id);
				}
			} else client_print_color(id, id, "^1[^3%s^1] ^4Oncelikle ^1Gorevli Isyanci^4 gorevini bitirmen gerekiyor.",SERVERISMI),meslekmenum(id);
		}
		case 6: {
			if(gorev4[id]) {
				if(meslegim[id]==6) client_print_color(id, id, "^1[^3%s^1] ^4Meslegin Zaten : ^1[^3Can Hirsizi^1]",SERVERISMI),meslekmenum(id);
				else {
					meslegim[id]=6; //uzman
					client_print_color(id, id, "^1[^3%s^1] ^4Yeni Meslegin : ^1[^3Isyan Uzmani^1]",SERVERISMI),anamenu(id);
				}
			} else client_print_color(id, id, "^1[^3%s^1] ^4Oncelikle ^1Isyancilar Krali^4 gorevini bitirmen gerekiyor.",SERVERISMI),meslekmenum(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public tldevam(id) if(meslegim[id]==3) TL[id]+=5,set_task(600.0,"tldevam",id);
public candevam(id) if(meslegim[id]==4) set_entvar(id, var_health, Float:get_entvar(id, var_health)+10.0),set_task(60.0,"candevam",id);
public uzman(id) {
	if(get_user_team(id)!=1 || !is_user_alive(id))  client_print_color(id, id, "^1[^3%s^1] ^4Bu komutu suan kullanamazsiniz.",SERVERISMI); 
	else if(!gorev4[id]) client_print_color(id, id, "^1[^3%s^1] ^4Oncelikle ^1Isyancilar Krali^4 gorevini bitirip ^3Isyan Uzmani ^4meslegini secmen gerekiyor.",SERVERISMI);
	else if(meslegim[id]!=6) client_print_color(id, id, "^1[^3%s^1] ^4Oncelikle ^1Isyan Uzmani^4 meslegini secmen gerekiyor.",SERVERISMI);
	else if(uzmanc[id]) client_print_color(id, id, "^1[^3%s^1] ^4Her rounnda bir kere kullanabilirsin.",SERVERISMI); 
	else {
		set_entvar(id, var_maxspeed, 500.0),hasarkatla[id]=true,set_entvar(id, var_takedamage, DAMAGE_NO);
		message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},id);
		write_short(~0); write_short(~0); write_short(1<<12);
		write_byte(255); write_byte(0); write_byte(0); write_byte(100);
		message_end();
		set_task(3.0,"uzmanbitir",id),uzmanc[id]=true;
	}
}
public uzmanbitir(id) {
	message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},id);	 
	write_short(1<<14); write_short(1<<9); write_short(1<<11);
	write_byte( 255 ); write_byte( 255 ); write_byte( 255); write_byte(255);
	message_end();	
	set_entvar(id, var_maxspeed, 250.0),hasarkatla[id]=false,set_entvar(id, var_takedamage, DAMAGE_AIM);
	client_print_color(id, id, "^1[^3%s^1] ^4Isyan Uzmanligin sona erdi. Tekrar kullanmak icin diger roundu bekleyin.",SERVERISMI);
}
/* MG TL */
public dvmgana(id) {
	new teams=get_user_team(id);
	switch(teams){
		case 1: anamenu(id);
		case 2: mgtlver(id);
	}
	return PLUGIN_HANDLED;
}
public mgtlver(id) {
	if(is_user_alive(id) && get_user_team(id)==2) {
		new ndmenu[64];
		formatex(ndmenu,charsmax(ndmenu),"\w%s Ailesi \d|| \yTL Ver-Al Menusu",SERVERISMI);
		new Menu = menu_create(ndmenu,"mgtlver2");

		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wTL Ver",KISATAG);
		menu_additem(Menu,ndmenu,"1");
		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wTL Al",KISATAG);
		menu_additem(Menu,ndmenu,"2");
		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wToplu TL Ver \d(Sadece Yasayanlar)",KISATAG);
		menu_additem(Menu,ndmenu,"3");
		formatex(ndmenu,charsmax(ndmenu),"\r%s \y` \wToplu TL Al \d(Sadece Yasayanlar)",KISATAG);
		menu_additem(Menu,ndmenu,"4");

		menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
		menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
		menu_display(id, Menu, 0);
	}
}
public mgtlver2(id,menu,item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[64];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) { 
		case 1: mgtl[id]=1,mg_oyuncu(id);
		case 2: mgtl[id]=2,mg_oyuncu(id);
		case 3: mgtl[id]=3,client_cmd(id, "messagemode TL_MIKTARI");
		case 4: mgtl[id]=4,client_cmd(id, "messagemode TL_MIKTARI");
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public mg_oyuncu(id) {
	new ndmenu[64],szName[32], szTempid[10], players[32], inum, ids;
	formatex(ndmenu, charsmax(ndmenu),"\w%s Ailesi \d|| \yOyuncu Sec.",SERVERISMI);
	new Menu = menu_create(ndmenu, "mg_oyuncu2");

	//get_players(players,inum,"acehi","TERRORIST"); //+c
	get_players_ex(players, inum, GetPlayers_ExcludeDead | GetPlayers_MatchTeam, "TERRORIST"); 
	for(new i=0; i<inum; i++) {
		ids=players[i];
		get_user_name(ids, szName, charsmax(szName));
		num_to_str(ids, szTempid, charsmax(szTempid));
		formatex(ndmenu, charsmax(ndmenu), "\w%s \y` \d[\r%0.2f TL\d] \d(Canli)",szName,TL[ids]);
		menu_additem(Menu, ndmenu, szTempid);
	}
	//get_players(players,inum,"bcehi","TERRORIST"); //+c
	get_players_ex(players, inum, GetPlayers_ExcludeAlive | GetPlayers_MatchTeam, "TERRORIST"); 
	for(new i=0; i<inum; i++) {
		ids=players[i];
		get_user_name(ids, szName, charsmax(szName));
		num_to_str(ids, szTempid, charsmax(szTempid));
		formatex(ndmenu, charsmax(ndmenu), "\w%s \y` \d[\r%0.2f TL\d] \d(Olu)",szName,TL[ids]);
		menu_additem(Menu, ndmenu, szTempid);
	}
	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(Menu, MPROP_EXITNAME, "\wCikis");
	menu_display(id, Menu, 0);
}
public mg_oyuncu2(id,menu,item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[64];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	g_mgisim[id]=str_to_num(data);
	client_cmd(id, "messagemode TL_MIKTARI");
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public TL_devam(id) {
	if(!is_user_alive(id) || get_user_team(id)!=2 || mgtl[id]==0) return PLUGIN_HANDLED;
	
	new say[300]; read_args(say, charsmax(say)); remove_quotes(say);
	new miktartl=str_to_num(say);
	if(!is_str_num(say) || equal(say, "") || miktartl<=0) { client_print_color(id,id,"^1[^3%s^1] ^4Gecersiz miktar.",SERVERISMI); mgtl[id]=0; return PLUGIN_HANDLED; }
	new isim[32],name[32],ids=g_mgisim[id]; get_user_name(id, isim, charsmax(isim)); get_user_name(ids, name, charsmax(name));
	if(mgtl[id]==1 && ids!=0) {
		if(miktartl > get_pcvar_float(cvars[35])) {
			client_cmd(id, "messagemode TL_MIKTARI");
			client_print_color(id, id, "^1[^3%s^1] ^4En fazla ^1[^3%0.2f^1]^4 TL verebilirsin.",SERVERISMI,get_pcvar_float(cvars[35]));
		} else {
			TL[ids]+=miktartl,mgtl[id]=0,g_mgisim[id]=0;
			client_print_color(0, 0, "^1[^3%s^1] ^4adli gardiyan ^1[^3%s^1]^4 adli mahkuma ^1%d.00 TL^4 yolladi.",isim,name,miktartl);
		}
	} else if(mgtl[id]==2 && ids!=0) {
		if(miktartl >= TL[ids]) {
			TL[ids]=0.00,mgtl[id]=0,g_mgisim[id]=0;
			client_print_color(0, 0, "^1[^3%s^1] ^4adli gardiyan ^1[^3%s^1]^4 adli mahkumun ^1tum parasini^4 aldi.",isim,name);
		} else {
			TL[ids]-=miktartl,mgtl[id]=0,g_mgisim[id]=0;
			client_print_color(0, 0, "^1[^3%s^1] ^4adli gardiyan ^1[^3%s^1]^4 adli mahkumdan ^1%d.00 TL^4 aldi.",isim,name,miktartl);
		}
	} else if(mgtl[id]==3) {
		if(miktartl > get_pcvar_float(cvars[35])) {
			client_cmd(id, "messagemode TL_MIKTARI");
			client_print_color(id, id, "^1[^3%s^1] ^4En fazla ^1[^3%0.2f^1]^4 TL verebilirsin.",SERVERISMI,get_pcvar_float(cvars[35]));
		} else {
			mgtl[id]=0,g_mgisim[id]=0;
			new players[32],inum,uid; //get_players(players,inum,"acehi","TERRORIST"); //+c
			get_players_ex(players, inum, GetPlayers_ExcludeDead | GetPlayers_MatchTeam, "TERRORIST"); 

			for(new i=0; i<inum; i++) uid=players[i],TL[uid]+=miktartl;
			client_print_color(0, 0, "^1[^3%s^1] ^4adli gardiyan tum mahkumlara ^1%d.00 TL^4 yolladi.",isim,miktartl);
		}
	} else if(mgtl[id]==4) {
		new players[32],inum,uid; //get_players(players,inum,"acehi","TERRORIST"); //+c
		get_players_ex(players, inum, GetPlayers_ExcludeDead | GetPlayers_MatchTeam, "TERRORIST"); 

		for(new i=0; i<inum; i++) {
			uid=players[i];
			if(TL[uid]-miktartl <= 0) TL[uid]=0.00;
			else TL[uid]-=miktartl;
		}
		mgtl[id]=0,g_mgisim[id]=0;
		client_print_color(0, 0, "^1[^3%s^1] ^4adli gardiyan tum mahkumlardan ^1%d.00 TL^4 aldi.",isim,miktartl);
	}
	return PLUGIN_HANDLED;
}
//Cuzdan Kodu

public kuponMenu(id) {
    new menuz;
    static amenu[256];
    formatex(amenu, charsmax(amenu), "\w%s Ailesi \d|| \yCuzdan Kodu^n\rOlusturacaginiz anahtara para yatirin.^nAyni map icinde bu anahtarla parayi tekrar alabilirsiniz.", SERVERISMI);
    menuz = menu_create(amenu, "kupon_handler");

    formatex(amenu, charsmax(amenu), "\wCuzdan Kodu Olustur - Para Yatir", KISATAG);
    menu_additem(menuz, amenu, "1");
    formatex(amenu, charsmax(amenu), "\wOtomatik Cuzdan Kodu Olustur - Para Yatir", KISATAG);
    menu_additem(menuz, amenu, "3");
    formatex(amenu, charsmax(amenu), "\wCuzdan Kodundan Para Cek^n", KISATAG);
    menu_additem(menuz, amenu, "5");
    formatex(amenu, charsmax(amenu), "\wCuzdan Kodu Olusturma Talimatlari", KISATAG);
    menu_additem(menuz, amenu, "2");
    formatex(amenu, charsmax(amenu), "\wOtomatik Cuzdan Kodu Olusturma Talimatlari", KISATAG);
    menu_additem(menuz, amenu, "4");
    formatex(amenu, charsmax(amenu), "\wPara Cekme Talimati \d(Basip Chat'e Bakiniz)", KISATAG);
    menu_additem(menuz, amenu, "6");
    if(!menu_tl[id]) formatex(amenu,charsmax(amenu),"\yCebinizdeki TL \d- \r[ %0.2f ]",TL[id]),menu_addtext(menuz, amenu);

    menu_setprop(menuz, MPROP_NUMBER_COLOR, "\d");
    menu_setprop(menuz, MPROP_EXITNAME, "\wCikis");
    menu_display(id, menuz, 0);

    return PLUGIN_CONTINUE;
}

public kupon_handler(id, menu, item) {
    if (item == MENU_EXIT) {
        menu_destroy(menu);
        return PLUGIN_HANDLED;
    }
    new access, callback, data[6], iname[64];
    menu_item_getinfo(menu, item, access, data, 5, iname, 63, callback);

    switch (str_to_num(data)) {
        case 1:
            client_cmd(id, "messagemode KEY_MIKTAR_GIR");
        case 2:
            {
                client_print_color(id, id, "^1[^3%s^1] ^4Ozel Cuzdan Kodu Olustur ^1secenegine basip <^3cuzdan_kodu^1> <^3para_miktari^1> ^4seklinde yaziniz.", KISATAG);
                client_print_color(id, id, "^1[^3%s^1]^4 Ornek : ^1deneme1 50 ^4 - deneme1 koduna 50 TL yatirilir.", KISATAG);
                kuponMenu(id)
            }
        case 3:
            client_cmd(id, "messagemode PARA_GIR");
        case 4:
            {
                client_print_color(id, id, "^1[^3%s^1] ^4Otomatik Cuzdan Kodu Olustur ^1secenegine basip <^3para_miktari^1>^4 seklinde yaziniz.", KISATAG);
                client_print_color(id, id, "^1[^3%s^1] ^4Ornek :^1 50^1 - otomatik olusturulan koda^1 50 TL^4 yatirilir.", KISATAG);
                kuponMenu(id)
            }
        case 5:
            client_cmd(id, "messagemode KEY_GIR_CEK");
        case 6:
            {
                client_print_color(id, id, "^1[^3%s^1] ^4Para Cek ^1secenegine basip <^3cuzdan_kodu^1>^4 seklinde yaziniz.", KISATAG);
                client_print_color(id, id, "^1[^3%s^1]^4 Ornek : ^1yansit^4 - yansit cuzdan kodundaki ^1para miktari^4 hesabiniza yatirilir.", KISATAG);
                kuponMenu(id)
            }
    }
    menu_destroy(menu);
    return PLUGIN_HANDLED;
}
public otoParaYatir(id) {
    new Args[128];
    read_args(Args, charsmax(Args));
    remove_quotes(Args);

    new mg = str_to_num(Args);

    if (mg < 1 || TL[id] < float(mg))
        client_print_color(id, id, "^1[^3%s^1] Maalesef ^4yeterli miktarda bakiyeniz yok^1 veya ^4gecerli bir sayi girmediniz^1.", KISATAG),kuponMenu(id);
    else paraYatir(id, randomKeyGenerator(id), mg),anamenu(id);

}
public ozelParaYatir(id) {
    new Args[128];
    read_args(Args, charsmax(Args));
    remove_quotes(Args);

    new key[100], sMiktar[28];
    strtok(Args, key, charsmax(key), sMiktar, charsmax(sMiktar));
    new mg = str_to_num(sMiktar);

    if (mg < 1 || TL[id] < float(mg))
        client_print_color(id, id, "^1[^3%s^1] Maalesef ^4yeterli miktarda bakiyeniz yok^1 veya ^4gecerli bir sayi girmediniz^1.", KISATAG),kuponMenu(id);
    else if (checkKey(id, key) == -1) {
        client_print_color(id, id, "^1[^3%s^1] ^4Bu Cuzdan Kodunu ^3kullanamazsiniz^1. Lutfen farkli bir kod deneyin.", KISATAG);
        client_cmd(id, "messagemode KEY_GIR");
    } else paraYatir(id, key, mg),anamenu(id);

}

public paraYatir(id, key[], mg) {
    new Kupon[eKupon];
    copy(Kupon[sifre], charsmax(Kupon), key);
    Kupon[miktar] = mg;
    ArrayPushArray(kuponlar, Kupon);
    TL[id] -= float(Kupon[miktar]);
    client_print_color(id, id, "^1[^3%s^1] ^1Lutfen Cuzdan kodunuzu ^4kimseyle paylasmayin ^1ve ^4kaybetmeyin!", KISATAG);
    client_print_color(id, id, "^1[^3%s^1] ^1Oyundan ^4Cikip Girseniz ^1bile ^3cuzdan kodu gecerli olacaktir^1.", KISATAG);
    client_print_color(id, id, "^1[^3%s^1] ^1Cuzdan Kodunuz : '^3%s^1' || Yatirilan Para Miktari : ^4%d^1 ", KISATAG, Kupon[sifre], Kupon[miktar]);
    console_print(id, "[%s] Cuzdan Kodunuz : %s || Yatirilan Para Miktari : %d TL", KISATAG, Kupon[sifre], Kupon[miktar]);
    anamenu(id);
}

public paraCek(id) {
    new key[128];
    read_args(key, charsmax(key));
    remove_quotes(key);
    new money = getMoneyfromKey(id, key);
    if (money == -1) {
        client_print_color(id, id, "^1[^3%s^1] ^1Maalesef bu anahtara ^4yuklu bakiye bulunmamaktadir^1.", KISATAG),kuponMenu(id);
    } else {
    	TL[id] += float(money);
        client_print_color(id, id, "^1[^3%s^1] ^1Cuzdan kodundan hesabiniza ^4%d TL^1 aktarildi.", KISATAG, money),anamenu(id);
    }
}

public checkKey(id, key[]) { // C?zdan kodunun benzersizli?ini kontrol eder
    new Kupon[eKupon];
    for (new i = 0; i < ArraySize(kuponlar); i++) {
        ArrayGetArray(kuponlar, i, Kupon);
        if (equal(Kupon[sifre], key)) {
            return -1;
        }
    }
    return 1;
}

public getMoneyfromKey(id, key[]) { // C?zdan kodundaki paray? d?nd?r?r (para yoksa -1 d?ner)
    new Kupon[eKupon];
    for (new i = 0; i < ArraySize(kuponlar); i++) {
        ArrayGetArray(kuponlar, i, Kupon);
        if (equal(Kupon[sifre], key)) {
            ArrayDeleteItem(kuponlar, i);
            return Kupon[miktar];
        }
    }
    return -1;
}

public randomKeyGenerator(id) { // Rastgele anahtar olu?turur
    new key[5];
    for (new i = 0; i < 4; i++) {
        key[i] = chars[random_num(0, charsmax(chars))];
    }
    if (checkKey(id, key) == -1) randomKeyGenerator(id);
    return key;
}
public getAllValues(id) {
	if(get_user_flags(id) & ADMIN_RCON) { 
	    new Kupon[eKupon];
	    console_print(id, "========== Tum Cuzdan Kodlar? || Degerleri ========");
	    for (new i = 0; i < ArraySize(kuponlar); i++) {
	        ArrayGetArray(kuponlar, i, Kupon);
	        console_print(id, "Cuzdan Kodu : '%s' || Para Miktari : '%d TL'", Kupon[sifre], Kupon[miktar]);
	    }
	    console_print(id, "===================================================");
    }
}
// Celik Kasa
public box(id)
{
	if(get_pcvar_num((engel)) && g_engel[id])
	{
		client_print_color(id,id,"^1[^3%s^1] Bu menuye Oyuna girdikten^4 60 Saniye ^3sonra ^1giriS yapabilirsiniz.", KISATAG);
		return PLUGIN_HANDLED
	}
	if(!kilitli)
	{
		client_print_color(id,id,"^1[^3%s^1] ^4Celik Kasa^1 hen?z oluSturulmadi. ^1Bir sonraki roundu bekleyin.", KISATAG);
		return PLUGIN_HANDLED
	}
	new menuz;
	static amenu[512];
	formatex(amenu,charsmax(amenu),"\w%s Ailesi \d|| \yCelik Kasa^n\dKasadaki Para: \r%d TL^n\dSifre Denemeleri \y[Herkes & Siz]: \r{%d}\y & \r{%d}",SERVERISMI,para,h_deneme,g_deneme[id]);
	menuz = menu_create(amenu,"box_handler");
	
	formatex(amenu,charsmax(amenu),"\r%s \y` \wSifre Dene \d[\r%d TL\d]",KISATAG,get_pcvar_num(ucret));
	menu_additem(menuz,amenu,"1");
	formatex(amenu,charsmax(amenu),"\r%s \y` \wSifre Bilgi", KISATAG);
	menu_additem(menuz,amenu,"2");

	if(para >= 50)
	{
		formatex(amenu,charsmax(amenu),"\r%s \y` \wSifre Ipucu \d(Son Basamak) [\r%d TL\d]",KISATAG,para/2+20);
		menu_additem(menuz,amenu,"3")
	}
	else
	{
		formatex(amenu,charsmax(amenu),"\r%s \y` \wSifre Ipucu \d(Son Basamak)",KISATAG);
		menu_additem(menuz,amenu,"4")
	}
	menu_setprop(menuz, MPROP_NUMBER_COLOR, "\d");
	menu_setprop(menuz, MPROP_EXITNAME, "\wCikis");
	menu_display(id,menuz,0);
	
	return PLUGIN_CONTINUE;
	
}
public box_handler(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new access,callback,data[6],iname[64];
	menu_item_getinfo(menu,item,access,data,5,iname,63,callback);
	
	switch(str_to_num(data))
	{
		case 1:
		{
			if(TL[id] >= get_pcvar_float(ucret))
			{
				TL[id] -= get_pcvar_float(ucret);
				para += get_pcvar_num(ucret);
				client_cmd(id,"messagemode PW_GIR");
			}
			else 
			{
				client_print_color(id,id,"^1[^3%s^1] Malesef yeterli paraniz yok.",KISATAG,get_pcvar_num(kasa_hane));
			}
		}
		case 2:
		{
			client_print_color(id,id,"^1[^3%s^1] Sifre, ^4%d ^1haneli bir dogal sayidan oluSmaktadir.",KISATAG,get_pcvar_num(kasa_hane));
			box(id);
		}
		case 3:
		{
			new kalan = kasa_sifre % 10;
			if(ipucu[id])
			{
				client_print_color(id,id,"^1[^3%s^1] ^4Celik Kasa^1'nin Sifresinin son basamagi: [^4 %d ^1].",KISATAG,kalan);
				client_print_color(id,id,"^1[^3%s^1] ^4Celik Kasa^1'nin Sifresinin son basamagi: [^4 %d ^1].",KISATAG,kalan);
			}
			else
			{
				if(TL[id] >= 50.0)
				{
					TL[id] -= float(para/2+20);
					ipucu[id] = true;
					client_print_color(id,id,"^1[^3%s^1] ^4Celik Kasa^1'nin Sifresinin son basamagi: [ ^4%d ^1].",KISATAG,kalan);
					client_print_color(id,id,"^1[^3%s^1] ^4Celik Kasa^1'nin Sifresinin son basamagi: [ ^4%d ^1].",KISATAG,kalan);
				}
				else 
				{
					client_print_color(id,id,"^1[^3%s^1] ^4Malesef ^1yeterli paraniz yok.",KISATAG);
				}
			}
			box(id);
		}
		case 4:
		{
			client_print_color(id,id,"^1[^3%s^1] ^4Ipucucunu, kasada en az^3 50 TL^1 biriktikten sonra kullanabilirsiniz.",KISATAG);
			box(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public checkBoxPw(id)
{
	new number[128];
	read_args(number, charsmax(number));
	remove_quotes(number);
	if(str_to_num(number) == kasa_sifre)
	{
		//dogru
		get_user_name(id,g_name,charsmax(g_name));
		
		kilitli = false;
		TL[id] += float(para);
		client_print_color(id,id,"^1[^3%s^1] ^4Tebrikler! ^1Sifreyi dogru bularak kasadaki [ ^3%d^1 ] ^3TL^1'nin sahibi oldunuz.",KISATAG,para);
		client_print_color(0,0,"^1[^3%s^1] ^4%s ^1Adli Oyuncu ^4%d^1. denemenin sonunda kasanin Sifresini Cozerek ^4%d^1 TL'nin sahibi oldu. Sifre : %d",KISATAG,g_name,g_deneme[id],para,str_to_num(number));
		new players[32],inum;
		//get_players(players,inum);
		get_players_ex(players, inum); 
		for(new i;i<inum;i++)
		{
			g_deneme[players[i]] = 0;
			ipucu[players[i]] = false;
		}
		h_deneme = 0;
	}
	else 
	{
		//yanliS
		h_deneme++;
		g_deneme[id]++;
		client_print_color(id,id,"^1[^3%s^1] Maalesef ^4Sifre Yanlis^1",KISATAG);
		box(id);
	}
	return PLUGIN_CONTINUE;
}
public Amad()
{
	if(kilitli)
	{
		remove_task(175),set_task(120.0, "Amad",755);
		client_print_color(0,0,"^1[^3%s^1] ^4Celik Kasa^1'nin Sifresini hen?z Cozen yok. Kasada biriken para [^3 %d TL ^1]",KISATAG,para);
		client_print_color(0,0,"^1[^3%s^1] ^3UNUTMA! ^1Sifreyi Cozen kasadaki tum parayi alir. [^4/kasa ^1& ^4/box^1] ",KISATAG);
	} else remove_task(175);
}
public aktifet(id)
{
	g_engel[id] = 0;
	client_print_color(id,id,"^1[^3%s^1]^4 60 saniyelik ^4Celik Kasa ^1koruma suresi doldu.",SERVERISMI);
	if(kilitli)
	{
		client_print_color(id,id,"^1[^3%s^1] ^4Celik Kasa^1'nin Sifresini hen?z Cozen yok. ^3%d TL ^1karSiliginda Sansini deneyebilirsin. [^4/box^1]",KISATAG,get_pcvar_num(ucret));
		client_print_color(id,id,"^1[^3%s^1] ^4UNUTMA! ^1Sifreyi Cozen kasadaki t?tum parayi alir. Su anki para : ^4%d TL",KISATAG,para);
	}
}
public create()
{
	switch(get_pcvar_num(kasa_hane))
	{
		case 2: 
		{
			kasa_sifre = random_num(10, 99);
			client_print_color(0,0,"^1[^3%s^1] Yeni bir celik kasa olusturuldu. Sifreyi Cozen kasadaki tum parayi alir. ^3Sifre ^1: [^4##^1]",KISATAG);
		}
		case 3: 
		{
			kasa_sifre = random_num(100,999);
			client_print_color(0,0,"^1[^3%s^1] Yeni bir Celik kasa oluSturuldu. Sifreyi Cozen kasadaki tum parayi alir. ^3Sifre ^1: [^4###^1]",KISATAG);
		}
		case 4: 
		{
			kasa_sifre = random_num(1000,9999);
			client_print_color(0,0,"^1[^3%s^1] Yeni bir Celik kasa oluSturuldu. Sifreyi Cozen kasadaki tum parayi alir. ^3Sifre ^1: [^4####^1]",KISATAG);
		}
	}
	remove_task(175)//,set_task(120.0, "Amad",755);
	h_deneme = 0;
	kilitli = true;
	para = get_pcvar_num(kasa_baslangic);
}
/*???????????????????????????????????????????????????????????????????????????????????????????????????????????????*/
/**?????????????????????????????????????????????? DIGER PUBLICLER ??????????????????????????????????????????????**/
/*???????????????????????????????????????????????????????????????????????????????????????????????????????????????*/


public devam(id) {
	id=id-100;
	new Players[32], tnum; get_players(Players, tnum, "aceh", "TERRORIST");
	if(!hud_ayar[id] && is_user_alive(id) && get_user_team(id)==1) { 
		remove_task(id+100),set_task(1.0,"devam",id+100);
		set_hudmessage(124, 252, 0, 5.0, 0.68, 0, 1.0, 1.0);
		if(g_seviye[id][g_level] < 4) {
			show_hudmessage(id, "Cebinizdeki TL : [ %0.2f ] |^n Godmode : [ %s ] |^nRutben : [ %s ] |^nIsyan EXP : [ %d/%d ] |^nYasayan Mahkum : [ %d ] |"
			,TL[id],godmode_sorgu() ? "ACIK":"KAPALI",isl_rank[g_seviye[id][g_level]][RankName],g_seviye[id][g_exp],
			isl_rank[g_seviye[id][g_level]+1][RankXp],tnum);
		} else if(g_seviye[id][g_level] == 4) {
			show_hudmessage(id, "Cebinizdeki TL : [ %0.2f ] |^nGodmode : [ %s ] |^nRutben : [ %s ] |^nIsyan EXP : [ %d ] |^nYasayan Mahkum : [ %d ] |"
			,TL[id],godmode_sorgu() ? "ACIK":"KAPALI",isl_rank[g_seviye[id][g_level]][RankName],g_seviye[id][g_exp],tnum);
		}
	}
}
public elsonu() {
	new players[32],inum; //get_players(players,inum,"acehi","TERRORIST");
	get_players_ex(players, inum, GetPlayers_ExcludeDead | GetPlayers_MatchTeam, "TERRORIST"); 

	for(new i=0;i<inum;i++) gorev_hayat[players[i]]++;
}
new sid[33];
public spec_target(id) {
	sid[id]=read_data(2);
	ClearSyncHud(id, hud);
	remove_task(id+100),set_task(0.1,"spdevam2",id+100);
}
public spdevam2(id) {
	id=id-100;
	if(!is_user_alive(id)) {
		new statu[32],isim[33],ids=sid[id],yetki=get_user_flags(ids); get_user_name(ids, isim, charsmax(isim));

		if(yetki & YoneticiMenu_Yetki) statu="Yonetici";
		else if(yetki & VIPELITMenu_Yetki) statu="ELIT & VIP Admin";
		else if(yetki & AdminMenu_Yetki) statu="Admin";
		else if(yetki & SlotMenu_Yetki) statu="Yetkili Slot";
		else statu="User";

		new teams=get_user_team(ids);
		switch(teams) {
			case 1: {
				set_hudmessage(150, 150, 150, -1.0, 0.75, 0, 0.0, 1.5);
				ShowSyncHudMsg(id, hud,"%s^nHP: %d | ARMOR: %d | %0.2f TL^nIsyan EXP: %d | Rutbesi: %s^n%s",isim,floatround(get_entvar(ids, var_health)),
				floatround(get_entvar(ids, var_armorvalue)),TL[ids],g_seviye[ids][g_exp],isl_rank[g_seviye[ids][g_level]][RankName],statu);
			}
			case 2: {
				set_hudmessage(0, 255, 255, -1.0, 0.75, 0, 0.0, 1.5);
				ShowSyncHudMsg(id, hud,"%s^nHP: %d | ARMOR: %d^n%s",isim,floatround(get_entvar(ids, var_health)),floatround(get_entvar(ids, var_armorvalue)),statu);
			}
		}
		//ShowSyncHudMsg(id, hud,"%s^nHP: %i | ARMOR: %i | %0.2f TL^nIsyan Puani: %i | Rutbesi: %s^n%s",isim,floatround(get_entvar(ids, var_health)),
		//floatround(get_entvar(ids, var_armorvalue)),TL[ids],g_seviye[ids][g_exp],isl_rank[g_seviye[ids][g_level]][RankName],statu);
		set_task(1.5,"spdevam2",id+100);
	}
}
public ayaklanmabaslat(id,level,cid) {
	if(!cmd_access(id,level,cid,2)) return PLUGIN_HANDLED;

	new arg1[32],namecik[32]; read_argv(1, arg1, charsmax(arg1)),get_user_name(id,namecik,charsmax(namecik));
	if(equali(arg1,"1")) {
		ayaklanma_kontrol=true,set_task(120.0,"ayaklanmareklam",1930,_,_,"b");
		client_print_color(id, id, "^1[^3%s^1] ^4Ayaklanma Baskanlarindan ^1%s^4 buyuk bir ayaklanma baslatti. ^3Ayaklanma Menusu Aktif !",SERVERISMI,namecik);
	} else ayaklanma_kontrol=false,remove_task(1930),client_print_color(id, id, "^1[^3%s^1] ^4Ayaklanma Baskanlarindan ^1%s^4 isyani durdurdu.",SERVERISMI,namecik);

	return PLUGIN_HANDLED;
}
public ayaklanmareklam() {
	client_print_color(0, 0, "^1[^3%s^1] ^4Ayaklanma baskanlari ve uyelerinin isyani halen devam ediyor. ^1Katilmak icin ^3/TS3",SERVERISMI);
}
/*public fwdAddToFullPack_Post( es_handle, e, ent, host, hostflags, player, pset ) {
	if(player && is_user_alive(host) && gorunmezlik[host] && host != ent && is_user_alive(ent) && get_user_team(host)==get_user_team(ent)){
		set_es( es_handle, ES_Origin, { 999999999.0, 999999999.0, 999999999.0 } );
	}
}*/
public Event_Change_Weapon(id) {
	new slh=read_data(2);
	if(slh==CSW_KNIFE) {
		new teams=get_user_team(id);
		switch(teams) {
			case 1: {
				if(TCuchillo[id] || Destapador[id]) {
					if(Destapador[id]) {
						set_entvar(id, var_viewmodel, VIEW_Palo);
					}
					else set_entvar(id, var_viewmodel, VIEW_MODELT);

					set_entvar(id, var_weaponmodel, PLAYER_MODELT);
				} else if(Motocierra[id]) set_entvar(id, var_viewmodel, VIEW_Moto),set_entvar(id, var_weaponmodel, PLAYER_Moto);
			}
			case 2: set_entvar(id, var_viewmodel, VIEW_MODELCT),set_entvar(id, var_weaponmodel, PLAYER_MODELCT);
		}
	}
	return PLUGIN_CONTINUE;
}
public elbasi() {
	elbasikontrol=true,set_task(1.0,"eskibas");
	if(kilitli)
	{
		client_print_color(0,0,"^1[^3%s^1] ^4Celik Kasa^1'nin Sifresini hen?z Cozen yok. ^3%d TL ^1karsiliginda sansini deneyebilirsin. [^4/box^1]",KISATAG,get_pcvar_num(ucret))
		client_print_color(0,0,"^1[^3%s^1] ^4UNUTMA! ^1Sifreyi cozen kasadaki tum parayi alir. Su anki para : ^4%d TL",KISATAG,para)
	}
	else set_task(3.0,"create")
}
public eskibas() elbasikontrol=false;
public oyuncuspawnoldu(id) {
	if(!is_user_connected(id) || !is_user_alive(id)) { return PLUGIN_CONTINUE; }
	if(elbasikontrol) {
		if(soygun[id]) soygun[id]--;
		reklamat[id]=false;
		uzmanc[id]=false;
		kanbagis[id]=false;
		ayaklanmareklami[id]=false;
		ayaklanmakontrol[id]=false;
		bonuskontrol[id]=false;
		if(jbonuskontrol[id]<0) jbonuskontrol[id]++;
		asalkontrol[id]=0;
		if(meslegim[id]==5) set_entvar(id, var_health, Float:150.0),set_entvar(id, var_armorvalue, Float:150.0);
	}
	//rg_set_user_footsteps(id, false);
	TCuchillo[id]=true;
	Destapador[id]=false;
	Motocierra[id]=false;
	marketkontrol[id]=false;
	//ciftziplama[id]=false;
	hasarazalt[id]=false;
	//unammo[id]=false;
	hasarkatla[id]=false;
	if(get_user_team(id)==1) {
		rg_remove_all_items(id), rg_give_item(id, "weapon_knife"), anamenu(id), devam(id+100);
	}

	return PLUGIN_CONTINUE;
}
public TakeDamage(victim, inflictor, attacker, Float:damage, damage_bits) {
	if(is_user_connected(attacker) && is_user_connected(victim) && victim != attacker) {
		if(hasarazalt[victim]) SetHookChainArg(4, ATYPE_FLOAT, damage*0.5);

		if(get_user_weapon(attacker) == CSW_KNIFE) {
			new teams=get_user_team(attacker);
			switch(teams) {
				case 1: {
					if(Destapador[attacker]) {
						if(get_member(victim, m_LastHitGroup) != HIT_HEAD) SetHookChainArg(4, ATYPE_FLOAT, get_pcvar_float(cvars[27]));
						else SetHookChainArg(4, ATYPE_FLOAT, get_pcvar_float(cvars[31]));
					} else if(TCuchillo[attacker]) {
						if(get_member(victim, m_LastHitGroup) != HIT_HEAD) SetHookChainArg(4, ATYPE_FLOAT, get_pcvar_float(cvars[25]));
						else SetHookChainArg(4, ATYPE_FLOAT, get_pcvar_float(cvars[29]));
					} else if(Motocierra[attacker]) SetHookChainArg(4, ATYPE_FLOAT, get_pcvar_float(cvars[28]));
				}
				case 2: {
					if(get_member(victim, m_LastHitGroup) != HIT_HEAD) SetHookChainArg(4, ATYPE_FLOAT, get_pcvar_float(cvars[26]));
					else SetHookChainArg(4, ATYPE_FLOAT, get_pcvar_float(cvars[30]));
				}
			}
		}
		if(hasarkatla[attacker]) SetHookChainArg(4, ATYPE_FLOAT, damage*2.0);
		if(get_user_team(attacker)==1 && get_user_team(victim)==2) {
			g_seviye[attacker][g_exp]+=floatround(damage, floatround_round);
			if(!task_exists(attacker+750) && g_seviye[attacker][g_level] < 4) set_task(5.0, "rankontrol",attacker+750);
		}
	}
}
public fwd_FM_ClientKill(id) if(get_user_team(id)==1) TL[id]+=get_pcvar_float(cvars[34]);
public CBasePlayer_Killed(olen, saldiran) {
	show_menu(olen,0,"");
	//if(get_user_team(saldiran)==1 && get_user_team(olen)==1) TL[saldiran]+=get_pcvar_float(cvars[34]);
	if(get_user_team(saldiran)==2 && get_user_team(olen)==1) {
		if(g_seviye[olen][g_exp]-get_pcvar_num(cvars[32])<0) g_seviye[olen][g_exp]=0;
		else g_seviye[olen][g_exp]-=get_pcvar_num(cvars[32]);

		if(g_seviye[olen][g_exp]<isl_rank[g_seviye[olen][g_level]][RankXp]) g_seviye[olen][g_level]--,set_task(1.0,"rutbedustu",olen);
	} else if(get_user_team(saldiran)==1 && get_user_team(olen)==2) {
		if(meslegim[saldiran]==2) set_entvar(saldiran, var_health, Float:get_entvar(saldiran, var_health)+25.0),TL[saldiran]+=5;
		g_seviye[saldiran][g_exp]+=get_pcvar_num(cvars[32]);
		if(!task_exists(saldiran+750) && g_seviye[saldiran][g_level] < 4) rankontrol(saldiran+750);
	}
	if(get_user_team(olen)==1) {
		new players[MAX_PLAYERS],num,ids; //get_players(players, num, "acehi", "TERRORIST");
		get_players_ex(players, num, GetPlayers_ExcludeDead | GetPlayers_MatchTeam, "TERRORIST"); 
		
		if(num==1) {
			for(new i=0; i<num; i++) {
				ids=players[i];
				//ciftziplama[ids]=false;
				hasarazalt[ids]=false;
				//unammo[ids]=false;
				hasarkatla[ids]=false;
			}
		}
	}
}
public rankontrol(id) {
	id=id-750;
	for(new i=4; i>g_seviye[id][g_level]; i--) {
		if(g_seviye[id][g_exp]>=isl_rank[i][RankXp]) {
			g_seviye[id][g_level]=i;
			rutbeartti(id);
			break;
		}
	}
	/*
	if(g_seviye[id][g_exp]>=isl_rank[g_seviye[id][g_level]+1][RankXp]) {
		g_seviye[id][g_level]++;
		rutbeartti(id);// set_task(1.0,"rutbeartti",id);
	}*/
}
public rutbedustu(id) {
	set_dhudmessage(200, 50, 50, -1.0, 0.3, 2, 0.5, 3.0, 0.01);
	show_hudmessage(id, "[ Rutbe Dustun. Yeni Rutben -%s- ]",isl_rank[g_seviye[id][g_level]][RankName]);
	emit_sound(id, CHAN_AUTO, isl_leveldown, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
}
public rutbeartti(id) {
	emit_sound(id, CHAN_AUTO, isl_levelup, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
	set_dhudmessage(0, 255, 0, -1.0, 0.3, 2, 0.5, 3.0, 0.01);
	if(g_seviye[id][g_level] < 4) {
		show_hudmessage(id, "[ Rutbe Atladin. Yeni Rutben -%s- ]",isl_rank[g_seviye[id][g_level]][RankName]);
	} else if(g_seviye[id][g_level] == 4) {
		new isl_name[MAX_NAME_LENGTH]; get_user_name(id, isl_name, charsmax(isl_name));
		show_hudmessage(0, "[ %s Adli Mahkum -Isyancilar Krali- Oldu! ]",isl_name);
	}
}
public Fwd_EmitSound(id, channel, const sample[], Float:volume, Float:attn, flags, pitch) {

	if( equal(sample, "common/wpn_denyselect.wav")) return FMRES_SUPERCEDE;

	if(!is_user_connected(id) || !equal(sample[8], "kni", 3)) return FMRES_IGNORED;
	new teams=get_user_team(id);
	switch(teams) {
		case 1: {
			if(Destapador[id] || TCuchillo[id]) {
				if(equal(sample[14], "sla", 3)) {
					engfunc(EngFunc_EmitSound, id, channel, t_slash1, volume, attn, flags, pitch);
					return FMRES_SUPERCEDE;
				} else if(equal(sample,"weapons/knife_deploy1.wav")) {
					engfunc(EngFunc_EmitSound, id, channel, t_deploy, volume, attn, flags, pitch);
					return FMRES_SUPERCEDE;
				} else if(equal(sample[14], "hit", 3)) {
					if(sample[17] == 'w') {
						if(Destapador[id]) engfunc(EngFunc_EmitSound, id, channel, t_hit1, volume, attn, flags, pitch);
						else engfunc(EngFunc_EmitSound, id, channel, t_wall, volume, attn, flags, pitch);
						return FMRES_SUPERCEDE;
					} else {
						if(Destapador[id]) {
							new mnum=random_num(1,2);
							switch(mnum) {
								case 1: engfunc(EngFunc_EmitSound, id, channel, t_hit3, volume, attn, flags, pitch);
								case 2: engfunc(EngFunc_EmitSound, id, channel, t_hit4, volume, attn, flags, pitch);
							}
						} else engfunc(EngFunc_EmitSound, id, channel, t_hit2, volume, attn, flags, pitch);
						return FMRES_SUPERCEDE;
					}
				} else if(equal(sample[14], "sta", 3)) {
					engfunc(EngFunc_EmitSound, id, channel, t_stab, volume, attn, flags, pitch);
					return FMRES_SUPERCEDE;
				}
			} else if(Motocierra[id]) {
				if(equal(sample[14], "sla", 3)) {
					engfunc(EngFunc_EmitSound, id, channel, motocierra_slash, volume, attn, flags, pitch);
					return FMRES_SUPERCEDE;
				} else if(equal(sample,"weapons/knife_deploy1.wav")) {
					engfunc(EngFunc_EmitSound, id, channel, motocierra_deploy, volume, attn, flags, pitch);
					return FMRES_SUPERCEDE;
				} else if(equal(sample[14], "hit", 3)) {
					if(sample[17] == 'w') {
						engfunc(EngFunc_EmitSound, id, channel, motocierra_wall, volume, attn, flags, pitch);
						return FMRES_SUPERCEDE;
					} else {
						new mnum=random_num(1,2);
						switch(mnum) {
							case 1: engfunc(EngFunc_EmitSound, id, channel, motocierra_hit1, volume, attn, flags, pitch);
							case 2: engfunc(EngFunc_EmitSound, id, channel, motocierra_hit2, volume, attn, flags, pitch);
						}
						return FMRES_SUPERCEDE;
					}
				} else if(equal(sample[14], "sta", 3)) {
					engfunc(EngFunc_EmitSound, id, channel, motocierra_stab, volume, attn, flags, pitch);
					return FMRES_SUPERCEDE;
				}
			}
		}
		case 2: {
			if(equal(sample[14], "sla", 3)) {
				engfunc(EngFunc_EmitSound, id, channel, ct_slash1, volume, attn, flags, pitch);
				return FMRES_SUPERCEDE;
			} else if(equal(sample,"weapons/knife_deploy1.wav")) {
				engfunc(EngFunc_EmitSound, id, channel, ct_deploy, volume, attn, flags, pitch);
				return FMRES_SUPERCEDE;
			} else if(equal(sample[14], "hit", 3)) {
				if(sample[17] == 'w') {
					engfunc(EngFunc_EmitSound, id, channel, ct_wall, volume, attn, flags, pitch);
					return FMRES_SUPERCEDE;
				} else {
					engfunc(EngFunc_EmitSound, id, channel, ct_hit1, volume, attn, flags, pitch);
					return FMRES_SUPERCEDE;
				}
			} else if(equal(sample[14], "sta", 3)) {
				engfunc(EngFunc_EmitSound, id, channel, ct_stab, volume, attn, flags, pitch);
				return FMRES_SUPERCEDE;
			}
		}
	}
	return FMRES_IGNORED;
}
public fallDamage(const id) if(meslegim[id]==1) set_member(id, m_idrowndmg, floatround(Float:GetHookChainReturn(ATYPE_FLOAT), floatround_floor)),set_member(id, m_idrownrestored, 0);
/*public Jump(id) {
	if(ciftziplama[id] && is_user_alive(id)) {
		static jumpnum[MAX_CLIENTS+1];
		if(~get_entvar(id,var_flags) & FL_ONGROUND && ~get_member(id,m_afButtonLast) & IN_JUMP && jumpnum[id]<1) {
			static Float:velocity[3]; get_entvar(id,var_velocity,velocity);
			velocity[2] = random_float(265.0,285.0); set_entvar(id,var_velocity,velocity);
			jumpnum[id]++;
		} else if(get_entvar(id,var_flags) & FL_ONGROUND) jumpnum[id]=0;
	}
}*/
public plugin_precache() {
	precache_sound(t_deploy),precache_sound(t_slash1),precache_sound(t_stab),precache_sound(t_wall);
	precache_sound(t_hit1),precache_sound(t_hit2),precache_sound(t_hit3),precache_sound(t_hit4);
	
	precache_sound(ct_deploy),precache_sound(ct_slash1),precache_sound(ct_stab),precache_sound(ct_wall);
	precache_sound(ct_hit1),precache_sound("weapons/flashbang-2.wav");

	precache_sound(motocierra_deploy),precache_sound(motocierra_slash),precache_sound(motocierra_stab);
	precache_sound(motocierra_wall),precache_sound(motocierra_hit1),precache_sound(motocierra_hit2);

	precache_sound(kutu_acilis),precache_sound(kutu_dolu),precache_sound(kutu_bos);
	precache_sound(isl_levelup),precache_sound(isl_leveldown);
	
	precache_model(VIEW_MODELT),precache_model(PLAYER_MODELT),precache_model(VIEW_MODELCT),precache_model(PLAYER_MODELCT);
	precache_model(VIEW_Palo),precache_model(VIEW_Moto),precache_model(PLAYER_Moto);
}

public plugin_natives() register_native("jb_get_user_packs","native_jb_get", 1),register_native("jb_set_user_packs","native_jb_set");
public native_jb_get(id) return float:TL[id];
public native_jb_set(id, Float:ammount) { new id = get_param(1),Float:ammount = get_param_f(2); TL[id]=ammount; return 1; }

bool:godmode_sorgu() {
	new players[MAX_PLAYERS], num; 
	get_players_ex(players, num, GetPlayers_ExcludeDead | GetPlayers_MatchTeam, "CT"); 

	for(new i=0; i<num; i++) {

		if(!get_entvar(players[i], var_takedamage)) {
			return true;
		}
	}
	return false;
}
public ac(id) {
	if(get_user_button(id) & IN_RELOAD && is_user_connected(id) && is_user_alive(id)) {
		new ids,body; get_user_aiming(id, ids, body, 41);
		if(is_user_alive(ids) && soygun[ids]>0  && ids && ids!=id) {
			client_print_color(id,id,"^1[^3%s^1] ^4Bu oyuncu ^1Anti Soygun^4 satin aldigi icin ^3soyamazsin. ^1%d gun sonra bitecek!",SERVERISMI,soygun[ids]);
			return PLUGIN_HANDLED;
		}
	}
	return PLUGIN_CONTINUE;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/
