//Updates On-site manifest

var/datum/manifest_controller/mnfst = new/datum/manifest_controller

/datum/manifest_controller
	var/active = 1

/datum/manifest_controller/New()
	spawn(2 MINUTE) //Lots of lag at the start of a shift.
		log_admin("Manifest Updater loaded.")
	process()

/datum/manifest_controller/proc/process()
	update_manifest()
	load_aeiouwhitelist()
	load_jobwhitelist()//Reloads whitelists, since we use the bot
	spawn(1 MINUTE) //We don't really need high-accuracy here.
		process()

/datum/manifest_controller/proc/update_manifest()
	var/list/output = list()

	// STATUS
	var/rawStatus = world.Topic("status=2")
	var/list/status = params2list(rawStatus)
	status["playerlist"] = params2list(status["playerlist"])
	status["adminlist"] = params2list(status["adminlist"])
	output["status"] = status

	// MANIFEST
	var/rawManifest = world.Topic("manifest")
	var/positions = params2list(rawManifest)
	for(var/k in positions)
		positions[k] = params2list(positions[k])
	output["manifest"] = positions
	//DELETE THE OLD JSON

	// OUTPUT AS JSON
	fdel("/opt/lampp/htdocs/manifest/manifest.json")
//	usr << json_encode(output)
	output = json_encode(output)
	text2file(output, "/opt/lampp/htdocs/manifest/manifest.json")
