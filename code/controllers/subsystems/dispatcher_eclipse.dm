/* 
 * Nanotrasen Department Alarm Dispatcher
 * This handles out-of-server calls for players, using the request console. We
 * have this set up as a subsystem so we can handle it with global lists.
 */

SUBSYSTEM_DEF(dispatch)
	// Metadata; you should define these.
	name = "Dispatch" //name of the subsystem
	var/init_order = -2		//lower priority, really
	var/flags = SS_BACKGROUND		//run in background. We only really need this for global stuff.
	var/runlevels = RUNLEVELS_DEFAULT
	var/static/dispatcher_initialized = FALSE		//American spelling, for consistency.
	
	//used in player tracking system
	var/list/tracked_players_all = list()		//All tracked players
	var/list/tracked_players_sec = list()		//Security
	var/list/tracked_players_med = list()		//Medical
	var/list/tracked_players_sci = list()		//Science
	var/list/tracked_players_cmd = list()		//Command
	var/list/tracked_players_crg = list()		//Supply
	var/list/tracked_players_eng = list()		//Engineering
	var/list/tracked_players_svc = list()		//Service
	
