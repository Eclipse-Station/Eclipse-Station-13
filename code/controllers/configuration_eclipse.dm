//
// Eclipse-specific configuration and config values
//

/datum/configuration
	var/eclipse_config_loaded = FALSE		//for things that require this, such as Reginald force spawning

	// Shift End Horn
	var/shift_end_horn = FALSE				//Master Enable
	var/shift_end_horn_delay = 48			//Delay, in 1/10 sec
	var/shift_end_horn_global = TRUE		//Play to everyone or just spawned characters?

	// Job Whitelisting
	var/usejobwhitelist = FALSE				//Master job whitelisting enable
	var/wl_heads = FALSE					//Whitelist Heads of Staff?
	var/wl_security = FALSE					//Whitelist Security department?
	var/wl_silicons = FALSE					//Whitelist silicons?
	var/wl_admins_too = FALSE				//Admins go through the whitelist too?

	//Mice and wires
	var/mice_wires = FALSE					//Mice can eat wires
	var/mice_wire_chance = 5				//Chance for a mouse to eat wires on the turf it's on.
	var/mice_wire_cooldown = 6000			//Cooldown for mouse wire chewing
	var/mice_wire_cooldown_rs = FALSE		//Roundstart mouse wire cooldown.
	var/mice_wire_eng_req = FALSE			//Require engineers to chew wires?

	//Miscellaneous
	var/vote_extensions = 2
	var/tip_of_the_round = FALSE			//Tip of the Round
	var/force_reginald = FALSE				//Force spawn Reginald.


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
				config.shift_end_horn_delay = 10 * text2num(value)
			if("shift_horn_for_spawned_players_only")
				config.shift_end_horn_global = FALSE
			if("force_spawn_reginald")
				config.force_reginald = TRUE
			if("enable_totr")
				config.tip_of_the_round = TRUE
			if("use_job_whitelisting")
				config.usejobwhitelist = TRUE
			if("whitelist_heads")
				config.wl_heads = TRUE
			if("whitelist_security")
				config.wl_security = TRUE
			if("whitelist_silicons")
				config.wl_silicons = TRUE
			if("admins_restricted_by_whitelist")
				config.wl_admins_too = TRUE
			if("vote_extensions")
				config.vote_extensions = text2num(value)
			if("mice_eat_wires")
				config.mice_wires = TRUE
			if("mice_wire_chomp_chance")
				config.mice_wire_chance = text2num(value)
			if("mice_wire_cooldown")
				config.mice_wire_cooldown = 10 * text2num(value)
			if("roundstart_mouse_wire_cooldown")
				config.mice_wire_cooldown_rs = TRUE
			if("mice_require_engineers")
				config.mice_wire_eng_req = TRUE

	config.eclipse_config_loaded = TRUE
	return 1
