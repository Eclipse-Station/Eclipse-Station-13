/datum/job
	//Requires a ckey to be whitelisted in jobwhitelist.txt
	var/whitelist_only = 0

	//Does not display this job on the occupation setup screen
	var/latejoin_only = 0

	//Every hour playing this role gains this much time off. (Can be negative for off duty jobs!)
	var/timeoff_factor = 3
	
	// // // BEGIN ECLIPSE ADDITIONS // // //
	//Rationale: Config-based job whitelisting.
	
	//Is this job whitelisted based on config files?
	var/wl_config_heads = FALSE		//heads of staff
	var/wl_config_sec = FALSE		//security
	var/wl_config_borgs = FALSE		//silicons
	
	//Is this job intended for admins only?
	var/wl_admin_only = FALSE
	// // // END ECLIPSE ADDITIONS

// Check client-specific availability rules.
/datum/job/proc/player_has_enough_pto(client/C)
	return timeoff_factor >= 0 || (C && LAZYACCESS(C.department_hours, department) > 0)
