/obj/machinery/suit_cycler
	species = list(
		SPECIES_HUMAN,
		SPECIES_SKRELL,
		SPECIES_UNATHI,
		SPECIES_TAJ,
		SPECIES_TESHARI,
		SPECIES_AKULA,
		SPECIES_ALRAUNE,
		SPECIES_NEVREAN,
		SPECIES_RAPALA,
		SPECIES_SERGAL,
		SPECIES_VASILISSAN,
		SPECIES_VULPKANIN,
		SPECIES_XENOCHIMERA,
		SPECIES_XENOHYBRID,
		SPECIES_ZORREN_FLAT,
		SPECIES_ZORREN_HIGH
	)
	//AEIOU-Station Add: Lookup tables for apply_paintjob edit.
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
		"Charring" = list("soot-covered voidsuit helmet", "rig0-firebug", "rig0-firebug"),
		"Exploration" = list("exploration voidsuit helmet", "helm_explorer", "helm_explorer"),
		"Old Exploration" = list("exploration voidsuit helmet", "helm_explorer2", "helm_explorer2"),
		"Pilot" = list("pilot voidsuit helmet", "rig0_pilot", "pilot_helm"),
		"Pilot Blue" = list("pilot voidsuit helmet", "rig0_pilot2", "pilot_helm2")
	)
	var/paintjobs_suit = list(
		"Engineering" = list("engineering voidsuit", "rig-engineering", "rig-engineering", "eng_voidsuit"),
		"Mining" = list("mining voidsuit", "rig-mining", "rig-mining", "mining_voidsuit"),
		"Medical" = list("medical voidsuit", "rig-medical", "rig-medical", "medical_voidsuit"),
		"Security" = list("security voidsuit", "rig-sec", "rig-sec", "sec_voidsuit"),
		"Crowd Control" = list("crowd control voidsuit", "rig-sec_riot", "rig-sec_riot", "sec_voidsuit_riot"),
		"Atmos" = list("atmospherics voidsuit", "rig-atmos", "rig-atmos", "atmos_voidsuit"),
		"HAZMAT" = list("HAZMAT voidsuit", "rig-engineering_rad", "rig-engineering_rad", "eng_voidsuit_rad"),
		"Construction" = list("construction voidsuit", "rig-engineering_con", "rig-engineering_con", "eng_voidsuit_con"),
		"Biohazard" = list("biohazard voidsuit", "rig-medical_bio", "rig-medical_bio", "medical_voidsuit_bio"),
		"Emergency Medical Response" = list("emergency medical response voidsuit", "rig-medical_emt", "rig-medical_emt", "medical_voidsuit_emt"),
		"^%###^%$" = list("blood-red voidsuit", "rig-syndie", "rig-syndie", "syndie_voidsuit"),
		"Mercenary" = list("blood-red voidsuit", "rig-syndie", "rig-syndie", "syndie_voidsuit"),
		"Charring" = list("soot-covered voidsuit", "rig-firebug", "rig-firebug", "rig-firebug"),
		"Exploration" = list("exploration voidsuit", "void_explorer", "void_explorer", "wiz_voidsuit"),
		"Old Exploration" = list("exploration voidsuit", "void_explorer2", "void_explorer2", "wiz_voidsuit"),
		"Pilot" = list("pilot voidsuit", "rig-pilot", "rig-pilot", "sec_voidsuitTG"),
		"Pilot Blue" = list("pilot voidsuit", "rig-pilot2", "rig-pilot2", "sec_voidsuitTG", "sec_voidsuitTG")
	)
	//AEIOU-Station Add End

// Old Exploration is too WIP to use right now
/obj/machinery/suit_cycler/exploration
	req_access = list(access_explorer)
	departments = list("Exploration")

// Pilot Blue is still missing a few sprites on polaris end
/obj/machinery/suit_cycler/pilot
	req_access = list(access_pilot)
	departments = list("Pilot")
