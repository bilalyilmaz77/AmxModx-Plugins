#include <amxmodx>

new const tag[]={"XX-CSGO"} // Server Ad?n?z? Yaz?n?z

public plugin_init() {
	register_plugin("Bos Menu","0.1","bilalgecer47")
	
	new const menuclcmd[][]={
		"say /kisayol","say /yardim"
	}
	for(new i;i<sizeof(menuclcmd);i++){
		register_clcmd(menuclcmd[i],"@anamenu");
	}
	register_clcmd("radio2", "@anamenu");
}
@anamenu(const id){
	static Item[128],menu;
	formatex(Item, charsmax(Item), "%s Csgo \d|| \wKisayol Menusu",tag)
	menu = menu_create(Item, "@anamenu_devam")
	
	formatex(Item, charsmax(Item), "\d%s \y` \wCsgo Menusu",tag)
	menu_additem(menu, Item, "1", 0);
	
	formatex(Item, charsmax(Item), "\d%s \y` \wCrosshair Menusu",tag);
	menu_additem(menu, Item, "2", 0);
	
	formatex(Item, charsmax(Item), "\d%s \y` \wTw Menusu",tag);
	menu_additem(menu, Item, "3", 0);
	
	formatex(Item, charsmax(Item), "\d%s \y` \wAdmin Tw Menusu",tag);
	menu_additem(menu, Item, "4", ADMIN_IMMUNITY);
	
	formatex(Item, charsmax(Item), "\d%s \y` \wSikayet Menusu",tag);
	menu_additem(menu, Item, "5", 0);
	
	formatex(Item, charsmax(Item), "\d%s \y` \wTs3 Baglan",tag);
	menu_additem(menu, Item, "6", 0);
	
	formatex(Item, charsmax(Item), "\d%s \y` \wKarakter Menusu \r[Yeni!]",tag);
	menu_additem(menu, Item, "7", 0);
	
	formatex(Item, charsmax(Item), "\rCikis")
	menu_setprop(menu,MPROP_EXITNAME,Item)
	menu_display(id, menu);
}
@anamenu_devam(id, menu, item) {
	if( item == MENU_EXIT )
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new data[6];menu_item_getinfo(menu,item,_,data,charsmax(data));
	new key = str_to_num(data);  
	switch(key)
	{
		case 1:{
			client_cmd(id,"say /csg");
		}
		case 2:{
			client_cmd(id,"say /cross");
		}
		case 3:{
			client_cmd(id,"say /tw");
		}
		case 4:{
			client_cmd(id,"say /twadmin");
		}
		case 5:{
			client_cmd(id,"say /sikayet");	
		}
		case 6:{
			client_cmd(id,"say /ts3");	
		}
		case 7:{
			client_cmd(id,"say /karakter");	
		}
	} 
	return PLUGIN_HANDLED;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/
