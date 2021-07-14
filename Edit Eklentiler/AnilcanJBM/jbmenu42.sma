#include <amxmodx>
#include <hamsandwich>
#include <fakemeta>
#include <reapi>

#define OFFSET_CLIPAMMO        51
#define OFFSET_LINUX_WEAPONS    4
#define rg_set_user_bpammo(%1,%2)    set_pdata_int(%1, OFFSET_CLIPAMMO, %2, OFFSET_LINUX_WEAPONS)
#define m_pActiveItem 373

native set_lights(const Lighting[]);

new const reklam1[] = "Ucretsiz Slot veya Komutcu Olmak Icin /ts3 e Geliniz.";
new const reklam2[] = "Server IP: 213.238.173.42 TS3: teamtr.tssunucusu.com";
new const tag[] = "TeamTR";
new const csip[] = "Cs42.CSDuragi.Com";
new const tsip[] = "teamtr.tssunucusu.com";
new const facebook[] = "fb.com/groups/TeamTRJB";
new const assasin[] = "models/player/assasin/assasin.mdl";
new const cj[] = "models/player/cj/cj.mdl";
new const matrix[] = "models/player/matrix/matrix.mdl";
new const trololo[] = "models/player/trololo/trololo.mdl";

/*============================================================
Variables
============================================================*/
const NOCLIP_WPN_BS    = ((1<<CSW_HEGRENADE)|(1<<CSW_SMOKEGRENADE)|(1<<CSW_FLASHBANG)|(1<<CSW_KNIFE)|(1<<CSW_C4))
new const g_MaxClipAmmo[] = { 0,13,0,10,0,7,0,30,30,0,15,20,25,30,35,25,12,20,10,30,100,8,30,30,20,0,7,30,30,0,50 };
new bool:m_terminator[MAX_CLIENTS+1];
new
precio1,
precio2,
precio3,
precio4,
precio5,
precio6,
precio7,
precioC1,
precioC4,
hp,
hasar,
elektrik,
dondur,
g_glock,
kutu_cost,
hasar_miktar,
gorev_odul1,
gorev_odul2,
gorev_odul3,
gorev_odul4,
gorev_odul5,
gorev_odul6,
fwPreThink,
CTDefaultDano,
TDefaultDano,
PaloDano,
HachaDano,
MacheteDano,
MotocierraDano,
hTDefaultDano,
hCTDefaultDano,
hPaloDano,
hHachaDano,
hMacheteDano,
g_killjp,
g_killhsjp,
g_startjp,
g_maxjp,
g_unammo[33],
jumpnum[33],
g_bonus[33],
engel[33],
g_yuksek[33],
hasar_azalt[33],
g_frozen[33],
g_market[33],
g_zipla[33],
tlsec[MAX_CLIENTS+1],
Speed[33],
Speed2[33],
g_slot[33],
TCuchillo[33],
odul_sinir[MAX_CLIENTS+1],
CTCuchillo[33],
Destapador[33],
Hacha[33],
Machete[33],
Motocierra[33],
g_jbpacks[33],
isimcek[MAX_CLIENTS+1],
quitar[33],
regalar[33],
kumar_engel[ 33 ],
gidPlayer[33]

enum _: EngelEl { ReklamAt }
new ElEngeller[ 33 ][ EngelEl ]

/*============================================================
Weapon Model's
============================================================*/


new VIEW_MODELT[]    	= "models/[Shop]JailBreak/Punos/Punos.mdl" //elmodeli
new PLAYER_MODELT[] 	= "models/[Shop]JailBreak/Punos/Punos2.mdl" //elmodeli distan

new VIEW_MODELCT[]    	= "models/[Shop]JailBreak/Electro/Electro.mdl" //ctbicak
new PLAYER_MODELCT[]   	= "models/[Shop]JailBreak/Electro/Electro2.mdl" //ctbicak d?sdan gorunum

new VIEW_Palo[]    	= "models/bilalgecer47/v_karambit.mdl" //bicakmodeli bir
new PLAYER_Palo[]    	= "models/w_knife.mdl" //bicak modeli distan gorunum

new VIEW_Moto[]    	= "models/[Shop]JailBreak/Moto/Moto.mdl" //testere
new PLAYER_Moto[]    	= "models/[Shop]JailBreak/Moto/Moto2.mdl" //testere d?stan

new WORLD_MODEL[]    	= "models/v_knife.mdl"
new OLDWORLD_MODEL[]    	= "models/w_knife.mdl"

/*============================================================
Shop Sounds!
============================================================*/

new const Si[] 		= { "[Shop]JailBreak/Yes.wav" }

/*============================================================
Weapon Sound's
============================================================*/

new const palo_deploy[] 		= { "weapons/knife_deploy1.wav" }
new const palo_slash1[] 		= { "weapons/knife_slash1.wav" }
new const palo_slash2[] 		= { "weapons/knife_slash2.wav" }
new const palo_wall[] 		= { "[Shop]JailBreak/Palo/PHitWall.wav" }
new const palo_hit1[] 		= { "[Shop]JailBreak/Palo/PHit1.wav" }
new const palo_hit2[] 		= { "[Shop]JailBreak/Palo/PHit2.wav" }
new const palo_hit3[] 		= { "[Shop]JailBreak/Palo/PHit3.wav" }
new const palo_hit4[] 		= { "[Shop]JailBreak/Palo/PHit4.wav" }
new const palo_stab[] 		= { "[Shop]JailBreak/Palo/PStab.wav" }

new const hacha_deploy[] 	= { "weapons/knife_deploy1.wav" }
new const hacha_slash1[] 	= { "[Shop]JailBreak/Hacha/HSlash1.wav" }
new const hacha_slash2[] 	= { "[Shop]JailBreak/Hacha/HSlash2.wav" }
new const hacha_wall[] 		= { "[Shop]JailBreak/Hacha/HHitWall.wav" }
new const hacha_hit1[] 		= { "[Shop]JailBreak/Hacha/HHit1.wav" }
new const hacha_hit2[] 		= { "[Shop]JailBreak/Hacha/HHit2.wav" }
new const hacha_hit3[] 		= { "[Shop]JailBreak/Hacha/HHit3.wav" }
new const hacha_stab[] 		= { "[Shop]JailBreak/Hacha/HHit4.wav" }

new const machete_deploy[] 	= { "[Shop]JailBreak/Machete/MConvoca.wav" }
new const machete_slash1[] 	= { "[Shop]JailBreak/Machete/MSlash1.wav" }
new const machete_slash2[] 	= { "[Shop]JailBreak/Machete/MSlash2.wav" }
new const machete_wall[] 	= { "[Shop]JailBreak/Machete/MHitWall.wav" }
new const machete_hit1[] 	= { "[Shop]JailBreak/Machete/MHit1.wav" }
new const machete_hit2[] 	= { "[Shop]JailBreak/Machete/MHit2.wav" }
new const machete_hit3[] 	= { "[Shop]JailBreak/Machete/MHit3.wav" }
new const machete_hit4[] 	= { "[Shop]JailBreak/Machete/MHit4.wav" }
new const machete_stab[] 	= { "[Shop]JailBreak/Machete/MStab.wav" }

new const motocierra_deploy[] 	= { "[Shop]JailBreak/Moto/MTConvoca.wav", }
new const motocierra_slash[] 	= { "[Shop]JailBreak/Moto/MTSlash.wav", }
new const motocierra_wall[] 	= { "[Shop]JailBreak/Moto/MTHitWall.wav" }
new const motocierra_hit1[] 	= { "[Shop]JailBreak/Moto/MTHit1.wav",  }
new const motocierra_hit2[] 	= { "[Shop]JailBreak/Moto/MTHit2.wav",  }
new const motocierra_stab[] 	= { "[Shop]JailBreak/Moto/MTStab.wav"  }

new const t_deploy[] 		= { "[Shop]JailBreak/T/TConvoca.wav", }
new const t_slash1[] 		= { "[Shop]JailBreak/T/Slash1.wav", }
new const t_slash2[] 		= { "[Shop]JailBreak/T/Slash2.wav", }
new const t_wall[] 		= { "[Shop]JailBreak/T/THitWall.wav" }
new const t_hit1[] 		= { "[Shop]JailBreak/T/THit1.wav",  }
new const t_hit2[] 		= { "[Shop]JailBreak/T/THit2.wav",  }
new const t_hit3[] 		= { "[Shop]JailBreak/T/THit3.wav",  }
new const t_hit4[] 		= { "[Shop]JailBreak/T/THit4.wav",  }
new const t_stab[] 		= { "[Shop]JailBreak/T/TStab.wav"  }

new const ct_deploy[] 		= { "[Shop]JailBreak/CT/CTConvoca.wav", }
new const ct_slash1[] 		= { "[Shop]JailBreak/CT/Slash1.wav", }
new const ct_slash2[] 		= { "[Shop]JailBreak/CT/Slash2.wav", }
new const ct_wall[] 		= { "[Shop]JailBreak/CT/CTHitWall.wav" }
new const ct_hit1[] 		= { "[Shop]JailBreak/CT/CTHit1.wav",  }
new const ct_hit2[] 		= { "[Shop]JailBreak/CT/CTHit2.wav",  }
new const ct_hit3[] 		= { "[Shop]JailBreak/CT/CTHit3.wav",  }
new const ct_hit4[] 		= { "[Shop]JailBreak/CT/CTHit4.wav",  }
new const ct_stab[] 		= { "[Shop]JailBreak/CT/CTStab.wav"  }

new bool:g_hasar[33]
new bool:dojump[33]
new Float: iAngles[ 33 ][ 3 ]

//Gorevler
new
gorev1[33],
gorev2[33],
gorev3[33],
gorev4[33],
gorev5[33],
gorev6[33],
gardiyan_oldur[33],
jb_harca[33],
mahkum_oldur[33],
esya_al[33],
g_survive[33];

//ler
new
select_meslek[33],
meslek[33];

/*============================================================
Config
============================================================*/
public plugin_natives()
{
	register_native("jb_get_user_packs","native_jb_get_user_packs")
	register_native("jb_set_user_packs","native_jb_set_user_packs")
}
public plugin_init()
{
	register_plugin("JB Menu", "1.1", "Anil Can")
	
	new const menuclcmd[][]={
	"say /jbmenu","say /bbmenu","say /csg","say_team /jbmenu","say_team /bbmenu","say_team /csg","say /item","say /market","say /shop" //menuye giris cmdleri
	}
	for(new i;i<sizeof(menuclcmd);i++){
		register_clcmd(menuclcmd[i],"anamenu");
	}
	register_clcmd("nightvision","anamenu");
	register_clcmd("TL_MIKTARI","TL_devam");
	register_clcmd("say /mg", 	"mg")
	register_clcmd("say !mg", 	"mg")
	register_clcmd("say_team /mg", 	"mg")
	register_clcmd("say_team !mg", 	"mg")
	register_logevent("logevent_round_end", 2, "1=Round_End")
	
	RegisterHam(Ham_Spawn, 		"player", "Fwd_PlayerSpawn_Post",	1)
	RegisterHam(Ham_TakeDamage, 	"player", "FwdTakeDamage", 		0)
	RegisterHam(Ham_TakeDamage, "player", "OnCBasePlayer_TakeDamage")
	RegisterHam(Ham_Killed,		"player", "fw_player_killed")
	RegisterHam( Ham_Player_Jump , "player" , "Player_Jump" , false )
	
	register_event( "DeathMsg" , "olunce" , "a" )
	register_event("HLTV", "elbasi", "a", "1=0", "2=0")
	RegisterHookChain(RG_CBasePlayer_Spawn, "OyuncuDogunca",1);
	register_event("CurWeapon", 	"Event_Change_Weapon", "be", "1=1")
	
	register_forward(FM_SetModel, 	"fw_SetModel")
	register_forward(FM_EmitSound,	"Fwd_EmitSound")
	
	/*============================================================
	Cvar's
	============================================================*/
	g_killjp 	= register_cvar("jb_killJP", 		"3");
	g_killhsjp 	= register_cvar("jb_bonushsJP", 	"2");
	g_startjp 	= register_cvar("jb_startJP",		"10");
	g_maxjp 	= register_cvar("jb_maxgiveJP",		"100");
	
	precio1 	= register_cvar("jb_pFlash", 		"8")
	precio2		= register_cvar("jb_pHe", 		"11")
	precio3		= register_cvar("jb_pHEFL", 		"25")
	precio4		= register_cvar("jb_pshield", 		"20")
	precio5		= register_cvar("jb_pFast", 		"24")
	precio6		= register_cvar("jb_pYuksek", 		"40")
	precio7		= register_cvar("jb_pUnammo", 		"20")
	
	precioC1	= register_cvar("jb_pKnife1", 		"-2")
	precioC4 	= register_cvar("jb_pKnife4", 		"35")
	
	TDefaultDano 	= register_cvar("jb_dKnifeT", 		"15")
	CTDefaultDano 	= register_cvar("jb_dKnifeCT", 		"50")
	PaloDano 	= register_cvar("jb_dKnife1", 		"25")
	HachaDano 	= register_cvar("jb_dKnife2", 		"50")
	MacheteDano 	= register_cvar("jb_dKnife3", 		"75")
	MotocierraDano 	= register_cvar("jb_dKnife4", 		"200")
	
	hTDefaultDano 	= register_cvar("jb_dHsKnifeT", 	"30")
	hCTDefaultDano 	= register_cvar("jb_dHsKnifeCT",	"80")
	hPaloDano 	= register_cvar("jb_dhsKnife1", 	"45")
	hHachaDano 	= register_cvar("jb_dhsKnife2", 	"75")
	hMacheteDano 	= register_cvar("jb_dhsKnife3", 	"95")
	
	hp                = register_cvar("jb_hp",                   "10")
	hasar             = register_cvar("jb_hasar",               "35")
	kutu_cost       = register_cvar("jb_kutu",                  "40")
	g_glock          = register_cvar("jb_glock",                "120")
	elektrik         = register_cvar("jb_elektrik",            "110")
	dondur           = register_cvar("jb_dondur",               "110")
	
	gorev_odul1     = register_cvar("gorev_odul1",              "15")
	gorev_odul2     = register_cvar("gorev_odul2",              "15")
	gorev_odul3     = register_cvar("gorev_odul3",              "15")
	gorev_odul4     = register_cvar("gorev_odul4",              "15")
	gorev_odul5     = register_cvar("gorev_odul5",              "15")
	gorev_odul6     = register_cvar("gorev_odul6",              "15")
	
	hasar_miktar    = register_cvar("jb_hasarkatla",           "2.0")	
}

