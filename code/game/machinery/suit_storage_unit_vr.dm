/obj/machinery/suit_cycler
	species = list("Human","Skrell","Unathi","Tajara", "Teshari", "Nevrean", "Akula", "Sergal", "Flatland Zorren", "Highlander Zorren", "Vulpkanin", "Promethean", "Xenomorph Hybrid", "Xenochimera","Vasilissan", "Rapala") //Added xenochimera while I was at it. Someone put in an issue about it.

	// AEIOU edit: Making paintjobs dynamic to make it easier to manage.
	// Each associated entry takes the form list(name, icon_state, item_state)
	var/paintjobs_helmet = list(
		"Engineering" = list("engineering voidsuit helmet", "rig0-engineering", "rig0-engineering"),
		"Mining" = list("mining voidsuit helmet", "rig0-mining", "rig0-mining"),
		"Medical" = list("medical voidsuit helmet", "rig0-medical", "rig0-medical"),
		"Security" = list("security voidsuit helmet", "rig0-sec", "rig0-sec"),
		"Crowd Control" = list("crowd control voidsuit helmet", "rig0-sec_riot", "rig0-sec_riot"),
		"Atmos" = list("atmospherics voidsuit helmet", "rig0-atmos", "rig0-atmos"),
		"HAZMAT" = list("HAZMAT voidsuit helmet", "rig0-engineering_rad", "rig0-engineering_rad"),
		"Construction" = list("construction voidsuit helmet", "rig0-engineering_con", "rig0-engineering_con"),
		"Biohazard" = list("biohazard voidsuit helmet", "rig0-medical_bio", "rig0-medical_bio"),
		"Emergency Medical Response" = list("emergency medical response voidsuit helmet", "rig0-medical_emt", "rig0-medical_emt"),
		"^%###^%$" = list("blood-red voidsuit helmet", "rig0-syndie", "rig0-syndie"),
		"Mercenary" = list("blood-red voidsuit helmet", "rig0-syndie", "rig0-syndie"),
		"Charring" = list("soot-covered voidsuit helmet", "rig0-firebug", "rig0-firebug")
	)
	var/paintjobs_suit = list(
		"Engineering" = list("engineering voidsuit", "rig-engineering", "eng_voidsuit"),
		"Mining" = list("mining voidsuit", "rig-mining", "mining_voidsuit"),
		"Medical" = list("medical voidsuit", "rig-medical", "medical_voidsuit"),
		"Security" = list("security voidsuit", "rig-sec", "sec_voidsuit"),
		"Crowd Control" = list("crowd control voidsuit", "rig-sec_riot", "sec_voidsuit_riot"),
		"Atmos" = list("atmospherics voidsuit", "rig-atmos", "atmos_voidsuit"),
		"HAZMAT" = list("HAZMAT voidsuit", "rig-engineering_rad", "eng_voidsuit_rad"),
		"Construction" = list("construction voidsuit", "rig-engineering_con", "eng_voidsuit_con"),
		"Biohazard" = list("biohazard voidsuit", "rig-medical_bio", "medical_voidsuit_bio"),
		"Emergency Medical Response" = list("emergency medical response voidsuit", "rig-medical_emt", "medical_voidsuit_emt"),
		"^%###^%$" = list("blood-red voidsuit", "rig-syndie", "rig-syndie"),
		"Mercenary" = list("blood-red voidsuit", "rig-syndie", "rig-syndie"),
		"Charring" = list("soot-covered voidsuit", "rig-firebug", "rig-firebug")
	)

// AEIOU edit: This should override the Polaris proc. I wasn't sure how else to do this to avoid conflicts.
/obj/machinery/suit_cycler/apply_paintjob()

	if(!target_species || !target_department)
		return

	if(target_species)
		if(helmet) helmet.refit_for_species(target_species)
		if(suit) suit.refit_for_species(target_species)

	if(target_department) // Where the proc starts to differ. Originally a massive switch structure.
		if(helmet)
			helmet.name = paintjobs_helmet[target_department][1]
			helmet.icon_state = paintjobs_helmet[target_department][2]
			helmet.item_state = paintjobs_helmet[target_department][3]
		if(suit)
			suit.name = paintjobs_suit[target_department][1]
			suit.icon_state = paintjobs_suit[target_department][2]
			suit.item_state = paintjobs_suit[target_department][3]

			if(istype(suit.helmet)) // This is originally what I set out to fix, before the overhaul.
				suit.helmet.name = paintjobs_helmet[target_department][1]
				suit.helmet.icon_state = paintjobs_helmet[target_department][2]
				suit.helmet.item_state = paintjobs_helmet[target_department][3]

	if(target_species != "Human") // The original model technically isn't "refitted"
		if(helmet) helmet.name = "refitted [helmet.name]"
		if(suit) suit.name = "refitted [suit.name]"
