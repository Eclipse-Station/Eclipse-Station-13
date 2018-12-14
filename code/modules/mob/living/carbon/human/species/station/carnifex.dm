/datum/species/carnifex
	name = SPECIES_CARNIFEX
	name_plural = "Carnifex"
	blurb ="These anaerobic beings seem friendly enough., The Carnifex are scavengers - metallic lifeforms that rely on the absorption  \
	of minerals to sustain themselves. .<br/><br/>Their society ebbs and flows in hibernation cycles;  \
	they may lie dormant for many years, even while hurtling through space. As soon as they become aware  \
	of significant metal deposits they reawaken. \
	Reports of reawakened Carnifex have appeared in many of the previously war-torn and abandoned sectors of SolGov and Hegemony Space."
	icobase = 'icons/mob/human_races/r_lanius.dmi'
	deform = 'icons/mob/human_races/r_lanius.dmi'
	unarmed_types = list(/datum/unarmed_attack/kick, /datum/unarmed_attack/claws)
	show_ssd =	"compeletely motionless"
	death_message = "falls apart!"
	knockout_message = "collapses into a blurbing pile of metal."

	num_alternate_languages = 1 //they're having troubles with fleshy people talk
	species_language = LANGUAGE_LANIUS
	secondary_langs = list(LANGUAGE_LANIUS)

	virus_immune =	1
	blood_volume =	null
	min_age =		18
	max_age =		250
	brute_mod =		0.75
	burn_mod =		1.8 //indiana jones melting face
	oxy_mod =		0
	slowdown =      1.2
	flash_mod =     2 //AAAAA SOLAR FLARE PANIC
	radiation_mod = 0
	darksight = 5
	toxins_mod = 0
	siemens_coefficient = 1.2 //they're metal, and conduct far better. Not really happy about that
	rarity_value = 5
	scream_verb = "screeches"

	breath_type = null
	poison_type = null


	flesh_color = "#AFA59E" //Gray-ish. Not sure if this is really needed, but eh.
	base_color 	= "#333333" //Blackish-gray
	blood_color = "#E27A1F" //rust???

	flags = NO_SCAN | NO_MINOR_CUT  | NO_INFECT | NO_BLOOD | NO_POISON
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR
	spawn_flags	= SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED

	genders = list(NEUTER)
	has_organ = list(O_BRAIN = /obj/item/organ/internal/brain/carnifex)

	hazard_low_pressure = -1 //Prevents them from dying normally in space. Special code handled below.
	cold_level_1 = -5000
	cold_level_2 = -5000
	cold_level_3 = -5000

	speech_bubble_appearance = "carni"


	inherent_verbs = list(/mob/living/carbon/human/proc/cromch, /mob/living/carbon/human/proc/lanius_produce)

/datum/species/carnifex/proc/calculate_exposure(var/mob/living/carbon/human/H) //ALWAYS RETURN SOMETHING LESS OR EQUAL 0.75 OR ATMOS WILL BREAK
	if(istype(H.wear_suit, /obj/item/clothing/suit/gelsuit)) //It just lowers the loss of oxygen, not negates it completely
		return 0.1
	if(istype(H.wear_suit, /obj/item/clothing/suit/gelsuit/deluxe))//THIS ONE DOES
		return 0.05
	if((istype(H.wear_suit, /obj/item/clothing/suit/space/)) && (istype(H.head, /obj/item/clothing/head/helmet/space/)))
		return 0
	if(istype(H.wear_suit, /obj/item/clothing/suit/space/))
		return 0.4
	if(istype(H.head, /obj/item/clothing/head/helmet/space/))
		return 0.6
	else
		return 0.75

