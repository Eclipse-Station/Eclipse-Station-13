/*
 * Tip of the Round.
 * Here you can set or send a tip of the round. Includes tip of the round proc,
 * from the game controller define, plus the vars we added. This is done so that
 * we leave as small a footprint on the master file as possible.
 */

/datum/controller/gameticker		// Variables we add go here.
	var/tip_sent = FALSE		//has the tip of the round been sent?
	var/send_tip_at = 30		//send tip at this many seconds left
	var/chosen_tip = ""			//empty string
	var/tip_text_file = 'config/strings/tips.txt'		//location of the tips
	var/silly_tip_text_file = 'config/strings/sillytips.txt'			//location of the not-so-serious tips

/datum/controller/gameticker/proc/send_tip_of_the_round()
	var/message
	if(chosen_tip)
		message = chosen_tip
	else
		var/list/randomtips = file2list(tip_text_file)
		var/list/memetips = file2list(silly_tip_text_file)
		if(randomtips.len && prob(95))
			message = pick(randomtips)
		else if(memetips.len)
			message = pick(memetips)

	if(message)
		to_chat(world, "<font color='purple'><b>Tip of the round: </b>[html_encode(message)]</font>")
		tip_sent = TRUE
		
/client/proc/cmd_admin_show_tip()
	set category = "Special Verbs"
	set name = "Show Tip"
	set desc = "Sends a tip (that you specify) to all players. After all \
		you're the experienced player here."

	if(!check_rights(R_VAREDIT))
		return

	var/input = input(usr, "Please specify your tip that you want to send to the players.", "Tip", "") as message|null
	if(!input)
		return

	if(!ticker)
		return

	ticker.chosen_tip = input

	// If we've already tipped, then send it straight away.
	if(ticker.tip_sent)
		ticker.send_tip_of_the_round()


	message_admins("[key_name_admin(usr)] sent a tip of the round.")
	log_admin("[key_name(usr)] sent \"[input]\" as the Tip of the Round.")