/*============================================================
Precaches
============================================================*/
public plugin_precache()
{
	precache_sound(Si)
	
	precache_sound(t_deploy)
	precache_sound(t_slash1)
	precache_sound(t_slash2)
	precache_sound(t_stab)
	precache_sound(t_wall)
	precache_sound(t_hit1)
	precache_sound(t_hit2)
	precache_sound(t_hit3)
	precache_sound(t_hit4)
	
	precache_sound(ct_deploy)
	precache_sound(ct_slash1)
	precache_sound(ct_slash2)
	precache_sound(ct_stab)
	precache_sound(ct_wall)
	precache_sound(ct_hit1)
	precache_sound(ct_hit2)
	precache_sound(ct_hit3)
	precache_sound(ct_hit4)
	
	precache_sound(palo_deploy)
	precache_sound(palo_slash1)
	precache_sound(palo_slash2)
	precache_sound(palo_stab)
	precache_sound(palo_wall)
	precache_sound(palo_hit1)
	precache_sound(palo_hit2)
	precache_sound(palo_hit3)
	precache_sound(palo_hit4)
	
	precache_sound(machete_deploy)
	precache_sound(machete_slash1)
	precache_sound(machete_slash2)
	precache_sound(machete_stab)
	precache_sound(machete_wall)
	precache_sound(machete_hit1)
	precache_sound(machete_hit2)
	precache_sound(machete_hit3)
	precache_sound(machete_hit4)
	
	precache_sound(hacha_deploy)
	precache_sound(hacha_slash1)
	precache_sound(hacha_slash2)
	precache_sound(hacha_stab)
	precache_sound(hacha_wall)
	precache_sound(hacha_hit1)
	precache_sound(hacha_hit2)
	precache_sound(hacha_hit3)
	
	precache_sound(motocierra_deploy)
	precache_sound(motocierra_slash)
	precache_sound(motocierra_stab)
	precache_sound(motocierra_wall)
	precache_sound(motocierra_hit1)
	precache_sound(motocierra_hit2)
	
	
	precache_model(VIEW_MODELT)
	precache_model(PLAYER_MODELT)
	precache_model(VIEW_MODELCT)
	precache_model(PLAYER_MODELCT)
	precache_model(VIEW_Palo)
	precache_model(PLAYER_Palo)
	precache_model(VIEW_Moto)
	precache_model(PLAYER_Moto)
	precache_model(WORLD_MODEL)
	precache_model(assasin)
	precache_model(cj)
	precache_model(matrix)
	precache_model(trololo)
	
	return PLUGIN_CONTINUE
}

/*============================================================
KNIFE SHOP
============================================================*/
public Tienda1(id)
{
	if (get_user_team(id) == 1 )
	{
		if(g_market[id])
		{
			static Item[128]
			formatex(Item, charsmax(Item),"\w[ \r%s \w] - \wEnvanter Menu",tag)
			new Menu = menu_create(Item, "CuchilleroHandler")
			
			formatex(Item, charsmax(Item),"\dBayonet \r[%d TL]", get_pcvar_num(precioC1))
			menu_additem(Menu, Item, "1")
			
			formatex(Item, charsmax(Item),"\dTestere \r[%d TL]^n", get_pcvar_num(precioC4))
			menu_additem(Menu, Item, "2")
			
			if(ElEngeller[id][ReklamAt] == 0)
			{
				formatex(Item,charsmax(Item),"\yReklam At \r[+3 TL]")
				menu_additem(Menu, Item,"3")
			}
			else
			{
				formatex(Item,charsmax(Item),"\yReklam At \r[+3 TL]")
				menu_additem(Menu, Item,"4")
			}			
			menu_setprop(Menu, MPROP_EXIT, MEXIT_ALL)
			menu_display(id, Menu)
		}
		else
		{
			client_print_color(id,id,"^4%s : ^1Bu menuyu zaten ^3kullandiniz!",tag)
		}
		
		
	}
	return PLUGIN_HANDLED
}

public CuchilleroHandler(id, menu, item)
{
	if( item == MENU_EXIT )
	{
		menu_destroy(menu);	
		return PLUGIN_HANDLED;
	}
	new data[6], iName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,5, iName, 63, callback);
	
	new vivo 	= is_user_alive(id)
	new Obtener1 	= get_pcvar_num(precioC1)
	new Obtener4 	= get_pcvar_num(precioC4)
	
	new key = str_to_num(data);
	
	switch(key)
	{
		case 1:
		{
			if (g_jbpacks[id]>= Obtener1 && vivo)
			{
				g_jbpacks[id] -= Obtener1
				jb_harca[id] += Obtener1
				CTCuchillo[id] 	= 0
				TCuchillo[id] 	= 0
				Destapador[id] 	= 1
				Hacha[id] 	= 0
				Machete[id] 	= 0
				Motocierra[id] 	= 0
				engel[id]        = 1
				g_market[id] = false
				esya_al[id] += 1
				
				rg_remove_all_items(id);
				rg_give_item(id,"weapon_knife");
				
				client_print_color(id,id,"^4%s : ^1Marketten ^3[Bayonet] ^1satin aldin",tag)
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM)
			}
			else
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.Gereken  ^3[%d] ^1TL",tag,Obtener1)
			}
		}
		case 2:
		{
			if (g_jbpacks[id] >= Obtener4 && vivo)
			{
				
				g_jbpacks[id] -= Obtener4
				jb_harca[id] += Obtener4
				g_market[id] = false
				CTCuchillo[id] 	= 0
				TCuchillo[id] 	= 0
				Destapador[id]	= 0
				Hacha[id] 	= 0
				Machete[id] 	= 0
				Motocierra[id] 	= 1
				engel[id]        = 1
				esya_al[id] += 1
				
				rg_remove_all_items(id);
				rg_give_item(id,"weapon_knife");
				
				client_print_color(id,id,"^4%s : ^1Marketten ^3[Testere] ^1satin aldin",tag)
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM)
			}
			else
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.Gereken  ^3[%d] ^1TL",tag,Obtener4)
			}
		}
		case 3:
		{
			new isim[64];
			get_user_name(id,isim,63)
			g_jbpacks[id] += 3
			client_print_color(0,0,"^4[%s] : ^3%s",isim,reklam1)
			client_print_color(0,0,"^4[%s] : ^3%s",isim,reklam2)
			ElEngeller[id][ReklamAt] = 1
			Tienda1(id);
		}
		case 4:
		{
			client_print_color(id,id,"^4%s : ^1Bu menuyu her elde ^3 1 kere ^1kullanabilirsiniz",tag);
			Tienda1(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public elbasi()
{
	new players[32],inum,id
	get_players(players,inum)
	for(new i;i<inum;i++)
	{
		id = players[i]
		select_meslek[id] = true
		if(meslek[id] == 5) set_entvar(id,var_health,150.0), set_entvar(id,var_armorvalue,150.0);
		g_slot[id] = true
		odul_sinir[id] = false;
		kumar_engel[ id ] = false;
		g_bonus[id] += 1
		client_cmd(id,"say /rs");
		for( new i ; i < EngelEl; i++){
			ElEngeller[ id ][ i ] = 0;
		}
	}
}

public client_PostThink(id)
{
	if(!is_user_alive(id)) return PLUGIN_CONTINUE
	if(dojump[id] == true)
	{
		new Float:velocity[3]
		get_entvar(id,var_velocity,velocity);
		velocity[2] = random_float(265.0,285.0)
		set_entvar(id,var_velocity,velocity);
		dojump[id] = false
		return PLUGIN_CONTINUE
	}
	return PLUGIN_CONTINUE
}
/*============================================================
ITEM'S MENU
============================================================*/
public Tienda(id)
{
	static Item[64]
	
	formatex(Item, charsmax(Item),"\w[ \r%s \w] - \wT Shop",tag)
	new Menu = menu_create(Item, "TiendaHandler")
	
	formatex(Item, charsmax(Item),"\dFlash Bombasi \r[%d TL]", get_pcvar_num(precio1))
	menu_additem(Menu, Item, "1")
	
	formatex(Item, charsmax(Item),"\dEl Bombasi \r[%d TL]", get_pcvar_num(precio2))
	menu_additem(Menu, Item, "2")
	
	formatex(Item, charsmax(Item),"\d3lu bomba paketi \r[%d TL]",get_pcvar_num(precio3))
	menu_additem(Menu, Item, "3")
	
	formatex(Item, charsmax(Item),"\dKalkan \r[%d TL]", get_pcvar_num(precio4))
	menu_additem(Menu, Item, "4")
	
	formatex(Item, charsmax(Item),"\dHizli Yurume \r[%d TL]", get_pcvar_num(precio5))
	menu_additem(Menu, Item, "5")
	
	formatex(Item, charsmax(Item),"\dYuksek Atlama \r[%d TL] \d(Yuksekten Dusunce Can Gitmez)", get_pcvar_num(precio6))
	menu_additem(Menu, Item, "6")
	
	formatex(Item, charsmax(Item),"\dSinirsiz Mermi \r[%d TL]", get_pcvar_num(precio7))
	menu_additem(Menu, Item, "7")
	
	menu_setprop(Menu, MPROP_EXIT, MEXIT_ALL)
	menu_display(id, Menu)
}
public client_connect(id)
{
	select_meslek[id] = true
	g_market[id] = true
	meslek[id] = 0
	jumpnum[id] = 0
	gorev1[id] = 0
	gorev2[id] = 0
	gorev3[id] = 0
	gorev4[id] = 0
	gorev5[id] = 0
	gorev6[id] = 0
	gardiyan_oldur[id] = 0
	jb_harca[id] = 0
	mahkum_oldur[id] = 0
	esya_al[id] = 0
	g_survive[id ] = 0
	dojump[id] = false
	g_zipla[id] = false
	g_slot[id] = true
	g_bonus[id] = 3
}

public client_disconnected(id)
{
	select_meslek[id] = true
	g_market[id] = true
	meslek[id] = 0
	m_terminator[id] = false;
	jumpnum[id] = 0
	gorev1[id] = 0
	gorev2[id] = 0
	gorev3[id] = 0
	gorev4[id] = 0
	gorev5[id] = 0
	gorev6[id] = 0
	gardiyan_oldur[id] = 0
	jb_harca[id] = 0
	mahkum_oldur[id] = 0
	esya_al[id] = 0
	g_survive[id ] = 0
	dojump[id] = false
	g_zipla[id] = false
	g_slot[id] = true
	g_bonus[id] = 3
}
public OnCBasePlayer_TakeDamage( id, iInflictor, iAttacker, Float:flDamage, bitsDamageType )
{
	if( bitsDamageType & DMG_FALL && g_yuksek[id])
	{
		return HAM_SUPERCEDE
	}
	if(meslek[id] == 1)
	{
		SetHamParamFloat(4, flDamage * 0.8)
	}
	if(hasar_azalt[id])
	{
		SetHamParamFloat(4, flDamage * 0.7)
	}
	
	return HAM_IGNORED
}

public olunce()
{
	new olduren = read_data(1)
	new olen = read_data(2)
	
	if(olduren == olen)
	{
		return PLUGIN_HANDLED
	}
	if(get_user_team(olduren) == 1 && get_user_team(olen) == 1)
		mahkum_oldur[olduren] += 1
	if(get_user_team(olduren) == 1 && get_user_team(olen) == 2)
		gardiyan_oldur[olduren] += 1
	if(meslek[olen] == 5)
	{
		set_task(2.0,"rev_sansi",olen+413)
	}
	
	return PLUGIN_CONTINUE;
	
}
public OyuncuDogunca(const id){
	if(m_terminator[id]) set_entvar(id,var_health,150.0), set_entvar(id,var_armorvalue,150.0);
}
public TiendaHandler(id, menu, item)
{
	if( item == MENU_EXIT )
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new data[6], iName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,5, iName, 63, callback);
	new vivo 		= is_user_alive(id)
	new Obtener1 		= get_pcvar_num(precio1)
	new Obtener2 		= get_pcvar_num(precio2)
	new Obtener3 		= get_pcvar_num(precio3)
	new Obtener4 		= get_pcvar_num(precio4)
	new Obtener5 		= get_pcvar_num(precio5)
	new Obtener6 		= get_pcvar_num(precio6)
	new Obtener7		= get_pcvar_num(precio7)
	
	
	new key = str_to_num(data);
	switch(key)
	{
		case 1:
		{
			if (g_jbpacks[id] >= Obtener1 && vivo)
			{
				g_jbpacks[id] -= Obtener1
				jb_harca[id] += Obtener1
				esya_al[id] += 1
				client_print_color(id,id,"^4%s : ^1T Shoptan ^3[Flash Bombasi] ^1satin aldin",tag)
				rg_give_item(id,"weapon_flashbang") 
				rg_give_item(id,"weapon_flashbang") 
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM)
			}
			else
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.Gereken  ^3[%d] ^1TL",tag,Obtener1)
			}
		}
		case 2:
		{
			
			if (g_jbpacks[id] >= Obtener2 && vivo)
			{
				g_jbpacks[id] -= Obtener2
				jb_harca[id] += Obtener2
				esya_al[id] += 1
				client_print_color(id,id,"^4%s : ^1T Shoptan ^3[El Bombasi] ^1satin aldin",tag)
				rg_give_item(id,"weapon_hegrenade") 
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM)
			}
			else
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.Gereken  ^3[%d] ^1TL",tag,Obtener2)
			}
		}
		case 3:
		{
			
			if (g_jbpacks[id] >= Obtener3 && vivo)
			{
				g_jbpacks[id] -= Obtener3
				jb_harca[id] += Obtener3
				esya_al[id] += 1
				rg_give_item(id,"weapon_hegrenade") 
				rg_give_item(id,"weapon_flashbang")
				rg_give_item(id,"weapon_flashbang")
				rg_give_item(id,"weapon_smokegrenade") 
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM)
			}
			else
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.Gereken  ^3[%d] ^1TL",tag,Obtener3)
			}
		}
		case 4:
		{
			
			if (g_jbpacks[id] >= Obtener4 && vivo)
			{
				g_jbpacks[id] -= Obtener4
				jb_harca[id] += Obtener4
				esya_al[id] += 1
				rg_give_item(id,"weapon_shield") 
				client_print_color(id,id,"^4%s : ^1T Shoptan ^3[Kalkan] ^1satin aldin",tag)
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM)
			}
			else
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.Gereken  ^3[%d] ^1TL",tag,Obtener4)
			}
		}
		case 5:
		{
			if (g_jbpacks[id] >= Obtener5 && vivo)
			{
				g_jbpacks[id] -= Obtener5
				jb_harca[id] += Obtener5
				esya_al[id] += 1
				set_entvar(id,var_maxspeed,600.0);
				Speed[id] = 1
				client_print_color(id,id,"^4%s : ^1T Shoptan ^3[Hizli Kosman] ^1satin aldin",tag)
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM)
			}
			else
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.Gereken  ^3[%d] ^1TL",tag,Obtener5)
			}
		}
		case 6:
		{
			if (g_jbpacks[id] >= Obtener6 && vivo)
			{
				g_jbpacks[id] -= Obtener6
				jb_harca[id] += Obtener6
				esya_al[id] += 1
				client_print_color(id,id,"^4%s : ^1T Shoptan ^3[Yuksek Atlama] ^1satin aldin",tag)
				g_yuksek[id] = true
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM)
			}
			else
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.Gereken  ^3[%d] ^1TL",tag,Obtener6)
			}
		}
		case 7:
		{
			if (g_jbpacks[id] >= Obtener7 && vivo)
			{
				g_jbpacks[id] -= Obtener7
				jb_harca[id] += Obtener7
				g_unammo[id] = true
				esya_al[id] += 1
				client_print_color(id,id,"^4%s : ^1T Shoptan ^3[Sinirsiz Mermi] ^1satin aldin",tag)
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM)
			}
			else
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.Gereken  ^3[%d] ^1TL",tag,Obtener7)
			}
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public kutu(id)
{
	switch(random_num(1,4))
	{
		case 1 :
		{
			client_print_color(id,id,"^4%s : ^1Kutundan iflas cikti :(.Uzulme kumarda kaybeden askta kazanir.",tag)
			g_jbpacks[id] = 0
		}
		case 2 :
		{
			client_print_color(id,id,"^4%s : ^1Kutundan 10 TL ve +50 HP cikti.",tag)
			g_jbpacks[id] += 10
			set_entvar(id,var_health, Float:get_entvar(id,var_health) + 50.0);
		}
		case 3 :
		{
			client_print_color(id,id,"^4%s : ^1Kutudan infaz cikti.",tag)
			user_kill(id,1)
		}
		case 4 :
		{
			client_print_color(id,id,"^4%s : ^1Kutudan 7 mermili deagle cikti.",tag)
			rg_give_item(id,"weapon_deagle")
		}
	}
}
public logevent_round_end()
{
	new players[32],inum,id
	get_players(players,inum)
	for(new i;i<inum;i++)
	{
		id = players[i]
		if(is_user_alive(id))
		{
			g_survive[id] += 1
		}
	}
}


