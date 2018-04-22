	// We really need some datums for this.
//I don't know how shit is handled so i am starting here.
/obj/item/weapon/hammer_head
	name = "hammer head"
	desc = "A rectangular plasteel head. Feels very heavy in your hand.."
	icon = 'icons/obj/coilgun.dmi'
	icon_state = "coilgun_construction_1"

	var/construction_stage = 1

/obj/item/weapon/hammer_head/attackby(var/obj/item/thing, var/mob/user)

	if(istype(thing, /obj/item/stack/rods) && construction_stage == 1)
		var/obj/item/stack/rods = thing
		if(rods.get_amount() < 4)
			to_chat(user, "<span class='warning'>You need at least 4 rods for this task.</span>")
			return
		rods.use(4)
		user.visible_message("<span class='notice'>\The [user] puts some rods together in \the [src] hole.</span>")
		increment_construction_stage()
		return

	if(istype(thing, /obj/item/weapon/weldingtool) && construction_stage == 2)
		var/obj/item/weapon/weldingtool/welder = thing
		if(!welder.isOn())
			to_chat(user, "<span class='warning'>Turn it on first!</span>")
			return

		if(!welder.remove_fuel(0,user))
			to_chat(user, "<span class='warning'>You need more fuel!</span>")
			return

		user.visible_message("<span class='notice'>\The [user] weld the rods to the head \the [src] together with \the [thing].</span>")
		playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
		spawn(5)
		increment_construction_stage()
		return

	if(istype(thing, /obj/item/stack/rods) && construction_stage == 3)
		var/obj/item/stack/rods = thing
		if(rods.get_amount() < 4)
			to_chat(user, "<span class='warning'>You need at least 4 rods for this task.</span>")
			return
		rods.use(4)
		user.visible_message("<span class='notice'>\The [user] jams \the [thing]'s into \the [src].</span>")
		increment_construction_stage()
		return

	if(istype(thing, /obj/item/weapon/weldingtool) && construction_stage == 4)
		var/obj/item/weapon/weldingtool/welder = thing

		if(!welder.isOn())
			to_chat(user, "<span class='warning'>Turn it on first!</span>")
			return

		if(!welder.remove_fuel(0,user))
			to_chat(user, "<span class='warning'>You need more fuel!</span>")
			return

		user.visible_message("<span class='notice'>\The [user] welds the rods together of the handle into place, forming a long irregular shaft.</span>")
		playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)

		increment_construction_stage()
		return

	if(istype(thing, /obj/item/stack/material) && construction_stage == 5)
		var/obj/item/stack/material/reinforcing = thing
		var/material/reinforcing_with = reinforcing.get_material()
		if(reinforcing_with.name == DEFAULT_WALL_MATERIAL) // Steel
			if(reinforcing.get_amount() < 3)
				to_chat(user, "<span class='warning'>You need at least 3 [reinforcing.singular_name]\s for this task.</span>")
				return
			reinforcing.use(3)
			user.visible_message("<span class='notice'>\The [user] shapes some metal sheets around the rods.</span>")
			increment_construction_stage()
			return

	if(istype(thing, /obj/item/weapon/weldingtool) && construction_stage == 6)
		var/obj/item/weapon/weldingtool/welder = thing
		if(!welder.isOn())
			to_chat(user, "<span class='warning'>Turn it on first!</span>")
			return
		if(!welder.remove_fuel(10,user))
			to_chat(user, "<span class='warning'>You need more fuel!</span>")
			return
		user.visible_message("<span class='notice'>\The [user] heats up the metal sheets until it glows red.</span>")
		playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
		increment_construction_stage()
		return


	if(istype(thing, /obj/item/weapon/wrench) && construction_stage == 7)
		user.visible_message("<span class='notice'>\The [user] whacks at \the [src] like a caveman, shaping the metal with \the [thing] into a rough handle, finishing it off.</span>")
		increment_construction_stage()
		playsound(src.loc, 'sound/weapons/smash5.ogg', 100, 1)
		var/obj/item/weapon/material/twohanded/sledgehammer/sledge = new(loc)
		var/put_in_hands
		var/mob/M = src.loc
		if(istype(M))
			put_in_hands = M == user
			M.drop_from_inventory(src)
		if(put_in_hands)
			user.put_in_hands(sledge)
		qdel(src)
		return

/*
	if(iswrench(thing) && construction_stage >= 7)
		user.visible_message("<span class='notice'>\The [user] whacks at \the [src] like a caveman, shaping the metal with \the [thing] into a rough handle, finishing it off.</span>")
		playsound(src.loc, 'sound/weapons/smash5.ogg', 100, 1)
		var/obj/item/weapon/material/twohanded/sledgehammer = new(get_turf(user))
		var/put_in_hands
		var/mob/M = src.loc
		user.put_in_hands(sledgehammer)
		qdel(src)
		return

*/


/*

/material/proc/build_wired_product(var/mob/living/user, var/obj/item/stack/used_stack, var/obj/item/stack/target_stack)
	if(!wire_product)
		user << "<span class='warning'>You cannot make anything out of \the [target_stack]</span>"
		return
	if(used_stack.get_amount() < 5 || target_stack.get_amount() < 1)
		user << "<span class='warning'>You need five wires and one sheet of [display_name] to make anything useful.</span>"
		return

	used_stack.use(5)
	target_stack.use(1)
	user << "<span class='notice'>You attach wire to the [name].</span>"
	var/obj/item/product = new wire_product(get_turf(user))
	user.put_in_hands(product)

	if(isscrewdriver(thing) && construction_stage >= 9)
		user.visible_message("<span class='notice'>\The [user] secures \the [src] and finishes it off.</span>")
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
		var/obj/item/weapon/gun/magnetic/coilgun = new(loc)
		var/put_in_hands
		var/mob/M = src.loc
		if(istype(M))
			put_in_hands = M == user
			M.drop_from_inventory(src)
		if(put_in_hands)
			user.put_in_hands(coilgun)
		qdel(src)
		return
*/


	return ..()

/obj/item/weapon/hammer_head/proc/increment_construction_stage()
	if(construction_stage < 7)
		construction_stage++
	icon_state = "coilgun_construction_[construction_stage]"

/obj/item/weapon/hammer_head/examine(var/mob/user)
	. = ..(user,2)
	if(.)
		switch(construction_stage)
			if(2) to_chat(user, "<span class='notice'>It has a bunch of rods sticking out of the hole.</span>")
			if(3) to_chat(user, "<span class='notice'>It has a short rough metal shaft sticking to it, quite short.</span>")
			if(4) to_chat(user, "<span class='notice'>It has a bunch of rods jammed into the shaft/</span>")
			if(4) to_chat(user, "<span class='notice'>It has a pretty long rough metal shaft sticking out of it, it look hard to grab.</span>")
			if(5) to_chat(user, "<span class='notice'>It has a few sheets bent in half across the handle.</span>")
			if(6) to_chat(user, "<span class='notice'>It has red hot, pliable looking metal sheets spread over the handle. What a sloppy job.</span>")
			if(7) to_chat(user, "<span class='notice'>It has a roughly shaped metal handle.</span>")
