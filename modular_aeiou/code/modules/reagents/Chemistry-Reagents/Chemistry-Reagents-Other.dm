//HOLY WATER EFFECTS OVERRIDE - a port of TG's holy water effects

/datum/reagent/water/holywater/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)	//Overrides default 10% chance of deconversion on ingestion with default chem behaviour
	M.bloodstr.add_reagent(id, removed)
	return

/datum/reagent/water/holywater/on_mob_life(mob/living/M)
	if(!data)
		data = 1
	data++
	M.jitteriness = min(M.jitteriness+25,100)
/*	if(M.mind && cult.is_antagonist(M.mind))	//Innate spells that cultists get on TG get disabled, but they don't exist on baycode
		for(var/datum/action/innate/cult/blood_magic/BM in M.actions)
			to_chat(M, "<span class='cultlarge'>Your blood rites falter as holy water scours your body!</span>")
			for(var/datum/action/innate/cult/blood_spell/BS in BM.spells)
				qdel(BS)	*/
	if(data >= 25)		// 10 units, 45 seconds @ metabolism 0.4 units & tick rate 1.8 sec
		if(!M.stuttering)
			M.stuttering = 1
		M.stuttering = min(M.stuttering+4, 10)
		M.make_dizzy(25)
		if(M.mind && cult.is_antagonist(M.mind) && prob(20))
			M.say(pick("Av'te Nar'sie","Pa'lid Mors","INO INO ORA ANA","SAT ANA!","Daim'niodeis Arc'iai Le'eones","R'ge Na'sie","Diabo us Vo'iscum","Eld' Mon Nobis"))
			if(prob(20))
				M.visible_message("<span class='danger'>[M] starts having a seizure!</span>", "<span class='userdanger'>You have a seizure!</span>")
				M.Paralyse(15)
				to_chat(M, "<span class='cultlarge'>[pick("Your blood is your bond - you are nothing without it.", "Do not forget your place.", "All that power and you still fail?")]</span>")
			else
				M.visible_message("<span class='warning'>[M] [pick("whimpers quietly", "shivers as though cold", "glances around in paranoia")].</span>")
	if(data >= 60)	// 30 units, 135 seconds
		if(M.mind && cult.is_antagonist(M.mind))
			cult.remove_antagonist(M.mind)
			M.jitteriness = 0
			M.stuttering = 0
			M.dizziness = 0
			M.SetParalysis(0)
			holder.remove_reagent(id, volume)	// maybe this is a little too perfect and a max() cap on the statuses would be better??
			return
	holder.remove_reagent(id, 0.4) //fixed consumption to prevent balancing going out of whack