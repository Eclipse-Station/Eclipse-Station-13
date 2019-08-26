var/global/datum/controller/subsystem/dispatcher/dispatcher		//This must be defined here, else dispatcher.Proc() calls will fail

/* 
 * Nanotrasen Department Alarm Dispatcher
 * This handles out-of-server calls for players, using the request console. We
 * have this set up as a subsystem so we can handle it with global lists.
 */

#define DEBUGLEVEL_FATAL_ONLY 0
#define DEBUGLEVEL_SEVERE 1
#define DEBUGLEVEL_WARNING 2
#define DEBUGLEVEL_VERBOSE 3


SUBSYSTEM_DEF(dispatcher)		
	name = "Dispatcher" //name of the subsystem
	init_order = -2		//lower priority, really
	flags = SS_BACKGROUND		//only used for global lists
	runlevels = RUNLEVELS_DEFAULT
	wait = 10 SECONDS		//only used in initial flush, not really necessary otherwise
	var/static/dispatcher_initialized = FALSE		//American spelling, for consistency.
	var/debug_level = DEBUGLEVEL_VERBOSE
	
	var/cooldown = 0
	
	//used in player tracking system
	var/list/tracked_players_all = list()		//All tracked players
	var/list/tracked_players_sec = list()		//Security
	var/list/tracked_players_med = list()		//Medical
	var/list/tracked_players_sci = list()		//Science
	var/list/tracked_players_cmd = list()		//Command
	var/list/tracked_players_crg = list()		//Supply
	var/list/tracked_players_eng = list()		//Engineering
	var/list/tracked_players_svc = list()		//Service

/datum/controller/subsystem/dispatcher/Initialize()
	dispatcher = src
	if(DEBUGLEVEL_VERBOSE <= debug_level)		//Yoda programming here.
		log_debug("DISPATCHER: Initializing.")
	dispatcher.flushTracking()		//test the dispatcher.Proc() call system; we shouldn't have any mobs to track
	if(DEBUGLEVEL_VERBOSE <= debug_level)
		log_debug("DISPATCHER: Initialized!")
	..()

/datum/controller/subsystem/dispatcher/fire(resumed = FALSE)
	if(DEBUGLEVEL_VERBOSE <= debug_level)
		log_debug("DISPATCHER: Standing by for initial flush...")
	if(Master.current_runlevel < RUNLEVEL_SETUP)
		log_debug("DISPATCHER: Holding off, runlevel: [Master.current_runlevel], waiting for [RUNLEVEL_GAME]...")
		return		//eh, it'll fire again.
	
	if(DEBUGLEVEL_VERBOSE <= debug_level)
		log_debug("DISPATCHER: Game is running (well, running enough for our standards). Beginning initial flush.")
	flushTracking()		//roundstart shenanigans will prevent it from flushing properly.
	flags |= SS_NO_FIRE
	if(DEBUGLEVEL_VERBOSE <= debug_level)
		log_debug("DISPATCHER: Initial flush completed. Subsystem will now go offline (this will not affect player tracking).")

/datum/controller/subsystem/dispatcher/Recover()
	flags |= SS_NO_INIT // We don't want to init twice.
	flushTracking()

