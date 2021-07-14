#pragma semicolon 1

#include <amxmodx>
#include <fakemeta>
#include <reapi>

native set_lights(const Lighting[]);

/* Gorev yapinca spr gostermesini istiyorsaniz ellemeyin.Istemiyorsaniz basina // koyun  */

#define Sprgoster

/* Bu Kismi Kendinize gore duzenleyin */

enum _:defineler {
	tag,
	ts3ip,
	serverip
};
new const g_szdefines[defineler][] = {
	"CSDuragi",
	"Ts3.Csduragi.Com",
	"Cs00.Csduragi.Com"
};

/* Burasi yetki kisimlarini kendinize gore ayralayin */

new slotbonus = ADMIN_RESERVATION,adminbonus = ADMIN_MAP,yoneticibonus = ADMIN_RCON,isyanteam_baskan = ADMIN_RCON,isyanteam_uye = ADMIN_RESERVATION;

/* Burasi anamodel dosyalari ellemeyin */

enum _:Modeller {
	VIEW_MODELT, PLAYER_MODELT,
	VIEW_MODELCT, PLAYER_MODELCT,
	VIEW_MOTO, PLAYER_MOTO,
	PLAYER_DEFK
};
new const g_szModels[][] = {
	"models/[Shop]JailBreak/Punos/Punos.mdl",
	"models/[Shop]JailBreak/Punos/Punos2.mdl",
	"models/[Shop]JailBreak/Electro/Electro.mdl",
	"models/[Shop]JailBreak/Electro/Electro2.mdl",
	"models/[Shop]JailBreak/Moto/Moto.mdl",
	"models/[Shop]JailBreak/Moto/Moto2.mdl",
	"models/p_knife.mdl" 
};

/* Burdan Bicak Modelleri degistirebilirsiniz */

new bicakmodel[][][]={
	{"Pompa","models/[Shop]JailBreak/Palo/Palo.mdl"},
	{"Ursus Knife","models/bilalgecer47/v_ursus_crimson.mdl"},
	{"Karambit","models/bilalgecer47/v_karambit_auto.mdl"},
	{"Kelebek","models/bilalgecer47/v_butterfly_marble.mdl"}
	/* Ornek Bicak ekleme{"Menudeki ismi","Bicak Model Yolu"}*/
};

/* Burasi ses dosyalari ellemeyin */

enum _:Sesler {
	HG_SES,NOCLIP,ADAM_OLDU,GOREV_SES,BASKIN_SES,KASA_AC,KASA_DOLU,KASA_BOS,SI,NO,
	MOTO_DEPLOY,MOTO_SLASH,MOTO_WALL,MOTO_HIT1,MOTO_HIT2,MOTO_STAB,
	T_DEPLOY,T_SLASH1,T_WALL,T_HIT1,T_HIT2,T_HIT3,T_HIT4,T_STAB,
	MAC_DEPLOY,MAC_SLASH1,MAC_WALL,MAC_HIT1,MAC_HIT2,MAC_STAB,
	CT_DEPLOY,CT_SLASH1,CT_WALL,CT_HIT1,CT_HIT2,CT_HIT3,CT_HIT4,CT_STAB
};

new const g_szSounds[][] = {
	"bilalgecer47/hgadam.wav",
	"bilalgecer47/noclip.wav",
	"bilalgecer47/adam_oldu.wav",
	"bilalgecer47/gorev_ses.wav",
	"bilalgecer47/baskin_ses.wav",
	"bilalgecer47/kutu_acilis.wav",
	"bilalgecer47/kutu_dolu.wav",
	"bilalgecer47/kutu_bos.wav",
	"[Shop]JailBreak/Yes.wav",
	"[Shop]JailBreak/No.wav",
	"[Shop]JailBreak/Moto/MTConvoca.wav",
	"[Shop]JailBreak/Moto/MTSlash.wav",
	"[Shop]JailBreak/Moto/MTHitWall.wav",
	"[Shop]JailBreak/Moto/MTHit1.wav",
	"[Shop]JailBreak/Moto/MTHit2.wav",
	"[Shop]JailBreak/Moto/MTStab.wav",
	"[Shop]JailBreak/T/TConvoca.wav",
	"[Shop]JailBreak/T/Slash1.wav",
	"[Shop]JailBreak/T/THitWall.wav",
	"[Shop]JailBreak/T/THit1.wav",
	"[Shop]JailBreak/T/THit2.wav",
	"[Shop]JailBreak/T/THit3.wav",
	"[Shop]JailBreak/T/THit4.wav",
	"[Shop]JailBreak/T/TStab.wav",
	"[Shop]JailBreak/Machete/MConvoca.wav",
	"[Shop]JailBreak/Machete/MSlash1.wav",
	"[Shop]JailBreak/Machete/MHitWall.wav",
	"[Shop]JailBreak/Machete/MHit1.wav",
	"[Shop]JailBreak/Machete/MHit2.wav",
	"[Shop]JailBreak/Machete/MStab.wav",
	"[Shop]JailBreak/CT/CTConvoca.wav",
	"[Shop]JailBreak/CT/Slash1.wav",
	"[Shop]JailBreak/CT/CTHitWall.wav",
	"[Shop]JailBreak/CT/CTHit1.wav",
	"[Shop]JailBreak/CT/CTHit2.wav",
	"[Shop]JailBreak/CT/CTHit3.wav",
	"[Shop]JailBreak/CT/CTHit4.wav",
	"[Shop]JailBreak/CT/CTStab.wav"
};
/* Variables Ellemeyin */
enum _:bool{
	marketsinir,
	pala,
	testere,
	reklam,
	bonus,
	isyanteamsinir,
	meslekengel,
	gctsinir,
	gbicaksinir,
	gbombasinir,
	gts3sinir,
	baskinsinir,
	unammo
};
enum _:normal{
	para,
	meslek,
	ct_kill,
	alinanbomba,
	alinan_bicak,
	tlsec,
	isimcek,
	gorunum
};
new bool:g_bool[MAX_CLIENTS+1][bool],g_normal[MAX_CLIENTS+1][normal],mapcek[32],Float:g_flcvars[9],g_cvars[24],synchud,bool:isyantkontrol;
#if defined Sprgoster
new pMsgIds[4],bool:g_PlayerRankedUp[MAX_CLIENTS+1];
#endif

/* Plugin init Kismi */

public plugin_init() {
	
	register_plugin("[Reapi]JBM_enu", "0.2", "BİLΛL YILMΛZ");
	
	new const menuclcmd[][]={
		"say /jbmenu","say .jbmenu","say jbmenu","say /jbm","say /csg","say /bbmenu"
	};
	new const sifirlaclcmd[][]={
		"say /reset","say /rs","say !reset","say !rs","say .reset","say .rs"
	};
	new const oldurclcmd[][]={
		"say /kill","say .kill","say /k"
	};
	for(new i;i<sizeof(menuclcmd);i++){
		register_clcmd(menuclcmd[i],"@anamenu");
	}
	for(new i;i<sizeof(oldurclcmd);i++){
		register_clcmd(oldurclcmd[i],"@oldurmek");
	}
	for(new i;i<sizeof(sifirlaclcmd);i++){
		register_clcmd(sifirlaclcmd[i],"@skorla");
	}
	register_clcmd("nightvision","@anamenu");
	register_clcmd("say /mg", "@mg");
	register_clcmd("say /tl", "@mg");
	register_clcmd("TL_MIKTARI","@TL_devam");
	
	RegisterHookChain(RG_CBasePlayer_Killed, "@CBasePlayer_Killed_Post", .post = true);
	RegisterHookChain(RG_CBasePlayer_TakeDamage, "@CBasePlayer_TakeDamage_Pre", .post = false);
	RegisterHookChain(RG_CBasePlayer_Spawn, "@CBasePlayer_Spawn_Post", .post = true);
	RegisterHookChain(RG_CSGameRules_RestartRound, "@CSGameRules_RestartRound_Pre", .post = false);
	RegisterHookChain(RG_CBasePlayerWeapon_DefaultDeploy, "@CBasePlayerWeapon_DefaultDeploy", .post = false);
	register_event("CurWeapon", "@UnammoVerici", "be", "1=1", "3=1");
	
	register_forward(FM_EmitSound, "@EmitSound_Pre", ._post = false);
	
	#if defined Sprgoster
	pMsgIds[0] = get_user_msgid("WeaponList");
	pMsgIds[1] = get_user_msgid("SetFOV");
	pMsgIds[2] = get_user_msgid("CurWeapon");
	pMsgIds[3] = get_user_msgid("HideWeapon");
	#endif
	
	/* Cvar ayarlari */
	
	bind_pcvar_float(create_cvar("default_damage", "15.0"), g_flcvars[1]);
	bind_pcvar_float(create_cvar("default_hsdamage", "30.0"), g_flcvars[2]);
	
	bind_pcvar_float(create_cvar("xdknife_damage", "25.0"), g_flcvars[3]);
	bind_pcvar_float(create_cvar("xdknife_hsdamage", "40.0"), g_flcvars[4]);
	
	bind_pcvar_float(create_cvar("moto_damage", "150.0"), g_flcvars[5]);
	bind_pcvar_float(create_cvar("moto_hsdamage", "200.0"), g_flcvars[6]);
	
	bind_pcvar_float(create_cvar("ctknife_damage", "50.0"), g_flcvars[7]);
	bind_pcvar_float(create_cvar("ctknife_hsdamage", "100.0"), g_flcvars[8]);
	
	bind_pcvar_num(create_cvar("knifexd_parasi", "-1"), g_cvars[1]);
	bind_pcvar_num(create_cvar("knifemoto_parasi", "40"), g_cvars[2]);
	bind_pcvar_num(create_cvar("reklam_parasi", "2"), g_cvars[3]);
	bind_pcvar_num(create_cvar("maxmgverme_parasi", "100"), g_cvars[4]);
	bind_pcvar_num(create_cvar("giris_parasi","5"), g_cvars[5] );
	bind_pcvar_num(create_cvar("flash_parasi","8"), g_cvars[6] );
	bind_pcvar_num(create_cvar("elbombasi_parasi","10"), g_cvars[7] );
	bind_pcvar_num(create_cvar("sisbombasi_parasi","10"), g_cvars[8] );
	bind_pcvar_num(create_cvar("bombaseti_parasi","25"), g_cvars[9] );
	bind_pcvar_num(create_cvar("sinirsizmermi_parasi","30"), g_cvars[10] );
	bind_pcvar_num(create_cvar("glock_parasi","40"), g_cvars[11] );
	bind_pcvar_num(create_cvar("canal_parasi","10"), g_cvars[12] );
	bind_pcvar_num(create_cvar("zirhal_parasi","10"), g_cvars[13] );
	bind_pcvar_num(create_cvar("kendinikaldir_parasi","30"), g_cvars[14] );
	bind_pcvar_num(create_cvar("elektrikkes_parasi","50"), g_cvars[15] );
	bind_pcvar_num(create_cvar("noclip_parasi","100"), g_cvars[16] );
	bind_pcvar_num(create_cvar("god_parasi","100"), g_cvars[17] );
	bind_pcvar_num(create_cvar("troll_parasi","25"), g_cvars[18] );
	bind_pcvar_num(create_cvar("isyanp_parasi","25"), g_cvars[19] );
	bind_pcvar_num(create_cvar("yokedicip_parasi","50"), g_cvars[20] );
	bind_pcvar_num(create_cvar("kazanol_parasi","25"), g_cvars[21] );
	bind_pcvar_num(create_cvar("ozelkasa_parasi","50"), g_cvars[22] );
	bind_pcvar_num(create_cvar("baskinbaslat_parasi","100"), g_cvars[23] );
	
	/* Digerleri */
	
	register_concmd("amx_isyanbaslat","@isyanbaslat",ADMIN_RCON,"<acik:1 | kapali:0>, isyanteam kurar");
	
	rh_get_mapname(mapcek, charsmax(mapcek));
	synchud=CreateHudSyncObj();
}

