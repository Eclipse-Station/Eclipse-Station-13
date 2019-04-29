//
// Eclipse-specific configuration and config values
//

/datum/configuration
	// Shift End Horn
	var/shift_end_horn = FALSE				//Master Enable
	var/shift_end_horn_delay = 48			//Delay, in 1/10 sec
	var/shift_end_horn_global = TRUE		//Play to everyone or just spawned characters?
	
	//Miscellaneous
	var/tip_of_the_round = FALSE			//Tip of the Round
	var/force_reginald = FALSE				//Force spawn Reginald.
	var/usejobwhitelist = FALSE				//Job whitelisting

/hook/startup/proc/read_eclipse_config()
	var/list/Lines = file2list("config/config_eclipse.txt")
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		switch (name)
			if ("enable_shift_horn")
				config.shift_end_horn = TRUE
			if("shift_horn_delay")
				config.shift_end_horn_delay = 10 * value
			if("shift_horn_for_spawned_players_only")
				config.shift_end_horn_global = FALSE
			if("force_spawn_reginald")
				config.force_reginald = TRUE
			if("enable_totr")
				config.tip_of_the_round = TRUE
			if("use_job_whitelisting")
				config.usejobwhitelist = TRUE
	return 1
