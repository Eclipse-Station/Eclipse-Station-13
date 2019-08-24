/* 
 * Nanotrasen Department Alarm Dispatcher
 * This handles out-of-server calls for players, using the request console. We
 * have this set up as a subsystem so we can handle it with global lists.
 */

#define DEBUGLEVEL_FATAL_ONLY 0
#define DEBUGLEVEL_SEVERE 1
#define DEBUGLEVEL_WARNING 2
#define DEBUGLEVEL_VERBOSE 3


SUBSYSTEM_DEF(dispatch)
	// Metadata; you should define these.
	name = "Dispatch" //name of the subsystem
	init_order = -2		//lower priority, really
	flags = SS_BACKGROUND		//run in background. We only really need this for global stuff.
	runlevels = RUNLEVELS_DEFAULT
	var/static/dispatcher_initialized = FALSE		//American spelling, for consistency.
	var/debug_level = DEBUGLEVEL_FATAL_ONLY
	
	//used in player tracking system
	var/list/tracked_players_all = list()		//All tracked players
	var/list/tracked_players_sec = list()		//Security
	var/list/tracked_players_med = list()		//Medical
	var/list/tracked_players_sci = list()		//Science
	var/list/tracked_players_cmd = list()		//Command
	var/list/tracked_players_crg = list()		//Supply
	var/list/tracked_players_eng = list()		//Engineering
	var/list/tracked_players_svc = list()		//Service
	
/datum/controller/subsystem/dispatch/Recover()
	flags |= SS_NO_INIT // We don't want to init twice.
	flushTracking()

/datum/controller/subsystem/dispatch/proc/flushTracking()
	//First, we reset all the lists.
	if(DEBUGLEVEL_VERBOSE <= debug_level)		//Yoda programming here.
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
	if(tracked_players_all || tracked_players_sec || tracked_players_med || tracked_players_sci || tracked_players_cmd || tracked_players_crg || tracked_players_eng || tracked_players_svc)
		world.Error("DISPATCHER: Attempted to flush player lists, but lists still had data. Abnormalities may occur!")
		if(DEBUGLEVEL_SEVERE <= debug_level)		//Yoda programming here.
			log_debug("DISPATCHER: Attempted to flush player lists, but lists still had data.")
	else if(DEBUGLEVEL_VERBOSE <= debug_level)		//Yoda programming here.
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
	for(var/mob/living/M in tracked_players_all)
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

/datum/controller/subsystem/dispatch/proc/addToTracking(mob/living/M)
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

/datum/controller/subsystem/dispatch/proc/removeFromTracking(mob/living/M)
	if(!M)
		CRASH("no mob specified.")
	if(!M.mind)
		return 0	//Mindless body.
	if(!M.mind.assigned_role)
		return 0	//No assigned role.

	//...departments first...
	if(tracked_players_sec & M)
		tracked_players_sec -= M
	if(tracked_players_med & M)
		tracked_players_med -= M
	if(tracked_players_sci & M)
		tracked_players_sci -= M
	if(tracked_players_cmd & M)
		tracked_players_cmd -= M
	if(tracked_players_crg & M)
		tracked_players_crg -= M
	if(tracked_players_eng & M)
		tracked_players_eng -= M
	if(tracked_players_svc & M)
		tracked_players_svc -= M
	
	//...then the final list.
	if(tracked_players_all & M)
		tracked_players_all -= M

	if(DEBUGLEVEL_VERBOSE <= debug_level)
		log_debug("DISPATCHER: Removed [M] from tracked players.")
	return 1

/datum/controller/subsystem/dispatch/proc/handleRequest(department = "", priority = FALSE, message)
//return statement should be whether or not the handler handled it.
//0 if it is kicking it back to the RC due to players being on,
//1 if it sent to Discord.
	department = lowertext(department)
	switch(department)
		if("engineering")
			if(!tracked_players_eng)
				sendDiscordRequest("engineering",priority, message)
				return 1
			else
				return 0
		else
			world.Error("Unimplemented department \"[department]\".")

/datum/controller/subsystem/dispatch/proc/sendDiscordRequest(department = "", priority = FALSE, message)
// "[priority ? "**HIGH PRIORITY** a" : "A"]ssistance request for [department_ping] from [sender] ([sender_role]): '[message]'"
	CRASH("Unimplemented.")

#undef DEBUGLEVEL_FATAL_ONLY
#undef DEBUGLEVEL_SEVERE
#undef DEBUGLEVEL_WARNING
#undef DEBUGLEVEL_VERBOSE