public Player_Jump(id)
{
	if(g_frozen[id])
	{
		return HAM_SUPERCEDE
	}
	return HAM_IGNORED
}
public fwPlayerPreThink(id)
{
	if(g_frozen[id])
	{
		if(is_user_alive(id))
		{
			set_pev( id , pev_v_angle , iAngles[ id ] )
			set_pev( id , pev_fixangle , 1 )
		}
	}
}



public client_putinserver(id)
{
	g_jbpacks[id] = get_pcvar_num(g_startjp)
	set_task(1.0, "JailbreakPacks", id, _, _, "b")
	jumpnum[id] = 0
	dojump[id] = false
	g_zipla[id] = false
}

public JailbreakPacks(id)
{
	if (get_user_team(id) == 1 ){
		set_hudmessage(124, 252, 0, 5.0, 0.7, 0, 0.0, 1.5);
		show_hudmessage(id, "Saglik : [ %i ] |^nArmor : [ %i ] |^nCebinizdeki TL - [ %i ] |",get_user_health(id),get_user_armor(id),g_jbpacks[id])
	}
}
public mg(const id) {
	if(is_user_alive(id) && get_member(id,m_iTeam) == TEAM_CT) {
		new ndmenu[64];
		formatex(ndmenu,charsmax(ndmenu),"\w[ \r%s \w] - \y MG-TL Menusu",tag);
		new Menu = menu_create(ndmenu,"mg_devam");
		
		formatex(ndmenu,charsmax(ndmenu),"\w[ \r%s \w] - \yTL Ver",tag);
		menu_additem(Menu,ndmenu,"1");
		formatex(ndmenu,charsmax(ndmenu),"\w[ \r%s \w] - \yTL Al",tag);
		menu_additem(Menu,ndmenu,"2");
		formatex(ndmenu,charsmax(ndmenu),"\w[ \r%s \w] - \yToplu TL Ver \d[Sadece Yasayanlar]",tag);
		menu_additem(Menu,ndmenu,"3");
		formatex(ndmenu,charsmax(ndmenu),"\w[ \r%s \w] - \yToplu TL Al \d[Sadece Yasayanlar]",tag);
		menu_additem(Menu,ndmenu,"4");
		
		menu_setprop(Menu, MPROP_EXITNAME, "\yCikis");
		menu_display(id, Menu, 0);
	}
}
public mg_devam(const id, const menu, const item){
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[64];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	new key=str_to_num(data);
	switch(key) { 
		case 1: tlsec[id]=1,mg_oyuncu(id);
			case 2: tlsec[id]=2,mg_oyuncu(id);
			case 3: tlsec[id]=3,client_cmd(id, "messagemode TL_MIKTARI");
			case 4: tlsec[id]=4,client_cmd(id, "messagemode TL_MIKTARI");
		}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public mg_oyuncu(const id) {
	new ndmenu[64],szName[32], szTempid[10], players[32], inum, ids;
	formatex(ndmenu, charsmax(ndmenu),"\w[ \r%s \w] - \yOyuncu Sec.",tag);
	new Menu = menu_create(ndmenu, "mg_oyuncu_devam");
	
	get_players(players,inum,"acehi","TERRORIST");
	for(new i=0; i<inum; i++) {
		ids=players[i];
		get_user_name(ids, szName, charsmax(szName));
		num_to_str(ids, szTempid, charsmax(szTempid));
		formatex(ndmenu, charsmax(ndmenu), "\w[ \r%s \w] - \d[\r%i TL\d] \d[Canli]",szName,g_jbpacks[ids]);
		menu_additem(Menu, ndmenu, szTempid);
	}
	get_players(players,inum,"bcehi","TERRORIST");
	for(new i=0; i<inum; i++) {
		ids=players[i];
		get_user_name(ids, szName, charsmax(szName));
		num_to_str(ids, szTempid, charsmax(szTempid));
		formatex(ndmenu, charsmax(ndmenu), "\w[ \r%s \w] - \d[\r%i TL\d] \d[Olu]",szName,g_jbpacks[ids]);
		menu_additem(Menu, ndmenu, szTempid);
	}
	menu_setprop(Menu, MPROP_EXITNAME, "\yCikis");
	menu_display(id, Menu, 0);
}
public mg_oyuncu_devam(const id,const menu,const item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[64];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	isimcek[id]=str_to_num(data);
	client_cmd(id, "messagemode TL_MIKTARI");
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public TL_devam(const id) {
	if(!is_user_alive(id) || get_user_team(id)!=2 || tlsec[id]==0) return PLUGIN_HANDLED;
	
	new say[300]; read_args(say, charsmax(say)); remove_quotes(say);
	new miktar=str_to_num(say);
	if(!is_str_num(say) || equal(say, "") || miktar<=0) { client_print_color(id,id,"^1[^3%s^1] ^4Gecersiz miktar.",tag); tlsec[id]=0; return PLUGIN_HANDLED; }
	new isim[32],name[32],ids=isimcek[id]; get_user_name(id, isim, charsmax(isim)); get_user_name(ids, name, charsmax(name));
	if(tlsec[id]==1 && ids!=0) {
		if(miktar > 150) {
			client_cmd(id, "messagemode TL_MIKTARI");
			client_print_color(id, id, "^1%s - ^4En fazla ^1[^3 150 ^1]^4 TL verebilirsin.",tag);
			} else {
			g_jbpacks[ids]+=miktar,tlsec[id]=0,isimcek[id]=0;
			client_print_color(0, 0, "^1%s - ^4adli gardiyan ^1[^3%s^1]^4 adli mahkuma^1 %i TL^4 yolladi.",isim,name,miktar);
		}
		} else if(tlsec[id]==2 && ids!=0) {
		if(miktar >= g_jbpacks[ids]) {
			g_jbpacks[ids]=0,tlsec[id]=0,isimcek[id]=0;
			client_print_color(0, 0, "^1%s - ^4adli gardiyan ^1[^3%s^1]^4 adli mahkumun ^1tum parasini^4 aldi.",isim,name);
			} else {
			g_jbpacks[ids]-=miktar,tlsec[id]=0,isimcek[id]=0;
			client_print_color(0, 0, "^1%s - ^4adli gardiyan ^1[^3%s^1]^4 adli mahkumdan ^1%i TL^4 aldi.",isim,name,miktar);
		}
		} else if(tlsec[id]==3) {
		if(miktar > 150) {
			client_cmd(id, "messagemode TL_MIKTARI");
			client_print_color(id, id, "^1%s - ^4En fazla ^1[^3 150 ^1]^4 TL verebilirsin.",tag);
			} else {
			tlsec[id]=0,isimcek[id]=0;
			new players[32],inum,uid; get_players(players,inum,"acehi","TERRORIST"); //+c
			for(new i=0; i<inum; i++) uid=players[i],g_jbpacks[uid]+=miktar;
			client_print_color(0, 0, "^1%s - ^4adli gardiyan tum mahkumlara ^1%i TL^4 yolladi.",isim,miktar);
		}
		} else if(tlsec[id]==4) {
		new players[32],inum,uid; get_players(players,inum,"acehi","TERRORIST"); //+c
		for(new i=0; i<inum; i++) {
			uid=players[i];
			if(g_jbpacks[uid]-miktar <= 0) g_jbpacks[uid]=0;
			else g_jbpacks[ids]-=miktar;
		}
		tlsec[id]=0,isimcek[id]=0;
		client_print_color(0, 0, "^1%s - ^4adli gardiyan tum mahkumlardan ^1%i TL^4 aldi.",isim,miktar);
	}
	return PLUGIN_HANDLED;
}
public player(id)
{
	new say[300]
	read_args(say, charsmax(say))
	
	remove_quotes(say)
	
	if(!is_str_num(say) || equal(say, ""))
		return PLUGIN_HANDLED
	
	jbpacks(id, say)
	
	return PLUGIN_CONTINUE
}

jbpacks(id, say[]) {
	new amount = str_to_num(say)
	new victim = gidPlayer[id]
	
	new vname[32]
	new adminname[32]
	
	if(victim > 0)
	{
		get_user_name(victim, vname, 31)
		get_user_name(id, adminname, 31)
		
		if(regalar[id])
		{
			if(amount > get_pcvar_num(g_maxjp))
			{
				client_print_color(0,0,"^4%s : ^1%s adli gardiyan ^3[%d TL]' ^1den fazla vermeye calisti.",tag,adminname,get_pcvar_num(g_maxjp))
			}
			else
			{
				g_jbpacks[victim] = g_jbpacks[victim] + amount
				client_print_color(0,0,"^4%s : ^1%s adli gardiyan ^3[%d TL] ^1adli mahkuma ^4[%d TL]  ^1verdi.",tag,adminname,vname,amount)
			}
		}
		if(quitar[id])
		{
			if(amount > g_jbpacks[victim])
			{
				g_jbpacks[victim] = 0
				client_print_color(0,0,"^4%s : ^1%s adli gardiyan ^3[%d TL] ^1adli mahkumun tum !n[!t%d TL!n]' !gsini aldi",tag,adminname,vname)
			}
			else
			{
				g_jbpacks[victim] = g_jbpacks[victim] - amount
				client_print_color(0,0,"^4%s : ^1%s adli gardiyan ^3[%d TL] ^1adli mahkumdan ^4[%d TL]  ^1aldi.",tag,adminname,vname,amount)
			}
			
		}
	}
	
	return PLUGIN_HANDLED
}
public Fwd_PlayerSpawn_Post(id)
{
	if (is_user_alive(id))
	{
		if(get_user_team(id) == 1) 
			rg_remove_item(id,"weapon_knife");
		rg_give_item(id,"weapon_knife");
		
		set_entvar(id,var_maxspeed,250.0);
		Speed[id] 	= 0
		Speed2[id] 	= 0
		CTCuchillo[id] 	= 1
		TCuchillo[id] 	= 1
		Destapador[id] 	= 0
		Hacha[id] 	= 0
		Machete[id] 	= 0
		Motocierra[id] 	= 0
		engel[id]        = 0
		jumpnum[id]      = 0
		dojump[id]       = false
		g_unammo[id]    = false
		g_hasar[id]     = false
		g_zipla[id]     = false
		g_yuksek[id]    = false
		g_market[id] = true
		anamenu(id)
	}
	if(get_user_team(id) == 2)
	{
		if(g_frozen[id])
		{
			ctcoz(id)
		}
	}
	if(meslek[id] == 2)
	{
		set_entvar(id,var_gravity,0.65);
	}
}
public FwdTakeDamage(victim, inflictor, attacker, Float:damage, damage_bits)
{
	if(!is_user_connected(attacker) || !is_user_connected(victim)) return HAM_IGNORED
	
	if (is_user_connected(attacker) && get_user_weapon(attacker) == CSW_KNIFE)
	{
		switch(get_user_team(attacker))
		{
			case 1:
			{
				if(TCuchillo[attacker])
				{
					
					SetHamParamFloat(4, get_pcvar_float(TDefaultDano))
					
					if(get_pdata_int(victim, 75) == HIT_HEAD)
					{
						SetHamParamFloat(4, get_pcvar_float(hTDefaultDano))
					}
				}
				
				if(Destapador[attacker])
				{
					SetHamParamFloat(4, get_pcvar_float(PaloDano))
					
					if(get_pdata_int(victim, 75) == HIT_HEAD)
					{
						SetHamParamFloat(4, get_pcvar_float(hPaloDano))
					}
				}
				
				if(Hacha[attacker])
				{
					SetHamParamFloat(4, get_pcvar_float(HachaDano))
					
					if(get_pdata_int(victim, 75) == HIT_HEAD)
					{
						SetHamParamFloat(4, get_pcvar_float(hHachaDano))
					}
				}
				
				if(Machete[attacker])
				{
					SetHamParamFloat(4, get_pcvar_float(MacheteDano))
					
					if(get_pdata_int(victim, 75) == HIT_HEAD)
					{
						SetHamParamFloat(4, get_pcvar_float(hMacheteDano))
					}
				}
				
				if(Motocierra[attacker])
				{
					SetHamParamFloat(4, get_pcvar_float(MotocierraDano))
				}
			}
			case 2:
			{
				if(CTCuchillo[attacker])
				{
					SetHamParamFloat(4, get_pcvar_float(CTDefaultDano))
					
					if(get_pdata_int(victim, 75) == HIT_HEAD)
					{
						SetHamParamFloat(4, get_pcvar_float(hCTDefaultDano))
					}
				}
			}
		}
	}
	if((damage_bits & DMG_FALL) && g_yuksek[victim])
	{
		return HAM_SUPERCEDE
	}
	if(is_user_connected(attacker) && g_hasar[attacker])
	{
		damage *= get_pcvar_float(hasar_miktar)
		SetHamParamFloat(4,damage)
	}
	
	return HAM_HANDLED
}

public fw_player_killed(victim, attacker, shouldgib)
{
	if(get_user_team(attacker) == 1)
	{
		g_jbpacks[attacker] += get_pcvar_num(g_killjp)
		
		if(get_pdata_int(victim, 75) == HIT_HEAD)
		{
			g_jbpacks[attacker] += get_pcvar_num(g_killhsjp)
		}
	}
}
public native_jb_get_user_packs(id)
{
	return g_jbpacks[id];
}

public native_jb_set_user_packs(id, ammount)
{
	new id = get_param(1);
	new ammount = get_param(2);
	g_jbpacks[id] = ammount
	return 1;
}

public Event_Change_Weapon(id)
{
	new weaponID = read_data(2)
	
	switch (get_user_team(id))
	{
		case 1:
		{
			if(Speed[id])
			{
				set_entvar(id,var_maxspeed,600.0);
			}
			
			if(Speed2[id])
			{
				set_entvar(id,var_maxspeed,380.0);
			}
			
			if(weaponID == CSW_KNIFE)
			{
				if(TCuchillo[id])
				{
					set_pev(id, pev_viewmodel2, VIEW_MODELT)
					set_pev(id, pev_weaponmodel2, PLAYER_MODELT)
				}
				
				if(Destapador[id])
				{
					set_pev(id, pev_viewmodel2, VIEW_Palo)
					set_pev(id, pev_weaponmodel2, PLAYER_Palo)
				}
				
				
				if(Motocierra[id])
				{
					set_pev(id, pev_viewmodel2, VIEW_Moto)
					set_pev(id, pev_weaponmodel2, PLAYER_Moto)
				}
				
				
			}
		}
		case 2:
		{
			if(CTCuchillo[id] && weaponID == CSW_KNIFE)
			{
				set_pev(id, pev_viewmodel2, VIEW_MODELCT)
				set_pev(id, pev_weaponmodel2, PLAYER_MODELCT)
			}
		}
	}
	if(g_frozen[id])
	{
		engclient_cmd(id,"weapon_knife")
	}
	if(g_unammo[id]){
		new iWeapon = read_data(2)
		if( !( NOCLIP_WPN_BS & (1<<iWeapon) ) )
		{
			rg_set_user_bpammo( get_pdata_cbase(id, m_pActiveItem) , g_MaxClipAmmo[ iWeapon ] )
		}
	}
	return PLUGIN_CONTINUE
}

public fw_SetModel(entity, model[])
{
	if(!pev_valid(entity))
		return FMRES_IGNORED
	
	if(!equali(model, OLDWORLD_MODEL))
		return FMRES_IGNORED
	
	new className[33]
	pev(entity, pev_classname, className, 32)
	
	if(equal(className, "weaponbox") || equal(className, "armoury_entity") || equal(className, "grenade"))
	{
		engfunc(EngFunc_SetModel, entity, WORLD_MODEL)
		return FMRES_SUPERCEDE
	}
	return FMRES_IGNORED
}

public Fwd_EmitSound(id, channel, const sample[], Float:volume, Float:attn, flags, pitch)
{
	
	if (!is_user_connected(id))
		return FMRES_IGNORED;
	
	if(CTCuchillo[id])
	{
		if(get_user_team(id) == 2)
		{
			if (equal(sample[8], "kni", 3))
			{
				if (equal(sample[14], "sla", 3))
				{
					switch (random_num(1, 2))
					{
						case 1: engfunc(EngFunc_EmitSound, id, channel, ct_slash1, volume, attn, flags, pitch)
							case 2: engfunc(EngFunc_EmitSound, id, channel, ct_slash2, volume, attn, flags, pitch)
						}
					
					return FMRES_SUPERCEDE;
				}
				if(equal(sample,"weapons/knife_deploy1.wav"))
				{
					engfunc(EngFunc_EmitSound, id, channel, ct_deploy, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
				if (equal(sample[14], "hit", 3))
				{
					if (sample[17] == 'w')
					{
						engfunc(EngFunc_EmitSound, id, channel, ct_wall, volume, attn, flags, pitch)
						return FMRES_SUPERCEDE;
					}
					else
					{
						switch (random_num(1, 4))
						{
							case 1: engfunc(EngFunc_EmitSound, id, channel, ct_hit1, volume, attn, flags, pitch)
								case 2: engfunc(EngFunc_EmitSound, id, channel, ct_hit2, volume, attn, flags, pitch)
								case 3: engfunc(EngFunc_EmitSound, id, channel, ct_hit3, volume, attn, flags, pitch)
								case 4: engfunc(EngFunc_EmitSound, id, channel, ct_hit4, volume, attn, flags, pitch)
							}
						
						return FMRES_SUPERCEDE;
					}
				}
				if (equal(sample[14], "sta", 3))
				{
					engfunc(EngFunc_EmitSound, id, channel, ct_stab, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
			}
		}
	}
	
	if(TCuchillo[id])
	{
		if(get_user_team(id) == 1)
		{
			if (equal(sample[8], "kni", 3))
			{
				if (equal(sample[14], "sla", 3))
				{
					switch (random_num(1, 2))
					{
						case 1: engfunc(EngFunc_EmitSound, id, channel, t_slash1, volume, attn, flags, pitch)
							case 2: engfunc(EngFunc_EmitSound, id, channel, t_slash2, volume, attn, flags, pitch)
						}
					
					return FMRES_SUPERCEDE;
				}
				if(equal(sample,"weapons/knife_deploy1.wav"))
				{
					engfunc(EngFunc_EmitSound, id, channel, t_deploy, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
				if (equal(sample[14], "hit", 3))
				{
					if (sample[17] == 'w')
					{
						engfunc(EngFunc_EmitSound, id, channel, t_wall, volume, attn, flags, pitch)
						return FMRES_SUPERCEDE;
					}
					else
					{
						switch (random_num(1, 4))
						{
							case 1: engfunc(EngFunc_EmitSound, id, channel, t_hit1, volume, attn, flags, pitch)
								case 2: engfunc(EngFunc_EmitSound, id, channel, t_hit2, volume, attn, flags, pitch)
								case 3: engfunc(EngFunc_EmitSound, id, channel, t_hit3, volume, attn, flags, pitch)
								case 4: engfunc(EngFunc_EmitSound, id, channel, t_hit4, volume, attn, flags, pitch)
							}
						
						return FMRES_SUPERCEDE;
					}
				}
				if (equal(sample[14], "sta", 3))
				{
					engfunc(EngFunc_EmitSound, id, channel, t_stab, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
			}
		}
	}
	
	if(Destapador[id])
	{
		if (equal(sample[8], "kni", 3))
		{
			if (equal(sample[14], "sla", 3))
			{
				switch (random_num(1, 2))
				{
					case 1: engfunc(EngFunc_EmitSound, id, channel, palo_slash1, volume, attn, flags, pitch)
						case 2: engfunc(EngFunc_EmitSound, id, channel, palo_slash2, volume, attn, flags, pitch)
						
				}
				
				return FMRES_SUPERCEDE;
			}
			if(equal(sample,"weapons/knife_deploy1.wav"))
			{
				engfunc(EngFunc_EmitSound, id, channel, palo_deploy, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
			if (equal(sample[14], "hit", 3))
			{
				if (sample[17] == 'w')
				{
					engfunc(EngFunc_EmitSound, id, channel, palo_wall, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
				else
				{
					switch (random_num(1, 4))
					{
						case 1:engfunc(EngFunc_EmitSound, id, channel, palo_hit1, volume, attn, flags, pitch)
							case 2:engfunc(EngFunc_EmitSound, id, channel, palo_hit2, volume, attn, flags, pitch)
							case 3:engfunc(EngFunc_EmitSound, id, channel, palo_hit3, volume, attn, flags, pitch)
							case 4:engfunc(EngFunc_EmitSound, id, channel, palo_hit4, volume, attn, flags, pitch)
						}
					
					return FMRES_SUPERCEDE;
				}
			}
			if (equal(sample[14], "sta", 3))
			{
				engfunc(EngFunc_EmitSound, id, channel, palo_stab, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
		}
	}
	
	if(Hacha[id])
	{
		
		if (equal(sample[8], "kni", 3))
		{
			if (equal(sample[14], "sla", 3))
			{
				switch (random_num(1, 2))
				{
					case 1: engfunc(EngFunc_EmitSound, id, channel, hacha_slash1, volume, attn, flags, pitch)
						case 2: engfunc(EngFunc_EmitSound, id, channel, hacha_slash2, volume, attn, flags, pitch)
					}
				
				return FMRES_SUPERCEDE;
			}
			if(equal(sample,"weapons/knife_deploy1.wav"))
			{
				engfunc(EngFunc_EmitSound, id, channel, hacha_deploy, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
			if (equal(sample[14], "hit", 3))
			{
				if (sample[17] == 'w')
				{
					engfunc(EngFunc_EmitSound, id, channel, hacha_wall, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
				else
				{
					switch (random_num(1, 3))
					{
						case 1: engfunc(EngFunc_EmitSound, id, channel, hacha_hit1, volume, attn, flags, pitch)
							case 2: engfunc(EngFunc_EmitSound, id, channel, hacha_hit2, volume, attn, flags, pitch)
							case 3: engfunc(EngFunc_EmitSound, id, channel, hacha_hit3, volume, attn, flags, pitch)
						}
					
					return FMRES_SUPERCEDE;
				}
			}
			if (equal(sample[14], "sta", 3))
			{
				engfunc(EngFunc_EmitSound, id, channel, hacha_stab, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
		}
	}
	
	if(Machete[id])
	{
		if (equal(sample[8], "kni", 3))
		{
			if (equal(sample[14], "sla", 3))
			{
				switch (random_num(1, 2))
				{
					case 1: engfunc(EngFunc_EmitSound, id, channel, machete_slash1, volume, attn, flags, pitch)
						case 2: engfunc(EngFunc_EmitSound, id, channel, machete_slash2, volume, attn, flags, pitch)
					}
				return FMRES_SUPERCEDE;
			}
			if(equal(sample,"weapons/knife_deploy1.wav"))
			{
				engfunc(EngFunc_EmitSound, id, channel, machete_deploy, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
			if (equal(sample[14], "hit", 3))
			{
				if (sample[17] == 'w')
				{
					engfunc(EngFunc_EmitSound, id, channel, machete_wall, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
				else // hit
				{
					switch (random_num(1, 4))
					{
						case 1: engfunc(EngFunc_EmitSound, id, channel, machete_hit1, volume, attn, flags, pitch)
							case 2: engfunc(EngFunc_EmitSound, id, channel, machete_hit2, volume, attn, flags, pitch)
							case 3: engfunc(EngFunc_EmitSound, id, channel, machete_hit3, volume, attn, flags, pitch)
							case 4: engfunc(EngFunc_EmitSound, id, channel, machete_hit4, volume, attn, flags, pitch)
						}
					return FMRES_SUPERCEDE;
				}
			}
			if (equal(sample[14], "sta", 3))
			{
				engfunc(EngFunc_EmitSound, id, channel, machete_stab, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
		}
	}
	
	if(Motocierra[id])
	{
		
		if (equal(sample[8], "kni", 3))
		{
			if (equal(sample[14], "sla", 3))
			{
				engfunc(EngFunc_EmitSound, id, channel, motocierra_slash, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
			if(equal(sample,"weapons/knife_deploy1.wav"))
			{
				engfunc(EngFunc_EmitSound, id, channel, motocierra_deploy, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
			if (equal(sample[14], "hit", 3))
			{
				if (sample[17] == 'w')
				{
					engfunc(EngFunc_EmitSound, id, channel, motocierra_wall, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
				else
				{
					switch (random_num(1, 2))
					{
						case 1: engfunc(EngFunc_EmitSound, id, channel, motocierra_hit1, volume, attn, flags, pitch)
							case 2: engfunc(EngFunc_EmitSound, id, channel, motocierra_hit2, volume, attn, flags, pitch)
							
					}
					return FMRES_SUPERCEDE;
				}
			}
			if (equal(sample[14], "sta", 3))
			{
				engfunc(EngFunc_EmitSound, id, channel, motocierra_stab, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
		}
	}
	return FMRES_IGNORED;
}

public anamenu(id)
{
	new te,players[MAX_PLAYERS]; get_players(players,te,"acehi","TERRORIST");
	if(get_member(id,m_iTeam) != TEAM_TERRORIST) client_print_color(id,id,"^4[%s] - ^1Bu menuyu sadece mahkumlar kullanabilir.",tag);
	else if(!is_user_alive(id)) client_print_color(id,id,"^4[%s] - ^1Bu menuyu sadece yasayanlar kullanabilir.",tag);
		else if(te <= 0) client_print_color(id,id,"^4[%s] - ^1Sona tek mahkum kaldigi icin bu menuyu acamazsin!",tag);
		else {
		static Item[512],menu;
		
		formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yJailbreak Menu",tag)
		menu = menu_create(Item,"anamenu_devam")
		
		if(g_market[id] == 0){
			formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yBicak Menu \r[Kullandin]",tag)
			menu_additem(menu,Item,"1")
		}
		else
		{
			formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yBicak Menu",tag)
			menu_additem(menu,Item,"1")
		}
		formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yEnvanter Menu",tag)
		menu_additem(menu,Item,"2")
		
		formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yGorev Menu",tag)
		menu_additem(menu,Item,"3")
		
		formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yMeslek Menu",tag)
		menu_additem(menu,Item,"4")
		
		formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yBonus Menu \w[\rUser Dahil\w]",tag)
		menu_additem(menu, Item, "5")
		
		formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yKarakter Menu \w[\rYeni\w]",tag)
		menu_additem(menu, Item, "6")
		
		formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yBilgi - Islem Menu^n\dCebinizdeki TL: \r[ %i ]",tag,g_jbpacks[id])
		menu_additem(menu,Item,"7")
		
		menu_setprop(menu, MPROP_EXIT, MEXIT_ALL)
		menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" )
		menu_display(id,menu,0)
	}
	return PLUGIN_HANDLED;
}
public anamenu_devam(id,menu,item)
{
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
			Tienda1(id)
		}
		case 2:{
			arac_gerec(id)
		}
		case 3:{
			gorev_menu(id)
		}
		case 4:{
			_menu(id)
		}
		case 5:{
			odulmenu(id)
		}
		case 6:{
			mahkumkarakter(id)
		}
		case 7:{
			ayarla(id)
		}
	} 
	return PLUGIN_HANDLED;
}
public arac_gerec(id)
{
	static Item[128]
	
	formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yArac Gerec Menusu",tag)
	new Menu = menu_create(Item, "arac_devam")
	
	formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yT Shop",tag)
	menu_additem(Menu, Item, "1")
	formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yIsyan Menu",tag)
	menu_additem(Menu, Item, "2")
	formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yKumar Salonu",tag)
	menu_additem(Menu, Item, "3")
	formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yTl Transfer Menu",tag)
	menu_additem(Menu, Item, "5")
	formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yKasa Menu",tag)
	menu_additem(Menu, Item, "6")
	
	menu_setprop(Menu, MPROP_EXIT, MEXIT_ALL);
	menu_display(id, Menu, 0);
	
	return PLUGIN_HANDLED
}
public arac_devam(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new access,callback,data[6],iname[64]
	
	menu_item_getinfo(menu,item,access,data,5,iname,63,callback)
	
	new key = str_to_num(data)
	
	switch(key)
	{
		case 1 :
		{
			Tienda(id)
		}
		case 2 :
		{
			isyan_menu(id)
		}
		case 3 :
		{
			Kumar_Salonu(id)
		}
		case 4:{
			
		}
		case 5:{
			Kasa_Menu(id)
		}
		
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
public ayarla(id)
{
	static Item[128]
	
	formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yBilgi - Islem Menu",tag)
	new Menu = menu_create(Item, "ayarcek")
	
	formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yFPS Ayarlarini Uygula",tag)
	menu_additem(Menu, Item, "1")
	formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yMapin Adini Ogren",tag)
	menu_additem(Menu, Item, "2")
	formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yKill Cek",tag)
	menu_additem(Menu, Item, "3")
	formatex(Item, charsmax(Item),"\w[ \r%s \w] - \ySkorunu Sifirla",tag)
	menu_additem(Menu, Item, "4")
	formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yServer Hakkinda Bilgi Al",tag)
	menu_additem(Menu, Item, "5")
	
	menu_setprop(Menu, MPROP_EXIT, MEXIT_ALL);
	menu_display(id, Menu, 0);
}
public ayarcek(id,menu,item)
{
	if( item == MENU_EXIT )
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new data[6];menu_item_getinfo(menu,item,_,data,charsmax(data));
	new key = str_to_num(data);  
	switch(key)
	{
		case 1 :
		{
			fps(id)
		}
		case 2 :
		{
			console_cmd(id,"say currentmap")
		}
		case 3 :
		{
			user_kill(id)
		}
		case 4 :
		{
			client_cmd(id, "say /rs");
		}
		case 5 :
		{
			client_print_color(0,0, "^4[%s] : ^1Server Ip : ^3%s", tag,csip)
			client_print_color(0,0, "^4[%s] : ^1TS Ip : ^3%s", tag,tsip)
			client_print_color(0,0, "^4[%s] : ^1Facebook : ^3%s", tag,facebook)
			client_print_color(0,0, "^4[%s] : ^1Bol Komutculuk Ve Slotluk Icin ^3/Ts3 ^1Yaziniz.", tag)
		}
		case 6 :
		{
			g_jbpacks[id] += 3
			client_print_color(0,0, "^4[%s] : ^1Bol Komutculuk Ve Slotluk Icin ^3/Ts3 ^1Yaziniz.", tag)
			client_print_color(0,0, "^4[%s] : ^1Bol Komutculuk Ve Slotluk Icin ^3/Ts3 ^1Yaziniz.", tag)
			client_print_color(0,0, "^4[%s] : ^1Bol Komutculuk Ve Slotluk Icin ^3/Ts3 ^1Yaziniz.", tag)
			client_print_color(0,0, "^4[%s] : ^1Bol Komutculuk Ve Slotluk Icin ^3/Ts3 ^1Yaziniz.", tag)
		}
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
}

public fps(id)
{
	console_cmd(id,"fps_max 9999")
	console_cmd(id,"fps_modem 9999")
	console_cmd(id,"cl_cmdrate 151")
	console_cmd(id,"cl_showfps 1")
	console_cmd(id,"rate 25000")
	console_cmd(id,"cl_updaterate 151")
}
public isyan_menu(id)
{
	static Item[64];
	new Menu;
	formatex(Item,charsmax(Item),"\w[ \r%s \w] - \yIsyan Menu",tag)
	Menu = menu_create(Item,"isyan_zamani")
	
	formatex(Item,charsmax(Item),"\d100 HP \r[%d TL]",get_pcvar_num(hp))
	menu_additem(Menu,Item,"1")
	formatex(Item,charsmax(Item),"\dHasari 2ye Katla \r[%d TL]",get_pcvar_num(hasar))
	menu_additem(Menu,Item,"2")
	formatex(Item,charsmax(Item),"\dDeagle Kutu \r[%d TL]",get_pcvar_num(kutu_cost))
	menu_additem(Menu,Item,"3")
	formatex(Item,charsmax(Item),"\dElektirkleri Kes \r[%d TL]",get_pcvar_num(elektrik))
	menu_additem(Menu,Item,"4")
	formatex(Item,charsmax(Item),"\d20 Mermili Glock \r[%d TL]",get_pcvar_num(g_glock))
	menu_additem(Menu,Item,"5")
	if(gorev1[id] == 1)
	{
		formatex(Item,charsmax(Item),"\dGardiyanlari Dondur \r[%d TL]",get_pcvar_num(dondur))
		menu_additem(Menu,Item,"6")
	}
	if(gorev1[id] == 0)
	{
		formatex(Item,charsmax(Item),"\dGardiyanlari Dondur \r[%d TL] \w[\yGorevi Tamamla\w]",get_pcvar_num(dondur))
		menu_additem(Menu,Item,"6")
	}
	
	menu_setprop(Menu,MPROP_EXIT,MEXIT_ALL)
	menu_display(id,Menu,0)
	
}
public isyan_zamani(id,menu,item)
{
	if( item == MENU_EXIT )
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new access,callback,data[6],iname[64]
	
	menu_item_getinfo(menu,item,access,data,5,iname,63,callback)
	
	new canli = is_user_alive(id)
	new esya1 = get_pcvar_num(hp)
	new esya2 = get_pcvar_num(hasar)
	new esya4 = get_pcvar_num(kutu_cost)
	new esya5 = get_pcvar_num(elektrik)
	new esya7 = get_pcvar_num(g_glock)
	new esya9 = get_pcvar_num(dondur)
	
	new key = str_to_num(data);  
	switch(key)
	{
		case 1 :
		{
			if(g_jbpacks[id] >= esya1 && canli)
			{
				g_jbpacks[id] -= esya1
				jb_harca[id] += esya1
				esya_al[id] += 1
				set_entvar(id,var_health, Float:get_entvar(id,var_health) + 100.0);
				client_print_color(id,id,"^4%s : ^1Isyan Menuden ^3[100 HP] ^1satin aldin",tag)
			}
			else
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.Gereken  ^3[%d] ^1TL",tag,esya1)
				
			}
		}
		case 2 :
		{
			if(g_jbpacks[id] >= esya2 && canli)
			{
				g_jbpacks[id] -= esya2
				jb_harca[id] += esya2
				g_hasar[id] = true
				esya_al[id] += 1
				client_print_color(id,id,"^4%s : ^1Isyan Menuden ^3[Hasari 2ye Katla] ^1satin aldin",tag)
				
			}
			else
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.Gereken  ^3[%d] ^1TL",tag,esya2)
			}
		}
		case 3 :
		{
			if(g_jbpacks[id] >= esya4 && canli)
			{
				g_jbpacks[id] -= esya4
				jb_harca[id] += esya4
				esya_al[id] += 1
				set_task(2.0,"kutu",id)
			}
			else
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^3niz yok.Gereken  ^1[%d] ^3TL",tag,esya4)
			}
		}
		case 4 :
		{
			if(g_jbpacks[id] >= esya5 && canli)
			{
				g_jbpacks[id] -= esya5
				jb_harca[id] += esya5
				esya_al[id] += 1
				set_lights("a")
				set_task(6.0,"elektrikac")
				get_user_name(id,iname,63)
				client_print_color(id,id,"^4%s : ^1Hapishanenin isiklarini ^3[%s] ^1adli mahkum kapadi,",tag,iname)
			}
			else
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.Gereken  ^3[%d] ^1TL",tag,esya5)
			}
		}
		case 5 :
		{
			if(g_jbpacks[id] >= esya7 && canli)
			{
				g_jbpacks[id] -= esya7
				jb_harca[id] += esya7
				esya_al[id] += 1
				rg_give_item(id,"weapon_glock18")
				client_print_color(id,id,"^4%s : ^1Isyan Menuden ^3[20 Mermili Glock] ^3satin aldin",tag)
			}
			else
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.Gereken ^3[%d] ^1TL",tag,esya7)
			}
		}
		case 6 :
		{
			if(gorev1[id] == 1)
			{
				if(g_jbpacks[id] >= esya9 && canli)
				{
					g_jbpacks[id] -= esya9
					jb_harca[id] += esya9
					esya_al[id] += 1
					ctdondur()
					get_user_name(id,iname,63)
					client_print_color(id,id,"^4%s : ^1%s adli mahkum gardiyanlari 5 saniye boyunca dondurdu.",tag,iname)
					new players[32],inum,cid
					get_players(players,inum)
					for(new i;i<inum;i++)
					{
						cid = players[i]
						if(get_user_team(cid) == 2)
						{
							set_task(5.0,"ctcoz",cid)
						}
					}
				}
				else
				{
					client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.Gereken  ^3[%d] ^1TL",tag,esya9)
				}
			}
			else
			{
				client_print_color(id,id,"^4%s : ^1Once 5 gardiyan oldur gorevini tamamla.",tag)
			}
		}
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
rg_set_user_rendering(const index, fx = kRenderFxNone, {Float,_}:color[3] = {0.0,0.0,0.0}, render = kRenderNormal, Float:amount = 0.0)
{
set_entvar(index, var_renderfx, fx);
set_entvar(index, var_rendercolor, color);
set_entvar(index, var_rendermode, render);
set_entvar(index, var_renderamt, amount);
}
public ctdondur()
{
new players[32],inum,id
get_players(players,inum)
for(new i;i<inum;i++)
{
	id = players[i]
	if(get_user_team(id) == 2)
	{
		new iFlags = pev( id , pev_flags )
		if( ~iFlags & FL_FROZEN )
		{
			set_pev( id , pev_flags , iFlags | FL_FROZEN )
			pev( id , pev_v_angle , iAngles[ id ] )
			rg_set_user_rendering(id, kRenderFxGlowShell, {0.0,100.0,200.0}, kRenderNormal, 16.0);
			fwPreThink = register_forward( FM_PlayerPreThink , "fwPlayerPreThink" )
		}
	}
}
}
public ctcoz(id)
{
new frozenCount = 0;
g_frozen[id] = false
new iFlags = pev( id , pev_flags)
if(iFlags & FL_FROZEN)
{
	set_pev(id ,pev_flags ,iFlags & ~FL_FROZEN)
	rg_set_user_rendering(id, kRenderFxNone , {0.0,100.0,200.0}, kRenderNormal, 16.0);
	new iPlayers[ 32 ] , iNum , i , tid
	get_players( iPlayers , iNum , "a" )
	for( i = 0; i < iNum; i++ )
	{
		tid = iPlayers[ i ]
		if( g_frozen[ tid ] )
		{
			frozenCount++
		}
	}
	if( !frozenCount && fwPreThink ) unregister_forward( FM_PlayerPreThink , fwPreThink )
}
client_print_color(0,0,"^4%s : ^1Gardiyanlar cozuldu.",tag)
}
public odulmenu(const id){
if(odul_sinir[id]) client_print_color(id,id,"^4[%s] - ^1Odul menuyu zaten kullandin.",tag);
else {
	static Menuz[512];
	
	formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yBonus Menu",tag)
	new menu = menu_create(Menuz, "odulmenu_devam")
	
	formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yUser Bonusu \r[\w3 TL\r]",tag);
	menu_additem(menu, Menuz, "1", 0);
	
	formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \ySlot Bonusu",tag);
	menu_additem(menu, Menuz, "2", 0);
	
	formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yAdmin Bonusu",tag);
	menu_additem(menu, Menuz, "3", 0);
	
	formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yYonetici & Kurucu Bonusu",tag);
	menu_additem(menu, Menuz, "4", 0);
	
	formatex(Menuz, charsmax(Menuz), "\rCikis")
	menu_setprop(menu,MPROP_EXITNAME,Menuz)
	menu_display(id, menu);
}
}
public odulmenu_devam(const id, const menu, const item){
if(item == MENU_EXIT || odul_sinir[id] || !is_user_alive(id))
{
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
new data[6];menu_item_getinfo(menu,item,_,data,charsmax(data));
new key = str_to_num(data);  
switch(key)
{
	case 1: {
		g_jbpacks[id] += 3
		client_print_color(id,id,"^4[%s] - ^1Odulunu basarili bir sekilde aldin.",tag);
		odul_sinir[id] = true;
	}
	case 2: {
		if(get_user_flags(id) & ADMIN_RESERVATION) slotodul(id);
	}
	case 3: {
		if(get_user_flags(id) & ADMIN_KICK) adminodul(id);
	}
	case 4: {
		if(get_user_flags(id) & ADMIN_BAN) yoneticiodul(id);
	}
}
return PLUGIN_HANDLED;
}
public slotodul(const id){
static Menuz[512];

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \w[SLOT] \yOdul Menu",tag)
new menu = menu_create(Menuz, "slotodul_devam")

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \y+3 TL",tag);
menu_additem(menu, Menuz, "1", 0);

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yDusuk Yercekimi",tag);
menu_additem(menu, Menuz, "2", 0);

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yYuksek Hiz",tag);
menu_additem(menu, Menuz, "3", 0);

formatex(Menuz, charsmax(Menuz), "\rCikis")
menu_setprop(menu,MPROP_EXITNAME,Menuz)
menu_display(id, menu);
}
public slotodul_devam(const id, const menu, const item){
if(item == MENU_EXIT || odul_sinir[id] || !is_user_alive(id))
{
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
new data[6];menu_item_getinfo(menu,item,_,data,charsmax(data));
new key = str_to_num(data);  
switch(key)
{
	case 1: {
		g_jbpacks[id] += 3
		client_print_color(id,id,"^4[%s] - ^1Odulunu basarili bir sekilde aldin.",tag);
		odul_sinir[id] = true;
	}
	case 2: {
		set_entvar(id,var_gravity,0.5);
		client_print_color(id,id,"^4[%s] - ^1Odulunu basarili bir sekilde aldin.",tag);
		odul_sinir[id] = true;
	}
	case 3: {
		set_entvar(id,var_maxspeed,600.0);
		client_print_color(id,id,"^4[%s] - ^1Odulunu basarili bir sekilde aldin.",tag);
		odul_sinir[id] = true;
	}
}
return PLUGIN_HANDLED;
}
public adminodul(const id){
static Menuz[512];

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \w[ADMIN] \yOdul Menu",tag)
new menu = menu_create(Menuz, "adminodul_devam")

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \y+5 TL",tag);
menu_additem(menu, Menuz, "1", 0);

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yEl Bombasi",tag);
menu_additem(menu, Menuz, "2", 0);

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yFlash Bombasi",tag);
menu_additem(menu, Menuz, "3", 0);

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yYuksek Hiz",tag);
menu_additem(menu, Menuz, "4", 0);

formatex(Menuz, charsmax(Menuz), "\rCikis")
menu_setprop(menu,MPROP_EXITNAME,Menuz)
menu_display(id, menu);
}
public adminodul_devam(const id, const menu, const item){
if(item == MENU_EXIT || odul_sinir[id] || !is_user_alive(id))
{
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
new data[6];menu_item_getinfo(menu,item,_,data,charsmax(data));
new key = str_to_num(data);  
switch(key)
{
	case 1: {
		g_jbpacks[id] += 5
		client_print_color(id,id,"^4[%s] - ^1Odulunu basarili bir sekilde aldin.",tag);
		odul_sinir[id] = true;
	}
	case 2: {
		rg_give_item(id,"weapon_hegrenade");
		client_print_color(id,id,"^4[%s] - ^1Odulunu basarili bir sekilde aldin.",tag);
		odul_sinir[id] = true;
	}
	case 3: {
		rg_give_item(id,"weapon_flashbang");
		client_print_color(id,id,"^4[%s] - ^1Odulunu basarili bir sekilde aldin.",tag);
		odul_sinir[id] = true;
	}
	case 4: {
		set_entvar(id,var_maxspeed,600.0);
		client_print_color(id,id,"^4[%s] - ^1Odulunu basarili bir sekilde aldin.",tag);
		odul_sinir[id] = true;
	}
}
return PLUGIN_HANDLED;
}
public yoneticiodul(const id){
static Menuz[512];

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \w[YONETICI] \yOdul Menu",tag)
new menu = menu_create(Menuz, "yoneticiodul_devam")

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \y+8 TL",tag);
menu_additem(menu, Menuz, "1", 0);

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yBomba Seti",tag);
menu_additem(menu, Menuz, "2", 0);

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yDusuk Yer Cekimi",tag);
menu_additem(menu, Menuz, "3", 0);

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yHizli Yurume",tag);
menu_additem(menu, Menuz, "4", 0);

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yReklam At \r[9 TL]",tag);
menu_additem(menu, Menuz, "5", 0);

formatex(Menuz, charsmax(Menuz), "\rCikis")
menu_setprop(menu,MPROP_EXITNAME,Menuz)
menu_display(id, menu);
}
public yoneticiodul_devam(const id, const menu, const item){
if(item == MENU_EXIT || odul_sinir[id] || !is_user_alive(id))
{
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
new data[6];menu_item_getinfo(menu,item,_,data,charsmax(data));
new key = str_to_num(data);  
switch(key)
{
	case 1: {
		g_jbpacks[id] += 8
		client_print_color(id,id,"^4[%s] - ^1Odulunu basarili bir sekilde aldin.",tag);
		odul_sinir[id] = true;
	}
	case 2: {
		rg_give_item(id,"weapon_hegrenade");
		rg_give_item(id,"weapon_flashbang");
		client_print_color(id,id,"^4[%s] - ^1Odulunu basarili bir sekilde aldin.",tag);
		odul_sinir[id] = true;
	}
	case 3: {
		set_entvar(id,var_gravity,0.4);
		client_print_color(id,id,"^4[%s] - ^1Odulunu basarili bir sekilde aldin.",tag);
		odul_sinir[id] = true;
	}
	case 4: {
		set_entvar(id,var_maxspeed,600.0);
		client_print_color(id,id,"^4[%s] - ^1Odulunu basarili bir sekilde aldin.",tag);
		odul_sinir[id] = true;
	}
	case 5: {
		new isim[MAX_NAME_LENGTH];
		get_user_name(id,isim,charsmax(isim));
		g_jbpacks[id] += 9
		client_print_color(0,0,"^4[%s] - ^1Bol yetkili slotluk veya komutculuk icin ^4[/ts3] ^1adresimize baglanabilirsiniz.",isim);
		odul_sinir[id] = true;
	}
}
return PLUGIN_HANDLED;
}
public tltransfer(const id){
static Menuz[512];

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yTL Transfer",tag)
new menu = menu_create(Menuz, "tltransfer_devam")

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \y5 TL",tag)
menu_additem(menu, Menuz, "1", 0);

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \y10 TL",tag);
menu_additem(menu, Menuz, "2", 0);

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \y20 TL",tag);
menu_additem(menu, Menuz, "3", 0);

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \y50 TL",tag);
menu_additem(menu, Menuz, "4", 0);

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \y65 TL",tag);
menu_additem(menu, Menuz, "5", 0);

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \y80 TL",tag);
menu_additem(menu, Menuz, "6", 0);

formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \y100 TL",tag);
menu_additem(menu, Menuz, "7", 0);

formatex(Menuz, charsmax(Menuz), "\rCikis")
menu_setprop(menu,MPROP_EXITNAME,Menuz)
menu_display(id, menu);
}
public tltransfer_devam(const id, const menu, const item){
if(item == MENU_EXIT || !is_user_alive(id))
{
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
new data[6];menu_item_getinfo(menu,item,_,data,charsmax(data));
new key = str_to_num(data);  
switch(key)
{
	case 1: if(g_jbpacks[id] >= 5){
		tlsec[id]=1
	}
	case 2: if(g_jbpacks[id] >= 10){
		tlsec[id]=2
	}
	case 3: if(g_jbpacks[id] >= 20){
		tlsec[id]=3
	}
	case 4: if(g_jbpacks[id] >= 50){ 
		tlsec[id]=4
	}
	case 5: if(g_jbpacks[id] >= 65){
		tlsec[id]=5
	}
	case 6: if(g_jbpacks[id] >= 80){
		tlsec[id]=6
	}
	case 7: if(g_jbpacks[id] >= 100){
		tlsec[id]=7
	}
}
listele(id);
return PLUGIN_HANDLED;
}
public listele(const id)
{
if(tlsec[id] > 0) {
	new menu = menu_create("\rKime TL Gondermek Istersin ?","listele_devam");
	
	new name[32], num[6];
	new players[32], menuz[64], inum;
	static Uid;
	get_players(players, inum);
	for(new i; i<inum; i++)
	{
		Uid = players[i];
		name[0] = '^0';
		menuz[0] = '^0';
		
		num_to_str(Uid, num, charsmax(num));
		get_user_name(Uid, name, charsmax(name));
		formatex(menuz,charsmax(menuz), "\w%s",name);
		menu_additem(menu,menuz,num);
	}
	menu_display(id,menu);
}
else client_print_color(id,id,"^4%s : ^1Sectiginiz miktar kadar ^3TL'niz ^1Yok!",tag),tlsec[id] = 0;
return PLUGIN_HANDLED
}
public listele_devam(const id, const menu, const item){
if(item == MENU_EXIT || !is_user_alive(id))
{
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
new data[6], name[32], access, callback;
menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
isimcek[id] = str_to_num(data);
yolla(id);
menu_destroy(menu);
return PLUGIN_HANDLED;
}
public yolla(const id){
new isim[MAX_NAME_LENGTH],isim2[MAX_NAME_LENGTH]
new id2 = isimcek[id];
get_user_name(id, isim, charsmax(isim));
get_user_name(id2, isim2, charsmax(isim2));
switch(tlsec[id]){
	case 1: g_jbpacks[id2]+= 5,g_jbpacks[id]-=5,client_print_color(id2,id2,"^4%s : ^1Isimli Oyuncu Size ^3[5] TL ^1Gonderdi",isim),client_print_color(id,id,"^3Basarili Bir Sekilde ^4[%s] ^1Isimli Oyuncuya ^3[5] TL ^1Gonderdiniz.",isim2),tlsec[id] = 0,isimcek[id] = 0;
		case 2: g_jbpacks[id2]+= 10,g_jbpacks[id]-=10,client_print_color(id2,id2,"^4%s : ^1Isimli Oyuncu Size ^3[10] TL ^1Gonderdi",isim),client_print_color(id,id,"^3Basarili Bir Sekilde ^4[%s] ^1Isimli Oyuncuya ^3[10] TL ^1Gonderdiniz.",isim2),tlsec[id] = 0,isimcek[id] = 0;
			case 3: g_jbpacks[id2]+= 20,g_jbpacks[id]-=20,client_print_color(id2,id2,"^4%s : ^1Isimli Oyuncu Size ^3[20] TL ^1Gonderdi",isim),client_print_color(id,id,"^3Basarili Bir Sekilde ^4[%s] ^1Isimli Oyuncuya ^3[20] TL ^1Gonderdiniz.",isim2),tlsec[id] = 0,isimcek[id] = 0;
			case 4: g_jbpacks[id2]+= 50,g_jbpacks[id]-=50,client_print_color(id2,id2,"^4%s : ^1Isimli Oyuncu Size ^3[50] TL ^1Gonderdi",isim),client_print_color(id,id,"^3Basarili Bir Sekilde ^4[%s] ^1Isimli Oyuncuya ^3[50] TL ^1Gonderdiniz.",isim2),tlsec[id] = 0,isimcek[id] = 0;
			case 5: g_jbpacks[id2]+= 65,g_jbpacks[id]-=65,client_print_color(id2,id2,"^4%s : ^1Isimli Oyuncu Size ^3[65] TL ^1Gonderdi",isim),client_print_color(id,id,"^3Basarili Bir Sekilde ^4[%s] ^1Isimli Oyuncuya ^3[65] TL ^1Gonderdiniz.",isim2),tlsec[id] = 0,isimcek[id] = 0;
			case 6: g_jbpacks[id2]+= 80,g_jbpacks[id]-=85,client_print_color(id2,id2,"^4%s : ^1Isimli Oyuncu Size ^3[80] TL ^1Gonderdi",isim),client_print_color(id,id,"^3Basarili Bir Sekilde ^4[%s] ^1Isimli Oyuncuya ^3[80] TL ^1Gonderdiniz.",isim2),tlsec[id] = 0,isimcek[id] = 0;
			case 7: g_jbpacks[id2]+= 100,g_jbpacks[id]-=100,client_print_color(id2,id2,"^4%s : ^1Isimli Oyuncu Size ^3[100] TL ^1Gonderdi",isim),client_print_color(id,id,"^3Basarili Bir Sekilde ^4[%s] ^1Isimli Oyuncuya ^3[100] TL ^1Gonderdiniz.",isim2),tlsec[id] = 0,isimcek[id] = 0;
		}
}
public mahkum_revle(id)
{
	new ad[32],sznum[6]
	new menu = menu_create("\rBir Mahkum Revle","revive_devam")
	for(new i = 1;i<=get_maxplayers();i++)
		if(is_user_connected(i) && get_user_team(i) == 1 && !is_user_alive(i))
	{
		num_to_str(i,sznum,5)
		get_user_name(i,ad,31)
		menu_additem(menu,ad,sznum)
	}
	menu_display(id,menu, 0)
	return PLUGIN_HANDLED
}
public revive_devam(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new ad[32],callback,access,data[6]
	menu_item_getinfo(menu,item,access,data,5,ad,31,callback)
	new tid = str_to_num(data)
	get_user_name(tid,ad,31)
	rg_round_respawn(id);
	new adnm[33]
	get_user_name(id,adnm,32)
	client_print_color(0,0,"^4%s : ^1Adli Kisi ^4%s : ^1Adli Mahkumu Revledi",adnm,ad)
	return PLUGIN_HANDLED
}
public elektrikac(id)
{
	set_lights("#OFF")
	client_print_color(id,id,"^4%s : ^1Elektrik kesintisi sona erdi",tag)
}

stock in_array(needle, data[], size)
{
	for(new i = 0; i < size; i++)
	{
		if(data[i] == needle)
			return i
	}
	return -1
}
public gorev_menu(id)
{
	static Item[64],sure;
	new Menu;
	formatex(Item,charsmax(Item),"\w[ \r%s \w] - \yGorev Menu",tag)
	Menu = menu_create(Item,"odul_al")
	
	sure = get_user_time(id,1) / 60
	
	if(gardiyan_oldur[id] < 5)
	{
		formatex(Item,charsmax(Item),"\w[\r5\w] \dGardiyan Oldur \d[\r%d/5\d] \w[\y%d TL\w]",gardiyan_oldur[id],get_pcvar_num(gorev_odul1))
		menu_additem(Menu,Item,"1")
	}
	if(gardiyan_oldur[id] >= 5 && gorev1[id] == 0)
	{
		formatex(Item,charsmax(Item),"\rGorev Tamamlandi.\rOdulunu Almak icin \d[\y1'e\d] \gbas.")
		menu_additem(Menu,Item,"1")
	}
	if(gorev1[id] == 1)
	{
		formatex(Item,charsmax(Item),"\gGorev Tamamlandi.")
		menu_additem(Menu,Item,"1")
	}
	if(jb_harca[id] < 80)
	{
		formatex(Item,charsmax(Item),"\w[\r80\w] \dTL Harca.\d[\r%d/80\d] \w[\y%d TL\w]",jb_harca[id],get_pcvar_num(gorev_odul2))
		menu_additem(Menu,Item,"2")
	}
	if(jb_harca[id] >= 80 && gorev2[id] == 0)
	{
		formatex(Item,charsmax(Item),"\rGorev Tamamlandi.\rOdulunu Almak icin \d[\y2'e\d] \gbas.")
		menu_additem(Menu,Item,"2")
	}
	if(gorev2[id] == 1)
	{
		formatex(Item,charsmax(Item),"\gGorev Tamamlandi.")
		menu_additem(Menu,Item,"2")
	}
	if(mahkum_oldur[id] < 10)
	{
		formatex(Item,charsmax(Item),"\w[\r10\w] \dArkadasini oldur. \d[\r%d/10\d] \w[\y%d TL\w]",mahkum_oldur[id],get_pcvar_num(gorev_odul3))
		menu_additem(Menu,Item,"3")
	}
	if(mahkum_oldur[id] >= 10 && gorev3[id] == 0)
	{
		formatex(Item,charsmax(Item),"\rGorev Tamamlandi.\rOdulunu Almak icin \d[\y3'e\d] \gbas.")
		menu_additem(Menu,Item,"3")
	}
	if(gorev3[id] == 1)
	{
		formatex(Item,charsmax(Item),"\gGorev Tamamlandi.")
		menu_additem(Menu,Item,"3")
	}
	if(esya_al[id] < 12)
	{
		formatex(Item,charsmax(Item),"\dToplam \w[\r12\w] \dEsya Satin Al \d[\r%d/12\d] \w[\y%d TL\w]",esya_al[id],get_pcvar_num(gorev_odul4))
		menu_additem(Menu,Item,"4")
	}
	if(esya_al[id] >= 12 && gorev4[id] == 0)
	{
		formatex(Item,charsmax(Item),"\rGorev Tamamlandi.\rOdulunu Almak icin \d[\y4'e\d] \gbas.")
		menu_additem(Menu,Item,"4")
	}
	if(gorev4[id] == 1)
	{
		formatex(Item,charsmax(Item),"\gGorev Tamamlandi")
		menu_additem(Menu,Item,"4")
	}
	if(g_survive[id] < 8 )
	{
		formatex(Item,charsmax(Item),"\w[\r8\w] \dKez Hayatta Kal \d[\r%d/8\d] \w[\y%d TL\w]",g_survive[id],get_pcvar_num(gorev_odul5))
		menu_additem(Menu,Item,"5")
	}
	if(g_survive[id] >= 8 && gorev5[id] == 0)
	{
		formatex(Item,charsmax(Item),"\rGorev Tamamlandi.\rOdulunu Almak icin \d[\y5'e\d] \gbas.")
		menu_additem(Menu,Item,"5")
	}
	if(gorev5[id] == 1)
	{
		formatex(Item,charsmax(Item),"\gGorev Tamamlandi")
		menu_additem(Menu,Item,"5")
	}
	if(sure < 30 )
	{
		formatex(Item,charsmax(Item),"\w[\r30\w] \dDakika Swde Takil.\d[\r%d/30\d] \w[\y%d TL\w]",sure,get_pcvar_num(gorev_odul6))
		menu_additem(Menu,Item,"6")
	}
	if(sure >= 30 && gorev6[id] == 0)
	{
		formatex(Item,charsmax(Item),"\rGorev Tamamlandi.\rOdulunu Almak icin \d[\y6'e\d] \gbas.")
		menu_additem(Menu,Item,"6")
	}
	if(gorev6[id] == 1)
	{
		formatex(Item,charsmax(Item),"\gGorev Tamamlandi")
		menu_additem(Menu,Item,"6")
	}
	
	menu_setprop(Menu,MPROP_EXIT,MEXIT_ALL)
	menu_display(id,Menu,0)
	
	return PLUGIN_HANDLED
}
public odul_al(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new access,callback,data[6],iname[64];
	menu_item_getinfo(menu,item,access,data,5,iname,63,callback)
	
	new odul1 = get_pcvar_num(gorev_odul1)
	new odul2 = get_pcvar_num(gorev_odul2)
	new odul3 = get_pcvar_num(gorev_odul3)
	new odul4 = get_pcvar_num(gorev_odul4)
	new odul5 = get_pcvar_num(gorev_odul5)
	new odul6 = get_pcvar_num(gorev_odul6)
	
	switch(str_to_num(data))
	{
		case 1 :
		{
			if(gardiyan_oldur[id] < 5)
			{
				gorev_menu(id)
			}
			if(gardiyan_oldur[id] >= 5 && gorev1[id] == 0)
			{
				g_jbpacks[id] += odul1
				client_print_color(id,id,"^4%s : ^15 Gardiyan oldurdugun icin ^3[%d TL] ^1kazandin",tag,odul1)
				gorev1[id] = 1
			}
			if(gorev1[id] == 1)
			{
				gorev_menu(id)
			}
		}
		case 2 :
		{
			if(jb_harca[id] < 80)
			{
				gorev_menu(id)
			}
			if(jb_harca[id] >= 80 && gorev2[id] == 0)
			{
				g_jbpacks[id] += odul2
				client_print_color(id,id,"^4%s : ^1 80 TL harcadigin icin ^3[%d TL] ^1kazandin",tag,odul2)
				gorev2[id] = 1
			}
			if(gorev2[id] == 1)
			{
				gorev_menu(id)
			}
		}
		case 3 :
		{
			if(mahkum_oldur[id] < 10)
			{
				gorev_menu(id)
			}
			if(mahkum_oldur[id] >= 10 && gorev3[id] == 0)
			{
				g_jbpacks[id] += odul3
				client_print_color(id,id,"^4%s : ^1FF'de 10 Arkadasini vurdugun icin ^3[%d TL] ^1kazandin",tag,odul3)
				gorev3[id] = 1
			}
			if(gorev3[id] == 1)
			{
				gorev_menu(id)
			}
		}
		case 4 :
		{
			if(esya_al[id] < 12)
			{
				gorev_menu(id)
			}
			if(esya_al[id] >= 12 && gorev4[id] == 0)
			{
				g_jbpacks[id] += odul4
				client_print_color(id,id,"^4%s : ^1Toplam 12 Esya aldigin icin ^4[%d TL]  ^1kazandin",tag,odul4)
				gorev4[id] = 1
			}
			if(gorev4[id] == 1)
			{
				gorev_menu(id)
			}
		}
		case 5 :
		{
			if(g_survive[id] < 8 )
			{
				gorev_menu(id)
			}
			if(g_survive[id] >= 8 && gorev5[id] == 0)
			{
				g_jbpacks[id] += odul5
				client_print_color(id,id,"^4%s : ^1Toplam 8 kez hayatta kaldigin icin ^4[%d TL]  ^1kazandin",tag,odul5)
				gorev5[id] = 1
			}
			if(gorev5[id] == 1)
			{
				gorev_menu(id)
			}
		}
		case 6 :
		{
			static sure;
			sure = get_user_time(id,1) / 60
			if(sure < 30 )
			{
				gorev_menu(id)
			}
			if(sure >= 30 && gorev6[id] == 0)
			{
				g_jbpacks[id] += odul6
				client_print_color(id,id,"^4%s : ^1Toplam 30 dakika swde durdugun icin ^4[%d TL]  ^1kazandin",tag,odul6)
				gorev6[id] = 1
			}
			if(gorev6[id] == 1)
			{
				gorev_menu(id)
			}
		}
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
public _menu(id)
{
	if(select_meslek[id])
	{
		static Item[64];
		new Menu;
		
		formatex(Item,charsmax(Item),"\w[ \r%s \w] - \yMeslek Menu",tag)
		Menu = menu_create(Item,"_sec")
		
		formatex(Item,charsmax(Item),"\dRambo \y(\dDaha Az Hasar Alir\r)")
		menu_additem(Menu,Item,"1")
		
		formatex(Item,charsmax(Item),"\dAstronot \y(\dDaha Yuksege Ziplar\r)")
		menu_additem(Menu,Item,"2")
		formatex(Item,charsmax(Item),"\dMutant \y(\dHer 30 saniyede +5 hp kazanir.\r)")
		menu_additem(Menu,Item,"3")
		
		formatex(Item,charsmax(Item),"\dTL Hirsizi \y(\dHer 10 dkde 15 TL kazanir.\r)")
		menu_additem(Menu,Item,"4")
		
		formatex(Item,charsmax(Item),"\dTerminator \y(\r150 HP 150 ARMOR\d)")
		menu_additem(Menu,Item,"5")
		
		menu_setprop(Menu,MPROP_EXIT,MEXIT_ALL)
		menu_display(id,Menu,0)
	}
	else{
		client_print_color(id,id,"^4%s : ^1Her elde 1 kere  degisebilirsin,",tag)
	}
	return PLUGIN_HANDLED;
}
public _sec(id,menu,item){
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new access,callback,data[6],iname[64];
	menu_item_getinfo(menu,item,access,data,5,iname,63,callback)
	
	switch(str_to_num(data))
	{
		case 1 :
		{
			if(meslek[id] == 1)
			{
				client_print_color(id,id,"^4%s : ^1Zaten mesleginiz ^3[Rambo]",tag)
				return PLUGIN_HANDLED
			}
			if(meslek[id] == 4) remove_task(id+600)
			if(meslek[id] == 3) remove_task(id+513)
			select_meslek[id] = false
			meslek[id] = 1
			set_entvar(id, var_gravity, 0.8);
			client_print_color(id,id,"^4%s : ^1Rambo meslegini sectin",tag)
		}
		case 2 :
		{
			if(meslek[id] == 2)
			{
				client_print_color(id,id,"^4%s : ^1Zaten mesleginiz ^3[Astronot.]",tag)
				return PLUGIN_HANDLED
			}
			if(meslek[id] == 4) remove_task(id+600)
			if(meslek[id] == 3) remove_task(id+513)
			select_meslek[id] = false
			meslek[id] = 2
			set_entvar(id, var_gravity, 0.65);
			client_print_color(id,id,"^4%s : ^1Astronot meslegini sectin",tag)
		}
		case 3 :
		{
			if(meslek[id] == 3)
			{
				client_print_color(id,id,"^4%s : ^1Zaten mesleginiz ^3[Mutant]",tag)
				return PLUGIN_HANDLED
			}
			if(meslek[id] == 4) remove_task(id+600)
			select_meslek[id] = false
			meslek[id] = 3
			set_entvar(id, var_gravity, 0.8);
			client_print_color(id,id,"^4%s : ^1Mutant meslegini sectin",tag)
			set_task(30.0,"hpver",id+513,_,_,"b")
		}
		case 4 :
		{
			if(meslek[id] == 4)
			{
				client_print_color(id,id,"^4%s : ^1Zaten mesleginiz ^3[TL Hirsizi.]",tag)
				return PLUGIN_HANDLED
			}
			if(meslek[id] == 3) remove_task(id+513)
			select_meslek[id] = false
			meslek[id] = 4
			set_task(600.0,"GiveJB2",id+600,_,_,"b")
			set_entvar(id, var_gravity, 0.8);
			client_print_color(id,id,"^4%s : ^1TL Hirsizi meslegini sectin",tag)
		}
		case 5 :
		{
			if(m_terminator[id])
			{
				client_print_color(id,id,"^4%s : ^1Zaten mesleginiz ^3[Terminator.]",tag)
				return PLUGIN_HANDLED
			}
			if(meslek[id] == 3) remove_task(id+513)
			if(meslek[id] == 4) remove_task(id+600)
			select_meslek[id] = false
			m_terminator[id] = true;
			set_entvar(id,var_health, 150.0);
			set_entvar(id,var_armorvalue, 150.0);
			client_print_color(id,id,"^4%s : ^1Terminator meslegini sectin",tag)
		}
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
public GiveJB2(taskid)
{
	new id = taskid - 600;
	g_jbpacks[id] += 10
	client_print_color(id,id,"^4%s : ^1 10 Dakikadir sunucuda oldugun icin 10 TL kazandin",tag)
}
public hpver(taskid)
{
	new id = taskid - 513
	if(is_user_alive(id))
	{
		set_entvar(id,var_health, Float:get_entvar(id,var_health) + 5.0);
	}
}

public Kasa_Menu(id) {
	if(is_user_alive(id))
	{
		static Item[128]
		
		formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yKasa Menu",tag)
		new Menu = menu_create(Item, "Kasa_Menu_devam")
		
		formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yBronz Kasa \r(\yBomba \d- \yCan \r) \y[20 TL]",tag)
		menu_additem(Menu, Item, "1")
		
		formatex(Item, charsmax(Item),"\w[ \r%s \w] - \ySilver Kasa \r(\ySilahlar\r) \y[50 TL]",tag)
		menu_additem(Menu, Item, "2")
		
		formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yGolden Kasa \r(\yAwp \d- \yScout\r) \y[85 TL]",tag)
		menu_additem(Menu, Item, "3")
		
		formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yDiamond Kasa \r(\y3/1\r) \r(\yAwp + Bomba\r) \y[150 TL]",tag)
		menu_additem(Menu, Item, "4")
		
		
		menu_setprop(Menu, MPROP_EXIT, MEXIT_ALL);
		menu_display(id, Menu, 0);
	}
	return PLUGIN_HANDLED
}

public Kasa_Menu_devam(id,menu,item) {
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new data[6];menu_item_getinfo(menu,item,_,data,charsmax(data));
	new key = str_to_num(data);  
	switch(key)
	{ 
		case 1:
		{
			if(g_jbpacks[id] >= 20)
			{
				g_jbpacks[id] -= 20
				set_task(7.0,"Bronz_Kasa",id)
			}
			else
			{
				set_task(0.1,"olumsuz_ses",id)
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.",tag)
			} 
		} 
		case 2:
		{
			if(g_jbpacks[id] >= 50)
			{
				g_jbpacks[id] -= 50
				set_task(7.0,"Silver_Kasa",id)
			}
			else
			{
				set_task(0.1,"olumsuz_ses",id)
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.",tag)
			} 
		} 
		case 3:
		{
			if(g_jbpacks[id] >= 85)
			{
				g_jbpacks[id] -= 85
				set_task(7.0,"Golden_Kasa",id)
			}
			else
			{
				set_task(0.1,"olumsuz_ses",id)
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.",tag)
			} 
		} 
		case 4:
		{
			if(g_jbpacks[id] >= 150)
			{
				g_jbpacks[id] -= 150
				set_task(7.0,"Diamond_Kasa",id)
			}
			else
			{
				set_task(0.1,"olumsuz_ses",id)
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]' ^1niz yok.",tag)
			} 
		}
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
}

public Bronz_Kasa( id )
{
	switch(random_num(0,10))
	{
		case 0:{
			client_print_color(id,id,"^4%s : ^1Malesef ^3[Bronz] ^1 Kasa'dan ^3Bisey Cikmadi",tag)
		}
		case 1:{
			set_entvar(id,var_health, Float:get_entvar(id,var_health) + 100.0);
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Bronz] ^1 Kasa'dan ^3+100 HP ^1Cikti ! !",tag)
		}
		case 2:{
			client_print_color(id,id,"^4%s : ^1Malesef ^3[Bronz] ^1 Kasa'dan ^3Bisey Cikmadi",tag)
		}
		case 3:{
			set_entvar(id,var_health, Float:get_entvar(id,var_health) + 150.0);
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Bronz] ^1 !gKasa'dan^3 +150 HP ^1Cikti ! !",tag)
		}
		case 4:{
			client_print_color(id,id,"^4%s : ^1Malesef ^3[Bronz] ^1 Kasa'dan ^3Bisey Cikmadi",tag)
		}
		case 5:{
			rg_give_item(id,"weapon_hegrenade")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Bronz] ^1 !gKasa'dan !t1 Adet BomBa ^1Cikti ! !",tag)
		}
		case 6:{
			set_entvar(id,var_health, Float:get_entvar(id,var_health) + 200.0);
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Bronz] ^1 Kasa'dan^3 +200 HP ^1Cikti ! !",tag)
		}
		case 7:{
			client_print_color(id,id,"^4%s : ^1Malesef ^3[Bronz] ^1 Kasa'dan ^3Bisey Cikmadi",tag)
		}
		case 8:{
			rg_give_item(id,"weapon_flashbang")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Bronz] ^1 Kasa'dan^3 1 Adet Flash ^1Cikti ! !",tag)
		}
		case 9:{
			rg_give_item(id,"weapon_smokegrenade")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Bronz] ^1 Kasa'dan^3 1 Adet SIS ^1Cikti ! !",tag)
		}
		case 10:{
			rg_give_item(id,"weapon_hegrenade")
			rg_give_item(id,"weapon_smokegrenade")
			rg_give_item(id,"weapon_flashbang")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Bronz] ^1 Kasa'dan^3 3 Adet BomBa ^1Cikti ! !",tag)
		}
	}
	return PLUGIN_HANDLED;
}

public Silver_Kasa( id )
{
	switch(random_num(0,11))
	{
		case 0: {
			client_print_color(id,id,"^4%s : ^1Malesef ^3[Silver] ^1 Kasa'dan ^1Bisey Cikmadi",tag)
		}
		case 1: {
			rg_give_item(id,"weapon_glock18")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Silver] ^1 Kasa'dan ^3Glock ^1Cikti ! !",tag)
		}
		case 2: {
			rg_give_item(id,"weapon_usp")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Silver] ^1 Kasa'dan ^3USP ^1Cikti ! !",tag)
		}
		case 3: {
			rg_give_item(id,"weapon_deagle")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Silver] ^1Kasa'dan ^3Deagle ^1Cikti ! !",tag)
		}
		case 4: {
			rg_give_item(id,"weapon_glock18")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Silver] ^1Kasa'dan ^3Glock ^1Cikti ! !",tag)
		}
		case 5: {
			client_print_color(id,id,"^4%s : ^1Malesef ^3[Silver] ^1 Kasa'dan ^3Bisey Cikmadi",tag)
		}
		case 6: {
			rg_give_item(id,"weapon_ak47")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Silver] ^1Kasa'dan ^3AK47 ^1Cikti ! !",tag)
		}
		case 7: {
			rg_give_item(id,"weapon_glock18")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Silver] ^1Kasa'dan ^3Glock ^1Cikti ! !",tag)
		}
		case 8: {
			client_print_color(id,id,"^4%s : ^1Malesef ^3[Silver] ^1 Kasa'dan ^3Bisey Cikmadi",tag)
		}
		case 9: {
			rg_give_item(id,"weapon_m4a1")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Silver] ^1Kasa'dan ^3M4A1 ^1Cikti ! !",tag)
		}
		case 10: {
			rg_give_item(id,"weapon_glock18")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Silver] ^1Kasa'dan ^3Glock ^1Cikti ! !",tag)
		}
		case 11: {
			rg_give_item(id,"weapon_mp5navy")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Silver] ^1Kasa'dan ^3MP5 ^1Cikti ! !",tag)
		}
	}
	return PLUGIN_HANDLED;
}

public Golden_Kasa( id )
{
	switch(random_num(0,4))
	{
		case 0: {
			client_print_color(id,id,"^4%s : ^1Malesef ^3[Golden] ^1Kasa'dan ^3Bisey Cikmadi",tag)
		}
		case 1: {
			rg_give_item(id,"weapon_scout")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Golden] ^1Kasa'dan ^3Scout ^1Cikti ! !",tag)
		}
		case 2: {
			client_print_color(id,id,"^4%s : ^1Malesef ^3[Golden] ^1Kasa'dan ^3Bisey Cikmadi",tag)
		}
		case 3: {
			rg_give_item(id,"weapon_scout")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Golden] ^1Kasa'dan ^3Scout ^1Cikti ! !",tag)
		}
		case 4: {
			rg_give_item(id,"weapon_awp")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Golden] ^1Kasa'dan ^3AWP ^1Cikti ! !",tag)
		}
	}
	return PLUGIN_HANDLED;
}

public Diamond_Kasa( id )
{
	switch(random_num(0,2))
	{
		case 0: {
			client_print_color(id,id,"^4%s : ^1Malesef ^3[Diamond] ^1Kasa'dan ^3Bisey Cikmadi",tag)
		}
		case 1: {
			rg_give_item(id,"weapon_hegrenade")
			rg_give_item(id,"weapon_awp")
			client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[Diamond] ^1Kasa'dan ^3AWP ve Bomba ^1Cikti ! !",tag)
		}
		case 2: {
			client_print_color(id,id,"^4%s : ^1Malesef ^3[Diamond] ^1Kasa'dan ^3Bisey Cikmadi",tag)
		}
	}
	return PLUGIN_HANDLED;
}

public Kumar_Salonu(id) {
	if(is_user_alive(id) && kumar_engel[ id ] == 0) {
		static Item[128]
		
		formatex(Item, charsmax(Item),"\w[ \r%s \w] - \yKumar Salonu",tag)
		new Menu = menu_create(Item, "Kumar_Salonu_devam")
		
		formatex(Item, charsmax(Item),"\dTL'ni \w2'ye Katla")
		menu_additem(Menu, Item, "1")
		
		menu_setprop(Menu, MPROP_EXIT, MEXIT_ALL);
		menu_display(id, Menu, 0);
	}
	else
	{
		client_print_color(id,id,"^4%s : ^1Kumar Salonuna Her El Bir defa Girebilirsin",tag)
		set_task(0.1,"olumsuz_ses",id)
		anamenu(id)
	}
	return PLUGIN_HANDLED
}
public Kumar_Salonu_devam(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new data[6];menu_item_getinfo(menu,item,_,data,charsmax(data));
	new key = str_to_num(data);  
	switch(key)
	{
		case 1 : {
			tl_yi_katla(id) 
		}
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
public tl_yi_katla(id)
{
	if (is_user_alive(id)) { 
		
		static Item[64];
		new Menu;
		formatex(Item,charsmax(Item),"\w[ \r%s \w] - \yNekadar Yatirmak Istiyorsun \r?",tag)
		Menu = menu_create(Item,"tl_yi_katla_devam")
		
		formatex(Item,charsmax(Item),"\d5 \yTL")
		menu_additem(Menu,Item,"1")
		formatex(Item,charsmax(Item),"\d10 \yTL")
		menu_additem(Menu,Item,"2")
		formatex(Item,charsmax(Item),"\d15 \yTL")
		menu_additem(Menu,Item,"3")
		formatex(Item,charsmax(Item),"\d20 \yTL")
		menu_additem(Menu,Item,"4")
		formatex(Item,charsmax(Item),"\d30 \yTL")
		menu_additem(Menu,Item,"5")
		formatex(Item,charsmax(Item),"\d40 \yTL")
		menu_additem(Menu,Item,"6")
		formatex(Item,charsmax(Item),"\d50 \yTL")
		menu_additem(Menu,Item,"7")
		
		
		formatex(Item,charsmax(Item),"\yCikis")
		menu_additem(Menu,Item,"0")
		
		
		
		menu_setprop( Menu, MPROP_PERPAGE, 0 );
		menu_setprop(Menu,MPROP_EXITNAME,Item)
		menu_display(id,Menu,0)
	}
	return PLUGIN_HANDLED
}
public tl_yi_katla_devam(id, menu, item)
{
	if( item == MENU_EXIT )
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new data[6];menu_item_getinfo(menu,item,_,data,charsmax(data));
	new key = str_to_num(data);  
	new adminismi[32]
	get_user_name(id,adminismi,31)
	
	switch(key)
	{
		case 1: {
			if(g_jbpacks[id] < 5 )
			{
				client_print_color(id,id,"!t[!t%s] !nYeterli ^3[TL]  ^1'niz Yok.",tag)
				set_task(0.1,"olumsuz_ses",id)
				return PLUGIN_HANDLED;
			}
			g_jbpacks[id] -= 5
			kumar_engel[ id ] = 1
			switch(random_num(0,2))
			{
				case 0 : {
					g_jbpacks[id] += 10
					client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[10 TL] ^1Kazandin ! !",tag)
				}
				case 1 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
				case 2 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
			}
			return PLUGIN_HANDLED;
		}
		case 2: {
			if(g_jbpacks[id] < 10 )
			{
				client_print_color(id,id,"!t[!g %s !t] !nYeterli ^3[TL]  ^1'niz Yok.",tag)
				set_task(0.1,"olumsuz_ses",id)
				return PLUGIN_HANDLED;
			}
			g_jbpacks[id] -= 10
			kumar_engel[ id ] = 1
			switch(random_num(0,2))
			{
				case 0 : {
					g_jbpacks[id] += 20
					client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[10 TL] ^1Kazandin ! !",tag)
				}
				case 1 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
				case 2 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
			}
			return PLUGIN_HANDLED;
		}
		case 3: {
			if(g_jbpacks[id] < 15 )
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]  ^1'niz Yok.",tag)
				set_task(0.1,"olumsuz_ses",id)
				return PLUGIN_HANDLED;
			}
			g_jbpacks[id] -= 15
			kumar_engel[ id ] = 1
			switch(random_num(0,2))
			{
				case 0 : {
					g_jbpacks[id] += 30
					client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[30 TL] ^1Kazandin ! !",tag)
				}
				case 1 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
				case 2 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
			}
			return PLUGIN_HANDLED;
		}
		case 4: {
			if(g_jbpacks[id] < 20 )
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]  ^1'niz Yok.",tag)
				set_task(0.1,"olumsuz_ses",id)
				return PLUGIN_HANDLED;
			}
			g_jbpacks[id] -= 20
			kumar_engel[ id ] = 1
			switch(random_num(0,2))
			{
				case 0 : {
					g_jbpacks[id] += 40
					client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[40 TL] ^1Kazandin ! !",tag)
				}
				case 1 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
				case 2 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
			}
			return PLUGIN_HANDLED;
		}
		case 5: {
			if(g_jbpacks[id] < 30 )
			{
				client_print_color(id,id,"!t[!t%s] !nYeterli ^3[TL]  ^1'niz Yok.",tag)
				set_task(0.1,"olumsuz_ses",id)
				return PLUGIN_HANDLED;
			}
			g_jbpacks[id] -= 30
			kumar_engel[ id ] = 1
			switch(random_num(0,3))
			{
				case 0 : {
					g_jbpacks[id] += 60
					client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[60 TL] ^1Kazandin ! !",tag)
				}
				case 1 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
				case 2 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
				case 3 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
			}
			return PLUGIN_HANDLED;
		}
		case 6: {
			if(g_jbpacks[id] < 40 )
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]  ^1'niz Yok.",tag)
				set_task(0.1,"olumsuz_ses",id)
				return PLUGIN_HANDLED;
			}
			g_jbpacks[id] -= 40
			kumar_engel[ id ] = 1
			switch(random_num(0,3))
			{
				case 0 : {
					g_jbpacks[id] += 80
					client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[80 TL] ^1Kazandin ! !",tag)
				}
				case 1 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
				case 2 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
				case 3 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
			}
			return PLUGIN_HANDLED;
		}
		case 7: {
			if(g_jbpacks[id] < 50 )
			{
				client_print_color(id,id,"^4%s : ^1Yeterli ^3[TL]  ^1'niz Yok.",tag)
				set_task(0.1,"olumsuz_ses",id)
				return PLUGIN_HANDLED;
			}
			g_jbpacks[id] -= 50
			kumar_engel[ id ] = 1
			switch(random_num(0,3))
			{
				case 0 : {
					g_jbpacks[id] += 100
					client_print_color(id,id,"^4%s : ^1Tebrikler! ^3[100 TL] ^1Kazandin ! !",tag)
				}
				case 1 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
				case 2 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
				case 3 : {
					client_print_color(id,id,"^4%s : ^1Malesef ^3Kaybettin",tag)
				}
			}
			return PLUGIN_HANDLED;
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public mahkumkarakter(id){
		new menu, Menuz[128]
		
		formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yMahkum Ozel Model Menu",tag)
		menu = menu_create(Menuz, "model_handler")
		
		formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yAssasin Model",tag)
		menu_additem(menu, Menuz, "1", 0)
		
		formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yCJ Model",tag)
		menu_additem(menu, Menuz, "2", 0)	
		
		formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yMatrix Model",tag)
		menu_additem(menu, Menuz, "3", 0)
		
		formatex(Menuz, charsmax(Menuz), "\w[ \r%s \w] - \yTrololo Model \w[\rYeni\w]",tag)
		menu_additem(menu, Menuz, "4", 0)
		
		formatex(Menuz, charsmax(Menuz), "\rCikis")
		menu_setprop(menu,MPROP_EXITNAME,Menuz)
		
		menu_setprop(menu,MPROP_EXIT, MEXIT_ALL)
		menu_display(id, menu, 0)
}
public model_handler(id,menu,item){
	new data[6];menu_item_getinfo(menu,item,_,data,charsmax(data));
	new key = str_to_num(data);  
	switch(key){
		case 1: rg_set_user_model(id,"assasin"),client_print_color(id,id,"^4%s : ^1Model basariyla aktiflestirildi.",tag);
			case 2: rg_set_user_model(id,"cj"),client_print_color(id,id,"^4%s : ^1Model basariyla aktiflestirildi.",tag);
			case 3: rg_set_user_model(id,"Matrix"),client_print_color(id,id,"^4%s : ^1Model basariyla aktiflestirildi.",tag);
			case 4: rg_set_user_model(id,"trololo"),client_print_color(id,id,"^4%s : ^1Model basariyla aktiflestirildi.",tag);
		}
}
/*============================================================
Stocks!
============================================================*/

