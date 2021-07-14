#pragma semicolon 1

#include <amxmodx>
#include <amxmisc>
#include <reapi>

new const tag[]="TeamTR";

public plugin_init() {
	register_plugin("Bos Menu", "0.1", "bilalgecer47");

	register_concmd("amx_weaponrev", "admin_rev", ADMIN_LEVEL_C, "<nick, #userid, authid or @team> <weapon #>");
}

new const RLWT[33] = {12,11,14,13,16,15,21,22,31,32,33,34,35,40,41,42,43,44,45,46,47,48,49,51,83,85,84,87,91,1,81,82,86};

new const weapons[33][] = {
	"weapon_usp","weapon_glock18","weapon_deagle","weapon_p228","weapon_elite","weapon_fiveseven","weapon_m3","weapon_xm1014",
	"weapon_tmp","weapon_mac10","weapon_mp5navy","weapon_p90","weapon_ump45","weapon_famas","weapon_galil","weapon_ak47",
	"weapon_m4a1","weapon_sg552","weapon_aug","weapon_scout","weapon_sg550","weapon_awp","weapon_g3sg1","weapon_m249",
	"weapon_hegrenade","weapon_smokegrenade","weapon_flashbang","weapon_shield","weapon_c4",
	"weapon_knife","item_kevlar","item_assaultsuit","item_thighpack"
};
public admin_rev(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 2))
	{
		return PLUGIN_HANDLED;
	}

	new arg[32], weapon;
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg, charsmax(arg));
	weapon = str_to_num(arg);
	
	if(!weapon)
	{
		for(new i=0; i < 30; i++)
		{
			if(containi(arg, weapons[i][7]) != -1)
			{
				weapon = RLWT[i];
				break;
			}
		}
	}

	new xweapon[64];

	for(new y = 0; y < sizeof(RLWT); y++)
	{
		if(RLWT[y] == weapon)
		{
			copy(xweapon, charsmax(xweapon), weapons[y]);
		}
	}

	replace_all(xweapon, charsmax(xweapon), "weapon_", "");

	read_argv(1, arg, charsmax(arg));
	
	if(arg[0] == '@')
	{
		new players[32], inum;

		if(equali("T", arg[1])) copy(arg[1], charsmax(arg), "TERRORIST");
		if(equali("ALL", arg[1])) get_players(players, inum);
		else get_players(players, inum, "e", arg[1]);

		if(inum == 0)
		{
			console_print(id, "[%s] Takim bulunamadi.", tag);
			return PLUGIN_HANDLED;
		}

		static Uid;
		for(new i=0; i<inum; i++)
		{
			Uid = players[i];
			rg_round_respawn(Uid);
			rg_give_weapon(Uid, weapon);
		}

		client_print_color(0, 0, "^3ADMIN ^4%s^1: ^3%s ^4takimini ^3revledi^1.", GetUserName(id), arg[1]);
		console_print(id, "[%s] %s takimini revledin.", tag, arg[1]);
	}
	else {
		new Uid = cmd_target(id, arg,3);
		if(!Uid) return PLUGIN_HANDLED;

		rg_round_respawn(Uid);
		rg_give_weapon(Uid, weapon);

		client_print_color(0, 0, "^3ADMIN ^4%s^1: ^3%s ^4adli oyuncuyu ^3revledin^1.", GetUserName(id), GetUserName(Uid));
		console_print(id, "[%s] %s adli oyuncuyu revledi.", tag, GetUserName(Uid));
		
	}
	return PLUGIN_HANDLED;
}

