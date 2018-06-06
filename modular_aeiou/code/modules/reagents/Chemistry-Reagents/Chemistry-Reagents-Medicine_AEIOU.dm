/datum/reagent/hannoa
	name = "hannoa"
	id = "hannoa"
	description = "A powerful clotting agent that treats brute damage very quickly but takes a long time to be metabolised. Overdoses easily, reacts badly with other chemicals."
	taste_description = "paint"
	reagent_state = LIQUID
	color = "#163851"
	overdose = 8
	scannable = 1
	metabolism = 0.03

/datum/reagent/hannoa/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, 3 * removed, 0)

/datum/reagent/hannoa/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(ishuman(M))
		var/wound_heal = 1.5 * removed
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			for(var/datum/wound/W in O.wounds)
				if(W.bleeding())
					W.damage = max(W.damage - wound_heal, 0)
					if(W.damage <= 0)
						O.wounds -= W

		M.take_organ_damage(3 * removed, 0)
		if(M.losebreath < 15)
			M.AdjustLosebreath(1)

		H.custom_pain("You feel as if your veins are fusing shut!",60)