/datum/reagent/hannoa //heals burn
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

/datum/reagent/bullvalene //This is for the third sap. It converts Brute Oxy and burn into equal amounts of toxic power.
	name = "bullvalene" //Don't ask me where the name comes from i forgot.
	id = "bullvalene"
	description = "pending description. Converts brute and burn into toxin. Or at least is supposed to."
	taste_description = "paint"
	reagent_state = LIQUID
	color = "#163851"
	overdose = 8 //This many units starts killing you.
	scannable = 1 // Mechs can scan this ye
	metabolism = 0.03 //Slow metabolism. This value was plucked out of nowhere. Can be changed.

/datum/reagent/bullvalene/affect_blood(var/mob/living/carbon/M, var/alien, var/removed) //Credit to Cameron for making my life easier with getFireLoss and such!

	if(alien == IS_SLIME)
		return
	if(alien != IS_DIONA)
		return
	else
		if(M.getOxyLoss()) //OXYGEN | This check if there is oxygen damage
			M.adjustOxyLoss(-1) //This remove the oxygen damage
			M.adjustToxLoss(0.8) //This add toxin damage
		if(M.getFireLoss()) //BURN
			M.adjustFireLoss(-1)
			M.adjustToxLoss(0.8)
		if(M.getBruteLoss()) //BRUTE
			M.adjustBruteLoss(-1)
			M.adjustToxLoss(0.8)

