#include <amxmodx>
#include <fakemeta>
#include <reapi>

native set_lights(const Lighting[]);
native jb_get_user_packs(id);
native jb_set_user_packs(id, Float:ammount);

/* ------------ Ayarlanacak Yer ------------ */


#define ServerTag "Web#Ailesi"
#define KisaTag "Wa"
#define tsip "Web#Ailesi"
#define serverip "CS00.CSDURAGI.COM"

#define slot_yetki ADMIN_RESERVATION
#define admin_yetki ADMIN_CVAR 
#define yonetici_yetki ADMIN_RCON 

#define sohbettemizleme ADMIN_RESERVATION // Sohbeti hangi yetkiye sahip olanlar temizlesin buradan ayarlayabilirsiniz.
#define reklamat ADMIN_KICK // Reklam atmayi hangi yetkiye sahip olacaginiz buradan ayarlayabilirsiniz.
#define hudreklams ADMIN_KICK // Hud Reklam atmayi hangi yetkiye sahip olacaginiz buradan ayarlayabilirsiniz.

new engel[33]

/* ------------- Modeller ve sesler ------------ */

new const reklamsatir1[] = { "Slotluk ve^3 +18 ^1Komutculuk ucretsizdir. ^3(^1/ts3 yazarak alabilirsiniz.^3)" };
new const reklamsatir2[] = { "CS Adresimiz:^3 Cs00.Csduragi.Com ^1 - TS3 Adresimiz:^3 Web#Ailesi" };
new const reklamsatir3[] = { "^3 +18 ^1Komutcu aranmaktadir. ^3(^1/ts3 yazarak alabilirsiniz.^3)" };
new const reklamsatir4[] = { "Admin fiyatlarinda ^3INDIRIM! ^3(^1/ts3 yazarak alabilirsiniz.^3)" };
new const reklamsatir5[] = { "Favorilerinize ekleyiniz:^3 213.238.173.00 ^1- ^3Cs00.Csduragi.Com" };

new const mesajatildi[] = { "mesajses.wav" };
new const sohbetsilindi[] = { "sohbetses.wav" };

new const VIEW_MODELT[] = { "models/jbmodeller/csd_thand.mdl" };         /* Yumruk Modeli */
new const PLAYER_MODELT[] = { "models/jbmodeller/csd_thand2.mdl" };     /* Dýs gorunus yumruk modeli */

new const VIEW_Palo[] =  { "models/jbmodeller/csd_bicak.mdl" };	        /* T Bicak modeli */ // Eðer býçak modelini beðenmediyseniniz baþka bir model secip ismini csd_bicak kaydetip panele öyle yükleyiniz.

new const VIEW_MODELCT[] = { "models/jbmodeller/csd_jop.mdl" }; 	        /* Ct jop */
new const PLAYER_MODELCT[] = { "models/jbmodeller/csd_jop2.mdl" };      /* Ct jop dýþ gorunuþu */

new const VIEW_Moto[] = { "models/[Shop]JailBreak/Moto/Moto.mdl" };     /* Testere */
new const PLAYER_Moto[] = { "models/[Shop]JailBreak/Moto/Moto2.mdl" };  /* Testere dýþ gorunuþu */

new const pandoracikti[] = { "misc/csd_pandoracikti.wav" };
new const pandorabos[] = { "misc/csd_pandorabos.wav" };
new const satinaldi[] = { "misc/csd_buy.wav" };

new const bictes_deploy[] = { "[Shop]JailBreak/Machete/MConvoca.wav" };
new const bictes_slash[] = { "[Shop]JailBreak/Machete/MSlash.wav" };
new const bictes_wall[] = { "[Shop]JailBreak/Machete/MHitWall.wav" };
new const bictes_hit1[] = { "[Shop]JailBreak/Machete/MHit1.wav" };
new const bictes_hit2[] = { "[Shop]JailBreak/Machete/MHit2.wav" };
new const bictes_stab[] = { "[Shop]JailBreak/Machete/MStab.wav" };
new const t_deploy[] = { "[Shop]JailBreak/T/TConvoca.wav" };
new const t_slash1[] = { "[Shop]JailBreak/T/Slash1.wav" };
new const t_wall[] = { "[Shop]JailBreak/T/THitWall.wav" };
new const t_hit1[] = { "[Shop]JailBreak/T/THit1.wav" };
new const t_hit2[] = { "[Shop]JailBreak/T/THit2.wav" };
new const t_hit3[] = { "[Shop]JailBreak/T/THit3.wav" };
new const t_hit4[] = { "[Shop]JailBreak/T/THit4.wav" };
new const t_stab[] = { "[Shop]JailBreak/T/TStab.wav" };
new const ct_deploy[] = { "[Shop]JailBreak/CT/CTConvoca.wav" };
new const ct_slash1[] = { "[Shop]JailBreak/CT/Slash1.wav" };
new const ct_wall[] = { "[Shop]JailBreak/CT/CTHitWall.wav" };
new const ct_hit1[] = { "[Shop]JailBreak/CT/CTHit1.wav" };
new const ct_hit2[] = { "[Shop]JailBreak/CT/CTHit2.wav" };
new const ct_hit3[] = { "[Shop]JailBreak/CT/CTHit3.wav" };
new const ct_hit4[] = { "[Shop]JailBreak/CT/CTHit4.wav" };
new const ct_stab[] = { "[Shop]JailBreak/CT/CTStab.wav" };

/* --------------------------------------------- */
static const g_maxclipammo[] = { 0,13,0,10,0,7,0,30,30,0,15,20,25,30,35,25,12,20,10,30,100,8,30,30,20,0,7,30,30,0,50 };

new Float: TL[MAX_CLIENTS+1],cvars[28],TCuchillo[MAX_CLIENTS+1],Destapador[MAX_CLIENTS+1],Motocierra[MAX_CLIENTS+1],
bicakkontrol[MAX_CLIENTS+1],reklamyap[MAX_CLIENTS+1],jbmg[MAX_CLIENTS+1],g_mgisim[MAX_CLIENTS+1],item_say[MAX_CLIENTS+1],
unammo[MAX_CLIENTS+1],yetkilikontrolet[MAX_CLIENTS+1],paratransfer[MAX_CLIENTS+1],userbonuskontrol[MAX_CLIENTS+1],player_origin[33][3]
/* --------------------------------------------- */
public plugin_init() {
	register_plugin("[ReAPI] Jailbreak Mahkum Menu", "v3.0", "BlueBell");
	
	register_clcmd("say /jbmenu", "jbmenu");
	register_clcmd("say_team /jbmenu", "jbmenu");
	register_clcmd("say /mg", "mgtlver");
	register_clcmd("say_team /mg", "mgtlver");
	register_clcmd("say /tl", "mgtlver");
	register_clcmd("say_team /tl", "mgtlver")
	register_concmd("plugintestjb","jbvertest")
	register_clcmd("say sa", "hosgeldin");
	register_clcmd("say s.a", "hosgeldin");
	register_clcmd("say selamun aleykum", "hosgeldin");
	register_clcmd("say_team sa", "hosgeldin");
	register_clcmd("say_team s.a", "hosgeldin");
	register_clcmd("say_team selamun aleykum", "hosgeldin");
	register_clcmd("say /isyanteam","isyanteammenu");
	register_clcmd("say /isyan","isyanteammenu");
	register_event("HLTV", "elbasi", "a", "1=0", "2=0");
	
	register_clcmd("TL_Miktari_giriniz", "tl_vermesi");
	
	register_clcmd("chooseteam","menugiriskontrol");
	register_clcmd("nightvision","menugiriskontrol");
	
	register_event("CurWeapon", "Event_Change_Weapon", "be", "1=1");
	register_forward(FM_EmitSound, "Fwd_EmitSound");
	register_forward(FM_ClientKill, "fwd_FM_ClientKill");
	
	RegisterHookChain(RG_CBasePlayer_Spawn, "userdogdu",1);
	RegisterHookChain(RG_CBasePlayer_Killed, "CBasePlayer_Killed", 1);
	RegisterHookChain(RG_CBasePlayer_TakeDamage, "TakeDamage",0);
	
	cvars[1] = register_cvar("baslangic_parasi", "5.00");	// Oyun basinda gelicek para
	cvars[2] = register_cvar("kill_parasi", "0.99");	         // Kill cekince gelen para
	
	cvars[3] = register_cvar("flipknife_para", "-0.63");	// Flip knife parasi
	cvars[4] = register_cvar("testere_para", "25.99");	// Testere parasi
	
	cvars[5] = register_cvar("mg_enfazlapara", "100.00");	// Gardiyan TL Menüsünde verilecek en yüksek miktar
	
	cvars[6] = register_cvar("market_hp_para", "10.00");	         // 100+ HP parasi
	cvars[7] = register_cvar("market_hp_para2", "20.00");	         // 200+ HP parasi
	cvars[8] = register_cvar("market_bomba_paket", "20.00");	         // Bomba paket parasi
	cvars[9] = register_cvar("market_bomba_hegrenade", "10.00");	// Bomba parasi patlayici
	cvars[10] = register_cvar("market_bomba_flashbang", "10.00");	// Bomba parasi flashbang
	cvars[11] = register_cvar("market_sinirsizmermi", "20.00");	// Sinirsiz mermi parasi
	
	cvars[12] = register_cvar("normal_pandora", "20.00");	// Klasik pandora kutu
	cvars[13] = register_cvar("silah_pandora", "30.00");	// Silah pandora kutu
	cvars[14] = register_cvar("gelismis_pandora", "35.00");	// Gelismis pandora kutu
	
	cvars[15] = register_cvar("yumruk_hasar", "15");	// Yumruk Hasar
	cvars[16] = register_cvar("yumrukhs_hasar", "25");	// Yumruk HS Hasar
	cvars[17] = register_cvar("bicakt_hasar", "25");	// TBicak hasar
	cvars[18] = register_cvar("bicaths_hasar", "30");	// TBicak HS Hasar
	cvars[19] = register_cvar("testere_hasar", "200");	// Testere hasar
	cvars[20] = register_cvar("jop_hasar", "50");	         // Ct Jop Hasar
	cvars[21] = register_cvar("jophs_hasar", "80");	// Ct Jop Hs Hasar
	
	cvars[22] = register_cvar("gelisms_bessngod", "30");	// 5 Sn godmode - Gelismis isyan esyalari
	cvars[23] = register_cvar("gelisms_onsnzipla", "25");	// 10 Sn yuksek zipla - Gelismis isyan esyalari
	cvars[24] = register_cvar("gelisms_gomuluysenkaldir", "25");	// Gomuluyken kaldirma - Gelismis isyan esyalari
	cvars[25] = register_cvar("gelisms_elektrikpara", "35");	// elektrik  - Gelismis isyan esyalari
	cvars[26] = register_cvar("gelisms_drugpara", "35");	// drug - Gelismis isyan esyalari
	cvars[27] = register_cvar("gelisms_besgom", "45");	// bes sn gom - Gelismis isyan esyalari
}
/* -----------------------Menuler & Publicler---------------------- */