rg_give_weapon(id, weapon)
{
	switch(weapon)
	{
		case 1: {
			rg_give_item(id, "weapon_knife");
		}
		case 11: {
			rg_give_item(id, "weapon_glock18");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
		}
		case 12: {
			rg_give_item(id, "weapon_usp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
		}
		case 13: {
			rg_give_item(id, "weapon_p228");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
		}
		case 14:{
			rg_give_item(id, "weapon_deagle");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
		}
		case 15:{
			rg_give_item(id, "weapon_fiveseven");
			rg_give_item(id, "ammo_57mm");
			rg_give_item(id, "ammo_57mm");
			rg_give_item(id, "ammo_57mm");
			rg_give_item(id, "ammo_57mm");
		}
		case 16:{
			rg_give_item(id, "weapon_elite");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
		}
		case 17:{
			rg_give_item(id, "weapon_usp");
			rg_give_item(id, "weapon_glock18");
			rg_give_item(id, "weapon_deagle");
			rg_give_item(id, "weapon_p228");
			rg_give_item(id, "weapon_elite");
			rg_give_item(id, "weapon_fiveseven");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
 			rg_give_item(id, "ammo_57mm");
			rg_give_item(id, "ammo_57mm");
			rg_give_item(id, "ammo_57mm");
			rg_give_item(id, "ammo_57mm");
		}
		case 21:{
			rg_give_item(id, "weapon_m3");
			rg_give_item(id, "ammo_buckshot");
			rg_give_item(id, "ammo_buckshot");
			rg_give_item(id, "ammo_buckshot");
			rg_give_item(id, "ammo_buckshot");
		}
		case 22:{

			rg_give_item(id, "weapon_xm1014");
			rg_give_item(id, "ammo_buckshot");
			rg_give_item(id, "ammo_buckshot");
			rg_give_item(id, "ammo_buckshot");
			rg_give_item(id, "ammo_buckshot");
		}
		case 31:{
			rg_give_item(id, "weapon_tmp");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
		}
		case 32:{
			rg_give_item(id, "weapon_mac10");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
		}
		case 33:{
			rg_give_item(id, "weapon_mp5navy");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
		}
		case 34:{
			rg_give_item(id, "weapon_p90");
			rg_give_item(id, "ammo_57mm");
			rg_give_item(id, "ammo_57mm");
 			rg_give_item(id, "ammo_57mm");
			rg_give_item(id, "ammo_57mm");
		}
		case 35:{ 
			rg_give_item(id, "weapon_ump45");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
		}
		case 40:{
			rg_give_item(id, "weapon_famas");
			rg_give_item(id, "ammo_556nato");
			rg_give_item(id, "ammo_556nato");
			rg_give_item(id, "ammo_556nato");
		}
		case 41:{
			rg_give_item(id, "weapon_galil");
			rg_give_item(id, "ammo_556nato");
			rg_give_item(id, "ammo_556nato");
			rg_give_item(id, "ammo_556nato");
		}
		case 42:{
			rg_give_item(id, "weapon_ak47");
			rg_give_item(id, "ammo_762nato");
			rg_give_item(id, "ammo_762nato");
			rg_give_item(id, "ammo_762nato");
		}
		case 43:{
			rg_give_item(id, "weapon_m4a1");
			rg_give_item(id, "ammo_556nato");
			rg_give_item(id, "ammo_556nato");
			rg_give_item(id, "ammo_556nato");
		}
		case 44:{
			rg_give_item(id, "weapon_sg552");
			rg_give_item(id, "ammo_556nato");
			rg_give_item(id, "ammo_556nato");
			rg_give_item(id, "ammo_556nato");
		}
		case 45:{
			rg_give_item(id, "weapon_aug");
			rg_give_item(id, "ammo_556nato");
			rg_give_item(id, "ammo_556nato");
			rg_give_item(id, "ammo_556nato");
		}
		case 46:{
			rg_give_item(id, "weapon_scout");
			rg_give_item(id, "ammo_762nato");
			rg_give_item(id, "ammo_762nato");
			rg_give_item(id, "ammo_762nato");
		}
		case 47:{
			rg_give_item(id, "weapon_sg550");
			rg_give_item(id, "ammo_556nato");
			rg_give_item(id, "ammo_556nato");
			rg_give_item(id, "ammo_556nato");
		}
		case 48:{
			rg_give_item(id, "weapon_awp");
			rg_give_item(id, "ammo_338magnum");
			rg_give_item(id, "ammo_338magnum");
			rg_give_item(id, "ammo_338magnum");
		}
		case 49:{
			rg_give_item(id, "weapon_g3sg1");
			rg_give_item(id, "ammo_762nato");
			rg_give_item(id, "ammo_762nato");
			rg_give_item(id, "ammo_762nato");
		}
		case 51:{
			rg_give_item(id, "weapon_m249"); 
			rg_give_item(id, "ammo_556natobox");
			rg_give_item(id, "ammo_556natobox");
			rg_give_item(id, "ammo_556natobox");
			rg_give_item(id, "ammo_556natobox");
			rg_give_item(id, "ammo_556natobox");
			rg_give_item(id, "ammo_556natobox");
			rg_give_item(id, "ammo_556natobox");
		}
		case 60:{
			rg_give_shield(id);
			rg_give_item(id, "weapon_glock18");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "weapon_hegrenade");
			rg_give_item(id, "weapon_flashbang");
			rg_give_item(id, "weapon_flashbang");
			rg_give_item(id, "item_assaultsuit");
		}
		case 61:{
			rg_give_shield(id);
			rg_give_item(id, "weapon_usp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "weapon_hegrenade");
			rg_give_item(id, "weapon_flashbang");
			rg_give_item(id, "weapon_flashbang");
			rg_give_item(id, "item_assaultsuit");
		}
		case 62:{
			rg_give_shield(id);
			rg_give_item(id, "weapon_p228");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "weapon_hegrenade");
			rg_give_item(id, "weapon_flashbang");
			rg_give_item(id, "weapon_flashbang");
			rg_give_item(id, "item_assaultsuit");
		}
		case 63:{
			rg_give_shield(id);
			rg_give_item(id, "weapon_deagle");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "weapon_hegrenade");
			rg_give_item(id, "weapon_flashbang");
			rg_give_item(id, "weapon_flashbang");
			rg_give_item(id, "item_assaultsuit");
		}
		case 64:{
			rg_give_shield(id);
			rg_give_item(id, "weapon_fiveseven");
			rg_give_item(id, "ammo_57mm");
			rg_give_item(id, "ammo_57mm");
			rg_give_item(id, "ammo_57mm");
			rg_give_item(id, "ammo_57mm");
			rg_give_item(id, "weapon_hegrenade");
			rg_give_item(id, "weapon_flashbang");
			rg_give_item(id, "weapon_flashbang");
			rg_give_item(id, "item_assaultsuit");
		}
		case 81:{
			rg_give_item(id, "item_kevlar");
		}
		case 82:{
			rg_give_item(id, "item_assaultsuit");
		}
		case 83:{
			rg_give_item(id, "weapon_hegrenade");
		}
		case 84:{
			rg_give_item(id, "weapon_flashbang");
			rg_give_item(id, "weapon_flashbang");
		}
		case 85:{
			rg_give_item(id, "weapon_smokegrenade");
		}
		case 86:{
			rg_give_item(id, "item_thighpack");
		}
		case 87:{
			rg_give_shield(id);
		}
		case 88:{
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_45acp");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_357sig");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_9mm");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_57mm");
			rg_give_item(id, "ammo_57mm");
			rg_give_item(id, "ammo_57mm");
			rg_give_item(id, "ammo_57mm");
			rg_give_item(id, "ammo_buckshot");
			rg_give_item(id, "ammo_buckshot");
			rg_give_item(id, "ammo_buckshot");
			rg_give_item(id, "ammo_buckshot");
			rg_give_item(id, "ammo_556nato");
			rg_give_item(id, "ammo_556nato");
			rg_give_item(id, "ammo_556nato");
			rg_give_item(id, "ammo_762nato");
			rg_give_item(id, "ammo_762nato");
			rg_give_item(id, "ammo_762nato");
			rg_give_item(id, "ammo_338magnum");
			rg_give_item(id, "ammo_338magnum");
			rg_give_item(id, "ammo_338magnum");
			rg_give_item(id, "ammo_556natobox");
			rg_give_item(id, "ammo_556natobox");
			rg_give_item(id, "ammo_556natobox");
			rg_give_item(id, "ammo_556natobox");
			rg_give_item(id, "ammo_556natobox");
			rg_give_item(id, "ammo_556natobox");
			rg_give_item(id, "ammo_556natobox");
		}
		case 89:{
			rg_give_item(id, "weapon_hegrenade");
			rg_give_item(id, "weapon_smokegrenade");
			rg_give_item(id, "weapon_flashbang");
			rg_give_item(id, "weapon_flashbang");
		}
		case 91:{
			rg_give_item(id, "weapon_c4");
		}
		case 100:{
			rg_give_item(id, "weapon_awp");
			rg_give_item(id, "weapon_deagle");
			rg_give_item(id, "weapon_hegrenade");
			rg_give_item(id, "weapon_flashbang");
			rg_give_item(id, "weapon_flashbang");
			rg_give_item(id, "weapon_smokegrenade");
			rg_give_item(id, "ammo_338magnum");
			rg_give_item(id, "ammo_338magnum");
			rg_give_item(id, "ammo_338magnum");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "ammo_50ae");
			rg_give_item(id, "item_assaultsuit");
		}
		case 200: {
			rg_give_weapon(id, 12);
			rg_give_weapon(id, 11);
			rg_give_weapon(id, 14);
			rg_give_weapon(id, 13);
			rg_give_weapon(id, 16);
			rg_give_weapon(id, 15);
			set_task(random_float(0.1, 1.5), "task0", id);
			set_task(random_float(0.1, 1.5), "task1", id);
			set_task(random_float(0.1, 1.5), "task2", id);
			set_task(random_float(0.1, 1.5), "task3", id);
		}
		default: {
			return false;
		}
	}
	return true;
}

