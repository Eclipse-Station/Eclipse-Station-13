/proc/lobby_message(var/message = "Debug Message", var/color = "#FFFFFF", var/sender)
	if (!config.chat_webhook_url || !message)
		return
	spawn(0)
		var/query_string = "type=lobbyalert"
		query_string += "&key=[url_encode(config.chat_webhook_key)]"
		query_string += "&msg=[url_encode(message)]"
		query_string += "&color=[url_encode(color)]"
		if(sender)
			query_string += "&from=[url_encode(sender)]"
		world.Export("[config.chat_webhook_url]?[query_string]")



/client/proc/discord_msg()
	set name = "Message Lobby"
	set category = "Admin"

	if(!check_rights(R_ADMIN)) return

	var/msg = input(src, "Enter the message. Leave blank to cancel.", "Lobby Message")
	if(msg)
		log_and_message_admins("has sent a message in discord lobby")
		lobby_message(message = msg, color = "#79FE5F")


/client/proc/discord_test()
	set name = "Send test message"
	set category = "Admin"
	lobby_message(message = "Transfer shuttle is on its way! Round ends very soon! <@&439778970599292938>", color = "#FE9500") //AEIOUstation add

