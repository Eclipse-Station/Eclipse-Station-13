var/list/aeiou_whitelist = list()

/hook/startup/proc/loadaeiouwhitelist()
	load_aeiouwhitelist()
	return 1

/proc/load_aeiouwhitelist()
	var/text = file2text("config/playerwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/playerwhitelist.txt")
	else
		aeiou_whitelist = splittext(text, "\n")


/proc/is_player_whitelisted(mob/M)
//	if(check_rights(R_ADMIN, 0))
//		return 1
	if(!aeiou_whitelist)
		log_misc("nestor you fucked up!")
		return 0
	for (var/s in aeiou_whitelist)
		if(findtext(s,"[lowertext(M.ckey)]"))
			return 1
		if(findtext(s,"[replacetext(lowertext(M.ckey), " ", "")]"))
			return 1
	log_misc("[lowertext(M.ckey)] tried to join, but they're not whitelisted!")
	return 0

/proc/is_key_whitelisted(var/checkKey)
//	if(check_rights(R_ADMIN, 0))
//		return 1
	if(!aeiou_whitelist)
		log_misc("nestor you fucked up!")
		return 0
	for (var/s in aeiou_whitelist)
		if(findtext(s,"[lowertext(checkKey)]"))
			return 1
		if(findtext(s,"[replacetext(lowertext(checkKey), " ", "")]"))
			return 1
	return 0


/mob/new_player/proc/discord_redirect(var/mob/u)
	u << "<span class='notice'>You are not whitelisted! Join our discord server at https://discord.gg/xuS4t9U to get whitelisted.</span>"


/client/proc/add_to_whitelist()
	set name = "Add CKEY to whitelist"
	set category = "Admin"

	if(!check_rights(R_ADMIN)) return

	var/userkey = input(src, "Enter the ckey. Leave blank to cancel.", "Add to Whitelist")
	if(userkey)
		if (!aeiou_whitelist)
			usr << ("Failed to load config/playerwhitelist.txt")
		if(is_key_whitelisted(userkey))
			usr << ("User is already whitelisted")
			return
		else
//			userkey += "\n" bad idea
			text2file(replacetext(lowertext(userkey), " ", ""), "config/playerwhitelist.txt")


/client/proc/reload_whitelist()
	set name = "Reload Whitelists"
	set category = "Admin"

	if(!check_rights(R_ADMIN)) return
	load_aeiouwhitelist()
	load_jobwhitelist()