/datum/species/carnifex/proc/handle_buildup(var/mob/living/carbon/human/H)
	if (H.buildup < 50)
		return H.buildup
	else if (H.buildup < 100)
		if(prob(5))
			H << "<span class='warning'>You feel a little woozy.</span>"
			H.buildup -= 3
		if(H.jitteriness < 10)
			H.jitteriness = max(H.jitteriness, 20)
			H.slurring = max(H.slurring, 20)
			return H.buildup
	else if (H.buildup < 200)
		if(prob(5))
			H << "<span class='warning'>Your head is spinning.</span>"
			H.buildup -= 5
		if(H.jitteriness < 20)
			H.eye_blurry = max(H.eye_blurry, 30)
			H.jitteriness = max(H.jitteriness, 90)
			H.slurring = max(H.slurring, 90)
			return H.buildup
	else if (H.buildup < 500)
		if(prob(5))
			H << "<span class='warning'>You feel like you're about to collapse.</span>"
			H.buildup -= 10
		if(H.jitteriness < 50)
			H.Confuse(45)
			H.eye_blurry = max(H.eye_blurry, 50)
			H.jitteriness = max(H.jitteriness, 90)
			H.slurring = max(H.slurring, 90)
			return H.buildup
	else
		if(prob(5))
			H << "<span class='warning'>You feel like you're melting.</span>"
			H.buildup -= 15
		if(H.jitteriness < 50)
			H.Confuse(20)
			H.eye_blurry = max(H.eye_blurry, 40)
			H.jitteriness = max(H.jitteriness, 50)
			H.slurring = max(H.slurring, 50)
			H.paralysis = max(H.paralysis, 20)
			H.sleeping  = max(H.sleeping, 30)
			if (prob(30))
				H.adjustFireLoss(0.25)//UH OH
				H.adjustBruteLoss(0.5)
			return H.buildup


/datum/species/carnifex/handle_environment_special(var/mob/living/carbon/human/H)
	if (H.buildup > 1.2)
		H.buildup -= 1.5
	if(prob(35) && (H.health < H.maxHealth))
		H.adjustBruteLoss(-0.3)
		H.adjustFireLoss(-0.2)
		H.adjustBrainLoss(-0.5)
		H.adjustToxLoss(-1)
		H.nutrition -= 1
	var/exposure = calculate_exposure(H) //Level of char's body exposed to enviroment
	if(exposure)//if calculate_exposure retuns 0 don't run this at all
		var/turf/T = get_turf(H.loc)
		var/datum/gas_mixture/environment //air magic. Pure fucking magic.
		environment =  T.remove_air(T:air:total_moles)
		if (environment.gas["oxygen"] > 8)
			environment.gas["oxygen"] = (environment.gas["oxygen"])*(1-exposure)
			if(T) T.assume_air(environment)
			if (H.buildup <= 650)
				H.buildup += (1 + (exposure*4)) // This way unshielded gives 4 and gel suit gives 1.4
			if (prob(50))
				H.nutrition -= ((H.nutrition/200) * exposure)
	handle_buildup(H)



/datum/species/carnifex/equip_survival_gear(var/mob/living/carbon/human/H)
	H.unEquip(H.wear_suit)
	H.unEquip(H.head)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/void/medical/alt/carnifex, slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/rig/medical, slot_head)
/*
/datum/species/carnifex/handle_death(var/mob/living/carbon/human/H)
	..()
	spawn(1)
		new /obj/effect/decal/remains/carnifex(H.loc)
		qdel(H)
*/


/obj/item/organ/internal/brain/carnifex
	name = "carnifex cortex"
	icon = 'icons/obj/mining.dmi'
	desc = "A strange metal nugget."
	icon_state = "ore_platinum"
	parent_organ = BP_TORSO


/obj/item/clothing/suit/gelsuit
	name = "adaptive gel suit"
	desc = "A membranous substance, capable of shielding its wearer from gaseous contaminants."
	icon = 'modular_aeiou/icons/mob/clothing/onmob/lanius.dmi'
	icon_state = "gelcore"
	icon_override = 'modular_aeiou/icons/mob/clothing/onmob/lanius.dmi'
	item_state = "adaptive_gel"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = 0
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	siemens_coefficient = 0.8
	item_flags = THICKMATERIAL | PHORONGUARD | AIRTIGHT

/obj/item/clothing/suit/gelsuit/deluxe
	name = "advanced adaptive gel suit"
	desc = "A membranous substance, capable of shielding its wearer from gaseous contaminants. This one seems to be extremely thick."
	icon = 'modular_aeiou/icons/mob/clothing/onmob/lanius.dmi'
	icon_state = "gelcore_deluxe"
	icon_override = 'modular_aeiou/icons/mob/clothing/onmob/lanius.dmi'
	item_state = "adaptive_gel_deluxe"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = 0
	armor = list(melee = 15, bullet = 5, laser = 10,energy = 10, bomb = 5, bio = 100, rad = 50)
	siemens_coefficient = 0.4
	item_flags = THICKMATERIAL | PHORONGUARD | STOPPRESSUREDAMAGE | AIRTIGHT