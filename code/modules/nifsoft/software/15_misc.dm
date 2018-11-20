/datum/nifsoft/apc_recharge
	name = "APC Connector"
	desc = "A small attachment that allows synthmorphs to recharge themselves from APCs."
	list_pos = NIF_APCCHARGE
	cost = 1250
	wear = 2
	applies_to = NIF_SYNTHETIC
	tick_flags = NIF_ACTIVETICK
	var/obj/machinery/power/apc/apc
	other_flags = (NIF_O_APCCHARGE)

	activate()
		if((. = ..()))
			var/mob/living/carbon/human/H = nif.human
			apc = locate(/obj/machinery/power/apc) in get_step(H,H.dir)
			if(!apc)
				apc = locate(/obj/machinery/power/apc) in get_step(H,0)
			if(!apc)
				nif.notify("You must be facing an APC to connect to.",TRUE)
				spawn(0)
					deactivate()
				return FALSE

			H.visible_message("<span class='warning'>Thin snakelike tendrils grow from [H] and connect to \the [apc].</span>","<span class='notice'>Thin snakelike tendrils grow from you and connect to \the [apc].</span>")

	deactivate()
		if((. = ..()))
			apc = null

	life()
		if((. = ..()))
			var/mob/living/carbon/human/H = nif.human
			if(apc && (get_dist(H,apc) <= 1) && H.nutrition < 440) // 440 vs 450, life() happens before we get here so it'll never be EXACTLY 450
				H.nutrition = min(H.nutrition+10, 450)
				apc.drain_power(7000/450*10) //This is from the large rechargers. No idea what the math is.
				return TRUE
			else
				nif.notify("APC charging has ended.")
				H.visible_message("<span class='warning'>[H]'s snakelike tendrils whip back into their body from \the [apc].</span>","<span class='notice'>The APC connector tendrils return to your body.</span>")
				deactivate()
				return FALSE

/datum/nifsoft/pressure
	name = "Pressure Seals"
	desc = "Creates pressure seals around important synthetic components to protect them from vacuum. Almost impossible on organics."
	list_pos = NIF_PRESSURE
	cost = 1750
	a_drain = 0.5
	wear = 3
	applies_to = NIF_SYNTHETIC
	other_flags = (NIF_O_PRESSURESEAL)

/datum/nifsoft/heatsinks
	name = "Heat Sinks"
	desc = "Advanced heat sinks for internal heat storage of heat on a synth until able to vent it in atmosphere."
	list_pos = NIF_HEATSINK
	cost = 1450
	a_drain = 0.25
	wear = 3
	var/used = 0
	tick_flags = NIF_ALWAYSTICK
	applies_to = NIF_SYNTHETIC
	other_flags = (NIF_O_HEATSINKS)

	activate()
		if((. = ..()))
			if(used >= 1500)
				nif.notify("Heat sinks not safe to operate again yet! Max 75% on activation.",TRUE)
				spawn(0)
					deactivate()
				return FALSE

	stat_text()
		return "[active ? "Active" : "Disabled"] (Stored Heat: [Floor(used/20)]%)"

	life()
		if((. = ..()))
			//Not being used, all clean.
			if(!active && !used)
				return TRUE

			//Being used, and running out.
			else if(active && ++used == 2000)
				nif.notify("Heat sinks overloaded! Shutting down!",TRUE)
				deactivate()

			//Being cleaned, and finishing empty.
			else if(!active && --used == 0)
				nif.notify("Heat sinks re-chilled.")

/datum/nifsoft/compliance
	name = "Compliance Module"
	desc = "A system that allows one to apply 'laws' to sapient life. Extremely illegal, of course."
	list_pos = NIF_COMPLIANCE
	cost = 8200
	wear = 4
	illegal = TRUE
	vended = FALSE
	access = 999 //Prevents anyone from buying it without an emag.
	var/laws = "Be nice to people!"

	New(var/newloc,var/newlaws)
		laws = newlaws //Sanitize before this (the disk does)
		..(newloc)

	activate()
		if((. = ..()))
			to_chat(nif.human,"<span class='danger'>You are compelled to follow these rules: </span>\n<span class='notify'>[laws]</span>")

	install()
		if((. = ..()))
			to_chat(nif.human,"<span class='danger'>You feel suddenly compelled to follow these rules: </span>\n<span class='notify'>[laws]</span>")

	uninstall()
		nif.notify("ERROR! Unable to comply!",TRUE)
		return FALSE //NOPE.

	stat_text()
		return "Show Laws"

/datum/nifsoft/sizechange
	name = "Mass Alteration"
	desc = "A system that allows one to change their weight and height slightly, through minor mass rearrangement. Causes significant wear when installed." //AEIOU edit - description
	list_pos = NIF_SIZECHANGE
	cost = 750
	wear = 6

	activate()
		if((. = ..()))
			var/alter_size = 0
			var/new_size = input("Put the desired size alteration (up to +- 10%)", "Alter Size", 10) as num
			alter_size = (nif.human.size_multiplier * 100) + new_size
			if ((alter_size > 150)||(alter_size < 50))
				to_chat(nif.human,"<span class='notice'>The safety features of the NIF Program indicate that further size alteration might cause permanent damage and have been disabled.</span>")
				return
			if ((!IsInRange(new_size,-10, 10)) || (new_size == 0))
				to_chat(nif.human,"<span class='notice'>The safety features of the NIF Program prevent you from choosing this value.</span>")
				return
			else
				nif.human.resize(alter_size/100)
				to_chat(nif.human,"<span class='notice'>You alter your size by [new_size]%</span>")

			nif.human.visible_message("<span class='warning'>Swirling streams of nanites move under [nif.human]'s surface as they change size!</span>","<span class='notice'>Swirling streams of nanites travel around your body, changing your size!</span>")
			nif.human.update_icons() //Apply matrix transform asap

			spawn(0)
				deactivate()

	deactivate()
		if((. = ..()))
			return TRUE

	stat_text()
		return "Change Size"

/datum/nifsoft/worldbend
	name = "World Bender"
	desc = "Alters your perception of various objects in the world. Only has one setting for now: displaying all your crewmates as farm animals."
	list_pos = NIF_WORLDBEND
	cost = 200
	a_drain = 0.01

	activate()
		if((. = ..()))
			var/list/justme = list(nif.human)
			for(var/human in human_mob_list)
				if(human == nif.human)
					continue
				var/mob/living/carbon/human/H = human
				H.display_alt_appearance("animals", justme)
				alt_farmanimals += nif.human

	deactivate()
		if((. = ..()))
			var/list/justme = list(nif.human)
			for(var/human in human_mob_list)
				if(human == nif.human)
					continue
				var/mob/living/carbon/human/H = human
				H.hide_alt_appearance("animals", justme)
				alt_farmanimals -= nif.human
