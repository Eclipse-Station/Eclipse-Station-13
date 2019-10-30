var/list/job_whitelist = list()

/hook/startup/proc/loadJobWhitelist()
	load_jobwhitelist()
	return 1

/proc/load_jobwhitelist()
	var/text = file2text("config/jobwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/jobwhitelist.txt")
	else
		job_whitelist = splittext(text, "\n")

/proc/is_job_whitelisted(mob/M, var/rank)
	var/datum/job/job = job_master.GetJob(rank)
	// // // BEGIN ECLIPSE EDIT // // //
	// Allows config option to disable job restrictions. Allows admins to bypass
	if(!config.wl_admins_too && check_rights(R_ADMIN, 0, M))		//They're admins.
		return 1
	if(!config.usejobwhitelist)			//Whitelist disabled.
		return 1
	if(job.wl_admin_only && check_rights(R_ADMIN, 0, M))		//Admin only ranks
		return 1
	// // // END ECLIPSE EDIT // // //
	if(!job.whitelist_only)
		return 1
	if(rank == USELESS_JOB) //VOREStation Edit - Visitor not Assistant
		return 1
	/* Eclipse Removal - moved above in the edit
	if(check_rights(R_ADMIN, 0))
		return 1
	*/
	if(!job_whitelist)
		return 0
	if(M && rank)
		for (var/s in job_whitelist)
			if(findtext(s,"[lowertext(M.ckey)] - [lowertext(rank)]"))
				return 1
			if(findtext(s,"[M.ckey] - All"))
				return 1
	return 0

