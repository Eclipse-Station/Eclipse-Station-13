/obj/machinery/hotdrinksanomaly

	name = "Hot Drinks machine"
	desc = "An old-looking vending machine with a standard SolCommon QWERTY keypad. Wait, a keypad?"
	icon = 'icons/obj/vending_vr.dmi'
	icon_state = "coffee_294"
	layer = 2.9
	anchored = 1
	density = 1
	var/uses_left = 12
	var/last_use = 0
	var/restocking_timer = 0


/obj/machinery/hotdrinksanomaly/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		to_chat(user, "You short out \the [src] keypad! It starts violently vibrating! RUN!")
		sleep(60)
		explosion(src, 1, 2, 3, 5)
		qdel(src)
		return 1
//take_blood

/obj/machinery/hotdrinksanomaly/process()
	..()
	if (restocking_timer > 0)
	 restocking_timer--
	if (restocking_timer == 0 && uses_left == 0)
		uses_left = 12


/obj/machinery/hotdrinksanomaly/attack_hand(mob/user)
	if((last_use + 3 SECONDS) > world.time)
		visible_message("<span class='notice'>[src] displays TOO EARLY message.</span>")
		return
	last_use = world.time
	if(uses_left < 1)
		visible_message("<span class='notice'>[src] displays RESTOCKING, PLEASE WAIT message.</span>")
		return
	uses_left--
	if (uses_left < 1)
		restocking_timer = 2000
	var/product = null
	var/mob/living/carbon/victim = null
	var/input_reagent = lowertext(input("Enter the name of any liquid", "What would you like to drink?") as text)
	for(var/mob/living/carbon/M in mob_list)
		if (lowertext(M.name) == input_reagent)
			if (istype(M, /mob/living/carbon/))
				victim = M
				//.take_blood(null, 30)
				if(victim)
					to_chat(M, "You feel a sharp stabbing pain, coming from inside!")
					var/i
					var/pain = rand(1, 6)
					for(i=1; i<=pain; i++)
						M.adjustBruteLoss(5)
	if(!victim)
//		replacetext(input_reagent, " ", "")
		product = find_reagent(input_reagent)
	sleep(10)
	if(product)
		var/obj/item/weapon/reagent_containers/food/drinks/sillycup/D = new /obj/item/weapon/reagent_containers/food/drinks/sillycup(loc)
		D.reagents.add_reagent(product, 30)
		visible_message("<span class='notice'>[src] dispenses a small paper cup.</span>")
	else if (victim)
		var/obj/item/weapon/reagent_containers/food/drinks/sillycup/D = new /obj/item/weapon/reagent_containers/food/drinks/sillycup(loc)
		product = victim.take_blood(D,30)
		D.reagents.reagent_list += product
		D.reagents.update_total()
		D.on_reagent_change()
		visible_message("<span class='notice'>[src] dispenses a small paper cup.</span>")
	else
		visible_message("<span class='notice'>[src]'s OUT OF RANGE light flashes rapidly.</span>")

/*
/obj/machinery/hotdrinksanomaly/proc/find_mob(input)
	for(var/mob/M in mob_list)
		if(lowertext(M.name) == input)
			input = "blood"*/

/obj/machinery/hotdrinksanomaly/proc/find_reagent(input)
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