/datum/controller/subsystem/dispatcher/proc/flushTracking()
	//First, we reset all the lists.
	if(DEBUGLEVEL_VERBOSE <= debug_level)
		log_debug("DISPATCHER: Flushing lists.")
	tracked_players_all = list()		//All tracked players
	tracked_players_sec = list()		//Security
	tracked_players_med = list()		//Medical
	tracked_players_sci = list()		//Science
	tracked_players_cmd = list()		//Command
	tracked_players_crg = list()		//Supply
	tracked_players_eng = list()		//Engineering
	tracked_players_svc = list()		//Service
	
	//make sure they're clear
	if(tracked_players_all.len || tracked_players_sec.len || tracked_players_med.len || tracked_players_sci.len || tracked_players_cmd.len || tracked_players_crg.len || tracked_players_eng.len || tracked_players_svc.len)
		world.Error("DISPATCHER: Attempted to flush player lists, but lists still had data. Falling back to list.Cut()...")
		if(DEBUGLEVEL_WARNING <= debug_level)
			log_debug("DISPATCHER: Attempted to flush player lists, but lists still had data. Reverting to list.Cut() method...")
		tracked_players_all.Cut()		//All tracked players
		tracked_players_sec.Cut()		//Security
		tracked_players_med.Cut()		//Medical
		tracked_players_sci.Cut()		//Science
		tracked_players_cmd.Cut()		//Command
		tracked_players_crg.Cut()		//Supply
		tracked_players_eng.Cut()		//Engineering
		tracked_players_svc.Cut()		//Service
		
		if(tracked_players_all.len || tracked_players_sec.len || tracked_players_med.len || tracked_players_sci.len || tracked_players_cmd.len || tracked_players_crg.len || tracked_players_eng.len || tracked_players_svc.len)
			throw EXCEPTION("DISPATCHER: Attempted to flush player lists twice, but lists still had data. Aborting - abnormalities may occur!")
			if(DEBUGLEVEL_SEVERE <= debug_level)
				log_debug("DISPATCHER: Attempted to flush player lists twice, but lists still had data. Aborting - abnormalities may occur!")


	else if(DEBUGLEVEL_VERBOSE <= debug_level)
		log_debug("DISPATCHER: Lists flushed.")
	
	//let's start by rebuilding the master list...
	for(var/mob/living/M in player_list)
		if(!M)
			if(DEBUGLEVEL_VERBOSE <= debug_level)
				log_debug("DISPATCHER: Master list population failure: No players on.")
			return		//Nobody's home. Go back to sleep.
		if(!M.mind)
			continue	//Mindless body.
		if(!M.mind.assigned_role)
			continue	//No assigned role.
		
		tracked_players_all += M
		if(DEBUGLEVEL_VERBOSE <= debug_level)
			log_debug("DISPATCHER: Master list population: [tracked_players_all.len] players.")
		
	//...and now we rebuild the department lists.
	for(var/mob/M in tracked_players_all)
		if(!M)
			if(DEBUGLEVEL_WARNING <= debug_level)
				log_debug("DISPATCHER: Sub-list population failure: No players in master list. This indicates that a 'return' is failing to end the flush proc.")
		if(!M.mind)
			continue		//Mindless body.
		if(!M.mind.assigned_role)
			tracked_players_all -= M		//Don't track a role-less man.
			continue
		else		//We add them to all positions that we need, in case someone's a head of staff (which has two position flags)
			addToTracking(M)
			continue		//We're done adding here.

/datum/controller/subsystem/dispatcher/proc/addToTracking(mob/M)
	if(!M)
		CRASH("no mob specified.")
	if(!M.mind)
		return 0	//Mindless body.
	if(!M.mind.assigned_role)
		return 0	//No assigned role.

	sleep(5)		//wait a sec

	tracked_players_all |= M		//add 'em if you got 'em

	if(M.mind.assigned_role in security_positions)
		tracked_players_sec += M
	if(M.mind.assigned_role in medical_positions)
		tracked_players_med += M
	if(M.mind.assigned_role in science_positions)
		tracked_players_sci += M
	if(M.mind.assigned_role in command_positions)
		if(M.mind.assigned_role != "Command Secretary")		//We don't count the secretary.
			tracked_players_cmd += M
	if(M.mind.assigned_role in cargo_positions)
		tracked_players_crg += M
	if(M.mind.assigned_role in engineering_positions)
		tracked_players_eng += M
	if(M.mind.assigned_role in civilian_positions)
		if(M.mind.assigned_role != (USELESS_JOB || "Intern"))		//visitors are not staff, and interns have no access.
			tracked_players_svc += M
	
	if(DEBUGLEVEL_VERBOSE <= debug_level)
		log_debug("DISPATCHER: Added [M.name] to tracked players.")
	return 1

