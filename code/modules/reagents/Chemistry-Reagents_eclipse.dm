/datum/reagent/toxin/trichloramine
	name = "Trichloramine"
	id = "liquid_trichlor"
	description = "A byproduct of mixing chlorine and ammonia, chloramines are used as a cheap source of water sanitation. Production of this is generally violently explosive, with an enthalpy of formation of 232 kJ/mol."
	taste_description = "bleach"
	reagent_state = LIQUID
	color = "#9B8303"
	strength = 8		//NFPA 704, 2 on the blue.

/datum/reagent/toxin/trichloramine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	switch(alien)
		if(IS_VOX)
			M.heal_organ_damage(0.2 * removed, 0.2 * removed)		//very, very small healing effect.
		if(IS_SLIME)
			M.heal_organ_damage(0.4 * removed, 0.4 * removed)		//prommies get a little bit more of a healing effect
		else
			M.take_organ_damage(0, removed * 0.1) //minor chemical burns; it is a skin irritant

/datum/reagent/toxin/trichloramine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)		//shitbirds heal from this crap. Somehow. Don't ask me I'm not a chemist.
		//Bad effects: Drowsiness.
		var/effective_dose = dose
	
		//Drowsiness code, copied from Unathi honey drinking code and altered
		if(effective_dose < 5)
			if(effective_dose == metabolism * 2 || prob(5))
				M.emote("yawn")
		else if(effective_dose < 10)
			M.eye_blurry = max(M.eye_blurry, 10)
		else if(effective_dose < 25)
			if(prob(50))
				M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 20)
		else
			M.sleeping = max(M.sleeping, 20)
			M.drowsyness = max(M.drowsyness, 60)

		//Beneficial effects: Heals brute and toxins. 6 units/tick each.
		M.adjustOxyLoss(-6 * removed)
		M.heal_organ_damage(3 * removed, 3 * removed)
		M.adjustToxLoss(-3 * removed)
	else
		..()