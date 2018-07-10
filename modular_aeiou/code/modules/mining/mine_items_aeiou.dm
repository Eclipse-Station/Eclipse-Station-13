/obj/item/weapon/pickaxe/heavydutydrill
	name = "heavy duty drill"
	desc = "Vroom vroom."
	icon_state = "chainsaw0"
	item_state = "chainsaw0"
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	digspeed = 120
	var/on = 0
	var/max_fuel = 100
	var/active_force = 55
	var/inactive_force = 10
	var/enginefailed = 0 //Is the engine currently stuck. If 1, it needs to be cleared.
	var/drill_bit = null //The actual drill in contact with the surface.
	var/engine = null //This is the engine that powers the drill. Better engines are faster
	var/filter = null //This will determine the engine fuel efficiency.

/obj/item/weapon/pickaxe/heavydutydrill/New()
	var/datum/reagents/R = new/datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)
	processing_objects |= src
	..()

/obj/item/weapon/pickaxe/heavydutydrill/Destroy()
	processing_objects -= src
	if(reagents)
		qdel(reagents)
	..()

/obj/item/weapon/pickaxe/heavydutydrill/proc/turnOn(mob/user as mob)
	if(on) return

	visible_message("You start pulling the string on \the [src].", "[usr] starts pulling the string on the [src].")

	if(max_fuel <= 0)
		if(do_after(user, 15))
			to_chat(user, "\The [src] won't start!")
		else
			to_chat(user, "You fumble with the string.")
	else
		if(do_after(user, 15))
			visible_message("You start \the [src] up with a loud grinding!", "[usr] starts \the [src] up with a loud grinding!")
			attack_verb = list("shredded", "ripped", "torn")
			playsound(src, 'sound/weapons/chainsaw_startup.ogg',60,3)
			force = active_force
			edge = 1
			sharp = 1
			on = 1
			digspeed = 5
			update_icon()
		else
			to_chat(user, "You fumble with the string.")

/obj/item/weapon/pickaxe/heavydutydrill/proc/turnOff(mob/user as mob)
	if(!on) return
	to_chat(user, "You switch the gas nozzle on the [src], turning it off.")
	attack_verb = list("bluntly hit", "beat", "knocked")
	playsound(user, 'sound/weapons/chainsaw_turnoff.ogg',40,3)
	force = inactive_force
	edge = 0
	sharp = 0
	on = 0
	digspeed = 120
	update_icon()

/obj/item/weapon/pickaxe/heavydutydrill/attack_self(mob/user as mob)
	if(!on)
		turnOn(user)
	else
		turnOff(user)

/obj/item/weapon/pickaxe/heavydutydrill/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(on)
		playsound(src, 'sound/weapons/chainsaw_attack.ogg',40,3)
	if(A && on)
		if(get_fuel() > 0)
			reagents.remove_reagent("fuel", 1)
		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			W.shatter()
		else if(istype(A,/obj/structure/grille))
			new /obj/structure/grille/broken(A.loc)
			new /obj/item/stack/rods(A.loc)
			qdel(A)
		else if(istype(A,/obj/effect/plant))
			var/obj/effect/plant/P = A
			qdel(P) //Plant isn't surviving that. At all
	if (istype(A, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,A) <= 1)
		to_chat(user, "<span class='notice'>You begin filling the tank on the [src].</span>")
		if(do_after(usr, 15))
			A.reagents.trans_to_obj(src, max_fuel)
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			to_chat(user, "<span class='notice'>[src] succesfully refueled.</span>")
		else
			to_chat(user, "<span class='notice'>Don't move while you're refilling the [src].</span>")

/obj/item/weapon/pickaxe/heavydutydrill/process()
	if(!on) return

	if(on)
		if(get_fuel() > 0)
			reagents.remove_reagent("fuel", 1)
			playsound(src, 'sound/weapons/chainsaw_turnoff.ogg',15,1)
		if(get_fuel() <= 0)
			to_chat(usr, "\The [src] sputters to a stop!")
			turnOff()
		if(prob(1))
			enginefail()
		
/obj/item/weapon/pickaxe/heavydutydrill/proc/enginefail()
	force = inactive_force
	edge = 0
	sharp = 0
	on = 0
	digspeed = 120
	enginefailed = 1
	attack_verb = list("bluntly hit", "beat", "knocked")
	playsound(src, 'sound/weapons/chainsaw_turnoff.ogg',15,1)
	to_chat(usr, "\The [src] engine jams suddenly! It looks like you'll have to clear the jam yourself.")
	update_icon()

/obj/item/weapon/pickaxe/heavydutydrill/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")

/obj/item/weapon/pickaxe/heavydutydrill/examine(mob/user)
	if(..(user,0))
		if(max_fuel)
			to_chat(usr, "<span class = 'notice'>The [src] feels like it contains roughtly [get_fuel()] units of fuel left.</span>")

/obj/item/weapon/pickaxe/heavydutydrill/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	to_chat(viewers(user), "<span class='danger'>[user] is lying down and pulling the [src] into [TU.him], it looks like [TU.he] [TU.is] trying to commit suicide!</span>")
	return(BRUTELOSS)

/obj/item/weapon/pickaxe/heavydutydrill/update_icon()
	if(on)
		icon_state = "chainsaw1"
		item_state = "chainsaw1"
	else
		icon_state = "chainsaw0"
		item_state = "chainsaw0"