/datum/controller/subsystem/dispatcher/proc/removeFromTracking(mob/M)		//we don't need the precision here, since we may be removing dead players
	if(!M)
		CRASH("no mob specified.")
	if(!M.mind)
		return 0	//Mindless body.
	if(!M.mind.assigned_role)
		return 0	//No assigned role.

	//...departments first...
	if(tracked_players_sec & M)
		tracked_players_sec.Remove(M)		//I'm not a coder without emotions
	if(tracked_players_med & M)				//I'm not what you see
		tracked_players_med.Remove(M)		//I've come to help you with your problems
	if(tracked_players_sci & M)				//So we can be free
		tracked_players_sci.Remove(M)		//I'm not a hero! I'm not some saviour!
	if(tracked_players_cmd & M)				//Forget what you know
		tracked_players_cmd.Remove(M)		//I'm just a man whose circumstances
	if(tracked_players_crg & M)				//Went byond his control.
		tracked_players_crg.Remove(M)
	if(tracked_players_eng & M)
		tracked_players_eng.Remove(M)
	if(tracked_players_svc & M)
		tracked_players_svc.Remove(M)
	
	//...then the final list.
	if(tracked_players_all & M)
		tracked_players_all.Remove(M)

	if(DEBUGLEVEL_VERBOSE <= debug_level)
		log_debug("DISPATCHER: Removed [M] from tracked players.")
	return 1

/datum/controller/subsystem/dispatcher/proc/handleRequest(department = "", priority = FALSE, message, sender = "Unknown", sender_role = "Unassigned", stamped)
//return statement should be whether or not the handler handled it.
//0 if it is kicking it back to the RC due to players being on,
//1 if it sent to Discord.
	if(DEBUGLEVEL_VERBOSE <= debug_level)
		log_debug("DISPATCHER: Received request for department [department], priority of [priority], message '[message]', sender '[sender]', role '[sender_role]', stamp '[stamped]'.")
	if((!(sender && sender_role)) && !stamped)
		#error MANUAL ERROR: This code is not in a runnable state.
	department = lowertext(department)
	switch(department)
		if("engineering" || "atmospherics")
			if(DEBUGLEVEL_VERBOSE <= debug_level)
				log_debug("DISPATCHER: Request sent to Engineering.")
			if(!tracked_players_eng.len)
				if(DEBUGLEVEL_VERBOSE <= debug_level)
					log_debug("DISPATCHER: No players in [department], calling sendDiscordRequest...")
				sendDiscordRequest("engineering",priority, message, sender, sender_role, stamped)
				return 1
			else
				return 0
		if("science" || "research")
			if(DEBUGLEVEL_VERBOSE <= debug_level)
				log_debug("DISPATCHER: Request sent to Science.")
			if(!tracked_players_sci.len)
				if(DEBUGLEVEL_VERBOSE <= debug_level)
					log_debug("DISPATCHER: No players in [department], calling sendDiscordRequest...")
				sendDiscordRequest("research",priority, message, sender, sender_role, stamped)
				return 1
			else
				return 0
		if("security")
			if(DEBUGLEVEL_VERBOSE <= debug_level)
				log_debug("DISPATCHER: Request sent to Security.")
			if(!tracked_players_sec.len)
				if(DEBUGLEVEL_VERBOSE <= debug_level)
					log_debug("DISPATCHER: No players in [department], calling sendDiscordRequest...")
				sendDiscordRequest("security",priority, message, sender, sender_role, stamped)
				return 1
			else
				return 0
		if("supply" || "cargo")
			if(DEBUGLEVEL_VERBOSE <= debug_level)
				log_debug("DISPATCHER: Request sent to Supply.")
			if(!tracked_players_crg.len)
				if(DEBUGLEVEL_VERBOSE <= debug_level)
					log_debug("DISPATCHER: No players in [department], calling sendDiscordRequest...")
				sendDiscordRequest("supply",priority, message, sender, sender_role, stamped)
				return 1
			else
				return 0
		if("service" || "janitorial")
			if(DEBUGLEVEL_VERBOSE <= debug_level)
				log_debug("DISPATCHER: Request sent to Service.")
			if(!tracked_players_svc.len)
				if(DEBUGLEVEL_VERBOSE <= debug_level)
					log_debug("DISPATCHER: No players in [department], calling sendDiscordRequest...")
				sendDiscordRequest("service",priority, message, sender, sender_role, stamped)
				return 1
			else
				return 0
		if("medical")
			if(DEBUGLEVEL_VERBOSE <= debug_level)
				log_debug("DISPATCHER: Request sent to Medical.")
			if(!tracked_players_med.len)
				if(DEBUGLEVEL_VERBOSE <= debug_level)
					log_debug("DISPATCHER: No players in [department], calling sendDiscordRequest...")
				sendDiscordRequest("medical",priority, message, sender, sender_role, stamped)
				return 1
			else
				return 0
		if("command" || "bridge")
			if(DEBUGLEVEL_VERBOSE <= debug_level)
				log_debug("DISPATCHER: Request sent to Command.")
			if(!tracked_players_cmd.len)
				if(DEBUGLEVEL_VERBOSE <= debug_level)
					log_debug("DISPATCHER: No players in [department], calling sendDiscordRequest...")
				sendDiscordRequest("command",priority, message, sender, sender_role, stamped)
				return 1
			else
				return 0
		else
			world.Error("Unimplemented department \"[department]\".")