public bicakmarket(id){
	if(bicakkontrol[id]){
		client_print_color(id, id, "^4[ ^3%s ^4] ^1Her roundda bir kere ^4bicak ^1satin alabilirsin.",ServerTag),jbmenu(id)
	}
	else{
		static blmenu[64]
		formatex(blmenu, charsmax(blmenu), "\r[ \w%s \r] \y~\r> \yBicak Marketi",ServerTag);
		new menu = menu_create(blmenu, "bicak_devam");	
		formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wFlip \rKnife \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[3]));
		menu_additem(menu, blmenu, "1");	
		formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wTestere\y+\rBomba \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[4]));
		menu_additem(menu, blmenu, "2");
		if(!reklamyap[id]) formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wReklam \rAt \d[\y +0.90 TL \d]",KisaTag);
		else formatex(blmenu, charsmax(blmenu), "\y[ \r%s \y] \d~\w> \dReklam At \yKullanildi",KisaTag);
		menu_additem(menu, blmenu, "3");
		
		menu_setprop(menu, MPROP_EXITNAME,"\dCikis",KisaTag);
		menu_display(id, menu, 0);
	}
}
public bicak_devam(id, menu, item){
	if(item == MENU_EXIT){
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new data[9],name[32],access,callback;
	menu_item_getinfo(menu,item,access,data,charsmax(data),name,charsmax(name),callback);
	new key=str_to_num(data);
	switch(key){
		case 1:{
			if(TL[id] >= get_pcvar_float(cvars[3])){
				TL[id]-=get_pcvar_float(cvars[3]);
				TCuchillo[id]=0,Destapador[id]=true,Motocierra[id]=false,bicakkontrol[id]=true;
				rg_remove_item(id, "weapon_knife"),rg_give_item(id, "weapon_knife");
				emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Basarili bir sekilde ^4Flip Knife ^1Satin alinmistir.",ServerTag),jbmenu(id);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4Flip Knife ^1almak icin yeterli TL'niz yok.",ServerTag);
		}
		case 2:{
			if(TL[id] >= get_pcvar_float(cvars[4])){
				TL[id]-=get_pcvar_float(cvars[4]);
				TCuchillo[id]=0,Destapador[id]=false,Motocierra[id]=true,bicakkontrol[id]=true;
				rg_remove_item(id, "weapon_knife"),rg_give_item(id, "weapon_knife"),rg_give_item(id, "weapon_hegrenade");
				emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Basarili bir sekilde ^4Testere + Bomba ^1Satin alinmistir.",ServerTag),jbmenu(id);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4Testere + Bomba ^1almak icin yeterli TL'niz yok.",ServerTag),jbmenu(id);
		}
		case 3:{
			if(!reklamyap[id]){
				client_print_color(0, 0, "^4[ ^3%s ^4] ^1Slotluk ve +18 komutculuk icin ^4sayden /ts3 ^1yazarak alabilirsiniz.",ServerTag);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Reklam atildi 0.90 TL ^4Kazandin!",ServerTag);
				reklamyap[id]=true,TL[id]+=0.90,bicakmarket(id);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Her Ronudda ^4Bir Kere ^1Atabilirsin.",ServerTag),bicakmarket(id);
		}
		
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public jbmenu(id){
	new players[MAX_PLAYERS],num; get_players(players, num, "acehi", "TERRORIST");
	if(!is_user_alive(id)) client_print_color(id,id,"^4[ ^3%s ^4] ^1Oluyken ^4menuye giremezsin.",ServerTag);
	else if(get_user_team(id)!=1) client_print_color(id,id,"^^4[ ^3%s ^4] ^1Bu menu ^4mahkumlar icindir.",ServerTag)
		else if(num<=0) client_print_color(id,id,"^4[ ^3%s ^4] ^1Sona kaldiginiz icin ^4giremezsiniz.",ServerTag);
		else{
		static blmenu[128]
		formatex(blmenu, charsmax(blmenu), "\r[ \w%s \r] \y~\r> \yMahkum Menusu^n\rTS3: \d%s",ServerTag ,tsip);
		new menu = menu_create(blmenu, "jbmenu_devam");
		
		if(bicakkontrol[id]) formatex(blmenu, charsmax(blmenu), "\y[ \r%s \y] \d~\w> \dBicak Marketi \yKullanildi",KisaTag);
		else formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \yBicak \rMarketi",KisaTag);
		menu_additem(menu, blmenu, "1");
		formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wT Market \rMenu",KisaTag);
		menu_additem(menu, blmenu, "2");
		if(!yetkilikontrolet[id]) formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wYetkili \rMenu",KisaTag);
		else formatex(blmenu, charsmax(blmenu), "\y[ \r%s \y] \d~\w> \dYetkili Menu \yKullanildi",KisaTag);
		menu_additem(menu, blmenu, "3");
		formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wTL Transfer \rMenu",KisaTag);
		menu_additem(menu, blmenu, "4");
		if(userbonuskontrol[id]) formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \dRasgele Bonus Menu",KisaTag);
		else formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wRasgele Bonus \rMenu",KisaTag);
		menu_additem(menu, blmenu, "5");
		formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wIsyanteam \rMenu \d[Baskan Menu]",KisaTag);
		menu_additem(menu, blmenu, "6");
		formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wReklam \rMenu",KisaTag);
		menu_additem(menu, blmenu, "7");
		
		
		menu_setprop(menu, MPROP_EXITNAME,"\dCikis",KisaTag);
		menu_display(id, menu, 0);
	}
}
public jbmenu_devam(id,menu,item){
	if(item == MENU_EXIT){
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	new data[9],name[32],access,callback;
	menu_item_getinfo(menu,item,access,data,charsmax(data),name,charsmax(name),callback);
	new key=str_to_num(data)
	switch(key){
		case 1:bicakmarket(id);
			case 2:tmarket(id);
			case 3:yetkilimenu(id);
			case 4:nakittransfer(id);
			case 5:bonus(id);
			case 6:isyanteammenu(id);
			case 7:reklammenu(id);
		}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public slot(id){
	static blmenu[128]
	formatex(blmenu, charsmax(blmenu), "\r%s \w~ \dSlot ayricaliklari",ServerTag);
	new menu = menu_create(blmenu, "slot_devam");
	
	formatex(blmenu, charsmax(blmenu), "\rSlot ayricaliklari:^n ^n\dSunucunuza gore ayarlayiniz.^n\dSunucunuza gore ayarlayiniz.^n\dSunucunuza gore ayarlayiniz.",KisaTag);
	menu_additem(menu, blmenu, "1");
	
	menu_setprop(menu, MPROP_EXITNAME,"\dCikis",KisaTag);
	menu_display(id, menu, 0);
}
public slot_devam(id,menu,item){
	if(item == MENU_EXIT){
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	new data[9],name[32],access,callback;
	menu_item_getinfo(menu,item,access,data,charsmax(data),name,charsmax(name),callback);
	new key=str_to_num(data)
	switch(key){
		case 1:{
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public reklammenu(id){
	static blmenu[128]
	formatex(blmenu, charsmax(blmenu), "\r%s \w~ \dGelismis \dreklam menusu v0\w.\y1^n\rYapimcisi: \dBlueBell",ServerTag); // Bluebell kýsmýný deðiþtirmezzseniz sevinirim :3
	new menu = menu_create(blmenu, "reklammenu_devam");
	
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \rSohbeti \wtemizle",KisaTag);
	menu_additem(menu, blmenu, "1");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \rReklam \wat",KisaTag);
	menu_additem(menu, blmenu, "2");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \rHud \wreklam at",KisaTag);
	menu_additem(menu, blmenu, "3");
	
	menu_setprop(menu, MPROP_EXITNAME,"\dCikis",KisaTag);
	menu_display(id, menu, 0);
}
public reklammenu_devam(id,menu,item){
	if(item == MENU_EXIT){
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	new data[9],name[32],access,callback;
	menu_item_getinfo(menu,item,access,data,charsmax(data),name,charsmax(name),callback);
	new key=str_to_num(data)
	switch(key){
		case 1:{
			if(get_user_flags(id) & sohbettemizleme){
				client_print_color(0, 0, " "),set_task(5.0,"chatclear",0);
				client_print_color(0, 0, "^4BILGI:^3 5 ^1Saniye sonra sohbet temizlenecektir."),client_print_color(0, 0, " ");
			}
			else{
				client_print_color(id, id, "^4BILGI: ^1Uzgunum bunu kullanacak yetkiniz yok. ^3ADMIN_RESERVATION");
			}
		}
		case 2:{
			if(get_user_flags(id) & reklamat){
				client_print_color(id, id, " "),set_task(3.0,"reklam",0)
				client_print_color(id, id, "^4BILGI: ^1Attiginiz reklam yollanacaktir.");
				client_print_color(id, id, "^4NOT:^3 3 ^1Saniye sonra atilacaktir. Spam olmamasi nedeniyle eklenmistir."),client_print_color(id, id, " ");
				
			}
			else{
				client_print_color(id, id, "^4BILGI: ^1Uzgunum bunu kullanacak yetkiniz yok. ^3ADMIN_KICK");
			}
		}
		case 3:{
			if(get_user_flags(id) & hudreklams){
				client_print_color(id, id, " "),set_task(5.0,"hudreklam",0)
				client_print_color(id, id, "^4BILGI: ^1Attiginiz reklam yollanacaktir.");
				client_print_color(id, id, "^4NOT:^3 5 ^1Saniye sonra atilacaktir. Spam olmamasi nedeniyle eklenmistir."),client_print_color(id, id, " ");
			}
			else{
				client_print_color(id, id, "^4BILGI: ^1Uzgunum bunu kullanacak yetkiniz yok. ^3ADMIN_KICK");
			}
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public hudreklam(id){
	set_task(3.2,"hudreklam2",0)
	set_hudmessage(170, 255, 85, -1.0, 0.69, 0, 6.0, 3.0)
	show_dhudmessage(id, "Slotluk ve +18 komutculuk ucretsizdir.")
	set_hudmessage(170, 255, 85, -1.0, 0.73, 0, 6.0, 3.0)
	show_hudmessage(id, "~ ~ %s ~ ~ ",ServerTag),emit_sound(id, CHAN_AUTO, mesajatildi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
	
}
public hudreklam2(id){
	set_hudmessage(170, 255, 85, -1.0, 0.69, 0, 6.0, 3.0)
	show_dhudmessage(id, "/ts3 yazarak slot veya komutcu olabilirsin!")
	set_hudmessage(170, 255, 85, -1.0, 0.73, 0, 6.0, 3.0)
	show_hudmessage(id, "- - %s - -",ServerTag)
}
public reklam(id){
	new mnum=random_num(1,5);
	switch(mnum){
		case 1:{
			client_print_color(id, id, " ");
			client_print_color(id, id, "^4%s: ^1%s",ServerTag,reklamsatir1),client_print_color(id, id, " "),emit_sound(id, CHAN_AUTO, mesajatildi, VOL_NORM, ATTN_NORM , id, PITCH_NORM);
		}
		case 2:{
			client_print_color(id, id, " ");
			client_print_color(id, id, "^4%s: ^1%s",ServerTag,reklamsatir2),client_print_color(id, id, " "),emit_sound(id, CHAN_AUTO, mesajatildi, VOL_NORM, ATTN_NORM , id, PITCH_NORM);
		}
		case 3:{
			client_print_color(id, id, " ");
			client_print_color(id, id, "^4%s: ^1%s",ServerTag,reklamsatir3),client_print_color(id, id, " "),emit_sound(id, CHAN_AUTO, mesajatildi, VOL_NORM, ATTN_NORM , id, PITCH_NORM);
		}
		case 4:{
			client_print_color(id, id, " ");
			client_print_color(id, id, "^4%s: ^1%s",ServerTag,reklamsatir4),client_print_color(id, id, " "),emit_sound(id, CHAN_AUTO, mesajatildi, VOL_NORM, ATTN_NORM , id, PITCH_NORM);
		}
		case 5:{
			client_print_color(id, id, " ");
			client_print_color(id, id, "^4%s: ^1%s",ServerTag,reklamsatir5),client_print_color(id, id, " "),emit_sound(id, CHAN_AUTO, mesajatildi, VOL_NORM, ATTN_NORM , id, PITCH_NORM);
		}
	}
}
public chatclear(id){
	new mnum=random_num(1,4);
	switch(mnum){
		case 1:{
			client_print_color(id, id, " "),client_print_color(id, id, " "),client_print_color(id, id, " ");
			client_print_color(id, id, " "),client_print_color(id, id, " ");
			client_print_color(id, id, "^4BILGI: ^1Silinen mesaj sayisi:^3 5"),emit_sound(id, CHAN_AUTO, sohbetsilindi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
		}
		case 2:{
			client_print_color(id, id, " "),client_print_color(id, id, " ");
			client_print_color(id, id, " "),client_print_color(id, id, " ");
			client_print_color(id, id, "^4BILGI: ^1Silinen mesaj sayisi:^3 4"),emit_sound(id, CHAN_AUTO, sohbetsilindi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
		}
		case 3:{
			client_print_color(id, id, " "),client_print_color(id, id, " "),client_print_color(id, id, " ");
			client_print_color(id, id, " "),client_print_color(id, id, " "),client_print_color(id, id, " ");
			client_print_color(id, id, "^4BILGI: ^1Silinen mesaj sayisi:^3 6"),emit_sound(id, CHAN_AUTO, sohbetsilindi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
		}
		case 4:{
			client_print_color(id, id, " "),client_print_color(id, id, " "),client_print_color(id, id, " "),client_print_color(id, id, " ");
			client_print_color(id, id, " "),client_print_color(id, id, " "),client_print_color(id, id, " ");
			client_print_color(id, id, "^4BILGI: ^1Silinen mesaj sayisi:^3 7"),emit_sound(id, CHAN_AUTO, sohbetsilindi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			
		}
	}
}
public bonus(id){
	if(userbonuskontrol[id]){
		client_print_color(id, id, "^4[ ^3%s ^4] ^1Her roundda bir kere ^4bonus ^1satin alabilirsin.",ServerTag),jbmenu(id)
	}
	else{
		static blmenu[128]
		formatex(blmenu, charsmax(blmenu), "\r[ \w%s \r] \y~\r> \yBonus Menu",ServerTag);
		new menu = menu_create(blmenu, "bonus_devam");
		
		formatex(blmenu, charsmax(blmenu), "\y[ \r%s \y] \d~\w> \wBonus \rAl \d(Oyuncular icin)",KisaTag);
		menu_additem(menu, blmenu, "1");
		
		menu_setprop(menu, MPROP_EXITNAME,"\dCikis",KisaTag);
		menu_display(id, menu, 0);
	}
}
public bonus_devam(id,menu,item){
	if(item == MENU_EXIT){
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	new data[9],name[32],access,callback;
	menu_item_getinfo(menu,item,access,data,charsmax(data),name,charsmax(name),callback);
	new key=str_to_num(data)
	switch(key){
		case 1:{
			new mnum=random_num(1,4);
			switch(mnum){
				case 1:{
					client_print_color(id, id, "^4[ ^3%s ^4] ^1Tebrikler Oyuncu bonus ^4menuden 2.99 TL ^1 aldin.",ServerTag);
					userbonuskontrol[id]=true,TL[id]+=2.99;
				}
				case 2:{
					client_print_color(id, id, "^4[ ^3%s ^4] ^1Tebrikler Oyuncu bonus ^4menuden 4.99 TL ^1 aldin.",ServerTag);
					userbonuskontrol[id]=true,TL[id]+=4.99
				}
				case 3:{
					client_print_color(id, id, "^4[ ^3%s ^4] ^1Tebrikler Oyuncu bonus ^4menuden +100 Can ^1 aldin.",ServerTag);
					userbonuskontrol[id]=true,set_entvar(id, var_health, Float:get_entvar(id, var_health)+100.0);
				}
				case 4:{
					client_print_color(id, id, "^4[ ^3%s ^4] ^1Tebrikler Oyuncu bonus ^4menuden 5.99 TL ^1 aldin.",ServerTag);
					userbonuskontrol[id]=true,TL[id]+=5.99;
				}
			}
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public nakittransfer(id){
	static blmenu[128]
	formatex(blmenu, charsmax(blmenu), "\r[ \w%s \r] \y~\r> \yNakit Transfer Menusu",ServerTag);
	new menu = menu_create(blmenu, "nakittransfer_devam");
	
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \w15 TL \rTransfer Et.",KisaTag);
	menu_additem(menu, blmenu, "1");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \w25 TL \rTransfer Et.",KisaTag);
	menu_additem(menu, blmenu, "2");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \w35 TL \rTransfer Et.",KisaTag);
	menu_additem(menu, blmenu, "3");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \w50 TL \rTransfer Et.",KisaTag);
	menu_additem(menu, blmenu, "4");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \w55 TL \rTransfer Et.",KisaTag);
	menu_additem(menu, blmenu, "5");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \w100 TL \rTransfer Et.",KisaTag);
	menu_additem(menu, blmenu, "6");
	
	menu_setprop(menu, MPROP_EXITNAME,"\dCikis",KisaTag);
	menu_display(id, menu, 0);
}
public nakittransfer_devam(id,menu,item){
	if(item == MENU_EXIT){
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	new data[9],name[32],access,callback;
	menu_item_getinfo(menu,item,access,data,charsmax(data),name,charsmax(name),callback);
	new key=str_to_num(data)
	switch(key){
		case 1:{
			if(TL[id] >= 15.00){
				paratransfer[id]=15,usersec(id);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4yeterli paraniz yok.",ServerTag);
		}
		case 2:{
			if(TL[id] >= 25.00){
				paratransfer[id]=20,usersec(id);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4yeterli paraniz yok.",ServerTag);
		}
		case 3:{
			if(TL[id] >= 35.00){
				paratransfer[id]=35,usersec(id);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4yeterli paraniz yok.",ServerTag);
		}
		case 4:{
			if(TL[id] >= 50.00){
				paratransfer[id]=50,usersec(id);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4yeterli paraniz yok.",ServerTag);
		}
		case 5:{
			if(TL[id] >= 55.00){
				paratransfer[id]=55,usersec(id);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4yeterli paraniz yok.",ServerTag);
		}
		case 6:{
			if(TL[id] >= 100.00){
				paratransfer[id]=100,usersec(id);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4yeterli paraniz yok.",ServerTag);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public usersec(id) {
	new blmenu[64],namee[32],sznum[6],players[32],inum,ids;
	formatex(blmenu, charsmax(blmenu),"\r[ \w%s \r] \y~\r> \yBirisini Sec",ServerTag);
	new Menu = menu_create(blmenu, "usersec_devam");
	
	get_players(players,inum,"cehi","TERRORIST"); //+c
	for(new i=0; i<inum; i++) {
		ids=players[i];
		if(ids==id) continue;
		num_to_str(ids,sznum,charsmax(sznum)); get_user_name(ids,namee,charsmax(namee));
		formatex(blmenu,charsmax(blmenu),"ry%s",namee);
		menu_additem(Menu,blmenu,sznum);
	}
	menu_setprop(Menu, MPROP_EXITNAME,"\dCikis",KisaTag);
	menu_display(id, Menu);
}
public usersec_devam(id,menu,item){
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[32],tname[32];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new tempid = str_to_num(data);
	get_user_name(id, iname, charsmax(iname));
	get_user_name(tempid, tname, charsmax(tname));
	switch(paratransfer[id]){
		case 15:{
			if(TL[id] >= 15.00){
				TL[id]-=15.00,TL[tempid]+=15.00,jbmenu(id);
				client_print_color(tempid, tempid, "^4[ ^3%s ^4] ^1%s ^4isimli mahkum size ^115.00 TL ^4trasfer etti.",ServerTag,iname);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1%s Isimli kisiye paraniz ^4gonderildi.",ServerTag,tname);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4yeterli paraniz yok.",ServerTag);
		}
		case 20:{
			if(TL[id] >= 20.00){
				TL[id]-=20.00,TL[tempid]+=20.00,jbmenu(id);
				client_print_color(tempid, tempid, "^4[ ^3%s ^4] ^1%s ^4isimli mahkum size ^115.00 TL ^4trasfer etti.",ServerTag,iname);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1%s Isimli kisiye paraniz ^4gonderildi.",ServerTag,tname);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4yeterli paraniz yok.",ServerTag);
		}
		case 35:{
			if(TL[id] >= 35.00){
				TL[id]-=35.00,TL[tempid]+=35.00,jbmenu(id);
				client_print_color(tempid, tempid, "^4[ ^3%s ^4] ^1%s ^4isimli mahkum size ^115.00 TL ^4trasfer etti.",ServerTag,iname);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1%s Isimli kisiye paraniz ^4gonderildi.",ServerTag,tname);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4yeterli paraniz yok.",ServerTag);
		}
		case 50:{
			if(TL[id] >= 50.00){
				client_print_color(tempid, tempid, "^4[ ^3%s ^4] ^1%s ^4isimli mahkum size ^115.00 TL ^4trasfer etti.",ServerTag,iname);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1%s Isimli kisiye paraniz ^4gonderildi.",ServerTag,tname);
				TL[id]-=50.00,TL[tempid]+=50.00,jbmenu(id);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4yeterli paraniz yok.",ServerTag);
		}
		case 55:{
			if(TL[id] >= 55.00){
				TL[id]-=55.00,TL[tempid]+=55.00,jbmenu(id);
				client_print_color(tempid, tempid, "^4[ ^3%s ^4] ^1%s ^4isimli mahkum size ^115.00 TL ^4trasfer etti.",ServerTag,iname);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1%s Isimli kisiye paraniz ^4gonderildi.",ServerTag,tname);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4yeterli paraniz yok.",ServerTag);
		}
		case 100:{
			if(TL[id] >= 100.00){
				TL[id]-=100.00,TL[tempid]+=100.00,jbmenu(id);
				client_print_color(tempid, tempid, "^4[ ^3%s ^4] ^1%s ^4isimli mahkum size ^115.00 TL ^4trasfer etti.",ServerTag);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1%s Isimli kisiye paraniz ^4gonderildi.",ServerTag,tname);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4yeterli paraniz yok.",ServerTag);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public tmarket(id){
	static blmenu[64]
	formatex(blmenu, charsmax(blmenu), "\r[ \w%s \r] \y~\r> \yT Market",ServerTag);
	new menu = menu_create(blmenu, "tmarket_devam");
	
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wKlasik Isyan \rEsyalari",KisaTag);
	menu_additem(menu, blmenu, "1");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wPandora \rKutulari",KisaTag);
	menu_additem(menu, blmenu, "2");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wGelismis \risyan \wesyalari",KisaTag);
	menu_additem(menu, blmenu, "3");
	
	menu_setprop(menu, MPROP_EXITNAME,"\dCikis",KisaTag);
	menu_display(id, menu, 0);
}
public tmarket_devam(id,menu,item){
	if(item == MENU_EXIT){
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	new data[9],name[32],access,callback;
	menu_item_getinfo(menu,item,access,data,charsmax(data),name,charsmax(name),callback);
	new key=str_to_num(data)
	switch(key){
		case 1:isyanesya(id)
			case 2:pandora(id)
			case 3:gelismisisyanmenu(id)
		}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public isyanesya(id){
	static blmenu[128]
	formatex(blmenu, charsmax(blmenu), "\r[ \w%s \r] \y~\r> \yKlasik Isyan esyalari",ServerTag ,tsip);
	new menu = menu_create(blmenu, "isyanesya_devam");
	
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \w+100 \rCan \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[6]));
	menu_additem(menu, blmenu, "1");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \w+200 \rCan \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[7]));
	menu_additem(menu, blmenu, "2");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wBomba \rPaketi \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[8]));
	menu_additem(menu, blmenu, "3");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wHegrenade \rBomba \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[9]));
	menu_additem(menu, blmenu, "4");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wFlashbang \rBomba \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[10]));
	menu_additem(menu, blmenu, "5");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wSinirsiz \rMermi \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[11]));
	menu_additem(menu, blmenu, "6");
	
	menu_setprop(menu, MPROP_EXITNAME,"\dCikis",KisaTag);
	menu_display(id, menu, 0);
}
public isyanesya_devam(id,menu,item){
	if(item == MENU_EXIT){
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	new data[9],name[32],access,callback;
	menu_item_getinfo(menu,item,access,data,charsmax(data),name,charsmax(name),callback);
	new key=str_to_num(data)
	switch(key){
		case 1:{
			if(TL[id] >= get_pcvar_float(cvars[6])){
				TL[id]-=get_pcvar_float(cvars[6]),set_entvar(id, var_health, Float:get_entvar(id, var_health)+100.0),item_say[id]++;
				emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Basarili bir sekilde ^4+100 Can ^1Satin alinmistir.",ServerTag),jbmenu(id);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4+100 Can ^1almak icin yeterli TL'niz yok.",ServerTag);
		}
		case 2:{
			if(TL[id] >= get_pcvar_float(cvars[7])){
				TL[id]-=get_pcvar_float(cvars[7]),set_entvar(id, var_health, Float:get_entvar(id, var_health)+200.0),item_say[id]++;
				emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Basarili bir sekilde ^4+200 Can ^1Satin alinmistir.",ServerTag),jbmenu(id);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4+200 Can ^1almak icin yeterli TL'niz yok.",ServerTag);
		}
		case 3:{
			if(TL[id] >= get_pcvar_float(cvars[8])){
				TL[id]-=get_pcvar_float(cvars[8]),rg_give_item(id,"weapon_hegrenade"),rg_give_item(id,"weapon_flashbang"),item_say[id]++;
				emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Basarili bir sekilde ^4Bomba Paketi ^1Satin alinmistir.",ServerTag),jbmenu(id);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4Bomba Paketi ^1almak icin yeterli TL'niz yok.",ServerTag);
		}
		case 4:{
			if(TL[id] >= get_pcvar_float(cvars[9])){
				TL[id]-=get_pcvar_float(cvars[9]),rg_give_item(id,"weapon_hegrenade"),item_say[id]++;
				emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Basarili bir sekilde ^4Hegrenade Bomba ^1Satin alinmistir.",ServerTag),jbmenu(id);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4Hegrenade Bomba ^1almak icin yeterli TL'niz yok.",ServerTag);
		}
		case 5:{
			if(TL[id] >= get_pcvar_float(cvars[10])){
				TL[id]-=get_pcvar_float(cvars[10]),rg_give_item(id,"weapon_flashbang"),item_say[id]++;
				emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Basarili bir sekilde ^4Flashbang Bomba ^1Satin alinmistir.",ServerTag),jbmenu(id);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4Flashbang Bomba ^1almak icin yeterli TL'niz yok.",ServerTag);
		}
		case 6:{
			if(TL[id] >= get_pcvar_float(cvars[11])){
				TL[id]-=get_pcvar_float(cvars[11]),unammo[id]=true,item_say[id]++;
				emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Basarili bir sekilde ^4Sinirsiz mermi ^1Satin alinmistir.",ServerTag),jbmenu(id);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4Sinirsiz mermi ^1almak icin yeterli TL'niz yok.",ServerTag);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public pandora(id){
	static blmenu[64]
	formatex(blmenu, charsmax(blmenu), "\r[ \w%s \r] \y~\r> \yPandora Kutulari",ServerTag);
	new menu = menu_create(blmenu, "pandora_devam");
	
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wPandora \rKutu \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[12]));
	menu_additem(menu, blmenu, "1");
	
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wSilah Pandora \rKutu \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[13]));
	menu_additem(menu, blmenu, "2");
	
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wGelismis Pandora \rkutu \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[14]));
	menu_additem(menu, blmenu, "3");
	
	menu_setprop(menu, MPROP_EXITNAME,"\dCikis",KisaTag);
	menu_display(id, menu, 0);
}
public pandora_devam(id,menu,item){
	if(item == MENU_EXIT){
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	new data[9],name[32],access,callback;
	menu_item_getinfo(menu,item,access,data,charsmax(data),name,charsmax(name),callback);
	new key=str_to_num(data)
	switch(key){
		case 1:{
			if(TL[id] >= get_pcvar_float(cvars[12])){
				TL[id]-=get_pcvar_float(cvars[12]);
				new mnum=random_num(1,6);
				switch(mnum){
					case 1:{
						set_entvar(id, var_health, Float:get_entvar(id, var_health)+100.0);
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Tebrikler ^4+100 Can ^1Kazandiniz.",ServerTag);
						emit_sound(id, CHAN_AUTO, pandoracikti, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
					case 2:{
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Tebrikler ^4Hegrenade bomba ^1Kazandiniz.",ServerTag),rg_give_item(id,"weapon_hegrenade");
						emit_sound(id, CHAN_AUTO, pandoracikti, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
					case 3:{
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Iflas ^4ettin!",ServerTag),TL[id]=0.00;
						client_print_color(0, 0, "^4[ ^3%s ^4] ^1Mahkumlardan birisi ^4iflas ^1etti..",ServerTag);
						emit_sound(id, CHAN_AUTO, pandorabos, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
					case 4:{
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Iflas ^4ettin!",ServerTag),TL[id]=0.00;
						client_print_color(0, 0, "^4[ ^3%s ^4] ^1Mahkumlardan birisi ^4iflas ^1etti..",ServerTag);
						emit_sound(id, CHAN_AUTO, pandorabos, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
					case 5:{
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Tebrikler ^4Elli TL ^1Kazandiniz.",ServerTag),TL[id]+=50.00;
						client_print_color(0, 0, "^4[ ^3%s ^4] ^1Mahkumlardan birisi ^4Elli TL ^1Kazandi!!.",ServerTag);
						emit_sound(id, CHAN_AUTO, pandoracikti, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
					case 6:{
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Tebrikler ^4YirmiBes TL ^1Kazandiniz.",ServerTag),TL[id]+=25.00;
						emit_sound(id, CHAN_AUTO, pandoracikti, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
				}
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4Pandora Kutu ^1almak icin yeterli TL'niz yok.",ServerTag);
		}
		case 2:{
			if(TL[id] >= get_pcvar_float(cvars[13])){
				TL[id]-=get_pcvar_float(cvars[13]);
				new mnum=random_num(1,6);
				switch(mnum){
					case 1:{
						rg_give_item(id,"weapon_glock18"),rg_set_user_ammo(id,WEAPON_GLOCK18,10);
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Tebrikler ^4+10 Mermili Glock ^1Kazandiniz.",ServerTag);
						client_print_color(0, 0, "^4[ ^3%s ^4] ^1Mahkumlardan birisine pandora kutusundan ^4Silah ^1Cikti!",ServerTag);
						emit_sound(id, CHAN_AUTO, pandoracikti, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
					case 2:{
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Iflas ^4ettin!",ServerTag),TL[id]=0.00;
						client_print_color(0, 0, "^4[ ^3%s ^4] ^1Mahkumlardan birisi ^4iflas ^1etti..",ServerTag);
						emit_sound(id, CHAN_AUTO, pandorabos, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
					case 3:{
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Iflas ^4ettin!",ServerTag),TL[id]=0.00;
						client_print_color(0, 0, "^4[ ^3%s ^4] ^1Mahkumlardan birisi ^4iflas ^1etti..",ServerTag);
						emit_sound(id, CHAN_AUTO, pandorabos, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
					case 4:{
						rg_give_item(id,"weapon_AWP"),rg_set_user_ammo(id,WEAPON_AWP,10);
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Tebrikler ^4+10 Mermili Awp ^1Kazandiniz.",ServerTag);
						client_print_color(0, 0, "^4[ ^3%s ^4] ^1Mahkumlardan birisine pandora kutusundan ^4Silah ^1Cikti!",ServerTag);
						emit_sound(id, CHAN_AUTO, pandoracikti, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
					case 5:{
						rg_give_item(id,"weapon_m4a1"),rg_set_user_ammo(id,WEAPON_M4A1,30);
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Tebrikler ^4+30 Mermili M4a1 ^1Kazandiniz!!!!",ServerTag);
						client_print_color(0, 0, "^4[ ^3%s ^4] ^1Mahkumlardan birisine pandora kutusundan ^4Silah ^1Cikti!",ServerTag);
						emit_sound(id, CHAN_AUTO, pandoracikti, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
					case 6:{
						rg_give_item(id,"weapon_usp"),rg_set_user_ammo(id,WEAPON_USP,15);
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Tebrikler ^4+15 Mermili Usp ^1Kazandiniz.",ServerTag);
						client_print_color(0, 0, "^4[ ^3%s ^4] ^1Mahkumlardan birisine pandora kutusundan ^4Silah ^1Cikti!",ServerTag);
						emit_sound(id, CHAN_AUTO, pandoracikti, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
				}
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4Silah Pandora Kutu ^1almak icin yeterli TL'niz yok.",ServerTag);
		}
		case 3:{
			if(TL[id] >= get_pcvar_float(cvars[14])){
				TL[id]-=get_pcvar_float(cvars[14]);
				new mnum=random_num(1,6);
				switch(mnum){
					case 1:{
						set_task(10.0,"ziplamabit",id),set_entvar(id, var_gravity, 0.7)
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Tebrikler ^4On Sn. Yuksek ziplama ^1Kazandiniz.",ServerTag);
						emit_sound(id, CHAN_AUTO, pandoracikti, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
					case 2:{
						set_task(15.0,"hizlikosma",id),set_entvar(id, var_maxspeed, 350.0)
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Tebrikler ^4OnBes Sn. Hizli Kosma ^1Kazandiniz.",ServerTag);
						emit_sound(id, CHAN_AUTO, pandoracikti, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
					case 3:{
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Iflas ^4ettin!",ServerTag),TL[id]=0.00;
						client_print_color(0, 0, "^4[ ^3%s ^4] ^1Mahkumlardan birisi ^4iflas ^1etti..",ServerTag);
						emit_sound(id, CHAN_AUTO, pandorabos, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
					case 4:{
						set_task(10.0,"godbit",id),set_entvar(id, var_takedamage, DAMAGE_NO)
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Tebrikler ^4On Sn. Godmode ^1Kazandiniz.",ServerTag);
						emit_sound(id, CHAN_AUTO, pandoracikti, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
					case 5:{
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Tebrikler ^4Yirmi TL ^1Kazandiniz.",ServerTag),TL[id]+=20.00;
						emit_sound(id, CHAN_AUTO, pandoracikti, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
					case 6:{
						client_print_color(id, id, "^4[ ^3%s ^4] ^1Iflas ^4ettin!",ServerTag),TL[id]=0.00;
						client_print_color(0, 0, "^4[ ^3%s ^4] ^1Mahkumlardan birisi ^4iflas ^1etti..",ServerTag);
						emit_sound(id, CHAN_AUTO, pandorabos, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
					}
				}
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4Gelismis Pandora Kutu ^1almak icin yeterli TL'niz yok.",ServerTag);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public gelismisisyanmenu(id){
	static blmenu[128]
	formatex(blmenu, charsmax(blmenu), "\r[ \w%s \r] \y~\r> \yGelimis isyan esyalari",ServerTag);
	new menu = menu_create(blmenu, "gelismisisyanmenu_devam");
	
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \w5 Sn \rGodmode \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[22]));
	menu_additem(menu, blmenu, "1");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \w10 Sn \rYuksek Zipla \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[23]));
	menu_additem(menu, blmenu, "2");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wGomuluyken Kendini \rKaldir \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[24]));
	menu_additem(menu, blmenu, "3");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \w5 Sn \rElektrikleri kes \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[25]));
	menu_additem(menu, blmenu, "4");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wGardiyanlara 5 Sn. \rDrug ver \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[26]));
	menu_additem(menu, blmenu, "5");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wGardiyanlari 5 Sn \rGom \d[\y %0.2f TL \d]",KisaTag,get_pcvar_float(cvars[27]));
	menu_additem(menu, blmenu, "6");
	
	menu_setprop(menu, MPROP_EXITNAME,"\dCikis",KisaTag);
	menu_display(id, menu, 0);
}
public gelismisisyanmenu_devam(id,menu,item){
	if(item == MENU_EXIT){
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	new access,callback,data[6],iname[32],players[32], inum, ids;
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	get_user_name(id, iname, charsmax(iname));
	new key=str_to_num(data);
	switch(key){
		case 1:{
			if(TL[id] >= get_pcvar_float(cvars[22])){
				TL[id]-=get_pcvar_float(cvars[22]),set_task(5.0,"godbit",id),set_entvar(id, var_takedamage, DAMAGE_NO),item_say[id]++;
				emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Basarili bir sekilde ^4Bes Sn. Godmode ^1Satin aldiniz.",ServerTag);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4Bes Sn. Godmode ^1almak icin yeterli TL'niz yok.",ServerTag);
		}
		case 2:{
			if(TL[id] >= get_pcvar_float(cvars[23])){
				TL[id]-=get_pcvar_float(cvars[23]),set_task(10.0,"ziplamabit",id),set_entvar(id, var_gravity, 0.7),item_say[id]++;
				emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Basarili bir sekilde ^4On Sn. Yuksek Ziplama ^1Satin aldiniz.",ServerTag);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4On Sn. Yuksek Ziplama ^1almak icin yeterli TL'niz yok.",ServerTag);
		}
		case 3:{
			if(TL[id] >= get_pcvar_float(cvars[24])){
				TL[id]-=get_pcvar_float(cvars[24]),item_say[id]++;
				new Float:origin[3]; get_entvar(id, var_origin, origin),origin[2] +=35.0,set_entvar(id, var_origin, origin);
				emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Basarili bir sekilde ^4Kaldirildiniz.",ServerTag);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4Gomuluysen Kendini kaldir ^1almak icin yeterli TL'niz yok.",ServerTag);
		}
		case 4:{
			if(TL[id] >= get_pcvar_float(cvars[25])){
				TL[id]-=get_pcvar_float(cvars[25]),set_lights("a"),set_task(5.0,"elektirikayarla"),item_say[id]++;
				emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Basarili bir sekilde ^4Bes Sn. Elektrikleri kes ^1Satin aldiniz.",ServerTag);
				client_print_color(0, 0, "^4[ ^3%s ^4] ^1Mahkumlarden birisi Bes Sn. Elektrikleri ^4KESTI.!",ServerTag);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4Bes Sn. Elektrikleri kes ^1almak icin yeterli TL'niz yok.",ServerTag);
		}
		case 5:{
			if(TL[id] >= get_pcvar_float(cvars[26])){
				TL[id]-=get_pcvar_float(cvars[26]),item_say[id]++;
				get_players(players,inum,"acehi","CT");
				for(new i=0; i<inum; i++) {
					ids=players[i];
					message_begin(MSG_ONE, get_user_msgid("SetFOV"), {0,0,0}, ids);
					write_byte(180);
					message_end();
					set_task(5.0,"gardidrugeski",ids);
				}
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Basarili bir sekilde ^4Bes Sn. Gardiyanlara Drug ^1Satin aldiniz.",ServerTag);
				client_print_color(0, 0, "^4[ ^3%s ^4] ^4[ ^3%s ^4] ^1Isimli oyuncu gardiyanlari Bes Sn. ^4DRUGLADI.",ServerTag,iname);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4Bes Sn. Gardiyanlara Drug ^1almak icin yeterli TL'niz yok.",ServerTag);
		}
		case 6:{
			if(TL[id] >= get_pcvar_float(cvars[27])){
				TL[id]-=get_pcvar_float(cvars[27]),item_say[id]++;
				get_players(players,inum,"acehi","CT");
				for(new i=0; i<inum; i++) {
					new Float:origin[3]; ids=players[i];
					get_entvar(ids, var_origin, origin),origin[2] -=35.0,set_entvar(ids, var_origin, origin);
					set_task(5.0,"gardiyanduzelt",ids);
				}
				emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
				client_print_color(0, 0, "^4[ ^3%s ^4] ^4[ ^3%s ^4] ^1Isimli oyuncu gardiyanlari ^4BES SN. GOMDU!!!",ServerTag,iname);
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Basarili bir sekilde ^4Gardiyanlari Bes Sn. Gom ^1Satin aldiniz.",ServerTag);
			}else client_print_color(id, id, "^4[ ^3%s ^4] ^1Uzgunum ^4Gardiyanlari Bes Sn. Gom ^1almak icin yeterli TL'niz yok.",ServerTag);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public tkaldir(id) { new Float:origin[3]; get_entvar(id, var_origin, origin),origin[2] +=35.0,set_entvar(id, var_origin, origin); }
public gardidrugeski(id) message_begin(MSG_ONE, get_user_msgid("SetFOV"), {0,0,0}, id),write_byte(100),message_end();
public elektirikayarla() set_lights("#OFF"),client_print_color(0, 0,"^4[ ^3%s ^4] ^1Elektrik kesintisi ^4duzeltildi.",ServerTag)
public ziplamabit(id) client_print_color(id, id,"^4[ ^3%s ^4] ^1Yuksek Ziplama ^4sureniz bitti.",ServerTag),set_entvar(id,var_gravity,1.0);
public godbit(id) client_print_color(id, id,"^4[ ^3%s ^4] ^1Godmode ^4sureniz bitti.",ServerTag),set_entvar(id, var_takedamage, DAMAGE_AIM)
public hizlikosma(id) client_print_color(id, id,"^4[ ^3%s ^4] ^1Hizli kosma ^4sureniz bitti.",ServerTag),rg_reset_maxspeed(id);
public yetkilimenu(id){
	if(yetkilikontrolet[id]){
		client_print_color(id, id, "^4[ ^3%s ^4] ^1Her roundda bir kere ^4yetkili bonus ^1alabilirsin.",ServerTag),jbmenu(id)
	}
	else{
		
		static blmenu[64]
		formatex(blmenu, charsmax(blmenu), "\r[ \w%s \r] \y~\r> \yYetkili Menusu",ServerTag);
		new menu = menu_create(blmenu, "yetkilimenu_devam");
		
		formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wSlot \rBonusu",ServerTag);
		menu_additem(menu, blmenu, "1");
		formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wAdmin \rBonusu",ServerTag);
		menu_additem(menu, blmenu, "2");
		formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wYonetici \rBonusu",ServerTag);
		menu_additem(menu, blmenu, "3");
		
		menu_setprop(menu, MPROP_EXITNAME,"\dCikis",KisaTag);
		menu_display(id, menu, 0);
	}
}
public yetkilimenu_devam(id,menu,item){
	if(item == MENU_EXIT){
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	new data[9],name[32],access,callback;
	menu_item_getinfo(menu,item,access,data,charsmax(data),name,charsmax(name),callback);
	new key=str_to_num(data)
	switch(key){
		case 1:{
			if(get_user_flags(id) & slot_yetki){
				slotmenu(id)
			}
			else{
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Slot degilsiniz. olmak icin sayden ^4/ts3 yazmaniz yeterli.",ServerTag),jbmenu(id)
			}
		}
		case 2:{
			if(get_user_flags(id) & admin_yetki){
				adminmenu(id)
			}
			else{
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Admin degilsiniz. olmak icin sayden ^4/ts3 yazip fiyatlara bakabilirsiniz.",ServerTag),jbmenu(id)
			}
		}
		case 3:{
			if(get_user_flags(id) & yonetici_yetki){
				yoneticimenu(id)
			}
			else{
				client_print_color(id, id, "^4[ ^3%s ^4] ^1Yonetici degilsiniz.",ServerTag),jbmenu(id)
			}
		}
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
public slotmenu(id){
	static blmenu[64]
	formatex(blmenu, charsmax(blmenu), "\r[ \w%s \r] \y~\r> \ySlot bonus menusu",ServerTag);
	new menu = menu_create(blmenu, "slotmenu_devam");
	
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \w+50 \rCan ",KisaTag);
	menu_additem(menu, blmenu, "1");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wPatlayici \rBomba",KisaTag);
	menu_additem(menu, blmenu, "2");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wHizli \rKosma \d5 Saniye",KisaTag);
	menu_additem(menu, blmenu, "3");
	formatex(blmenu, charsmax(blmenu), "\y[ \r%s \y] \d~\w> \wSlot \rBonus \d( +1.99 TL \d)",KisaTag);
	menu_additem(menu, blmenu, "4");
	menu_setprop(menu, MPROP_EXITNAME,"\dCikis",KisaTag);
	menu_display(id, menu, 0);
}
public slotmenu_devam(id,menu,item){
	if(item == MENU_EXIT){
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	new data[9],name[32],access,callback;
	menu_item_getinfo(menu,item,access,data,charsmax(data),name,charsmax(name),callback);
	new key=str_to_num(data)
	switch(key){
		case 1:{
			set_entvar(id, var_health, Float:get_entvar(id, var_health)+50.0),emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			client_print_color(id, id, "^4[ ^3%s ^4] ^1Slot Bonus ^4alindi.",ServerTag),jbmenu(id)
			yetkilikontrolet[id]=true
		}
		case 2:{
			rg_give_item(id, "weapon_hegrenade"),emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			client_print_color(id, id, "^4[ ^3%s ^4] ^1Slot Bonus ^4alindi.",ServerTag),jbmenu(id)
			yetkilikontrolet[id]=true
		}
		case 3:{
			set_task(5.0,"hizlikosma",id),set_entvar(id, var_maxspeed, 350.0),emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			client_print_color(id, id, "^4[ ^3%s ^4] ^1Slot Bonus ^4alindi.",ServerTag),jbmenu(id)
			yetkilikontrolet[id]=true
		}
		case 4:{
			TL[id]+=1.99,emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			client_print_color(id, id, "^4[ ^3%s ^4] ^1Slot Bonus ^4alindi.",ServerTag),jbmenu(id)
			yetkilikontrolet[id]=true
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public adminmenu(id){
	static blmenu[64]
	formatex(blmenu, charsmax(blmenu), "\r[ \w%s \r] \y~\r> \yAdmin bonus menusu",ServerTag);
	new menu = menu_create(blmenu, "adminmenu_devam");
	
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \w+150 \rCan ",KisaTag);
	menu_additem(menu, blmenu, "1");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wPatlayici & Kor edici \rBomba",KisaTag);
	menu_additem(menu, blmenu, "2");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wHizli \rKosma \d10 Saniye",KisaTag);
	menu_additem(menu, blmenu, "3");
	formatex(blmenu, charsmax(blmenu), "\y[ \r%s \y] \d~\w> \wSlot \rBonus \d( +3.99 TL \d)",KisaTag);
	menu_additem(menu, blmenu, "4");
	menu_setprop(menu, MPROP_EXITNAME,"\dCikis",KisaTag);
	menu_display(id, menu, 0);
}
public adminmenu_devam(id,menu,item){
	if(item == MENU_EXIT){
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	new data[9],name[32],access,callback;
	menu_item_getinfo(menu,item,access,data,charsmax(data),name,charsmax(name),callback);
	new key=str_to_num(data)
	switch(key){
		case 1:{
			set_entvar(id, var_health, Float:get_entvar(id, var_health)+150.0),emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			client_print_color(id, id, "^4[ ^3%s ^4] ^1Admin Bonus ^4alindi.",ServerTag),jbmenu(id)
			yetkilikontrolet[id]=true
		}
		case 2:{
			rg_give_item(id, "weapon_flashbang"),rg_give_item(id, "weapon_hegrenade"),emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			client_print_color(id, id, "^4[ ^3%s ^4] ^1Admin Bonus ^4alindi.",ServerTag),jbmenu(id)
			yetkilikontrolet[id]=true
		}
		case 3:{
			set_task(10.0,"hizlikosma",id),set_entvar(id, var_maxspeed, 350.0),emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			client_print_color(id, id, "^4[ ^3%s ^4] ^1Admin Bonus ^4alindi.",ServerTag),jbmenu(id)
			yetkilikontrolet[id]=true
		}
		case 4:{
			TL[id]+=3.99,emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			client_print_color(id, id, "^4[ ^3%s ^4] ^1Admin Bonus ^4alindi.",ServerTag),jbmenu(id)
			yetkilikontrolet[id]=true
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public yoneticimenu(id){
	static blmenu[64]
	formatex(blmenu, charsmax(blmenu), "\r[ \w%s \r] \y~\r> \yYonetici bonus menusu",ServerTag);
	new menu = menu_create(blmenu, "yoneticimenu_devam");
	
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \w+200 \rCan ",KisaTag);
	menu_additem(menu, blmenu, "1");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wTum \rBombalar",KisaTag);
	menu_additem(menu, blmenu, "2");
	formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wHizli \rKosma \d20 Saniye",KisaTag);
	menu_additem(menu, blmenu, "3");
	formatex(blmenu, charsmax(blmenu), "\y[ \r%s \y] \d~\w> \wSlot \rBonus \d( +6.99 TL \d)",KisaTag);
	menu_additem(menu, blmenu, "4");
	menu_setprop(menu, MPROP_EXITNAME,"\dCikis",KisaTag);
	menu_display(id, menu, 0);
}
public yoneticimenu_devam(id,menu,item){
	if(item == MENU_EXIT){
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	new data[9],name[32],access,callback;
	menu_item_getinfo(menu,item,access,data,charsmax(data),name,charsmax(name),callback);
	new key=str_to_num(data)
	switch(key){
		case 1:{
			set_entvar(id, var_health, Float:get_entvar(id, var_health)+200.0),emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			client_print_color(id, id, "^4[ ^3%s ^4] ^1Yonetici Bonus ^4alindi.",ServerTag),jbmenu(id)
			yetkilikontrolet[id]=true
		}
		case 2:{
			rg_give_item(id, "weapon_smokegrenade"),rg_give_item(id, "weapon_flashbang"),rg_give_item(id, "weapon_hegrenade"),emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			client_print_color(id, id, "^4[ ^3%s ^4] ^1Yonetici Bonus ^4alindi.",ServerTag),jbmenu(id)
			yetkilikontrolet[id]=true
		}
		case 3:{
			set_task(02.0,"hizlikosma",id),set_entvar(id, var_maxspeed, 350.0),emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			client_print_color(id, id, "^4[ ^3%s ^4] ^1Yonetici Bonus ^4alindi.",ServerTag),jbmenu(id)
			yetkilikontrolet[id]=true
		}
		case 4:{
			TL[id]+=6.99,emit_sound(id, CHAN_AUTO, satinaldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			client_print_color(id, id, "^4[ ^3%s ^4] ^1Yonetici Bonus ^4alindi.",ServerTag),jbmenu(id)
			yetkilikontrolet[id]=true
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public hudmesaj(id) {
	if(is_user_alive(id) && get_user_team(id)==1){
		set_task(1.0,"hudmesaj",id);
		set_hudmessage(255, 127, 42, -1.0, 0.74, 0, 6.0, 1.0)
		show_hudmessage(id, "[ %s ]^n[ IP: %s ]^n ^n[ Cebinizdeki TL: %0.2f ]^n[ Menuye giris (N) ]",ServerTag ,serverip,TL[id])
	}
}
public cthudmesaj(id) {
	if(is_user_alive(id) && get_user_team(id)==2){
		set_task(1.0,"cthudmesaj",id);
		static Float:health; health = get_entvar(id,var_health);
		static Float:armor; armor = Float:get_entvar(id,var_armorvalue)
		set_hudmessage(85, 212, 255, -1.0, 0.74, 0, 6.0, 1.0)
		show_hudmessage(id, "[ %s ]^n[ IP: %s ]^n ^n[ Caniniz: %0.2f ]^n[ Armorunuz: %0.2f ]^n[ /karakter ile model seçebilirsin! ]",ServerTag ,serverip,health,armor)
	}
}
public client_putinserver(id) {
	TL[id]=get_pcvar_float(cvars[1]);
	item_say[id]=0
}
public fwd_FM_ClientKill(id) {
	if(get_user_team(id)==1){
		TL[id]+=get_pcvar_float(cvars[2])
		client_print_color(id, id, "^4[ ^3%s ^4] ^1Kill cektigin icin. ^4%0.2f TL ^1bonus aldin.",ServerTag,get_pcvar_float(cvars[2]));
	}
}
public menugiriskontrol(id) {
	new teams=get_user_team(id);
	switch(teams){
		case 1: jbmenu(id);
			case 2: mgtlver(id);
		}
	return PLUGIN_HANDLED;
}
public mgtlver(id){
	if (get_user_team(id) == 2 && is_user_alive(id)){
		static blmenu[128]
		formatex(blmenu, charsmax(blmenu), "\r[ \w%s \r] \y~\r> \yGardiyan TL-Menu",ServerTag);
		new menu = menu_create(blmenu, "mgtlver_devam");
		
		formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wTL \rVer",KisaTag);
		menu_additem(menu, blmenu, "1");
		formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wTL \rAl",KisaTag);
		menu_additem(menu, blmenu, "2");
		formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wToplu \rTL Ver \dSadece Yasayanlar",KisaTag);
		menu_additem(menu, blmenu, "3");
		formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wToplu \rTL Al \dSadece Yasayanlar",KisaTag);
		menu_additem(menu, blmenu, "4");
		
		menu_setprop(menu, MPROP_EXITNAME, "\r[ \w%s \r] \y~\r> \rCikis",KisaTag);
		menu_display(id, menu, 0);
	}
}
public mgtlver_devam(id, menu, item){
	if(item == MENU_EXIT){
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	new data[9],name[32],access,callback;
	menu_item_getinfo(menu,item,access,data,charsmax(data),name,charsmax(name),callback);
	new key=str_to_num(data)
	switch(key){
		case 1: jbmg[id]=1,tl_oyuncu(id);
			case 2: jbmg[id]=2,tl_oyuncu(id);
			case 3: jbmg[id]=3,client_cmd(id, "messagemode TL_Miktari_giriniz");
			case 4: jbmg[id]=4,client_cmd(id, "messagemode TL_Miktari_giriniz");
		}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public tl_oyuncu(id){
	new blmenu[64],szName[32], szTempid[10], players[32], inum, ids;
	formatex(blmenu, charsmax(blmenu),"\r[ \w%s \r] \y~\r> \yOyuncu Sec.",ServerTag);
	new Menu = menu_create(blmenu, "tl_oyuncu2");
	
	get_players(players,inum,"acehi","TERRORIST");
	for(new i=0; i<inum; i++){
		ids=players[i];
		get_user_name(ids, szName, charsmax(szName));
		num_to_str(ids, szTempid, charsmax(szTempid));
		formatex(blmenu, charsmax(blmenu), "\w%s \w<~ \d[ \y%0.2f TL \d]  \yCanli",szName,TL[ids]);
		menu_additem(Menu, blmenu, szTempid);
	}
	get_players(players,inum,"bcehi","TERRORIST");
	for(new i=0; i<inum; i++){
		ids=players[i];
		get_user_name(ids, szName, charsmax(szName));
		num_to_str(ids, szTempid, charsmax(szTempid));
		formatex(blmenu, charsmax(blmenu), "\w%s \w<~ \d[ \y%0.2f TL \d]  \dOlu",szName,TL[ids]);
		menu_additem(Menu, blmenu, szTempid);
	}
	menu_setprop(Menu, MPROP_EXITNAME, "\dCikis");
	menu_display(id, Menu, 0);
}
public tl_oyuncu2(id,menu,item){
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[64];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	g_mgisim[id]=str_to_num(data);
	client_cmd(id, "messagemode TL_Miktari_giriniz");
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public tl_vermesi(id){
	if(!is_user_alive(id) || get_user_team(id)!=2 || jbmg[id]==0) return PLUGIN_HANDLED;
	
	new say[300]; read_args(say, charsmax(say)); remove_quotes(say);
	new miktar=str_to_num(say);
	if(!is_str_num(say) || equal(say, "") || miktar<=0) { client_print_color(id,id,"^4[ ^3%s ^4] ^1Gecersiz ^4miktar.",ServerTag); jbmg[id]=0; return PLUGIN_HANDLED; }
	new isim[32],name[32],ids=g_mgisim[id]; get_user_name(id, isim, charsmax(isim)); get_user_name(ids, name, charsmax(name));
	if(jbmg[id]==1 && ids!=0){
		if(miktar > get_pcvar_float(cvars[5])){
			client_cmd(id, "messagemode TL_Miktari_giriniz");
			client_print_color(id, id, "^4[ ^3%s ^4] ^1En fazla ^4[ ^3%0.2f ^4] ^1 TL verebilirsin.",ServerTag,get_pcvar_float(cvars[5]));
			}else{
			TL[ids]+=miktar,jbmg[id]=0,g_mgisim[id]=0;
			client_print_color(0, 0, "^4[ ^3%s ^4] ^1adli gardiyan ^4[ ^3%s ^4]^1 adli mahkuma ^4%d.00 TL^1 yolladi.",isim,name,miktar);
		}
		}else if(jbmg[id]==2 && ids!=0){
		if(miktar >= TL[ids]) {
			TL[ids]=0.00,jbmg[id]=0,g_mgisim[id]=0;
			client_print_color(0, 0, "^4[ ^3%s ^4] ^1adli gardiyan ^4[ ^3%s ^4]^1 adli mahkumun ^4tum parasini^1 aldi.",isim,name);
			}else{
			TL[ids]-=miktar,jbmg[id]=0,g_mgisim[id]=0;
			client_print_color(0, 0, "^4[ ^3%s ^4] ^1adli gardiyan ^4[ ^3%s ^4]^1 adli mahkumdan ^4%d.00 TL^1 aldi.",isim,name,miktar);
		}
		}else if(jbmg[id]==3){
		if(miktar > get_pcvar_float(cvars[5])) {
			client_cmd(id, "messagemode TL_Miktari_giriniz");
			client_print_color(id, id, "^4[ ^3%s ^4] ^1En fazla ^4[ ^3%0.2f ^4]^4 TL verebilirsin.",ServerTag,get_pcvar_float(cvars[5]));
			}else{
			jbmg[id]=0,g_mgisim[id]=0;
			new players[32],inum,uid; get_players(players,inum,"acehi","TERRORIST"); //+c
			for(new i=0; i<inum; i++) uid=players[i],TL[uid]+=miktar;
			client_print_color(0, 0, "^4[ ^3%s ^4] ^1adli gardiyan ^4tum ^1mahkumlara ^4%d.00 TL^1 yolladi.",isim,miktar);
		}
		}else if(jbmg[id]==4){
		new players[32],inum,uid; get_players(players,inum,"acehi","TERRORIST"); //+c
		for(new i=0; i<inum; i++){
			uid=players[i];
			if(TL[uid]-miktar <= 0) TL[uid]=0.00;
			else TL[uid]-=miktar;
		}
		jbmg[id]=0,g_mgisim[id]=0;
		client_print_color(0, 0, "^4[ ^3%s ^4] ^1adli gardiyan tum mahkumlardan ^4%d.00 TL^1 aldi.",isim,miktar);
	}
	return PLUGIN_HANDLED;
}
public plugin_precache(){
	precache_model(VIEW_MODELT),precache_model(PLAYER_MODELT),precache_model(VIEW_Moto);
	precache_model(VIEW_Palo),precache_model(VIEW_MODELCT),precache_model(PLAYER_MODELCT);
	precache_model(PLAYER_Moto);
	precache_sound(t_deploy),precache_sound(t_slash1),precache_sound(t_stab),precache_sound(t_wall);
	precache_sound(t_hit1),precache_sound(t_hit2),precache_sound(t_hit3),precache_sound(t_hit4);
	precache_sound(ct_deploy),precache_sound(ct_slash1),precache_sound(ct_stab),precache_sound(ct_wall);
	precache_sound(ct_hit1),precache_sound(ct_hit2),precache_sound(ct_hit3),precache_sound(ct_hit4);
	precache_sound(bictes_deploy),precache_sound(bictes_slash),precache_sound(bictes_stab);
	precache_sound(bictes_wall),precache_sound(bictes_hit1),precache_sound(bictes_hit2);
	precache_sound(pandoracikti),precache_sound(pandorabos),precache_sound(satinaldi);
	precache_sound(mesajatildi),precache_sound(sohbetsilindi);
}
public elbasi()
{
	new players[32],inum,id
	get_players(players,inum)
	for(new i;i<inum;i++)
	{
		id = players[i]
		engel[id] = 0
	}
}
public userdogdu(id){
	rg_set_user_footsteps(id, false);
	TCuchillo[id]=1;
	Destapador[id]=false;
	Motocierra[id]=false;
	bicakkontrol[id]=false;
	yetkilikontrolet[id]=false;
	userbonuskontrol[id]=false;
	reklamyap[id]=false;
	
	new teams=get_user_team(id);
	switch(teams) {
		case 1: rg_remove_all_items(id),rg_give_item(id, "weapon_knife"),jbmenu(id),hudmesaj(id)
			case 2: show_menu(id,0,""),set_entvar(id, var_health, Float:get_entvar(id, var_health)+50),cthudmesaj(id);  // 50 Yazan yer gardiyanlara verilecek hp'dir.
		}
}
public CBasePlayer_Killed(geberen){
	if(get_user_team(geberen)==1){
		new players[MAX_PLAYERS],num,ids; get_players(players, num, "acehi", "TERRORIST");
		if(num==1){
			for(new i=0; i<num; i++){
				ids=players[i];
				unammo[ids]=false;
			}
		}
	}
}
public Event_Change_Weapon(id){
	new slh=read_data(2);
	if(slh==CSW_KNIFE){
		new teams=get_user_team(id);
		switch(teams){
			case 1:{
				if(TCuchillo[id]==1 || TCuchillo[id]==2 || Destapador[id]){
					if(!Destapador[id]) set_entvar(id, var_viewmodel, VIEW_MODELT);
					else set_entvar(id, var_viewmodel, VIEW_Palo);
					set_entvar(id, var_weaponmodel, PLAYER_MODELT);
				}else if(Motocierra[id]) set_entvar(id, var_viewmodel, VIEW_Moto),set_entvar(id, var_weaponmodel, PLAYER_Moto);
			}
			case 2: set_entvar(id, var_viewmodel, VIEW_MODELCT),set_entvar(id, var_weaponmodel, PLAYER_MODELCT);
			}
	}
	if(unammo[id]){
		if(g_maxclipammo[slh] < 0) return PLUGIN_CONTINUE;
		set_member(get_member(id, m_pActiveItem), m_Weapon_iClip, g_maxclipammo[slh]);
	}
	return PLUGIN_CONTINUE;
}
public TakeDamage(victim, inflictor, attacker, Float:damage, damage_bits) {
	if(is_user_connected(attacker) && is_user_connected(victim) && victim != attacker){
		
		if(get_user_weapon(attacker) == CSW_KNIFE){
			new teams=get_user_team(attacker);
			switch(teams){
				case 1:{
					if(TCuchillo[attacker]==1 || Destapador[attacker]){
						SetHookChainArg(4, ATYPE_FLOAT, get_pcvar_float(cvars[15]));
						if(get_member(victim, m_LastHitGroup) == HIT_HEAD) SetHookChainArg(4, ATYPE_FLOAT, get_pcvar_float(cvars[16]));
						}else if(TCuchillo[attacker]==2){
						SetHookChainArg(4, ATYPE_FLOAT, get_pcvar_float(cvars[17]));
						if(get_member(victim, m_LastHitGroup) == HIT_HEAD) SetHookChainArg(4, ATYPE_FLOAT, get_pcvar_float(cvars[18]));
					                     }else if(Motocierra[attacker]) SetHookChainArg(4, ATYPE_FLOAT, get_pcvar_float(cvars[19]));
				}
				case 2:{
					SetHookChainArg(4, ATYPE_FLOAT, get_pcvar_float(cvars[20]));
					if(get_member(victim, m_LastHitGroup) == HIT_HEAD) SetHookChainArg(4, ATYPE_FLOAT, get_pcvar_float(cvars[21]));
				}
			}
		}
	}
}
public Fwd_EmitSound(id, channel, const sample[], Float:volume, Float:attn, flags, pitch){
	if(!is_user_connected(id) || !equal(sample[8], "kni", 3)) return FMRES_IGNORED;
	new teams=get_user_team(id);
	switch(teams){
		case 1:{
			if(TCuchillo[id]==1 || TCuchillo[id]==2){
				if(equal(sample[14], "sla", 3)){
					engfunc(EngFunc_EmitSound, id, channel, t_slash1, volume, attn, flags, pitch);
					return FMRES_SUPERCEDE;
					}else if(equal(sample,"weapons/knife_deploy1.wav")){
					engfunc(EngFunc_EmitSound, id, channel, t_deploy, volume, attn, flags, pitch);
					return FMRES_SUPERCEDE;
					}else if(equal(sample[14], "hit", 3)){
					if(sample[17] == 'w'){
						engfunc(EngFunc_EmitSound, id, channel, t_wall, volume, attn, flags, pitch);
						return FMRES_SUPERCEDE;
						}else{
						new mnum=random_num(1,4);
						switch(mnum){
							case 1: engfunc(EngFunc_EmitSound, id, channel, t_hit1, volume, attn, flags, pitch);
								case 2: engfunc(EngFunc_EmitSound, id, channel, t_hit2, volume, attn, flags, pitch);
								case 3: engfunc(EngFunc_EmitSound, id, channel, t_hit3, volume, attn, flags, pitch);
								case 4: engfunc(EngFunc_EmitSound, id, channel, t_hit4, volume, attn, flags, pitch);
							}
						return FMRES_SUPERCEDE;
					}
					}else if(equal(sample[14], "sta", 3)){
					engfunc(EngFunc_EmitSound, id, channel, t_stab, volume, attn, flags, pitch);
					return FMRES_SUPERCEDE;
				}
				}else if(Motocierra[id] || Destapador[id]){
				if(equal(sample[14], "sla", 3)){
					engfunc(EngFunc_EmitSound, id, channel, bictes_slash, volume, attn, flags, pitch);
					return FMRES_SUPERCEDE;
					}else if(equal(sample,"weapons/knife_deploy1.wav")){
					engfunc(EngFunc_EmitSound, id, channel, bictes_deploy, volume, attn, flags, pitch);
					return FMRES_SUPERCEDE;
					}else if(equal(sample[14], "hit", 3)){
					if(sample[17] == 'w'){
						engfunc(EngFunc_EmitSound, id, channel, bictes_wall, volume, attn, flags, pitch);
						return FMRES_SUPERCEDE;
						}else{
						new mnum=random_num(1,2);
						switch(mnum){
							case 1: engfunc(EngFunc_EmitSound, id, channel, bictes_hit1, volume, attn, flags, pitch);
								case 2: engfunc(EngFunc_EmitSound, id, channel, bictes_hit2, volume, attn, flags, pitch);
							}
						return FMRES_SUPERCEDE;
					}
					}else if(equal(sample[14], "sta", 3)){
					engfunc(EngFunc_EmitSound, id, channel, bictes_stab, volume, attn, flags, pitch);
					return FMRES_SUPERCEDE;
				}
			}
		}
		case 2: {
			if(equal(sample[14], "sla", 3)){
				engfunc(EngFunc_EmitSound, id, channel, ct_slash1, volume, attn, flags, pitch);
				return FMRES_SUPERCEDE;
				}else if(equal(sample,"weapons/knife_deploy1.wav")){
				engfunc(EngFunc_EmitSound, id, channel, ct_deploy, volume, attn, flags, pitch);
				return FMRES_SUPERCEDE;
				}else if(equal(sample[14], "hit", 3)){
				if(sample[17] == 'w'){
					engfunc(EngFunc_EmitSound, id, channel, ct_wall, volume, attn, flags, pitch);
					return FMRES_SUPERCEDE;
					}else{
					new mnum=random_num(1,4);
					switch(mnum){
						case 1: engfunc(EngFunc_EmitSound, id, channel, ct_hit1, volume, attn, flags, pitch);
							case 2: engfunc(EngFunc_EmitSound, id, channel, ct_hit2, volume, attn, flags, pitch);
							case 3: engfunc(EngFunc_EmitSound, id, channel, ct_hit3, volume, attn, flags, pitch);
							case 4: engfunc(EngFunc_EmitSound, id, channel, ct_hit4, volume, attn, flags, pitch);
						}
					return FMRES_SUPERCEDE;
				}
				}else if(equal(sample[14], "sta", 3)){
				engfunc(EngFunc_EmitSound, id, channel, ct_stab, volume, attn, flags, pitch);
				return FMRES_SUPERCEDE;
			}
		}
	}
	return FMRES_IGNORED;
}
public hosgeldin(id){
	new name[32];
	get_user_name(id, name, charsmax(name));
	client_print_color(0, 0, "^3%s ^1Aleykum selam! ^4Sunucumuza hosgeldin. ^1/ts3 yazarak ^4SLOT & KOMUTCU ^1olabilirsin!",name);
}
public same_origin(id){
	new Float:origin[3];
	get_entvar(id, var_origin, origin);
	for(new i = 0; i < 3; i++)
		if(origin[i] != player_origin[id][i])
		return 0;
	return 1;
}
public jbvertest(id){
	TL[id]+=1000.00;
}

public isyanteammenu(id){		
	if(get_user_flags(id) & ADMIN_KICK)
	{		
		if(engel[id] == 0)
		{
			static blmenu[64]
			formatex(blmenu, charsmax(blmenu), "\r[ \w%s \r] \y~\r> \yIsyan Team Menu",ServerTag);
			new menu = menu_create(blmenu, "isyanteammenu_devam");
			
			formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wMahkumlara 50 HP \rVer ",KisaTag);
			menu_additem(menu, blmenu, "1");
			formatex(blmenu, charsmax(blmenu), "\d[ \r%s \d] \d~\w> \wMahkumlara 100 Armor \rVer",KisaTag);
			menu_additem(menu, blmenu, "2");
			formatex(blmenu, charsmax(blmenu), "\d[ \y%s \d] \d~\w> \wMahkumlara Flash \rVer",KisaTag);
			menu_additem(menu, blmenu, "3");
			formatex(blmenu, charsmax(blmenu), "\y[ \r%s \y] \d~\w> \wMahkumlara Bomba \r Ver [He]",KisaTag);
			menu_additem(menu, blmenu, "4");
			menu_setprop(menu, MPROP_EXITNAME,"\dCikis",KisaTag);
			menu_display(id, menu, 0);
		}
		else
	{
		client_print_color(id,id,"^4%s : ^1Menuye her el^3 1 kez ^1girebilirsin.",KisaTag);
	}
		
	}
	else
		{
			client_print_color(id,id,"^4%s : ^1Menuye girmek icin ^3yetkin yok.",KisaTag);
		}
	return PLUGIN_HANDLED
}
public isyanteammenu_devam(const id, const menu, const item)
{
	if(item == MENU_EXIT )
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	switch(str_to_num(data))
	{
		case 1:{
			hp_ver(id)
			client_cmd(id,"spk ^"events/enemy_died.wav^"")
			engel[id] = 1
			client_print_color(0,0,"^4%s : ^1Isyan Team Baskani Mahkumlara ^3+50 HP ^1verdin.",KisaTag);
		}
		case 2:{
			armor_ver(id)
			client_cmd(id,"spk ^"events/enemy_died.wav^"")
			engel[id] = 1
			client_print_color(0,0,"^4%s : ^1Isyan Team Baskani Mahkumlara^3 100 Armor ^1verdin.",KisaTag);
		}		
		case 3:{
			flashver(id)
			client_cmd(id,"spk ^"events/enemy_died.wav^"")
			engel[id] = 1
			client_print_color(0,0,"^4%s : ^1Isyan Team Baskani Mahkumlara ^3Flashbang ^1verdin.",KisaTag);
		}
		case 4:{
			bombaver(id)
			client_cmd(id,"spk ^"events/enemy_died.wav^"")
			engel[id] = 1
			client_print_color(0,0,"^4%s : ^1Isyan Team Baskani Mahkumlara ^3Patlayici Bomba ^1verdi!",KisaTag);
		}
	}
	return PLUGIN_HANDLED
}
public bombaver(id)
{
	new players[32],inum;
	static tempid;
	get_players(players,inum)
	for(new i; i<inum; i++)
	{
		tempid = players[i]
		if(get_user_team(tempid) == 1)
		{
			rg_give_item(tempid,"weapon_hegrenade")
		}
	}
}
public hp_ver(id)
{
	new players[32],inum;
	static tempid;
	get_players(players,inum)
	for(new i; i<inum; i++)
	{
		tempid = players[i]
		if(get_user_team(tempid) == 1)
		{
			set_entvar(tempid,var_health, Float:get_entvar(id,var_health) + 50.0);
		}
	}
}
public armor_ver(id)
{
	new players[32],inum;
	static tempid;
	get_players(players,inum)
	for(new i; i<inum; i++)
	{
		tempid = players[i]
		if(get_user_team(tempid) == 1)
		{
			set_entvar(tempid,var_armortype, Float:get_entvar(id,var_armortype) + 100.0);
		}
	}	
}
public flashver(id)
{
	new players[32],inum;
	static tempid;
	get_players(players,inum)
	for(new i; i<inum; i++)
	{
		tempid = players[i]
		if(get_user_team(tempid) == 1 && get_user_flags(tempid) & ADMIN_RESERVATION)
		{
			rg_give_item(tempid,"weapon_flashbang")
		}
	}
}
public plugin_natives() register_native("jb_get_user_packs","native_jb_get", 1),register_native("jb_set_user_packs","native_jb_set");
public native_jb_get(id) return float:TL[id];
public native_jb_set(id, Float:ammount) { new id = get_param(1),Float:ammount = get_param_f(2); TL[id]=ammount; return 1; }
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/