public task0(const id)
{
	if(!is_user_alive(id))
	{
		return;
	}

	rg_give_weapon(id, 21);
	rg_give_weapon(id, 22);
	rg_give_weapon(id, 31);
	rg_give_weapon(id, 32);
	rg_give_weapon(id, 33);
	rg_give_weapon(id, 34);
	rg_give_weapon(id, 35);
}

public task1(const id)
{
	if(!is_user_alive(id))
	{
		return;
	}

	rg_give_weapon(id, 40);
	rg_give_weapon(id, 41);
	rg_give_weapon(id, 42);
	rg_give_weapon(id, 43);
	rg_give_weapon(id, 44);
	rg_give_weapon(id, 45);
}

public task2(const id)
{
	if(!is_user_alive(id))
	{
		return;
	}

	rg_give_weapon(id, 46);
	rg_give_weapon(id, 47);
	rg_give_weapon(id, 48);
	rg_give_weapon(id, 49);
	rg_give_weapon(id, 51);
	rg_give_weapon(id, 83);
}

public task3(const id)
{
	if(!is_user_alive(id))
	{
		return;
	}

	rg_give_weapon(id, 84);
	rg_give_weapon(id, 85);
	rg_give_weapon(id, 82);
}
GetUserName(const id){
	static name[32];
	get_user_name(id, name, charsmax(name));

	return name;
}

/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/