/datum/controller/subsystem/dispatcher/proc/sendDiscordRequest(department = "", priority = FALSE, message, sender, sender_role, stamped)
	if(world.time < cooldown)
		if(DEBUGLEVEL_WARNING <= debug_level)
			log_debug("DISPATCHER: Cancelling send: System in cooldown.")
		return 0
	var/department_ping = ""
	switch(department)
		if("command")
			department_ping = ""	//Replace this with the relevant role ping IDs.
		if("engineering")
			department_ping = ""
		if("research")
			department_ping = ""
		if("security")
			department_ping = ""
		if("supply")
			department_ping = ""
		if("service")
			department_ping = ""
		if("medical")
			department_ping = ""
		else
			if(DEBUGLEVEL_WARNING <= debug_level)
				log_debug("DISPATCHER: Undefined department '[department]'.")
		
	var/msg = ""		//This is the string intended to be sent to the bot.
	msg = "[priority ? "**HIGH PRIORITY** a" : "A"]ssistance request for [department_ping], [stamped ? "stamped by [stamped], " : ""]from [sender] ([sender_role]): '[message]'"
	
	cooldown = (world.time + 3 MINUTES)		//we aren't sending people to space, we don't need pinpoint accuracy
											// ... wait a minute.
	if(DEBUGLEVEL_VERBOSE <= debug_level)
		log_debug("DISPATCHER: Message prints as follows:")
		log_debug("DISPATCHER: [msg]")
	

	throw EXCEPTION("Unimplemented. Department '[department]', priority '[priority]', message '[message]', sender '[sender]', sender role '[sender_role]', stamped '[stamped]'.")
	return
	
/datum/controller/subsystem/dispatcher/proc/sendDiscordTest()
// "This is a test of the Nanotrasen Department Alarm Dispatcher. This is only a test."
	CRASH("Unimplemented.")

/datum/controller/subsystem/dispatcher/Shutdown()
	//clear all lists
	tracked_players_all = list()		//The time has come at last
	tracked_players_sec = list()		//To throw away this mask
	tracked_players_med = list()		//Now everyone can see
	tracked_players_sci = list()		//My true identity!
	tracked_players_cmd = list()
	tracked_players_crg = list()
	tracked_players_eng = list()		//I'm SPITZER! Spitzer! Spitzer. Spitzer...
	tracked_players_svc = list()

	//I'm sure Nestor will want to do something here with the Discord bot he has planned, later
	
/datum/controller/subsystem/dispatcher/stat_entry(msg_prefix)
	var/list/msg = list(msg_prefix)
	msg += "T:[tracked_players_all.len]"		//Total
	msg += "{"
	msg += "H [tracked_players_cmd.len] | "		//Heads
	msg += "E [tracked_players_eng.len] | "		//Engi
	msg += "S [tracked_players_sec.len] | "		//Sec
	msg += "M [tracked_players_med.len] | "		//Med
	msg += "R [tracked_players_sci.len] | "		//Research
	msg += "C [tracked_players_crg.len] | "		//Cargo
	msg += "O [tracked_players_svc.len]"		//Other
	msg += "}"
	..(msg.Join())
	
	//sample T:28{H 6|E 3|S 4|M 4|R 5|C 5|O 12}

#undef DEBUGLEVEL_FATAL_ONLY
#undef DEBUGLEVEL_SEVERE
#undef DEBUGLEVEL_WARNING
#undef DEBUGLEVEL_VERBOSE