/* Publicler  */

public plugin_precache(){
	for(new i = 0; i < Modeller; i++) {
		precache_model(g_szModels[i]);
	}
	for(new i = 0; i < Sesler; i++) {
		precache_sound(g_szSounds[i]);
	}
	for(new i = 0; i < sizeof(bicakmodel); i++) {
		precache_model(bicakmodel[i][1]);
	}
	#if defined Sprgoster
	precache_generic(fmt("sprites/MsPassedRespect.txt"));
	precache_generic(fmt("sprites/MsPassedRespect.spr"));
	#endif
}
public client_putinserver(id) {
	set_task(2.0, "@hudgoster", id, .flags = "b");
	rh_emit_sound2(id , id , CHAN_AUTO, g_szSounds[HG_SES]);
	g_normal[id][para] = g_cvars[5];
	g_bool[id][gctsinir] = false;
	g_bool[id][gbicaksinir] = false;
	g_bool[id][gbombasinir] = false;
	g_bool[id][gts3sinir] = false;
	g_normal[id][meslek] = 0;
	g_normal[id][ct_kill] = 0;
	g_normal[id][alinanbomba] = 0;
	g_normal[id][alinan_bicak] = 0;
	g_normal[id][gorunum] = 0;
}
public client_disconnected(id) {
	g_bool[id][gctsinir] = false;
	g_bool[id][gbicaksinir] = false;
	g_bool[id][gbombasinir] = false;
	g_bool[id][gts3sinir] = false;
	g_normal[id][meslek] = 0;
	g_normal[id][ct_kill] = 0;
	g_normal[id][alinanbomba] = 0;
	g_normal[id][alinan_bicak] = 0;
	g_normal[id][gorunum] = 0;
	g_normal[id][para] = 0;
}
@CSGameRules_RestartRound_Pre() {
	for(new id = 1; id <= MaxClients; id++) {
		if(!is_user_alive(id)) {
			return;
		}
		switch(g_normal[id][meslek]) {
			case 2: {
				set_task(2.0,"@bombaver",id);
			}
			case 3: {
				set_entvar(id,var_gravity,0.4);
			}
			case 4: {
				set_entvar(id,var_health,150.0);
				set_entvar(id,var_armorvalue,150.0);
			}
		}
		rg_remove_item(id,"weapon_knife");
		rg_give_item(id,"weapon_knife");
		g_bool[id][marketsinir] = false;
		g_bool[id][pala] = false;
		g_bool[id][testere] = false;
		g_bool[id][reklam] = false;
		g_bool[id][bonus] = false;
		g_bool[id][isyanteamsinir] = false;
		g_bool[id][meslekengel] = false;
		g_bool[id][baskinsinir] = false;
		g_bool[id][unammo] = false;
	}
	set_lights("#OFF");
}
@CBasePlayer_Spawn_Post(const id){
	if(!is_user_alive(id)) {
		return;
	}
	switch(g_normal[id][meslek]) {
		case 2: {
			set_task(2.0,"@bombaver",id);
		}
		case 3: {
			set_entvar(id,var_gravity,0.4);
		}
		case 4: {
			set_entvar(id,var_health,150.0);
			set_entvar(id,var_armorvalue,150.0);
		}
	}
	rg_remove_item(id,"weapon_knife");
	rg_give_item(id,"weapon_knife");
	g_bool[id][marketsinir] = false;
	g_bool[id][pala] = false;
	g_bool[id][testere] = false;
	g_bool[id][reklam] = false;
	g_bool[id][bonus] = false;
	g_bool[id][meslekengel] = false;
	g_bool[id][unammo] = false;
	if(get_member(id,m_iTeam) == TEAM_TERRORIST){
		@bicakmenu(id);
	}
}
@CBasePlayerWeapon_DefaultDeploy(const pEntity, szViewModel[], szWeaponModel[], iAnim, szAnimExt[], skiplocal) {
	if(get_member(pEntity, m_iId) != WEAPON_KNIFE) {
		return;
	}
	
	new id = get_member(pEntity, m_pPlayer);
	new iTeam = get_member(id, m_iTeam);
	
	switch(iTeam) {
		case TEAM_TERRORIST: {
			if(g_bool[id][testere]) {
				SetHookChainArg(2, ATYPE_STRING, g_szModels[VIEW_MOTO]);
				SetHookChainArg(3, ATYPE_STRING, g_szModels[PLAYER_MOTO]);
			}
			else if(g_bool[id][pala]) {
				SetHookChainArg(2, ATYPE_STRING, bicakmodel[g_normal[id][gorunum]][1]);
				SetHookChainArg(3, ATYPE_STRING, g_szModels[PLAYER_DEFK]);
			}
			else{
				SetHookChainArg(2, ATYPE_STRING, g_szModels[VIEW_MODELT]);
				SetHookChainArg(3, ATYPE_STRING, g_szModels[PLAYER_MODELT]);
			}
		}
		case TEAM_CT: {
			SetHookChainArg(2, ATYPE_STRING, g_szModels[VIEW_MODELCT]);
			SetHookChainArg(3, ATYPE_STRING, g_szModels[PLAYER_MODELCT]);
		}
	}
}
@CBasePlayer_TakeDamage_Pre(const pVictim, pInflictor, pAttacker, Float:flDamage, bitsDamageType) {
	if(!is_user_connected(pAttacker) || !rg_is_player_can_takedamage(pVictim, pAttacker) || pVictim == pAttacker) {
		return;
	}
	
	if(bitsDamageType & DMG_GRENADE || get_user_weapon(pAttacker) != CSW_KNIFE) {
		return;
	}
	new iTeam = get_member(pAttacker, m_iTeam);
	new bool:blHeadShot = bool:(get_member(pVictim, m_LastHitGroup) == HIT_HEAD);
	
	switch(iTeam) {
		case TEAM_TERRORIST: {
			if(g_bool[pAttacker][testere]) {
				SetHookChainArg(4, ATYPE_FLOAT, g_flcvars[blHeadShot ? 5 : 6]);
			}
			if(g_bool[pAttacker][pala]){
				SetHookChainArg(4, ATYPE_FLOAT, g_flcvars[blHeadShot ? 3 : 4]);
			}
			else{
				SetHookChainArg(4, ATYPE_FLOAT, g_flcvars[blHeadShot ? 1 : 2]);
			}
		}
		case TEAM_CT: {
			SetHookChainArg(4, ATYPE_FLOAT, g_flcvars[blHeadShot ? 8 : 7]);
		}
	}
}
@CBasePlayer_Killed_Post(const pVictim, pAttacker, iGib) {
	if(!is_user_connected(pAttacker) || pVictim == pAttacker) {
		return;
	}
	
	if(!(get_member(pAttacker, m_iTeam) == TEAM_TERRORIST && get_member(pVictim, m_iTeam) == TEAM_CT)) {
		return;
	}
	g_normal[pAttacker][para] += 1;
	
	if(g_normal[pAttacker][meslek] == 1) {
		g_normal[pAttacker][para]  += 5;
		client_print_color(pAttacker, pAttacker, "^3[^4%s^3] ^3Meslegin ^4Avci oldugu icin ekstra ^4+5 TL ^3kazandin.", g_szdefines[tag]);
	}
	if(!g_bool[pAttacker][gctsinir]) {
		if(get_member(pVictim,m_iTeam) == TEAM_CT) {
			g_normal[pAttacker][ct_kill]++;
		}
	}
}
@EmitSound_Pre(id, channel, const sample[], Float:volume, Float:attn, flags, pitch) {
	if(!is_user_connected(id) || !equal(sample[8], "kni", 3)) {
		return FMRES_IGNORED;
	}
	
	new TeamName:iTeam = get_member(id, m_iTeam);
	
	switch(iTeam) {
		case TEAM_TERRORIST: {
			if(equal(sample[14], "sla", 3)) {
				rh_emit_sound2(id, 0, channel, g_bool[id][testere] ? g_szSounds[MOTO_SLASH] : g_bool[id][pala] ? g_szSounds[MAC_SLASH1] : g_szSounds[T_SLASH1], volume, attn, flags, pitch);
				return FMRES_SUPERCEDE;
			}
			else if(equal(sample, "weapons/knife_deploy1.wav")) {
				rh_emit_sound2(id, 0, channel, g_bool[id][testere] ? g_szSounds[MOTO_DEPLOY] : g_bool[id][pala] ? g_szSounds[MAC_DEPLOY] : g_szSounds[T_DEPLOY], volume, attn, flags, pitch);
				return FMRES_SUPERCEDE;
			}
			else if(equal(sample[14], "hit", 3)) {
				if(sample[17] == 'w') {
					rh_emit_sound2(id, 0, channel, g_bool[id][testere] ? g_szSounds[MOTO_WALL] : g_bool[id][pala] ? g_szSounds[MAC_WALL] : g_szSounds[T_WALL], volume, attn, flags, pitch);
					return FMRES_SUPERCEDE;
				}
				else {
					if(g_bool[id][testere]) {
						rh_emit_sound2(id, 0, channel, g_szSounds[random_num(MOTO_HIT1, MOTO_HIT2)], volume, attn, flags, pitch);
					}
					else if(g_bool[id][pala]) {
						rh_emit_sound2(id, 0, channel, g_szSounds[random_num(MAC_HIT1, MAC_HIT2)], volume, attn, flags, pitch);
					}
					else {
						rh_emit_sound2(id, 0, channel, g_szSounds[random_num(T_HIT1, T_HIT4)], volume, attn, flags, pitch);
					}
					return FMRES_SUPERCEDE;
				}
			}
			else if(equal(sample[14], "sta", 3)) {
				rh_emit_sound2(id, 0, channel, g_bool[id][testere] ? g_szSounds[MOTO_STAB] : g_bool[id][pala] ? g_szSounds[MAC_STAB] : g_szSounds[T_STAB], volume, attn, flags, pitch);
				return FMRES_SUPERCEDE;
			}
		}
		case TEAM_CT: {
			if(equal(sample[14], "sla", 3)) {
				rh_emit_sound2(id, 0, channel, g_szSounds[CT_SLASH1], volume, attn, flags, pitch);
				return FMRES_SUPERCEDE;
			}
			else if(equal(sample, "weapons/knife_deploy1.wav")) {
				rh_emit_sound2(id, 0, channel, g_szSounds[CT_DEPLOY], volume, attn, flags, pitch);
				return FMRES_SUPERCEDE;
			}
			else if(equal(sample[14], "hit", 3)) {
				if(sample[17] == 'w') {
					rh_emit_sound2(id, 0, channel, g_szSounds[CT_WALL], volume, attn, flags, pitch);
				}
				else {
					rh_emit_sound2(id, 0, channel, g_szSounds[random_num(CT_HIT1, CT_HIT4)], volume, attn, flags, pitch);
				}
				return FMRES_SUPERCEDE;
			}
			else if(equal(sample[14], "sta", 3)) {
				rh_emit_sound2(id, 0, channel, g_szSounds[CT_STAB], volume, attn, flags, pitch);
				return FMRES_SUPERCEDE;
			}
		}
	}
	return FMRES_IGNORED;
}
@UnammoVerici(const id) {
	if(g_bool[id][unammo]) {
		static const g_maxclipammo[] = {
			0,13,0,10,0,7,0,30,30,0,15,20,25,30,35,25,
			12,20,10,30,100,8,30,30,20,0,7,30,30,0,50
		};
		new weapon = read_data(2),activeitem;
		if(g_maxclipammo[weapon] < 0)
			return PLUGIN_CONTINUE;
		
		activeitem = get_member(id, m_pActiveItem);
		set_member(activeitem, m_Weapon_iClip, g_maxclipammo[weapon]);
	}
	#if defined Sprgoster
	if(!g_PlayerRankedUp[id] || get_member(id, m_iFOV) != 90) {
		return PLUGIN_CONTINUE;
	}
	return PLUGIN_CONTINUE;
	#endif
}
@hudgoster(const id) {
	if(is_user_alive(id) && get_member(id, m_iTeam) == TEAM_TERRORIST) { 
		set_hudmessage(124, 252, 0, 5.0, 0.68, 0, 1.0, 1.0);
		ShowSyncHudMsg(id, synchud, "Cebinizdeki TL : [ %i ] -^nCan : [ %i ] -", g_normal[id][para] ,get_user_health(id));
	}
}

