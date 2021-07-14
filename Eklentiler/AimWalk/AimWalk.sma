#include <amxmodx>
#include <reapi>

new const tag[] = "CSDuragi";

new gitmesayi[MAX_CLIENTS+1],ucret,gitmecvar;

public plugin_init() {
	register_plugin("Aim Walk", "1.0", "BİLΛL YILMΛZ");
	
	RegisterHookChain(RG_CBasePlayer_Spawn,"@oyuncudogdu",.post=true);
	register_clcmd("say /git", "@ileri");
	register_clcmd("radio2", "@ileri");
	bind_pcvar_num(create_cvar("gitme_sayi","3"), gitmecvar);
	bind_pcvar_num(create_cvar("gitme_fiyat","-200"), ucret);
	set_task(15.0,"@Bilgiver",4443);
}
@oyuncudogdu(id){
	gitmesayi[id]=0;
}
@ileri(id){
	new at,act
	rg_initialize_player_counts(at,act);
	if(gitmesayi[id] >= gitmecvar && gitmecvar > 0) {
		client_print_color(id,id,"^4%s Hey, ^3Ileri Gitme Hakkini bitirdin.",tag,gitmecvar);
	}
	else if(!is_user_alive(id)) client_print_color(id,id,"^4%s Hey, ^3Oluyken Nasil Ileri Gidiceksin!",tag);
	else if(at <= 1) client_print_color(id,id,"^4%s Hey, ^3Sona bir tane mahkum kalinca Ileri Gitme alamazsiniz.",tag);
	else if(get_member(id, m_iAccount) < ucret) {
		client_print_color(id,id,"^4%s Hey, ^3Ileri Gitme almak icin yeterli paraniz yok. Gereken ^4$%d",tag,ucret);
	}
	else {
		rg_add_account(id, get_member(id, m_iAccount) - ucret, AS_SET);
		new Float:velo[3];
		velocity_by_aim(id,1500,velo);
		velo[2] = 0.0;
		set_entvar(id,var_velocity,velo);
		if(gitmecvar > 0) {
			gitmesayi[id]++;
			client_print_color(id,id,"^4%s Hey, ^3basarili bir sekilde Ileri gittin ^3[^4Kalan Hak : %d^3]",tag,gitmecvar-gitmesayi[id]);
		}
	}
	return PLUGIN_HANDLED;
}
@Bilgiver() {
	client_print_color(0, 0, "^4! ^3BILGI ^4! ^3Bu Serverde ^4Aim-Walk ^3Eklentisi Vardýr!");
	client_print_color(0, 0, "^4! ^3BILGI ^4! ^3Kullanmak konsola icin ^4bind ^"x say /git^" ^3yazabilirsiniz.");
	client_print_color(0, 0, "^4! ^3BILGI ^4! ^3X Tusuna bastiginizda hizlanirsiniz.");
	set_task(80.0,"@Bilgiver",4443);
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/
