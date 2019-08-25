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
	flags = SS_NO_FIRE		//only used for global lists
	runlevels = RUNLEVELS_DEFAULT
	wait = 12 MINUTES		//only used for periodic housekeeping; we don't need the precision.
	var/static/dispatcher_initialized = FALSE		//American spelling, for consistency.
	var/debug_level = DEBUGLEVEL_VERBOSE
	
	var/do_regular_list_housekeeping = TRUE
	
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
	if(!do_regular_list_housekeeping)
		flags |= SS_NO_FIRE
		if(DEBUGLEVEL_WARNING <= debug_level)
			log_debug("DISPATCHER: Regular housekeeping is disabled. To prevent unnecessary calls, this subsystem will stop firing now. This will NOT affect player tracking!")
	dispatcher.flushTracking()		//test the dispatcher.Proc() call system; we shouldn't have any mobs to track
	if(DEBUGLEVEL_VERBOSE <= debug_level)
		log_debug("DISPATCHER: Initialized!")
	..()
	
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
	for(var/mob/M in player_list)
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
		log_debug("DISPATCHER: Added [M] to tracked players.")
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
		tracked_players_sec.Remove(M)
	if(tracked_players_med & M)
		tracked_players_med.Remove(M)
	if(tracked_players_sci & M)
		tracked_players_sci.Remove(M)
	if(tracked_players_cmd & M)
		tracked_players_cmd.Remove(M)
	if(tracked_players_crg & M)
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
	
/datum/controller/subsystem/dispatcher/proc/handleRequest(department = "", priority = FALSE, message, sender = "Unknown", sender_role = "Unassigned")
//return statement should be whether or not the handler handled it.
//0 if it is kicking it back to the RC due to players being on,
//1 if it sent to Discord.
	department = lowertext(department)
	switch(department)
		if("engineering")
			if(!tracked_players_eng)
				sendDiscordRequest("engineering",priority, message, sender, sender_role)
				return 1
			else
				return 0
		if("science")
			if(!tracked_players_sci)
				sendDiscordRequest("research",priority, message, sender, sender_role)
				return 1
			else
				return 0
		if("security")
			if(!tracked_players_sec)
				sendDiscordRequest("security",priority, message, sender, sender_role)
				return 1
			else
				return 0
		if("supply")
			if(!tracked_players_crg)
				sendDiscordRequest("supply",priority, message, sender, sender_role)
				return 1
			else
				return 0
		if("service")
			if(!tracked_players_svc)
				sendDiscordRequest("service",priority, message, sender, sender_role)
				return 1
			else
				return 0
		if("medical")
			if(!tracked_players_med)
				sendDiscordRequest("medical",priority, message, sender, sender_role)
				return 1
			else
				return 0
		if("command")
			if(!tracked_players_cmd)
				sendDiscordRequest("command",priority, message, sender, sender_role)
				return 1
			else
				return 0
		else
			world.Error("Unimplemented department \"[department]\".")

/datum/controller/subsystem/dispatcher/proc/sendDiscordRequest(department = "", priority = FALSE, message, sender, sender_role)
// "[priority ? "**HIGH PRIORITY** a" : "A"]ssistance request for [department_ping] from [sender] ([sender_role]): '[message]'"
	CRASH("Unimplemented. Department [department], priority [priority], message [message], sender [sender], sender role [sender_role].")
	
/datum/controller/subsystem/dispatcher/proc/sendDiscordTest()
// "This is a test of the Nanotrasen Department Alarm Dispatcher. This is only a test."
	CRASH("Unimplemented.")

/datum/controller/subsystem/dispatcher/Shutdown()
	//clear all lists
	tracked_players_all = list()		//All tracked players
	tracked_players_sec = list()		//Security
	tracked_players_med = list()		//Medical
	tracked_players_sci = list()		//Science
	tracked_players_cmd = list()		//Command
	tracked_players_crg = list()		//Supply
	tracked_players_eng = list()		//Engineering
	tracked_players_svc = list()		//Service

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