/* Menuler */

@bicakmenu(const id){
	if(g_bool[id][marketsinir]){
		client_print_color(id,id,"^3[^4%s^3] ^3Market Menuyu Zaten Kullandin.",g_szdefines[tag]);
		@anamenu(id);
	}
	else {
		new menu = menu_create(fmt("\r%s \w| \yBicak Menu", g_szdefines[tag]), "@bicakmenu_devam");
		
		menu_additem(menu,fmt("\r%s \w| \y%s \d[%d TL]^n", g_szdefines[tag],bicakmodel[g_normal[id][gorunum]][0], g_cvars[1]));
		
		menu_additem(menu,fmt("\r%s \w| \yTestere + Bomba \d[%d TL]^n", g_szdefines[tag], g_cvars[2]));
		
		menu_additem(menu,fmt("\r%s \w| \yReklam At \d[%d TL]", g_szdefines[tag], g_cvars[3]));
		
		menu_setprop(menu, MPROP_EXITNAME, fmt("\d%s \w| \yCikis", g_szdefines[tag]));
		menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
		menu_display(id, menu);
	}
}
@bicakmenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !IsPlayerCanUse(id, true, true)) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: {
			if(g_normal[id][para] >= g_cvars[1]){
				g_bool[id][pala] = true;
				
				rg_remove_item(id, "weapon_knife");
				rg_give_item(id, "weapon_knife", GT_REPLACE);
				g_normal[id][alinan_bicak]++;
				
				rg_send_audio(id , g_szSounds[SI]);
				g_bool[id][marketsinir] = true;
				g_normal[id][para]-= g_cvars[1];
			}
			else{
				rg_send_audio(id , g_szSounds[NO]);
				@bicakmenu(id);
			}
		}
		case 1: {
			if(g_normal[id][para] >= g_cvars[2]){
				g_bool[id][testere] = true;
				
				rg_remove_item(id, "weapon_knife");
				rg_give_item(id, "weapon_knife", GT_REPLACE);
				rg_give_item(id, "weapon_hegrenade");
				g_normal[id][alinan_bicak]++;
				
				rg_send_audio(id , g_szSounds[SI]);
				g_bool[id][marketsinir] = true;
				g_normal[id][para]-= g_cvars[2];
			}
			else{
				rg_send_audio(id , g_szSounds[NO]);
				@bicakmenu(id);
			}
		}
		case 2: {
			if(g_bool[id][reklam]){
				rg_send_audio(id , g_szSounds[NO]);
				@bicakmenu(id);
			}
			else{
				rg_send_audio(id , g_szSounds[SI]);
				client_print_color(0,0,"^3[^4%s^3] ^3Sizde ailemize katilmak isterseniz say'a ^4/ts3 ^3yazabilirsiniz.",g_szdefines[tag]);
				g_normal[id][para]+= g_cvars[3];
				g_bool[id][reklam]=true;
				@bicakmenu(id);
			}
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@anamenu(const id){
	if(get_member(id, m_iTeam) == TEAM_TERRORIST && IsPlayerCanUse(id, false, true)) {
		new menu = menu_create(fmt("\r%s \w| \yJailBreak Menu \w| \rCebindeki TL : %i^n\dTs3 Adresimiz : %s", g_szdefines[tag],g_normal[id][para],g_szdefines[ts3ip]), "@anamenu_devam");
		
		menu_additem(menu, fmt("\r%s \w| \yBicak Menu%s", g_szdefines[tag], g_bool[id][marketsinir] ? " \d[Kullandiniz]" : ""));
		menu_additem(menu, fmt("\r%s \w| \yKacakci Bilal", g_szdefines[tag]));
		menu_additem(menu, fmt("\r%s \w| \yBonus Menu%s", g_szdefines[tag], g_bool[id][bonus] ? " \d[Kullandiniz]" : ""));
		menu_additem(menu, fmt("\r%s \w| \yIsyanTeam Menu%s", g_szdefines[tag], isyantkontrol ? " \d[Acik]" : " \d[Kapali]"));
		menu_additem(menu, fmt("\r%s \w| \yMeslek Menu", g_szdefines[tag]));
		menu_additem(menu, fmt("\r%s \w| \yGorev Menu", g_szdefines[tag]));
		menu_additem(menu, fmt("\r%s \w| \yBicak Degis Menu", g_szdefines[tag]));
		menu_additem(menu, fmt("\r%s \w| \yCt'ye Baskin Baslat%s", g_szdefines[tag], g_bool[id][baskinsinir] ? " \d[Baslattin]" : ""));
		menu_additem(menu, fmt("\r%s \w| \yBilgi Menu", g_szdefines[tag]));
		
		menu_additem(menu, "\dCikis", "0", 0);
		menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
		menu_setprop(menu, MPROP_PERPAGE, 0);
		menu_display(id, menu);
	}
	return PLUGIN_HANDLED;
}
@anamenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !IsPlayerCanUse(id, false, true)) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: {
			@bicakmenu(id);
		}
		case 1: {
			@kacakcibilal(id);
		}
		case 2: {
			@bonusmenu(id);
		}
		case 3: {
			if(isyantkontrol){
				@isyanteammenu(id);
			}
			else{
				client_print_color(id,id,"^3[^4%s^3] ^3IsyanTeam Kurulmadi.Kurulmasi icin ^4Baskanlari ^3ile iletisime gec.",g_szdefines[tag]);
				@anamenu(id);
			}
		}
		case 4: {
			@meslekmenu(id);
		}
		case 5: {
			@gorevmenu(id);
		}
		case 6: {
			@bicakdegismenu(id);
		}
		case 7: {
			@ctyebaskinbaslatmenu(id);
		}
		case 8: {
			@bilgimenu(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@kacakcibilal(const id){
	new menu = menu_create(fmt("\r%s \w| \yKacakci Menu", g_szdefines[tag]), "@kacakci_devam");
	
	menu_additem(menu, fmt("\r%s \w| \yCephane Menu", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \yIsyan Menu", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \yBilal Ozel Menu^n", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \yTL Transfer ^n", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \yBilal Ozel Kasa \d[%d TL]", g_szdefines[tag],g_cvars[22]));
	
	menu_setprop(menu, MPROP_EXITNAME,fmt( "\d%s \w| \yCikis", g_szdefines[tag]));
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
}
@kacakci_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !IsPlayerCanUse(id, true, true)) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: {
			@cephanemenu(id);
		}
		case 1: {
			@isyanmenu(id);
		}
		case 2: {
			@bilalozelmenu(id);
		}
		case 3: {
			@jbmenu_tltransfer(id);
		}
		case 4: {
			@bilalozelkasa(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@cephanemenu(const id){
	new menu = menu_create(fmt("\r%s \w| \yCephane Menu", g_szdefines[tag]), "@cephanemenu_devam");
	
	menu_additem(menu, fmt("\r%s \w| \yFlash Bombasi \d[%d TL]", g_szdefines[tag],g_cvars[6]));
	menu_additem(menu, fmt("\r%s \w| \yEl Bombasi \d[%d TL]", g_szdefines[tag],g_cvars[7]));
	menu_additem(menu, fmt("\r%s \w| \ySis Bombasi \d[%d TL]", g_szdefines[tag],g_cvars[8]));
	menu_additem(menu, fmt("\r%s \w| \yBomba Seti \d[%d TL]", g_szdefines[tag],g_cvars[9]));
	menu_additem(menu, fmt("\r%s \w| \ySinirsiz Mermi \d[%d TL]", g_szdefines[tag],g_cvars[10]));
	menu_additem(menu, fmt("\r%s \w| \y20Mermili Glock \d[%d TL]", g_szdefines[tag],g_cvars[11]));
	
	menu_setprop(menu, MPROP_EXITNAME,fmt( "\d%s \w| \yCikis", g_szdefines[tag]));
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
	
}
@cephanemenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !IsPlayerCanUse(id, true, true)) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: if(g_normal[id][para] >= g_cvars[6]){
			
			rg_give_item(id,"weapon_flashbang");
			g_normal[id][alinanbomba]++;
			
			rg_send_audio(id , g_szSounds[SI]);
			
			g_normal[id][para]-= g_cvars[6];
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@cephanemenu(id);
		}
		case 1: if(g_normal[id][para] >= g_cvars[7]){
			
			rg_give_item(id,"weapon_hegrenade");
			g_normal[id][alinanbomba]++;
			
			rg_send_audio(id , g_szSounds[SI]);
			
			g_normal[id][para]-= g_cvars[7];
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@cephanemenu(id);
		}
		case 2: if(g_normal[id][para] >= g_cvars[8]){
			
			rg_give_item(id,"weapon_smokegrenade");
			g_normal[id][alinanbomba]++;
			
			rg_send_audio(id , g_szSounds[SI]);
			
			g_normal[id][para]-= g_cvars[8];
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@cephanemenu(id);
		}
		case 3: if(g_normal[id][para] >= g_cvars[9]){
			
			rg_give_item(id,"weapon_flashbang");
			rg_give_item(id,"weapon_hegrenade");
			rg_give_item(id,"weapon_smokegrenade");
			g_normal[id][alinanbomba]++;
			
			rg_send_audio(id , g_szSounds[SI]);
			
			g_normal[id][para]-= g_cvars[9];
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@cephanemenu(id);
		}
		case 4: if(g_normal[id][para] >= g_cvars[10]){
			
			g_bool[id][unammo]=true;
			
			rg_send_audio(id , g_szSounds[SI]);
			
			g_normal[id][para]-= g_cvars[10];
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@cephanemenu(id);
		}
		case 5: if(g_normal[id][para] >= g_cvars[11]){
			
			rg_give_item(id,"weapon_glock18");
			rg_set_user_bpammo(id,WEAPON_GLOCK18,20);
			
			rg_send_audio(id , g_szSounds[SI]);
			
			g_normal[id][para]-= g_cvars[11];
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@cephanemenu(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@isyanmenu(const id){
	new menu = menu_create(fmt("\r%s \w| \yIsyan Menu", g_szdefines[tag]), "@isyanmenu_devam");
	
	menu_additem(menu, fmt("\r%s \w| \y100 Can Al \d[%d TL]", g_szdefines[tag],g_cvars[12]));
	menu_additem(menu, fmt("\r%s \w| \y100 Zirh Al \d[%d TL]", g_szdefines[tag],g_cvars[13]));
	menu_additem(menu, fmt("\r%s \w| \yKendini Kaldir \d[%d TL]", g_szdefines[tag],g_cvars[14]));
	menu_additem(menu, fmt("\r%s \w| \yElektrikleri Kes \d[%d TL]", g_szdefines[tag],g_cvars[15]));
	menu_additem(menu, fmt("\r%s \w| \y5sn Noclip Al \d[%d TL]", g_szdefines[tag],g_cvars[16]));
	menu_additem(menu, fmt("\r%s \w| \y5sn God Al \d[%d TL]", g_szdefines[tag],g_cvars[17]));
	
	menu_setprop(menu, MPROP_EXITNAME,fmt( "\d%s \w| \yCikis", g_szdefines[tag]));
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
}
@isyanmenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !IsPlayerCanUse(id, true, true)) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: if(g_normal[id][para] >= g_cvars[12]){
			
			set_entvar(id, var_health, Float:get_entvar(id, var_health) + 100.0);
			
			rg_send_audio(id , g_szSounds[SI]);
			
			g_normal[id][para]-= g_cvars[12];
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@isyanmenu(id);
		}
		case 1: if(g_normal[id][para] >= g_cvars[13]){
			
			set_entvar(id,var_armorvalue,Float:get_entvar(id,var_armorvalue)+100.0);
			
			rg_send_audio(id , g_szSounds[SI]);
			
			g_normal[id][para]-= g_cvars[13];
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@isyanmenu(id);
		}
		case 2: if(g_normal[id][para] >= g_cvars[14]){
			
			new Float:origin[3]; get_entvar(id, var_origin, origin),origin[2] +=35.0,set_entvar(id, var_origin, origin);
			
			rg_send_audio(id , g_szSounds[SI]);
			
			g_normal[id][para]-= g_cvars[14];
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@isyanmenu(id);
		}
		case 3: if(g_normal[id][para] >= g_cvars[15]){
			
			set_lights("a");
			set_task(6.0,"@elektrikac");
			
			rg_send_audio(id , g_szSounds[SI]);
			
			g_normal[id][para]-= g_cvars[15];
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@isyanmenu(id);
		}
		case 4: if(g_normal[id][para] >= g_cvars[16]){
			
			set_entvar(id,var_movetype,MOVETYPE_NOCLIP);
			rh_emit_sound2(id,0, CHAN_AUTO, g_szSounds[NOCLIP]);
			set_task(5.0,"@noclipkapat",id);
			
			rg_send_audio(id , g_szSounds[SI]);
			
			g_normal[id][para]-= g_cvars[16];
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@isyanmenu(id);
		}
		case 5: if(g_normal[id][para] >= g_cvars[17]){
			
			set_entvar(id, var_takedamage, DAMAGE_NO);
			set_task(5.0,"@godkapa",id);
			
			
			rg_send_audio(id , g_szSounds[SI]);
			
			g_normal[id][para]-= g_cvars[17];
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@isyanmenu(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@elektrikac(){
	set_lights("#OFF");
	client_print_color(0, 0, "^3[^4%s^3] ^4Elektrik Kesintisi ^3sona erdi.",g_szdefines[tag]);
}
@noclipkapat(id){
	if(is_user_connected(id) && is_user_alive(id)){
		set_entvar(id,var_movetype,MOVETYPE_NONE);
		client_print_color(id,id,"^3[^4%s^3] ^4Noclipin ^3suresi doldu",g_szdefines[tag]);
		rh_emit_sound2(id,0, CHAN_AUTO, g_szSounds[NOCLIP]);
	}
}
@godkapa(id){
	set_entvar(id, var_takedamage, DAMAGE_AIM);
	client_print_color(id, id, "^3[^4%s^3] ^4Godmodenin ^3suresi doldu.",g_szdefines[tag]);
}
@bilalozelmenu(const id){
	new menu = menu_create(fmt("\r%s \w| \yBilal Ozel Menu", g_szdefines[tag]), "@bilalozelmenu_devam");
	
	menu_additem(menu, fmt("\r%s \w| \yBilal Troll Paketi \d[%d TL]", g_szdefines[tag],g_cvars[18]));
	menu_additem(menu, fmt("\r%s \w| \yBilal Isyan Paketi \d[%d TL]", g_szdefines[tag],g_cvars[19]));
	menu_additem(menu, fmt("\r%s \w| \yBilal Ozel Yokedici Paketi \d[%d TL]^n", g_szdefines[tag],g_cvars[20]));
	
	menu_additem(menu, fmt("\r%s \w| \y%50 Ol veya Kazan \d[%d TL]", g_szdefines[tag],g_cvars[21]));
	
	menu_setprop(menu, MPROP_EXITNAME,fmt( "\d%s \w| \yCikis", g_szdefines[tag]));
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
	
}
@bilalozelmenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !IsPlayerCanUse(id, true, true)) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: if(g_normal[id][para] >= g_cvars[18]){
			
			rg_give_item(id, "weapon_flashbang");
			rg_give_item(id,"weapon_smokegrenade");
			rg_set_user_bpammo(id, WEAPON_FLASHBANG, 2);
			
			rg_send_audio(id , g_szSounds[SI]);
			
			g_normal[id][para]-= g_cvars[18];
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@bilalozelmenu(id);
		}
		case 1: if(g_normal[id][para] >= g_cvars[19]){
			
			rg_give_item(id, "weapon_hegrenade");
			set_entvar(id, var_health, Float:get_entvar(id, var_health) + 150.0);
			set_entvar(id,var_armorvalue,Float:get_entvar(id,var_armorvalue)+150.0);
			
			rg_send_audio(id , g_szSounds[SI]);
			
			g_normal[id][para]-= g_cvars[19];
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@bilalozelmenu(id);
		}
		case 2: if(g_normal[id][para] >= g_cvars[20]){
			
			rg_give_item(id, "weapon_flashbang");
			rg_give_item(id, "weapon_hegrenade");
			rg_give_item(id,"weapon_smokegrenade");
			set_entvar(id, var_health, Float:get_entvar(id, var_health) + 250.0);
			
			rg_send_audio(id , g_szSounds[SI]);
			
			g_normal[id][para]-= g_cvars[20];
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@bilalozelmenu(id);
		}
		case 3: if(g_normal[id][para] >= g_cvars[21]){
			
			new random = random_num(1,2);
			switch(random) {
				case 1: {
					user_kill(id);
					rh_emit_sound2(id,0, CHAN_AUTO, g_szSounds[ADAM_OLDU]);
				}
				case 2: {
					g_normal[id][para]+=50;
					rg_send_audio(id , g_szSounds[KASA_DOLU]);
				}
			}
			g_normal[id][para]-= g_cvars[21];
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@bilalozelmenu(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@jbmenu_tltransfer(const id) {
	new menu = menu_create(fmt("\r%s \w| \yTL Transfer Menu", g_szdefines[tag]), "@tltransfer_devam");
	
	menu_additem(menu, fmt("\r%s \w| \y10 TL Gonder", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \y25 TL Gonder", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \y50 TL Gonder", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \y100 TL Gonder", g_szdefines[tag]));
	
	menu_setprop(menu, MPROP_EXITNAME,fmt( "\d%s \w| \yCikis", g_szdefines[tag]));
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
}
@tltransfer_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !IsPlayerCanUse(id, true, true)) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: if(g_normal[id][para] >= 10){
			g_normal[id][tlsec]=1;
		}
		case 1: if(g_normal[id][para] >= 25){
			g_normal[id][tlsec]=2;
		}
		case 2: if(g_normal[id][para] >= 50){
			g_normal[id][tlsec]=3;
		}
		case 3: if(g_normal[id][para] >= 100){
			g_normal[id][tlsec]=4;
		}
	}
	@listele(id);
	return PLUGIN_HANDLED;
}
@listele(const id){
	if(g_normal[id][tlsec] > 0) {
		new menu = menu_create("\rKime TL Gondermek Istersin ?","@listele_devam");
		
		for(new idc = 1, szStr[3]; idc <= MaxClients; idc++) {
			if(is_user_alive(idc) && get_member(idc, m_iTeam) == TEAM_TERRORIST && id != idc) {
				num_to_str(idc, szStr, charsmax(szStr));
				menu_additem(menu, fmt("\y%n", idc), szStr);
			}
		}
		menu_display(id,menu);
	}
	else client_print_color(id,id,"^3[^4%s^3] ^3Yeterli ^4TL'n ^3Bulunmamakta.",g_szdefines[tag]),g_normal[id][tlsec] = 0;
	return PLUGIN_HANDLED;
}
@listele_devam(const id, const menu, const item){
	if(item == MENU_EXIT || !IsPlayerCanUse(id, true, true))
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	g_normal[id][isimcek] = str_to_num(data);
	@yolla(id);
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@yolla(const id){
	new isim[MAX_NAME_LENGTH],isim2[MAX_NAME_LENGTH];
	new id2 = g_normal[id][isimcek];
	get_user_name(id, isim, charsmax(isim));
	get_user_name(id2, isim2, charsmax(isim2));
	switch(g_normal[id][tlsec]){
		case 1: {
			g_normal[id2][para]+= 10;
			g_normal[id][para]-=10;
			client_print_color(id2,id2,"^3[^4%s^3] ^3Isimli oyuncu size ^4+10 TL ^3gonderdi",isim);
			client_print_color(id,id,"^3[^4%s^3] ^3Isimli oyuncuya ^4+10 TL ^3gonderdiniz.",isim2);
			g_normal[id][tlsec] = 0;
			g_normal[id][isimcek] = 0;
		}
		case 2: {
			g_normal[id2][para]+= 25;
			g_normal[id][para]-=25;
			client_print_color(id2,id2,"^3[^4%s^3] ^3Isimli oyuncu size ^4+25 TL ^3gonderdi",isim);
			client_print_color(id,id,"^3[^4%s^3] ^3Isimli oyuncuya ^4+25 TL ^3gonderdiniz.",isim2);
			g_normal[id][tlsec] = 0;
			g_normal[id][isimcek] = 0;
		}
		case 3: {
			g_normal[id2][para]+= 50;
			g_normal[id][para]-=50;
			client_print_color(id2,id2,"^3[^4%s^3] ^3Isimli oyuncu size ^4+50 TL ^3gonderdi",isim);
			client_print_color(id,id,"^3[^4%s^3] ^3Isimli oyuncuya ^4+50 TL ^3gonderdiniz.",isim2);
			g_normal[id][tlsec] = 0;
			g_normal[id][isimcek] = 0;
		}
		case 4: {
			g_normal[id2][para]+= 100;
			g_normal[id][para]-=100;
			client_print_color(id2,id2,"^3[^4%s^3] ^3Isimli oyuncu size ^4+100 TL ^3gonderdi",isim);
			client_print_color(id,id,"^3[^4%s^3] ^3Isimli oyuncuya ^4+10 TL ^3gonderdiniz.",isim2);
			g_normal[id][tlsec] = 0;
			g_normal[id][isimcek] = 0;
		}
	}
}
@bilalozelkasa(const id){
	new menu = menu_create(fmt("\r%s \w| \yBilal Ozel Kasa Menu", g_szdefines[tag]), "@bilalozelkasa_devam");
	
	menu_additem(menu, fmt("\r%s \w| \yEvet \d[%d TL]", g_szdefines[tag],g_cvars[22]));
	menu_additem(menu, fmt("\r%s \w| \yHayir", g_szdefines[tag]));
	
	menu_setprop(menu, MPROP_EXITNAME,fmt( "\d%s \w| \yCikis", g_szdefines[tag]));
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
}
@bilalozelkasa_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !IsPlayerCanUse(id, true, true)) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: {
			if(g_normal[id][para] >= g_cvars[22]){
				set_task(7.0,"@bilalozelkasaac",id);
				rh_emit_sound2(id, 0, CHAN_AUTO, g_szSounds[KASA_AC]);
				client_print_color(0,0,"^3[^4%s^3] ^3Mahkumlardan Biri ^4Kasa ^3aciyor.",g_szdefines[tag]);
				g_normal[id][para]-= g_cvars[22];
			}
			else{
				rg_send_audio(id , g_szSounds[NO]);
				@bilalozelkasa(id);
			}
		}
		case 1: {
			@kacakcibilal(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@bilalozelkasaac(id){
	if(IsPlayerCanUse(id, true, true)){
		new random = random_num(1,10);
		switch(random){
			case 1: {
				set_member(rg_give_item(id,"weapon_deagle"),m_Weapon_iClip,7);
				rh_emit_sound2(id,0, CHAN_AUTO, g_szSounds[KASA_DOLU]);
				client_print_color(0,0,"^3[^4%s^3] ^3Mahkumlardan Biri ^4Deagle ^3cikardi.",g_szdefines[tag]);
			}
			case 2: {
				set_member(rg_give_item(id,"weapon_awp"),m_Weapon_iClip,10);
				rh_emit_sound2(id,0, CHAN_AUTO, g_szSounds[KASA_DOLU]);
				client_print_color(0,0,"^3[^4%s^3] ^3Mahkumlardan Biri ^4AWP ^3cikardi.",g_szdefines[tag]);
			}
			case 3: {
				set_member(rg_give_item(id,"weapon_m4a1"),m_Weapon_iClip,30);
				rh_emit_sound2(id,0, CHAN_AUTO, g_szSounds[KASA_DOLU]);
				client_print_color(0,0,"^3[^4%s^3] ^3Mahkumlardan Biri ^4M4A1 ^3cikardi.",g_szdefines[tag]);
			}
			case 4: {
				set_entvar(id,var_health, Float:get_entvar(id,var_health) + 250.0);
				rh_emit_sound2(id,0, CHAN_AUTO, g_szSounds[KASA_DOLU]);
				client_print_color(id,id,"^3[^4%s^3] ^3Kasadan ^4+250 Can ^3Kazandin.",g_szdefines[tag]);
			}
			case 5: {
				g_normal[id][para]+=50;
				rh_emit_sound2(id,0, CHAN_AUTO, g_szSounds[KASA_DOLU]);
				client_print_color(id,id,"^3[^4%s^3] ^3Kasadan ^4+50 TL ^3Kazandin.",g_szdefines[tag]);
			}
			case 6..10: {
				rh_emit_sound2(id,0, CHAN_AUTO, g_szSounds[KASA_BOS]);
				client_print_color(id,id,"^3[^4%s^3] ^3Kasadan ^4Hicbirsey ^3Kazanamadin.",g_szdefines[tag]);
			}
		}
	}
}
@bonusmenu(const id){
	if(g_bool[id][bonus]){
		client_print_color(id,id,"^3[^4%s^3] ^3Bonus Menuyu Zaten Kullandin.",g_szdefines[tag]);
		@anamenu(id);
	}
	else {
		new menu = menu_create(fmt("\r%s \w| \yBonus Menu", g_szdefines[tag]), "@bonusmenu_devam");
		
		menu_additem(menu, fmt("\r%s \w| \yUser Bonusu \d[2 TL] ", g_szdefines[tag]));
		menu_additem(menu, fmt("\r%s \w| \ySlot Bonusu \d[5 TL] ", g_szdefines[tag]));
		menu_additem(menu, fmt("\r%s \w| \yAdmin Bonusu \d[7 TL] ", g_szdefines[tag]));
		menu_additem(menu, fmt("\r%s \w| \yYonetici Bonusu \d[10 TL] ", g_szdefines[tag]));
		
		menu_setprop(menu, MPROP_EXITNAME,fmt( "\d%s \w| \yCikis", g_szdefines[tag]));
		menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
		menu_display(id, menu);
	}
}
@bonusmenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !IsPlayerCanUse(id, true, true)) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new guf = get_user_flags(id);
	switch(item) {
		case 0: {
			g_normal[id][para]+=2;
			rg_send_audio(id , g_szSounds[SI]);
			g_bool[id][bonus]=true;
		}
		case 1: {
			if(guf & slotbonus){
				g_normal[id][para]+=5;
				rg_send_audio(id , g_szSounds[SI]);
				g_bool[id][bonus]=true;
			}
			else{
				rg_send_audio(id , g_szSounds[NO]);
				@bonusmenu(id);
			}
		}
		case 2: {
			if(guf&adminbonus){
				g_normal[id][para]+=7;
				rg_send_audio(id , g_szSounds[SI]);
				g_bool[id][bonus]=true;
			}
			else{
				rg_send_audio(id , g_szSounds[NO]);
				@bonusmenu(id);
			}
		}
		case 3: {
			if(guf&yoneticibonus){
				g_normal[id][para]+=10;
				rg_send_audio(id , g_szSounds[SI]);
				g_bool[id][bonus]=true;
			}
			else{
				rg_send_audio(id , g_szSounds[NO]);
				@bonusmenu(id);
			}
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@isyanbaslat(const id){
	new arg1[32];
	read_argv(1,arg1,charsmax(arg1));
	if(equali(arg1,"1")){
		isyantkontrol=true;
		client_print_color(0,0,"^3[^4%s^3] ^3IsyanTeam Baskanlari ^3TeamSpeak'de IsyanTeam baslatti.Katilmak icin ^4/ts3 ^3yaziniz",g_szdefines[tag]);
		@anamenu(id);
	}
	else{
		isyantkontrol=false;
		client_print_color(0,0,"^3[^4%s^3] ^3IsyanTeam Baskanlari ^3IsyanTeami Durdurdu.",g_szdefines[tag]);
		@anamenu(id);
	}
	return PLUGIN_HANDLED;
}
@isyanteammenu(const id){
	if(g_bool[id][isyanteamsinir]){
		client_print_color(id,id,"^3[^4%s^3] ^3IsyanTeam Menuyu Zaten kullandin.",g_szdefines[tag]);
		@anamenu(id);
	}
	else if(get_user_flags(id) & isyanteam_baskan){
		new menu = menu_create(fmt("\r%s \w| \yIsyan Team Baskan Menu", g_szdefines[tag]), "@isyanteammenu_devam");
		
		menu_additem(menu, fmt("\r%s \w| \yUyelerine \d[50 HP] ver", g_szdefines[tag]));
		menu_additem(menu, fmt("\r%s \w| \yUyelerine \d[5 TL] ver", g_szdefines[tag]));
		menu_additem(menu, fmt("\r%s \w| \yUyelerine El Bombasi ver", g_szdefines[tag]));
		menu_additem(menu, fmt("\r%s \w| \yUyelerine Flash Bombasi Ver", g_szdefines[tag]));
		menu_additem(menu, fmt("\r%s \w| \yUyelerine Smoke Bombasi Ver", g_szdefines[tag]));
		
		menu_setprop(menu, MPROP_EXITNAME,fmt( "\d%s \w| \yCikis", g_szdefines[tag]));
		menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
		menu_display(id, menu);
	}
}
@isyanteammenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !IsPlayerCanUse(id, true, true)) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new players[32],inum;
	get_players(players,inum,"aechi","TERRORIST");
	static idx;
	for(new i ; i < inum ; i++){
		idx = players[i];
		if(get_user_flags(idx) & isyanteam_uye){
			switch(item){
				case 0:{
					set_entvar(idx,var_health, Float:get_entvar(idx,var_health) + 50.0);
					g_bool[id][isyanteamsinir]=true;
					client_print_color(0, 0, "^3[^4%s^3] ^3Isyanteam Baskanlari Uyelerine ^4 50 HP ^3Dagitti.", g_szdefines[tag]);
				}
				case 1:{
					g_normal[idx][para]+=5;
					g_bool[id][isyanteamsinir]=true;
					client_print_color(0, 0, "^3[^4%s^3] ^3Isyanteam Baskanlari Uyelerine ^4 5 TL ^3Dagitti.", g_szdefines[tag]);
				}
				case 2:{
					rg_give_item(idx,"weapon_hegrenade");
					g_bool[id][isyanteamsinir]=true;
					client_print_color(0, 0, "^3[^4%s^3] ^3Isyanteam Baskanlari Uyelerine ^4Smoke Grenade ^3Dagitti.", g_szdefines[tag]);
				}
				case 3:{
					rg_give_item(idx,"weapon_flashbang");
					g_bool[id][isyanteamsinir]=true;
					client_print_color(0, 0, "^3[^4%s^3] ^3Isyanteam Baskanlari Uyelerine ^4Flashbang ^3Dagitti.", g_szdefines[tag]);
				}
				case 4:{
					rg_give_item(idx,"weapon_smokegrenade");
					g_bool[id][isyanteamsinir]=true;
					client_print_color(0, 0, "^3[^4%s^3] ^3Isyanteam Baskanlari Uyelerine ^4He Grenade ^3Dagitti.", g_szdefines[tag]);
				}
			}
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@meslekmenu(const id) {
	if(g_bool[id][meslekengel]) {
		client_print_color(id, id, "^3[^4%s^3] ^3En az bir el gecmeden ^4meslek ^3degistiremezsiniz.", g_szdefines[tag]);
		@anamenu(id);
	}
	else{
	new menu = menu_create(fmt("\r%s \w| \yMeslek Menu", g_szdefines[tag]), "@meslekmenu_devam");
	
	menu_additem(menu, fmt("\r%s \w| \yAvci \dHer \rCT \dOldurdugunde \r5 \dTL Kazanirsin", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \yBombaci \dRastgele \rBomba \dSahibi Olursun", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \yAstronot \dDaha Yuksege \rZiplarsin", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \yTerminator  \dHer El \r150 \dHP + \r150 \dArmor", g_szdefines[tag]));
	
	menu_setprop(menu, MPROP_EXITNAME,fmt( "\d%s \w| \yCikis", g_szdefines[tag]));
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
}
}
@meslekmenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !IsPlayerCanUse(id, true, true)) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: {
			if(g_normal[id][meslek] != 1) {
				g_normal[id][meslek] = 1;
				g_bool[id][meslekengel] = true;
				
				client_print_color(id, id, "^3[^4%s^3] ^3Meslegini ^4Avci ^3olarak degistirdin.", g_szdefines[tag]);
			}
			else {
				client_print_color(id, id, "^3[^4%s^3] ^3Meslegin zaten ^4Avci^3.", g_szdefines[tag]);
			}
		}
		case 1: {
			if(g_normal[id][meslek] != 2) {
				g_normal[id][meslek] = 2;
				g_bool[id][meslekengel] = true;
				
				set_task(2.0,"@bombaver",id);
				
				client_print_color(id, id, "^3[^4%s^3] ^3Meslegini ^4Bombaci ^3olarak degistirdin.", g_szdefines[tag]);
			}
			else {
				client_print_color(id, id, "^3[^4%s^3] ^3Meslegin zaten ^4Bombaci^3.", g_szdefines[tag]);
			}
		}
		case 2: {
			if(g_normal[id][meslek] != 3) {
				g_normal[id][meslek] = 3;
				g_bool[id][meslekengel] = true;
				
				set_entvar(id,var_gravity,0.4);
				
				client_print_color(id, id, "^3[^4%s^3] ^3Meslegini ^4Astronot ^3olarak degistirdin.", g_szdefines[tag]);
			}
			else {
				client_print_color(id, id, "^3[^4%s^3] ^3Meslegin zaten ^4Astronot^3.", g_szdefines[tag]);
			}
		}
		case 3: {
			if(g_normal[id][meslek] != 4) {
				g_normal[id][meslek] = 4;
				g_bool[id][meslekengel] = true;
				
				set_entvar(id, var_health, 150.0);
				rg_set_user_armor(id, 150, ARMOR_KEVLAR);
				
				client_print_color(id, id, "^3[^4%s^3] ^3Meslegini ^4Terminator ^3olarak degistirdin.", g_szdefines[tag]);
			}
			else {
				client_print_color(id, id, "^3[^4%s^3] ^3Meslegin zaten ^4Terminator^3.", g_szdefines[tag]);
			}
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@bombaver(const id){
	switch(random_num(0,2)){
		case 0:{
			rg_give_item(id,"weapon_hegrenade");
		}
		case 1:{
			rg_give_item(id,"weapon_flashbang");
		}
		case 2:{
			rg_give_item(id,"weapon_smokegrenade");
		}
	}
}
@gorevmenu(const id){
	new menu = menu_create(fmt("\r%s \w| \yGorev Menu", g_szdefines[tag]), "@gorevmenu_devam");
	
	menu_additem(menu, fmt("\r%s \w| \yTs3 Baglan%s", g_szdefines[tag], g_bool[id][gts3sinir] ? " \d[Tamamladin]" : " \d[5 TL]"));
	menu_additem(menu, fmt("\r%s \w| \yBicak Menuden 5 Kere Bicak Al%s", g_szdefines[tag], g_bool[id][gbicaksinir] ? " \d[Tamamladin]" : " \d[15 TL]"));
	menu_additem(menu, fmt("\r%s \w| \yCephane Menuden 5 Bomba Al%s", g_szdefines[tag], g_bool[id][gbombasinir] ? " \d[Tamamladin]" : " \d[20 TL]"));
	menu_additem(menu, fmt("\r%s \w| \y10 CT Oldur%s", g_szdefines[tag], g_bool[id][gctsinir] ? " \d[Tamamladin]" : " \d[25 TL]"));
	
	menu_setprop(menu, MPROP_EXITNAME,fmt( "\d%s \w| \yCikis", g_szdefines[tag]));
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
}
@gorevmenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !IsPlayerCanUse(id, true, true)) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: {
			if(g_bool[id][gts3sinir]){
				client_print_color(id,id,"^3[^4%s^3] ^3Bu ^3gorevi ^3daha once tamamladin",g_szdefines[tag]);
				rg_send_audio(id , g_szSounds[NO]);
			}
			else {
				client_cmd(id,"say /ts3");
				g_bool[id][gts3sinir] = true;
				g_normal[id][para]+= 5;
				rg_send_audio(id , g_szSounds[GOREV_SES]);
				#if defined Sprgoster
				@sprshow(id);
				#endif
			}
		}
		case 1: {
			if(g_bool[id][gbicaksinir]){
				client_print_color(id,id,"^3[^4%s^3] ^3Bu ^3gorevi ^3daha once tamamladin",g_szdefines[tag]);
				rg_send_audio(id , g_szSounds[NO]);
			}
			else if(g_normal[id][alinan_bicak] >= 5){
				g_bool[id][gbicaksinir]=true;
				g_normal[id][para]+= 15;
				rg_send_audio(id , g_szSounds[GOREV_SES]);
				#if defined Sprgoster
				@sprshow(id);
				#endif
			}
			else{
				client_print_color(id,id,"^3[^4%s^3] ^3Yeterli ^3Sayiya ^4ulasamadin",g_szdefines[tag]);
				rg_send_audio(id , g_szSounds[NO]);
				@gorevmenu(id);
			}
		}
		case 2: {
			if(g_bool[id][gbombasinir]){
				client_print_color(id,id,"^3[^4%s^3] ^3Bu ^3gorevi ^3daha once tamamladin",g_szdefines[tag]);
				rg_send_audio(id , g_szSounds[NO]);
				@gorevmenu(id);
			}
			else if(g_normal[id][alinanbomba] >= 5){
				g_bool[id][gbombasinir]=true;
				g_normal[id][para]+= 20;
				rg_send_audio(id , g_szSounds[GOREV_SES]);
				#if defined Sprgoster
				@sprshow(id);
				#endif
			}
			else{
				client_print_color(id,id,"^3[^4%s^3] ^3Yeterli ^3Sayiya ^4ulasamadin",g_szdefines[tag]);
				rg_send_audio(id , g_szSounds[NO]);
				@gorevmenu(id);
			}
		}
		case 3: {
			if(g_bool[id][gctsinir]){
				client_print_color(id,id,"^3[^4%s^3] ^3Bu ^3gorevi ^3daha once tamamladin",g_szdefines[tag]);
				rg_send_audio(id , g_szSounds[NO]);
				@gorevmenu(id);
			}
			else if(g_normal[id][ct_kill] >= 10){
				g_bool[id][gctsinir]=true;
				g_normal[id][para]+= 25;
				rg_send_audio(id , g_szSounds[GOREV_SES]);
				#if defined Sprgoster
				@sprshow(id);
				#endif
			}
			else{
				client_print_color(id,id,"^3[^4%s^3] ^3Yeterli ^3Sayiya ^4ulasamadin",g_szdefines[tag]);
				rg_send_audio(id , g_szSounds[NO]);
				@gorevmenu(id);
			}
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@bicakdegismenu(const id){
	new menu = menu_create(fmt("\r%s \w| \yBicak Degis Menu", g_szdefines[tag]), "@bicakdegismenu_devam");
	
	for(new i = 0; i < sizeof(bicakmodel); i++) {
		menu_additem(menu, fmt("\r%s \w| \y%s", g_szdefines[tag], bicakmodel[i][0]));
	}
	menu_setprop(menu, MPROP_EXITNAME,fmt( "\d%s \w| \yCikis", g_szdefines[tag]));
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
}
@bicakdegismenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !IsPlayerCanUse(id, true, true)) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	g_normal[id][gorunum] = item;
	rg_remove_item(id, "weapon_knife");
	rg_give_item(id, "weapon_knife", GT_REPLACE);
	rg_send_audio(id , g_szSounds[SI]);
	menu_destroy(menu);return PLUGIN_HANDLED;
}
@ctyebaskinbaslatmenu(const id){
	new menu = menu_create(fmt("\r%s \w| \yBaskin Baslat Menu", g_szdefines[tag]), "@ctyebaskinbaslatmenu_devam");
	
	menu_additem(menu, fmt("\r%s \w| \yBaskin Baslat \d[%d TL]^n", g_szdefines[tag], g_cvars[23]));
	menu_addtext(menu, "\dBaskin Baslatilinca");
	menu_addtext(menu, "\dHucre Kapisi Acilir");
	menu_addtext(menu, "\dElektrikler Kesilir");
	menu_addtext(menu, "\dTum Ct Glowlanir");
	menu_addtext(menu, "\dBaskin Muzigi Calmaya Baslar");
	
	menu_setprop(menu, MPROP_EXITNAME,fmt( "\d%s \w| \yCikis", g_szdefines[tag]));
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
}
@ctyebaskinbaslatmenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT || !IsPlayerCanUse(id, true, true)) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new players[MAX_PLAYERS],num;
	switch(item) {
		case 0: if(g_normal[id][para] >= g_cvars[23]){
			hucreyiac();
			set_lights("a");
			rh_emit_sound2(id ,0 , CHAN_AUTO, g_szSounds[BASKIN_SES]);
			get_players(players,num,"aechi","CT");
			static idv;
			for(new i ; i < num ; i++){
				idv = players[i];
				rg_set_user_render(idv,255,42,212);
			}
			client_print_color(0,0,"^3[^4%s^3] ^3Mahkumlardan biri ^4Baskin ^3baslatti!",g_szdefines[tag]);
			g_normal[id][para]-= g_cvars[23];
			g_bool[id][baskinsinir]=true;
			set_task(20.0,"@baskinbitir",id);
		}
		else{
			rg_send_audio(id , g_szSounds[NO]);
			@ctyebaskinbaslatmenu(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@baskinbitir(){
	set_lights("#OFF");
	client_print_color(0, 0, "^3[^4%s^3] ^4Mahkumlarin Baslattigi ^4Baskin ^3sona erdi.",g_szdefines[tag]);
}
@bilgimenu(const id){
	new menu = menu_create(fmt("\r%s \w| \yBilgi Menu", g_szdefines[tag]), "@bilgimenu_devam");
	
	menu_additem(menu, fmt("\r%s \w| \yJbmenu Sesleri Hakkinda Bilgi^n", g_szdefines[tag]));
	menu_additem(menu, fmt("\d%s \w| \dServer Ipmiz : %s", g_szdefines[tag],g_szdefines[serverip]));
	menu_additem(menu, fmt("\d%s \w| \dTs3 Ipmiz : %s", g_szdefines[tag],g_szdefines[ts3ip]));
	menu_additem(menu, fmt("\d%s \w| \dSuan Oynanan Harita : %s", g_szdefines[tag],mapcek));
	menu_additem(menu, fmt("\d%s \w| \dOyundaki Oyuncular : %d", g_szdefines[tag],get_playersnum()));
	
	menu_setprop(menu, MPROP_EXITNAME,fmt( "\d%s \w| \yCikis", g_szdefines[tag]));
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, menu);
	
}
@bilgimenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: {
			@sesmenu(id);
		}
		case 1: {
			@bilgimenu(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@sesmenu(const id){
	new menu = menu_create(fmt("\r%s \w| \yJbmenu Ses Bilgi Menu", g_szdefines[tag]), "@sesmenu_devam");
	
	menu_additem(menu, fmt("\r%s \w| \yBilgi Menuye Don^n", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \yDinlemek Icin Ses Secin", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \yJbmenu Satin Alma Sesi", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \yJbmenu Yetersiz Para Sesi", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \yJbmenu Gorev Tamamlama Sesi", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \yJbmenu Kasa Bos Sesi", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \yJbmenu Kasa Dolu Sesi", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \yAdam Oldu Sesi", g_szdefines[tag]));
	menu_additem(menu, fmt("\r%s \w| \yAdamya Adam Sesi", g_szdefines[tag]));
	
	menu_additem(menu, "\dCikis", "0", 0);
	menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
	menu_setprop(menu, MPROP_PERPAGE, 0);
	menu_display(id, menu);
}
@sesmenu_devam(const id, const menu, const item) {
	if(item == MENU_EXIT) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) {
		case 0: {
			@bilgimenu(id);
		}
		case 1: {
			@sesmenu(id);
		}
		case 2: {
			rg_send_audio(id , g_szSounds[SI]);
			@sesmenu(id);
		}
		case 3: {
			rg_send_audio(id , g_szSounds[NO]);
			@sesmenu(id);
		}
		case 4: {
			rg_send_audio(id , g_szSounds[GOREV_SES]);
			@sesmenu(id);
		}
		case 5: {
			rg_send_audio(id , g_szSounds[KASA_BOS]);
			@sesmenu(id);
		}
		case 6: {
			rg_send_audio(id , g_szSounds[KASA_DOLU]);
			@sesmenu(id);
		}
		case 7: {
			rg_send_audio(id , g_szSounds[ADAM_OLDU]);
			@sesmenu(id);
		}
		case 8: {
			rg_send_audio(id , g_szSounds[HG_SES]);
			@sesmenu(id);
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@mg(const id) {
	if(is_user_alive(id) && get_member(id,m_iTeam) == TEAM_CT) {
		new menu = menu_create(fmt("\r%s \w| \yMG - TL Menusu", g_szdefines[tag]), "@mg_devam");
		
		menu_additem(menu, fmt("\r%s \w| \yTL Ver", g_szdefines[tag]));
		menu_additem(menu, fmt("\r%s \w| \yTL Al", g_szdefines[tag]));
		menu_additem(menu, fmt("\r%s \w| \yToplu TL Ver \d[Sadece Yasayanlar]", g_szdefines[tag]));
		menu_additem(menu, fmt("\r%s \w| \yToplu TL Al \d[Sadece Yasayanlar]", g_szdefines[tag]));
		
		menu_setprop(menu, MPROP_EXITNAME,fmt( "\d%s \w| \yCikis", g_szdefines[tag]));
		menu_setprop(menu,MPROP_NUMBER_COLOR,"\d");
		menu_display(id, menu);
	}
}
@mg_devam(const id, const menu, const item){
	if(item == MENU_EXIT) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item) { 
		case 0: {
			g_normal[id][tlsec]=1;
			@mg_oyuncu(id);
		}
		case 1: {
			g_normal[id][tlsec]=2;
			@mg_oyuncu(id);
		}
		case 2: {
			g_normal[id][tlsec]=3;
			client_cmd(id, "messagemode TL_MIKTARI");
		}
		case 3: {
			g_normal[id][tlsec]=4;
			client_cmd(id, "messagemode TL_MIKTARI");
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@mg_oyuncu(const id) {
	new ndmenu[64],szName[32], szTempid[10], players[32], inum, ids;
	formatex(ndmenu, charsmax(ndmenu),"\r[%s] \w| \yOyuncu Sec.",g_szdefines[tag]);
	new Menu = menu_create(ndmenu, "@mg_oyuncu_devam");
	
	get_players(players,inum,"acehi","TERRORIST");
	for(new i=0; i<inum; i++) {
		ids=players[i];
		get_user_name(ids, szName, charsmax(szName));
		num_to_str(ids, szTempid, charsmax(szTempid));
		formatex(ndmenu, charsmax(ndmenu), "\y%s \w| \d[\r%i TL\d] \d[Canli]",szName,g_normal[ids][para]);
		menu_additem(Menu, ndmenu, szTempid);
	}
	get_players(players,inum,"bcehi","TERRORIST");
	for(new i=0; i<inum; i++) {
		ids=players[i];
		get_user_name(ids, szName, charsmax(szName));
		num_to_str(ids, szTempid, charsmax(szTempid));
		formatex(ndmenu, charsmax(ndmenu), "\y%s \w| \d[\r%i TL\d] \d[Olu]",szName,g_normal[ids][para]);
		menu_additem(Menu, ndmenu, szTempid);
	}
	menu_setprop(Menu, MPROP_EXITNAME, "\yCikis");
	menu_setprop(Menu,MPROP_NUMBER_COLOR,"\d");
	menu_display(id, Menu, 0);
}
@mg_oyuncu_devam(const id,const menu,const item) {
	if(item == MENU_EXIT) { menu_destroy(menu); return PLUGIN_HANDLED; }
	new access,callback,data[6],iname[64];
	menu_item_getinfo(menu,item,access,data,charsmax(data),iname,charsmax(iname),callback);
	g_normal[id][isimcek]=str_to_num(data);
	client_cmd(id, "messagemode TL_MIKTARI");
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
@TL_devam(const id) {
	if(!is_user_alive(id) || get_member(id, m_iTeam) == TEAM_TERRORIST || g_normal[id][tlsec]==0) return PLUGIN_HANDLED;
	
	new say[300]; read_args(say, charsmax(say)); remove_quotes(say);
	new miktar=str_to_num(say);
	if(!is_str_num(say) || equal(say, "") || miktar<=0) { client_print_color(id,id,"^1[^3%s^1] ^4Gecersiz miktar.",g_szdefines[tag]); g_normal[id][tlsec]=0; return PLUGIN_HANDLED; }
	new isim[32],name[32],ids=g_normal[id][isimcek]; get_user_name(id, isim, charsmax(isim)); get_user_name(ids, name, charsmax(name));
	if(g_normal[id][tlsec]==1 && ids!=0) {
		if(miktar > g_cvars[4]) {
			client_cmd(id, "messagemode TL_MIKTARI");
			client_print_color(id, id, "^3[^4%s^3] ^3En fazla ^1[^3 %i ^1]^4 TL verebilirsin.",g_szdefines[tag],g_cvars[4]);
			} else {
			g_normal[ids][para]+=miktar,g_normal[id][tlsec]=0,g_normal[id][isimcek]=0;
			client_print_color(0, 0, "^3[^4%s^3] ^3adli gardiyan ^1[^3%s^1]^4 adli mahkuma^1 %i TL^4 yolladi.",isim,name,miktar);
		}
		} else if(g_normal[id][tlsec]==2 && ids!=0) {
		if(miktar >= g_normal[ids][para]) {
			g_normal[ids][para]=0,g_normal[id][tlsec]=0,g_normal[id][isimcek]=0;
			client_print_color(0, 0, "^3[^4%s^3] ^3adli gardiyan ^1[^3%s^1]^4 adli mahkumun ^1tum parasini^4 aldi.",isim,name);
			} else {
			g_normal[ids][para]-=miktar,g_normal[id][tlsec]=0,g_normal[id][isimcek]=0;
			client_print_color(0, 0, "^3[^4%s^3] ^3adli gardiyan ^1[^3%s^1]^4 adli mahkumdan ^1%i TL^4 aldi.",isim,name,miktar);
		}
		} else if(g_normal[id][tlsec]==3) {
		if(miktar > g_cvars[4]) {
			client_cmd(id, "messagemode TL_MIKTARI");
			client_print_color(id, id, "^3[^4%s^3] ^3En fazla ^1[^3 %i ^1]^4 TL verebilirsin.",g_szdefines[tag],g_cvars[4]);
			} else {
			g_normal[id][tlsec]=0,g_normal[id][isimcek]=0;
			new players[32],inum,uid; get_players(players,inum,"acehi","TERRORIST"); //+c
			for(new i=0; i<inum; i++) uid=players[i],g_normal[uid][para]+=miktar;
			client_print_color(0, 0, "^3[^4%s^3] ^3adli gardiyan tum mahkumlara ^1%i TL^4 yolladi.",isim,miktar);
		}
		} else if(g_normal[id][tlsec]==4) {
		new players[32],inum,uid; get_players(players,inum,"acehi","TERRORIST"); //+c
		for(new i=0; i<inum; i++) {
			uid=players[i];
			if(g_normal[uid][para]-miktar <= 0) g_normal[uid][para]=0;
			else g_normal[uid][para]-=miktar;
		}
		g_normal[id][tlsec]=0,g_normal[id][isimcek]=0;
		client_print_color(0, 0, "^3[^4%s^3] ^3adli gardiyan tum mahkumlardan ^1%i TL^4 aldi.",isim,miktar);
	}
	return PLUGIN_HANDLED;
}

/* Extralar */

#if defined Sprgoster
const TaskId_ARS = 1337;
@sprshow(id){
	Show_Rank_Event(id);
	remove_task(id + TaskId_ARS);
	g_PlayerRankedUp[id] = true;
	set_task(6.0, "@Clear_Rank_Event", id + TaskId_ARS);
}
Show_Rank_Event(const id) {
	new ammo, weapon = get_user_weapon(id, ammo);
	
	switch(weapon) {
		case CSW_P228: SetMessage_WeaponList(id, 9, 52);
			case CSW_HEGRENADE: SetMessage_WeaponList(id, 12, 1);
			case CSW_XM1014: SetMessage_WeaponList(id, 5, 32);
			case CSW_C4: SetMessage_WeaponList(id, 14, 1);
			case CSW_MAC10: SetMessage_WeaponList(id, 6, 100);
			case CSW_AUG: SetMessage_WeaponList(id, 4, 90);
			case CSW_SMOKEGRENADE: SetMessage_WeaponList(id, 13, 1);
			case CSW_ELITE: SetMessage_WeaponList(id, 10, 120);
			case CSW_FIVESEVEN: SetMessage_WeaponList(id, 7, 100);
			case CSW_UMP45: SetMessage_WeaponList(id, 6, 100);
			case CSW_GALIL: SetMessage_WeaponList(id, 4, 90);
			case CSW_FAMAS: SetMessage_WeaponList(id, 4, 90);
			case CSW_USP: SetMessage_WeaponList(id, 6, 100);
			case CSW_GLOCK18: SetMessage_WeaponList(id, 10, 120);
			case CSW_MP5NAVY: SetMessage_WeaponList(id, 10, 120);
			case CSW_M249: SetMessage_WeaponList(id, 3, 200);
			case CSW_M3: SetMessage_WeaponList(id, 5, 32);
			case CSW_M4A1: SetMessage_WeaponList(id, 4, 90);
			case CSW_TMP: SetMessage_WeaponList(id, 10, 120);
			case CSW_FLASHBANG: SetMessage_WeaponList(id, 11, 2);
			case CSW_DEAGLE: SetMessage_WeaponList(id, 8, 35);
			case CSW_SG552: SetMessage_WeaponList(id, 4, 90);
			case CSW_AK47: SetMessage_WeaponList(id, 2, 90);
			case CSW_KNIFE: SetMessage_WeaponList(id, -1, -1);
			case CSW_P90: SetMessage_WeaponList(id, 7, 100);
			case CSW_SCOUT: SetMessage_WeaponList(id, 2, 90);
			case CSW_SG550: SetMessage_WeaponList(id, 4, 90);
			case CSW_AWP: SetMessage_WeaponList(id, 1, 30);
			case CSW_G3SG1: SetMessage_WeaponList(id, 2, 90);
			default: return;
	}
	
	SetMessage_SetFOV(id, 89);
	SetMessage_CurWeapon(id, ammo);
	SetMessage_SetFOV(id, 90);
}

@Clear_Rank_Event(TaskId) {
	new id = TaskId - TaskId_ARS;
	SetMessage_HideWeapon(id);
	g_PlayerRankedUp[id] = false;
}
SetMessage_WeaponList(const id, const pAmmoId, const pAmmoMaxAmount) {
	message_begin(MSG_ONE, pMsgIds[0], .player = id); {
		write_string(fmt("MsPassedRespect"));
		write_byte(pAmmoId);
		write_byte(pAmmoMaxAmount);
		write_byte(-1);
		write_byte(-1);
		write_byte(0);
		write_byte(11);
		write_byte(2);
		write_byte(0);
	}
	message_end();
}

SetMessage_SetFOV(const id, const FOV) {
	message_begin(MSG_ONE, pMsgIds[1], .player = id); {
		write_byte(FOV);
	}
	message_end();
}

SetMessage_CurWeapon(const id, const ammo) {
	message_begin(MSG_ONE, pMsgIds[2], .player = id); {
		write_byte(1);
		write_byte(2);
		write_byte(ammo);
	}
	message_end();
}

SetMessage_HideWeapon(const id) {
	message_begin(MSG_ONE, pMsgIds[3], .player = id);
	write_byte(0);
	message_end();
}
#endif
@skorla(const id){
	set_entvar(id,var_frags,0.0);
	set_member(id,m_iDeaths,0);
	message_begin(MSG_ALL,85);
	write_byte(id);
	write_short(0);write_short(0);write_short(0);write_short(0);
	message_end();
	client_print_color(0,0, "^3[^4%n^3] ^4Skorunu ^3Sifirladi.",id);
}
@oldurmek(const id){
	client_print_color(0,0, "^3[^4%n^3] ^4Kill ^3Cekti.",id);
	rg_send_audio(id , g_szSounds[ADAM_OLDU]);
	user_kill(id);
}
public hucreyiac(){
	new Float:radius = 200.0, Float:origin[3], ent = 1, ent2 = 1, ent3, name[32], pos;
	static found[10];
	
	while((pos <= sizeof(found)) && (ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "info_player_deathmatch"))) {
		get_entvar(ent, var_origin, origin);
		while((ent2 = engfunc(EngFunc_FindEntityInSphere, ent2, origin, radius))) {
			if(is_entity(ent2) && !FClassnameIs(ent2, "func_door")) continue;
			
			get_entvar(ent2, var_targetname, name, charsmax(name)); ent3=engfunc(EngFunc_FindEntityByString, 0, "target", name);
			if(is_entity(ent3) && (in_array(ent3, found, sizeof(found)) < 0)) {
				dllfunc(DLLFunc_Use, ent3, 0, 0, 1, 1.0),pos++;
				break;
			}
		}
	}
	return PLUGIN_HANDLED; //pos;
}
in_array(needle, data[], sized) {
	for(new i=0; i<sized; i++) 
		if(data[i] == needle) 
		return i;
	
	return -1;
}
rg_set_user_render(const id,const first=0,const secon=0,const third=0){
	new Float:RenderColor[3];RenderColor[0]=float(first);RenderColor[1]=float(secon);RenderColor[2]=float(third);
	set_entvar(id,var_renderfx,kRenderFxGlowShell);
	set_entvar(id,var_rendercolor,RenderColor);
	set_entvar(id,var_rendermode,kRenderNormal);
	set_entvar(id,var_renderamt,50.0);
}
bool:IsPlayerCanUse(const id, const bool:bAlive, const bool:bLastPlayer) {
	if(bAlive && !is_user_alive(id)) {
		client_print_color(id, id, "^3[^4%s^3] ^3Oluyken bu islemi yapamazsin!", g_szdefines[tag]);
		return false;
	}
	if(bLastPlayer) {
		new at,act;
		rg_initialize_player_counts(at,act);
		if(at == 1) {
			client_print_color(id, id, "^3[^4%s^3] ^3Sona bir ^4Mahkum ^3kalinca bu islemi yapamazsin!", g_szdefines[tag]);
			return false;
		}
	}
	return true;
}
public plugin_natives() {
	register_native("jb_get_user_packs", "@jb_get_user_packs");
	register_native("jb_set_user_packs", "@jb_set_user_packs");
}
@jb_get_user_packs() {
	new id = get_param(1);

	return g_normal[id][para];
}
@jb_set_user_packs() {
	new id = get_param(1);
	new iAmount = get_param(2);

	g_normal[id][para] = iAmount;
	return PLUGIN_HANDLED;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/
