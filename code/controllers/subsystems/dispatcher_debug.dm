// Debugging code relating to player tracking system (dispatcher_eclipse.dm)
var/global/ptrack_dump_in_progress = FALSE

/client/proc/dump_tracking()		//Dumps player tracking information to a file.
	set category = "Debug"
	set name = "Dump tracking data"
	set desc = "Dumps debugging information from the player tracking subsystem to a file."

	if(!check_rights(R_DEBUG)) return
	
	if(ptrack_dump_in_progress)
		to_chat(usr, "<span class='danger'> A player tracking dump is already in progress. You should wait until it is completed before you start another.</span>")
		return

	var/supersecretpasscode = rand(1000,9999)
	
	var/codecheck = input(usr,"WARNING - READ CAREFULLY BEFORE PROCEEDING! \n\n You are about to dump the player tracking data to a file. Because most of this is rate limited to reduce performance costs, this operation could take some time to complete (iterations that are not are marked \"NRL\"). If you don't know what need you would have for this, you probably should not continue. If you know what you are doing or you have been asked to do this, enter the code \"[supersecretpasscode]\" to begin this operation. Leave blank to cancel. Dump files are saved in the same directory as this round's logs.","Confirm tracking data dump?") as null|num
	
	if(!codecheck)		//blank entry
		to_chat(usr, "<span class='warning'>Confirmation check failed - no entry. Tracking data dump canceled.</span>")
		return

	if(codecheck != supersecretpasscode)		//wrong number
		to_chat(usr, "<span class='warning'>Confirmation check failed - entry mismatch. Tracking data dump canceled.</span>")
		return

	message_admins("[key_name(src)] began a player tracking data dump.")
	log_admin("[key_name(src)] began a player tracking data dump.")
	
	ptrack_dump_in_progress = TRUE
	
	var/dump_log = start_log("[log_path]-ptrack.[time2text(world.realtime, "YYYYMMDDhhmmss")].log")		//let's one logfile per dump
	sleep(10)
	try
		ASSERT(dump_log)		//if it don't exist, well, shit's fucked anyway and this isn't going to work.
	catch
		to_chat(usr, "<span class='danger'>PTrack dump failed: the dump file could not be assigned to a variable for writing.</span>")
		CRASH("Could not assign logfile to variable for writing")
	WRITE_LOG(dump_log, " Player Tracking Dump")
	WRITE_LOG(dump_log, "   Tracking dump initialized by [usr.ckey]")
	WRITE_LOG(dump_log, " ---")
	WRITE_LOG(dump_log, " Tracking statistics (as of start of dump):")		//begin with printing statistics
	WRITE_LOG(dump_log, "   TOTAL:[dispatcher.tracked_players_all.len]")
	WRITE_LOG(dump_log, "   HEADS [dispatcher.tracked_players_cmd.len]")
	WRITE_LOG(dump_log, "   ENGIS [dispatcher.tracked_players_eng.len]")
	WRITE_LOG(dump_log, "   SECUR [dispatcher.tracked_players_sec.len]")
	WRITE_LOG(dump_log, "   MEDIC [dispatcher.tracked_players_med.len]")
	WRITE_LOG(dump_log, "   RSRCH [dispatcher.tracked_players_sci.len]")
	WRITE_LOG(dump_log, "   CARGO [dispatcher.tracked_players_crg.len]")
	WRITE_LOG(dump_log, "   OTHER [dispatcher.tracked_players_svc.len]")
	WRITE_LOG(dump_log, " ################################################################################")
	
	sleep(10)
	var/stopwatch = world.time		//tick tock.
	
	to_chat(usr, "<span class='danger'>Beginning PTrack dump - iteration 1...</span>")
	WRITE_LOG(dump_log, " Beginning iteration 1 (all connected mobs with associated ckey)")
	WRITE_LOG(dump_log, " keyname - Type (NP = lobby, OB = observer, SI = silicon, HU = humanoid, SA = simpleanimal)")
	
	for(var/mob/M in world)
		if(!M.ckey)
			sleep(1)
			continue

		var/mob_assoc = ""
		if(isnewplayer(M))
			mob_assoc += "NP "
		if(isobserver(M))
			mob_assoc += "OB "
		if(issilicon(M))
			mob_assoc += "SI "
		if(ishuman(M))
			mob_assoc += "HU "
		if(isanimal(M))
			mob_assoc += "SA "
		
		WRITE_LOG(dump_log, " [key_name(M)] - [mob_assoc]")
		sleep(1)
		continue
	
	WRITE_LOG(dump_log, " First iteration complete.")
	sleep(5)
	WRITE_LOG(dump_log, " ---------------")
	WRITE_LOG(dump_log, " Beginning iteration 2 (player list dump)")
	WRITE_LOG(dump_log, " keyname - Type (NP = lobby, OB = observer, SI = silicon, HU = humanoid, SA = simpleanimal)")
	to_chat(usr, "<span class='danger'>Beginning PTrack dump - iteration 2...</span>")
	
	for(var/mob/M in player_list)
		var/mob_assoc = ""
		if(isnewplayer(M))
			mob_assoc += "NP "
		if(isobserver(M))
			mob_assoc += "OB "
		if(issilicon(M))
			mob_assoc += "SI "
		if(ishuman(M))
			mob_assoc += "HU "
		if(isanimal(M))
			mob_assoc += "SA "
		
		WRITE_LOG(dump_log, " [key_name(M)] - [mob_assoc]")
		sleep(1)
		continue
	WRITE_LOG(dump_log, " Iteration 2 complete.")
	sleep(5)
	sleep(5)
	WRITE_LOG(dump_log, " ---------------")
	WRITE_LOG(dump_log, " Beginning iteration 3 (PTrack master list dump)")
	WRITE_LOG(dump_log, " keyname - Assignment ")
	to_chat(usr, "<span class='danger'>Beginning PTrack dump - iteration 3 (NRL)...</span>")
	for(var/mob/M in dispatcher.tracked_players_all)
		WRITE_LOG(dump_log, " [key_name(M)] - [M.mind.assigned_role]")
		continue
	WRITE_LOG(dump_log, " Iteration 3 complete.")
	sleep(5)
	WRITE_LOG(dump_log, " ---------------")
	WRITE_LOG(dump_log, " Beginning iteration 4 (Individual lists)")
	WRITE_LOG(dump_log, " keyname - Assignment ")
	to_chat(usr, "<span class='danger'>Beginning PTrack dump - iteration 4...</span>")
	
	WRITE_LOG(dump_log, " -- Command --")
	for(var/mob/M in dispatcher.tracked_players_cmd)
		WRITE_LOG(dump_log, "   [key_name(M)] - [M.mind.assigned_role]")
		sleep(1)
		continue
		
	WRITE_LOG(dump_log, " -- Engineering --")
	for(var/mob/M in dispatcher.tracked_players_eng)
		WRITE_LOG(dump_log, "   [key_name(M)] - [M.mind.assigned_role]")
		sleep(1)
		continue
		
	WRITE_LOG(dump_log, " -- Security --")
	for(var/mob/M in dispatcher.tracked_players_sec)
		WRITE_LOG(dump_log, "   [key_name(M)] - [M.mind.assigned_role]")
		sleep(1)
		continue
		
	WRITE_LOG(dump_log, " -- Medical --")
	for(var/mob/M in dispatcher.tracked_players_med)
		WRITE_LOG(dump_log, "   [key_name(M)] - [M.mind.assigned_role]")
		sleep(1)
		continue
		
	WRITE_LOG(dump_log, " -- Research --")
	for(var/mob/M in dispatcher.tracked_players_sci)
		WRITE_LOG(dump_log, "   [key_name(M)] - [M.mind.assigned_role]")
		sleep(1)
		continue
		
	WRITE_LOG(dump_log, " -- Cargo --")
	for(var/mob/M in dispatcher.tracked_players_crg)
		WRITE_LOG(dump_log, "   [key_name(M)] - [M.mind.assigned_role]")
		sleep(1)
		continue
	
	WRITE_LOG(dump_log, " -- Other --")
	for(var/mob/M in dispatcher.tracked_players_svc)
		WRITE_LOG(dump_log, "   [key_name(M)] - [M.mind.assigned_role]")
		sleep(1)
		continue
		
	WRITE_LOG(dump_log, " Iteration 4 complete.")
	sleep(5)
	WRITE_LOG(dump_log, " ---------------")
	to_chat(usr, "<span class='danger'>Finishing PTrack dump (NRL)...</span>")

	WRITE_LOG(dump_log, " ################################################################################")
	var/timer = (world.time - stopwatch) / 10		//seconds
	WRITE_LOG(dump_log, " Tracking dump completed [time2text(world.realtime, "YYYY-MM-DD T hh:mm:ss")] in [timer] seconds.")
	WRITE_LOG(dump_log, " # END OF CONTENT")
	
	ptrack_dump_in_progress = FALSE
	to_chat(usr, "<span class='danger'>PTrack dump completed in [timer] seconds. Saved to server as '[dump_log]'.</span>")
	message_admins("Player tracking data dump completed in [timer] seconds. Saved as '[dump_log]'.")
	log_admin("Player tracking data dump completed.")