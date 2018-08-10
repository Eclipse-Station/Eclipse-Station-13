/datum/reagent/toxin/bluesap //This is the first sap. Blue one.
	name = "Blue Sap"
	id = "bluesap"
	description = "Glowing blue liquid."
	reagent_state = LIQUID
	color = "#91f9ff" // rgb(145, 249, 255)
	metabolism = 0.01
	strength = 10//Don't drink it
	mrate_static = TRUE

/datum/reagent/bullvalene // I really can't recall this thing purpose
	name = "Bullvalene "
	id = "bullvalene"
	description = "Glowing red liquid."
	reagent_state = LIQUID
	color = "#91f9ff" // rgb(145, 249, 255)
	metabolism = 0.01
	mrate_static = TRUE

/datum/reagent/purplesap 
	name = "Purple sap"
	id = "purplesap"
	description = "Purple liquid. It is very sticky and smells of amonia."
	color = "#7a48a0"
	taste_description = "Amonia"

/datum/reagent/hannoa/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	var/effective_dose = dose

	if(effective_dose < 2)
		if(effective_dose == metabolism * 2 || prob(5))
			M.emote("yawn")
		else if(effective_dose < 5)
			M.eye_blurry = max(M.eye_blurry, 10)
		else if(effective_dose < 20)
			if(prob(50))
				M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 20)
		else
			M.sleeping = max(M.sleeping, 20)
			M.drowsyness = max(M.drowsyness, 60)

/datum/reagent/ash
	name = "Ash"
	id = "ash"
	description = "Supposedly phoenixes rise from these, but you've never seen it."
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "ash"