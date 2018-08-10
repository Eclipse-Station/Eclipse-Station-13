/datum/chemical_reaction/myelamine //This is the base sap
	name = "Myelamine"
	id = "myelamine"
	result = "myelamine"
	required_reagents = list("bicaridine" = 1, "iron" = 2, "kelotane" = 1, "bluesap" = 1)
	result_amount = 1

/datum/chemical_reaction/hannoa //This is the 2nd sap. It is supposed to make a 'decent' healing chemical.
	name = "Hannoa"
	id = "hannoa"
	result = "hannoa"
	required_reagents = list("purplesap" = 1, "iron" = 2, "kelotane" = 1, "carbon" = 1)
	result_amount = 1

/datum/chemical_reaction/hannoadermaline //This is some pretty useless recipe honestly.
	name = "hannoadermaline"
	id = "fertilizer"
	result = "fertilizer"
	required_reagents = list("dermaline" = 1, "hannoa" = 1)
	result_amount = 1

/datum/chemical_reaction/bullvalene //This is for the 3rd sap.
	name = "Bullvalene"
	id = "bullvalene"
	result = "bullvalene"
	required_reagents = list("dermaline" = 1, "orangesap" = 1, "Copper" = 1)
	result_amount = 1