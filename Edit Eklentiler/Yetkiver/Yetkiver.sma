#pragma semicolon 1

#include <amxmodx>
#include <reapi>

static const yetkivergiris = ADMIN_MAP;		/* Menuye Giris Yetkisi */

enum _:defineler {
	yetkitag,
	komutcutag,
	slottag,
	menutag
};
new const g_szdefines[defineler][] = {
	"TeamTR | ",	/* Yetkinin Basina Gelicek Tag */
	" [K-A]",		/* Komutcu Sonuna Gelicek Tag */
	" [V-A]",		/* Slotun Sonuna Gelicek Tag */
	"TeamTR"
};
new const file[] = "addons/amxmodx/configs/users.ini";

new bool:komutcu_nick_giris[MAX_CLIENTS+1],bool:komutcu_sifre_giris[MAX_CLIENTS+1],bool:slot_nick_giris[MAX_CLIENTS+1],
bool:slot_sifre_giris[MAX_CLIENTS+1],pFlags,pFlags2,g_szName[MAX_CLIENTS+1][MAX_CLIENTS];

public plugin_init() {
	register_plugin("Yetkili Ekle", "1.0", "Bilalgecer47");
	new const menuclcmd[][]={
		"say /yetkiver","say /yetki","say /yetkiekle","say /yetkiyaz"
	};
	for(new i;i<sizeof(menuclcmd);i++){
		register_clcmd(menuclcmd[i],"@Giris_Kontrol");
	}
	register_clcmd("say test","@Giris_Kontrol");
	pFlags = register_cvar("slot_yetki","bemni");		/* Slot Yetkileri */
	pFlags2 = register_cvar("komutcu_yetki","befijumnops");		/* Komutcu Yetkileri */

	register_clcmd("Kontrol_Sifre","@Panel_Kontrol_Sifresi");
	register_clcmd("Slot_Nick","@Slot_Nick");
	register_clcmd("Slot_Sifre","@Slot_Sifre");
	register_clcmd("Komutcu_Nick","@Komutcu_Nick");
	register_clcmd("Komutcu_Sifre","@Komutcu_Sifre");
}
@Giris_Kontrol(const id){
	client_cmd(id,"messagemode Kontrol_Sifre");
}
@Panel_Kontrol_Sifresi( id ){
	new text[64];
	read_args(text,63);
	remove_quotes(text);
	if(!text[0]) {
		client_print_color(id,id,"^3[^4%s^3] ^3Bu kisim bos birakilamaz !", g_szdefines[menutag]);		
		client_cmd(id,"messagemode Kontrol_Sifre");
		return PLUGIN_HANDLED;
	}
	if(containi(text,"bilalgecer27") != -1) {
		client_print_color(id,id,"^3[^4%s^3] ^3Bu kisim bos birakilamaz !", g_szdefines[menutag]);
		@yetkiver(id);
	}
	else{
		client_print_color(id,id,"^3[^4%s^3] ^3Hatali Sifre !", g_szdefines[menutag]);	
	}
	return PLUGIN_HANDLED;	 
}
@yetkiver(const id) {
	if(get_user_flags(id) & yetkivergiris){
		new menu = menu_create(fmt("\w%s \d| \yYetkili Ekle", g_szdefines[menutag]), "@anamenu_devam");
	
		menu_additem(menu, fmt("\w%s \d| \ySlot Admin Yaz", g_szdefines[menutag]), "1");
		menu_additem(menu, fmt("\w%s \d| \yKomutcu Admin Yaz", g_szdefines[menutag]), "2");
		menu_additem(menu, fmt("\w%s \d| \yKullanim Kulavizu", g_szdefines[menutag]), "3");
		menu_setprop(menu, MPROP_EXITNAME, fmt("\w%s \d| \yCikis", g_szdefines[menutag]));
		menu_display(id, menu);
	}
	else{
		client_print_color(id,id,"^3[^4%s^3] ^3Bu menuye girmek icin yeterki ^4Yetkin ^3Yok",g_szdefines[menutag]);
	}
}
@anamenu_devam(const id, const menu, const item){
	if(item == MENU_EXIT) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new iData[6], iKey;
	menu_item_getinfo(menu, item, _, iData, charsmax(iData));
	iKey = str_to_num(iData);
	switch(iKey) {
		case 1: {
			@slotlukyaz(id);
		}
		case 2: {
			@komutculukyaz(id);
		}
		case 3: {
			@kullanimkilavuzu(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@slotlukyaz(const id){
	new menu = menu_create(fmt("\w%s \d| \ySlotluk Yaz", g_szdefines[menutag]), "@slotlukyaz_devam");
	
	menu_additem(menu, fmt("\w%s \d| \ySlot Admin", g_szdefines[menutag]), "1");

	menu_setprop(menu, MPROP_EXITNAME, fmt("\w%s \d| \yCikis", g_szdefines[menutag]));
	menu_display(id, menu);
}
@slotlukyaz_devam(const id, const menu, const item){
	if(item == MENU_EXIT) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new iData[6], iKey;
	menu_item_getinfo(menu, item, _, iData, charsmax(iData));
	iKey = str_to_num(iData);
	switch(iKey) {
		case 1: {
			slot_nick_giris[id] = true;
			client_cmd(id,"messagemode Slot_Nick");
			client_print_color(id,id,"^3[^4%s^3] ^3Slot Nickini Giriniz.",g_szdefines[menutag]);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@komutculukyaz(const id)
{
	new menu = menu_create(fmt("\w%s \d| \yKomutculuk Yaz", g_szdefines[menutag]), "@komutculukyaz_devam");
	
	menu_additem(menu, fmt("\w%s \d| \yKomutcu Admin", g_szdefines[menutag]), "1");

	menu_setprop(menu, MPROP_EXITNAME, fmt("\w%s \d| \yCikis", g_szdefines[menutag]));
	menu_display(id, menu);
}
@komutculukyaz_devam(const id, const menu, const item){
	if(item == MENU_EXIT) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new iData[6], iKey;
	menu_item_getinfo(menu, item, _, iData, charsmax(iData));
	iKey = str_to_num(iData);
	switch(iKey) {
		case 1: {
			komutcu_nick_giris[id] = true;
			client_cmd(id,"messagemode Komutcu_Nick");
			client_print_color(id,id,"^3[^4%s^3] ^3Komutcu Nickini Giriniz.",g_szdefines[menutag]);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@kullanimkilavuzu(const id){
	new menu = menu_create(fmt("\w%s \d| \yKullanim Kilavuzu", g_szdefines[menutag]), "@kullanimkilavuzu_devam");
	
	menu_additem(menu, fmt("\w%s \d| \yKullanicinin Sadece Nickini Giriniz", g_szdefines[menutag]), "1");
	menu_additem(menu, fmt("\w%s \d| \yNick Girdikden Sonra Sifresini Giriniz", g_szdefines[menutag]), "1");
	menu_additem(menu, fmt("\w%s \d| \yGirdikten Sonra Yetkimiz Aktifdir", g_szdefines[menutag]), "1");
	menu_additem(menu, fmt("\w%s \d| \yKonsoldan Kopyalayip Atabilirsiniz", g_szdefines[menutag]), "1");
	menu_additem(menu, fmt("\w%s \d| \yNot : Otomatik Tag Eklenir !", g_szdefines[menutag]), "1");
	
	menu_setprop(menu, MPROP_EXITNAME, fmt("\w%s \d| \yCikis", g_szdefines[menutag]));
	menu_display(id, menu);
}
@kullanimkilavuzu_devam(const id, const menu, const item){
	if(item == MENU_EXIT) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new iData[6], iKey;
	menu_item_getinfo(menu, item, _, iData, charsmax(iData));
	iKey = str_to_num(iData);
	switch(iKey) {
		case 1: {
			@kullanimkilavuzu(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@Slot_Nick(id) {
	if(!slot_nick_giris[id]) {
		client_print_color(id,id,"^3[^4%s^3] ^3Bug yapmaya calisma !",g_szdefines[menutag]);
		return PLUGIN_HANDLED;
	}
	new text[64];
	read_args(text,63);
	remove_quotes(text);
	if(!text[0]) {
		client_print_color(id,id,"^3[^4%s^3] ^3Bu kisim bos birakilamaz !",g_szdefines[menutag]);
		client_cmd(id,"messagemode Slot_Nick");
		return PLUGIN_HANDLED;
	}
	if(admin_exists(text)) {
		client_print_color(id,id,"^3[^4%s^3] ^3Bu isimde bi Yetkili var !",g_szdefines[menutag]);
		client_cmd(id,"messagemode Slot_Nick");
		return PLUGIN_HANDLED;
	}
	copy(g_szName[id],31,text);
	slot_nick_giris[id] = false;
	slot_sifre_giris[id] = true;
	client_cmd(id,"messagemode Slot_Sifre");
	client_print_color(id,id,"^3[^4%s^3] ^3Slot Sifresini Giriniz.",g_szdefines[menutag]);
	return PLUGIN_HANDLED;
}
@Slot_Sifre(id) {
	if(!slot_sifre_giris[id]) {
		client_print_color(id,id,"^3[^4%s^3] ^3Bug yapmaya calisma !",g_szdefines[menutag]);
		return PLUGIN_HANDLED;
	}
	new text[64];
	read_args(text,63);
	remove_quotes(text);
	
	@add_slot(id,g_szName[id],text);
	
	slot_sifre_giris[id] = false;
	client_print_color(id,id,"^3[^4%s^3] ^3Slotluk Basariyla Aktiflestirildi.",g_szdefines[menutag]);
	client_print_color(id,id,"^3[^4%s^3] ^3Nick : ^4%s%s%s  ^3Sifre : ^4%s",g_szdefines[menutag],g_szdefines[yetkitag],g_szName[id],g_szdefines[slottag],text);
	
	return PLUGIN_HANDLED;
}
@Komutcu_Nick(id) {
	if(!komutcu_nick_giris[id]) {
		client_print_color(id,id,"^3[^4%s^3] ^3Bug yapmaya calisma !",g_szdefines[menutag]);
		return PLUGIN_HANDLED;
	}
	new text[64];
	read_args(text,63);
	remove_quotes(text);
	if(!text[0]) {
		client_print_color(id,id,"^3[^4%s^3] ^3Bu kisim bos birakilamaz !",g_szdefines[menutag]);
		client_cmd(id,"messagemode Komutcu_Nick");
		return PLUGIN_HANDLED;
	}
	if(admin_exists(text)) {
		client_print_color(id,id,"^3[^4%s^3] ^3Bu isimde bi Yetkili var !",g_szdefines[menutag]);
		client_cmd(id,"messagemode Komutcu_Nick");
		return PLUGIN_HANDLED;
	}
	copy(g_szName[id],31,text);
	komutcu_nick_giris[id] = false;
	komutcu_sifre_giris[id] = true;
	client_cmd(id,"messagemode Komutcu_Sifre");
	client_print_color(id,id,"^3[^4%s^3] ^3Komutcu Sifresini Giriniz.",g_szdefines[menutag]);
	return PLUGIN_HANDLED;
}
@Komutcu_Sifre(id) {
	if(!komutcu_sifre_giris[id]) {
		client_print_color(id,id,"^3[^4%s^3] ^3Bug yapmaya calisma !",g_szdefines[menutag]);
		return PLUGIN_HANDLED;
	}
	new text[64];
	read_args(text,63);
	remove_quotes(text);
	
	@add_komutcu(id,g_szName[id],text);
	
	komutcu_sifre_giris[id] = false;
	client_print_color(id,id,"^3[^4%s^3] ^3Komutculuk Basariyla Aktiflestirildi.",g_szdefines[menutag]);
	client_print_color(id,id,"^3[^4%s^3] ^3Nick : ^4%s%s%s  ^3Sifre : ^4%s",g_szdefines[menutag],g_szdefines[yetkitag],g_szName[id],g_szdefines[komutcutag],text);
	
	return PLUGIN_HANDLED;
}
@add_slot(id,const Name[],const Pw[]) {
	new szLine[248],yonetici[32],yetkiler[32];
	get_pcvar_string(pFlags,yetkiler,31);
	get_user_name(id,yonetici,31);
	formatex(szLine,247,"^"%s%s%s^" ^"%s^" ^"%s^" ^"a^" // Yazan: %s^n",g_szdefines[yetkitag],Name,g_szdefines[slottag],Pw,yetkiler,yonetici);
	write_file(file,szLine);
	server_cmd("amx_reloadadmins");
	return PLUGIN_HANDLED;
}
@add_komutcu(id,const Name[],const Pw[]) {
	new szLine[248],yonetici[32],yetkiler[32];
	get_pcvar_string(pFlags2,yetkiler,31);
	get_user_name(id,yonetici,31);
	formatex(szLine,247,"^"%s%s%s^" ^"%s^" ^"%s^" ^"a^" // Yazan: %s^n",g_szdefines[yetkitag],Name,g_szdefines[komutcutag],Pw,yetkiler,yonetici);
	write_file(file,szLine);
	server_cmd("amx_reloadadmins");
	return PLUGIN_HANDLED;
}
stock admin_exists(const Name[]) {
	new szLine[248],LineName[32],blabla[32],maxlines,txtlen;
	maxlines = file_size(file,1);
	for(new line;line<maxlines;line++) {
		read_file(file,line,szLine,247,txtlen);
		parse(szLine,LineName,31,blabla,31);
		if(equali(LineName,Name)) {
			return 1;
		}
	}
	return 0;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/
