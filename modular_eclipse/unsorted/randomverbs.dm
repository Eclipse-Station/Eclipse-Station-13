/client/proc/cmd_admin_subtle_message_unsafe(mob/M as mob in mob_list)
	set category = "Special Verbs"
	set name = "Unsafe Subtle Message"

	if(!ismob(M))	return
	if (!holder)
		src << "Only administrators may use this command."
		return

	var/msg = input("Message:", text("Subtle PM to [M.key]")) as text

	if (!msg)
		return
	if(usr)
		if (usr.client)
			if(usr.client.holder)
				M << "<B>You hear a voice in your head...</B> <i>[msg]</i>"

	log_admin("SubtlePM: [key_name(usr)] -> [key_name(M)] : [msg]")
	msg = "<span class='adminnotice'><b> SubtleMessage: [key_name_admin(usr)] -> [key_name_admin(M)] :</b> [msg]</span>"
	message_admins(msg)
	admin_ticket_log(M, msg)

/client/proc/cmd_admin_world_narrate_unsafe() // Allows administrators to fluff events a little easier -- TLE
	set category = "Special Verbs"
	set name = "Unsafe Global Narrate"

	if (!holder)
		src << "Only administrators may use this command."
		return

	var/msg = input("Message:", text("Enter the text you wish to appear to everyone:")) as text

	if (!msg)
		return
	world << "[msg]"
	log_admin("GlobalNarrate: [key_name(usr)] : [msg]")
	message_admins("<font color='blue'><B> GlobalNarrate: [key_name_admin(usr)] : [msg]<BR></B></font>", 1)

/client/proc/cmd_admin_direct_narrate_unsafe(var/mob/M)	// Targeted narrate -- TLE
	set category = "Special Verbs"
	set name = "Unsafe Direct Narrate"

	if(!holder)
		src << "Only administrators and moderators may use this command."
		return

	if(!M)
		M = input("Direct narrate to who?", "Active Players") as null|anything in get_mob_with_client_list()

	if(!M)
		return

	var/msg = input("Message:", text("Enter the text you wish to appear to your target:")) as text

	if( !msg )
		return

	to_chat(M, msg)
	log_admin("DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]")
	msg = "<span class='adminnotice'><b> DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]):</b> [msg]<BR></span>"
	message_admins(msg)
	admin_ticket_log(M, msg)