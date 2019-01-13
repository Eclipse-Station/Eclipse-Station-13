//Positive
/datum/trait/endurance_very_high
	name = "Very High Endurance"
	desc = "Increases your maximum total hitpoints to 140"
	cost = 5
	var_changes = list("total_health" = 140)
	apply(var/datum/species/S,var/mob/living/carbon/human/H)
		..(S,H)
		H.setMaxHealth(S.total_health)

/datum/trait/burn_resist_plus
	name = "Major Burn Resist"
	desc = "Adds 35% resistance to burn damage sources."
	cost = 4
	var_changes = list("burn_mod" = 0.65)
	excludes = list(/datum/trait/minor_brute_resist,/datum/trait/brute_resist,/datum/trait/brute_resist_plus)


/datum/trait/brute_resist_plus
	name = "Major Brute Resist"
	desc = "Adds 35% resistance to brute damage sources."
	cost = 4
	var_changes = list("brute_mod" = 0.65)
	excludes = list(/datum/trait/minor_burn_resist,/datum/trait/burn_resist, /datum/trait/burn_resist_plus)

//Neutral
/datum/trait/voracious_appetite
	name = "Voracious Appetite"
	desc = "Gives you ability to eat people. Sheeesh."
	cost = 0
	var_changes = list("voracious" = 1)

/datum/trait/voracious_appetite/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/proc/insidePanel

