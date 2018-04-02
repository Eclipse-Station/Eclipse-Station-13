/datum/species/skeleton
	name = SPECIES_SKELETON
	name_plural = "Skeletons"
	icobase = 'icons/mob/human_races/r_skeleton.dmi'
//	primitive_form = "Monkey"
	language = "Sol Common"
	unarmed_types = list(/datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/sharp)	//Bones are pointy, fight me.
	blurb = "Welcome to the bone zone!"
	name_language = null // Use the first-name last-name generator rather than a language scrambler
	min_age = 18
	max_age = 250
	health_hud_intensity = 1.5
	flesh_color = "#ffffff" //WHITE
	base_color 	= "#ffffff" //ALSO WHITE
	blood_color = "#ffffff" //GUESS WHAT
	num_alternate_languages = 2
//	species_language = LANGUAGE_BONERS

	flags = NO_SCAN | NO_PAIN | NO_SLIP | NO_POISON | NO_MINOR_CUT | NO_BLOOD | UNDEAD
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_EYE_COLOR

	show_ssd = null

	blood_volume = null
	taste_sensitivity = TASTE_DULL
	hunger_factor = 0
	metabolic_rate = 0

	virus_immune = 1
	total_health = 75
	brute_mod =     1.2
	burn_mod =      0
	oxy_mod =       0
	toxins_mod =    0
	radiation_mod = 0
	flash_mod =     0
	chemOD_mod =	0

	siemens_coefficient = 0

	death_message = "falls over and stops moving!"
	knockout_message = "falls over and stops moving!"

	has_organ = list()

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	body_temperature = T20C

	inherent_verbs = list(/mob/living/carbon/human/proc/xylobone,  /mob/living/carbon/human/proc/bonerattle, /mob/living/carbon/human/proc/setfont)


/datum/species/skeleton/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	H.mutations.Add(SKELETON)
