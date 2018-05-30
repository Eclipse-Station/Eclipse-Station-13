/datum/species/lanius
	name = "Carnifex"
	name_plural = "Carnifex"
	blurb ="These anaerobic beings seem friendly enough., The Carnifex are scavengers - metallic lifeforms that rely on the absorption  \
	of minerals to sustain themselves. .<br/><br/>Their society ebbs and flows in hibernation cycles;  \
	they may lie dormant for many years, even while hurtling through space As soon as they become aware  \
	of significant metal deposits they reawaken. Usually this occurs in the dying stages of a galactic civilization  \
	or in the wake of intergalactic war. \
	Reports of reawakened Carnifex have appeared in many of the war-torn and abandoned sectors of SolGov Space."
	icobase = 'icons/mob/human_races/lanius.dmi'
	deform = 'icons/mob/human_races/r_lanius.dmi'
	unarmed_types = list(/datum/unarmed_attack/kick, /datum/unarmed_attack/claws)
	show_ssd =	"compeletely motionless"
	death_message = "falls apart!"
	knockout_message = "collapses into a blurbing pile of molten metal."
	remains_type = /obj/item/weapon/ore/laniusded

	num_alternate_languages = 1
	species_language = LANGUAGE_LANIUS

	virus_immune =	1
	blood_volume =	null
	min_age =		1
	max_age =		500
	brute_mod =		0.75
	burn_mod =		1.8 //indiana jones melting face
	oxy_mod =		0
	slowdown =      1.15
	flash_mod =     2 //AAAAA SOLAR FLARE PANIC
	radiation_mod = 0
	darksight = 5
	toxins_mod = 0
	siemens_coefficient = 0.8
	rarity_value = 5
	scream_verb = "screeches"

	breath_type = null
	poison_type = null


	flesh_color = "#AFA59E" //Gray-ish. Not sure if this is really needed, but eh.
	base_color 	= "#333333" //Blackish-gray
	blood_color = "#E27A1F" //FUCKING RUSTBLOODS

	flags = NO_SCAN | NO_MINOR_CUT  | NO_INFECT | NO_BLOOD | NO_POISON
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR
	spawn_flags	= SPECIES_IS_RESTRICTED //disabled until further notice

	genders = list(NEUTER)
	has_organ = list(O_BRAIN =    /obj/item/organ/internal/brain/golem)

	hazard_low_pressure = -1 //Prevents them from dying normally in space. Special code handled below.
	cold_level_1 = -5000
	cold_level_2 = -5000
	cold_level_3 = -5000

	speech_bubble_appearance = "synthetic_evil"


	inherent_verbs = list(/mob/living/carbon/human/proc/cromch, /mob/living/carbon/human/proc/lanius_produce)



/datum/species/lanius/handle_environment_special(var/mob/living/carbon/human/H)
	if (H.buildup >= 0)
		H.buildup -= 2
	if(prob(80) && (H.health < H.maxHealth))
		H.adjustBruteLoss(-0.25)
		H.adjustFireLoss(-0.15)
		H.adjustBrainLoss(-0.5)
		H.adjustToxLoss(-1)
		H.nutrition -= 2
	if(!istype(H.wear_suit, /obj/item/clothing/suit/space/) || !istype(H.head, /obj/item/clothing/head/helmet/space/))
		var/turf/T = get_turf(H.loc)
		var/datum/gas_mixture/environment //air magic. Pure fucking magic. DO NOT TOUCH
		environment =  T.remove_air(T:air:total_moles)
		if (environment.gas["oxygen"] > 8)
			environment.gas["oxygen"] = (environment.gas["oxygen"])*0.75
			if(T) T.assume_air(environment)
			if (H.buildup <= 650) H.buildup += 5
			if (prob(60))
				H.nutrition -= H.nutrition/200
	if (H.buildup < 50)
		return
	else if (H.buildup < 100)
		if(H.jitteriness < 10)
			H.jitteriness = max(H.jitteriness, 20)
			H.slurring = max(H.slurring, 20)
			return
	else if (H.buildup < 200)
		if(H.jitteriness < 20)
			H.eye_blurry = max(H.eye_blurry, 30)
			H.jitteriness = max(H.jitteriness, 90)
			H.slurring = max(H.slurring, 90)
	else if (H.buildup < 500)
		if(H.jitteriness < 50)
			H.Confuse(45)
			H.eye_blurry = max(H.eye_blurry, 50)
			H.jitteriness = max(H.jitteriness, 90)
			H.slurring = max(H.slurring, 90)
	else
		if(H.jitteriness < 80)
			H.Confuse(90)
			H.eye_blurry = max(H.eye_blurry, 60)
			H.jitteriness = max(H.jitteriness, 90)
			H.slurring = max(H.slurring, 90)
			H.paralysis = max(H.paralysis, 20)
			H.sleeping  = max(H.sleeping, 30)
/*
/datum/species/lanius/handle_buildup(var/mob/living/carbon/human/H)
	if (H.buildup < 50)
		return
	else if (H.buildup < 100)
		if(H.jitteriness < 10)
			H.jitteriness = max(H.jitteriness, 20)
			H.slurring = max(H.slurring, 20)
			return
	else if (H.buildup < 200)
		if(H.jitteriness < 20)
			H.eye_blurry = max(H.eye_blurry, 30)
			H.jitteriness = max(H.jitteriness, 90)
			H.slurring = max(H.slurring, 90)
	else if (H.buildup < 500)
		if(H.jitteriness < 50)
			H.Confuse(45)
			H.eye_blurry = max(H.eye_blurry, 50)
			H.jitteriness = max(H.jitteriness, 90)
			H.slurring = max(H.slurring, 90)
	else
		if(H.jitteriness < 80)
			H.Confuse(90)
			H.eye_blurry = max(H.eye_blurry, 60)
			H.jitteriness = max(H.jitteriness, 90)
			H.slurring = max(H.slurring, 90)
			H.paralysis = max(H.paralysis, 20)
			H.sleeping  = max(H.sleeping, 30)	*/

/datum/species/lanius/equip_survival_gear(var/mob/living/carbon/human/H)
	H.unEquip(H.wear_suit)
	H.unEquip(H.head)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/void/medical/alt/lanius, slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/rig/medical, slot_head)


