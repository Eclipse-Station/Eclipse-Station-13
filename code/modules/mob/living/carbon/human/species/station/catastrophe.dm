/datum/species/tajaran/cak
	name = "Pastrian"
	name_plural = "Pastrians"
	icobase = 'icons/mob/human_races/cakrace.dmi'
	deform = 'icons/mob/human_races/r_cakrace.dmi'
	tail = "tajtail"
	tail_animation = 'icons/mob/species/tajaran/tail.dmi'
	unarmed_types = list(/datum/unarmed_attack/kick, /datum/unarmed_attack/punch)
	darksight = 8
	slowdown = -0.5
	snow_movement = -1		//Ignores half of light snow
	brute_mod = 0.5
	burn_mod =  3
	flash_mod = 1.1
	metabolic_rate = 0.1
	gluttonous = 0
	min_age = 1
	max_age = 3

	inherent_verbs = list(/mob/living/carbon/human/proc/nomnom)


	blurb = "What has culinary done?!"

	body_temperature = 320.15	//Even more cold resistant, even more flammable

	cold_level_1 = 200 //Default 260
	cold_level_2 = 140 //Default 200
	cold_level_3 = 80  //Default 120

	primitive_form = "Cak"
	flags = NO_PAIN | NO_SCAN | NO_POISON
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS  | HAS_SKIN_COLOR | HAS_EYE_COLOR
	spawn_flags = SPECIES_IS_RESTRICTED //Disabled for consistency's sake

	flesh_color = "#AFA59E"
	base_color = "#333333"

	heat_discomfort_strings = list(
		"Your pretty glazing crumbles in heat.",
		"You feel uncomfortably warm.",
		"Your dried cream clumps and falls off!",
		)
	//cold_discomfort_level = 275 //VOREStation Removal

	has_organ = list(    //No guts, no glory
		O_BRAIN =    /obj/item/organ/internal/brain/cak,
		)









/datum/species/tajaran/cak/handle_environment_special(var/mob/living/carbon/human/H)
	..()
	if(prob(80))
		H.adjustBruteLoss(-1)
	for(var/obj/item/weapon/reagent_containers/food/snacks/donut/normal/D in range(1, src)) //Frosts nearby donuts!
		if(D.icon_state != "donut2")
			D.name = "frosted donut"
			D.icon_state = "donut2"
			D.reagents.add_reagent("sprinkles", 2)
			D.filling_color = "#FF69B4"
			if(prob(30))
				D.reagents.add_reagent("sprinkles", 2)
				D.reagents.add_reagent("nutriment", 2)