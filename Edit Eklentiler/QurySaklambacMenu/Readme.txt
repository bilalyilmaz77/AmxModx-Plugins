Komutlar : 
    new const menuclcmd[][]={
        "nightvision","say /saklambacmenu","say !saklambacmenu","say .saklambacmenu","say_team /saklambacmenu",
        "say_team !saklambacmenu","say_team .saklambacmenu", "say /jbmenu","say .jbmenu","say /csg","say /bbmenu"
    };
Cvar Ayarlari :
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
Kurucular için Para verme :
register_concmd("amx_paraver","@paraver");
Ayarlanmasi gereken kisimlar :
new const g_sztags[tags][] = {
    "TeamTR",
    "213.238.173.77",
    "TeamTR Community"
};