Komutlar :
    new const menuclcmd[][]={
        "say /jbmenu","say .jbmenu","say jbmenu","say /jbm","say /csg","say /bbmenu"        //Jbmenüye Giriş Komutları
    };
    new const sifirlaclcmd[][]={
        "say /reset","say /rs","say !reset","say !rs","say .reset","say .rs"                     //Skor Resetleme Komutları
    };
    new const oldurclcmd[][]={
        "say /kill","say .kill","say /k"                                            //Kill Çekme Komutları
    };
    register_clcmd("say /mg", "@mg");                  //Tl Verme
    register_clcmd("say /tl", "@mg");                          //Tl Verme
Cvar Ayarları :
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

register_concmd("amx_isyanbaslat","@isyanbaslat",ADMIN_RCON,"<acik:1 | kapali:0>, isyanteam kurar");           //İsyanTeam Menüyü Açar

Düzenlenmesi Gereken Kısımlar ;

/* Gorev yapinca spr gostermesini istiyorsaniz ellemeyin.Istemiyorsaniz basina // koyun  */

#define Sprgoster 1

/* Bu Kismi Kendinize gore duzenleyin  */

new const tag[] = "CSDuragi";
new const ts3ip[] = "Ts3.Csduragi.Com";
new const serverip[] = "Cs00.Csduragi.Com";

static const slotbonus = ADMIN_RESERVATION;
static const adminbonus = ADMIN_MAP;
static const yoneticibonus = ADMIN_RCON;

static const isyanteam_baskan = ADMIN_RCON;
static const isyanteam_uye = ADMIN_RESERVATION;
