/datum/reagent/toxin/trichloramine
	name = "Trichloramine"
	id = "liquid_trichlor"
	description = "A byproduct of mixing chlorine and ammonia, chloramines are used as a cheap source of water sanitation. Production of this is generally violently explosive, with an enthalpy of formation of 232 kJ/mol."
	taste_description = "bleach"
	reagent_state = LIQUID
	color = "#9B8303"
	strength = 8		//NFPA 704, 2 on the blue.

/datum/reagent/toxin/trichloramine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	M.take_organ_damage(0, removed * 0.1) //minor chemical burns; it is a skin irritant