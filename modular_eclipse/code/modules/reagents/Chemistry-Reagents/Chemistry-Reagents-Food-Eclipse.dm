/datum/reagent/nutriment/fungalprotein // Special skrell food that makes skrell full and other feel meh.
	name = "Fungalprotein"
	id = "fungalprotein"
	description = "The primary nutritional chemical found in Skrellsnax brand Skrellsnax, every herbivore's favorite snack."
	taste_description = "salty, slightly bitter mushrooms."
	nutriment_factor = 3
	reagent_state = SOLID
	color = "#113522"

/datum/reagent/nutriment/fungalprotein/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	var/effective_dose = dose
	if(issmall(M))
		effective_dose *= 2

	if(alien == IS_SKRELL)
		nutriment_factor = 15


