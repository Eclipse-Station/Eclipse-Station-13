/obj/machinery/scp294

	name = "Hot Drinks machine"
	desc = "An old-looking vending machine with a standard SolCommon QWERTY keypad. Wait, a keypad?"
	icon = 'icons/obj/vending_vr.dmi'
	icon_state = "coffee_294"
	layer = 2.9
	anchored = 1
	density = 1


/obj/machinery/scp294/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		to_chat(user, "You short out \the [src]! It starts violently vibrating! RUN!")
		sleep(90)
		explosion(src, 1, 2, 3, 5)
		qdel(src)
		return 1


/*

/obj/machinery/chem_dispenser/scp_294/ui_act(action, params)
	if(..())
		return
	update_icon()
	switch(action)
		if("ejectBeaker")
			if(beaker)
				beaker.forceMove(drop_location())
				if(Adjacent(usr) && !issilicon(usr))
					usr.put_in_hands(beaker)
				beaker = null
				. = TRUE
		if("input")
			var/input_reagent = replacetext(lowertext(input("Enter the name of any liquid", "Input") as text), " ", "") //95% of the time, the reagent id is a lowercase/no spaces version of the name
			if(shortcuts[input_reagent])
				input_reagent = shortcuts[input_reagent]
			else
				input_reagent = find_reagent(input_reagent)
			if(!input_reagent || !GLOB.chemical_reagents_list[input_reagent])
				say("OUT OF RANGE")
				return
			else
				if(!beaker)
					return
				else if(!beaker.reagents && !QDELETED(beaker))
					beaker.create_reagents(beaker.volume)
				beaker.reagents.add_reagent(input_reagent, 10)
		if("makecup")
			if(beaker)
				return
			beaker = new /obj/item/reagent_containers/food/drinks/sillycup(src)
			visible_message("<span class='notice'>[src] dispenses a small, paper cup.</span>")
*/
/obj/machinery/scp294/attack_hand(mob/user)
	var/product = null
	var/input_reagent = replacetext(lowertext(input("Enter the name of any liquid", "What would you like to drink?") as text), " ", "")
	product = find_reagent(input_reagent)
	sleep(20)
	if(product)
		var/obj/item/weapon/reagent_containers/food/drinks/sillycup/D = new /obj/item/weapon/reagent_containers/food/drinks/sillycup(loc)
		D.reagents.add_reagent(product, 30)
		visible_message("<span class='notice'>[src] dispenses a small, paper cup.</span>")
	else
		visible_message("<span class='notice'>[src]'s OUT OF RANGE light flashes rapidly.</span>")




/obj/machinery/scp294/proc/find_reagent(input)
	. = FALSE
	if(chemical_reagents_list[input]) //prefer IDs!
		var/datum/reagent/R = chemical_reagents_list[input]
		if(R)
			return input
	else
		for(var/X in chemical_reagents_list)
			var/datum/reagent/R = chemical_reagents_list[X]
			if(R && input == replacetext(lowertext(R.name), " ", ""))
				return X
