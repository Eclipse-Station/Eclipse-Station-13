/obj/item/clothing/under/storage//copied so we can make it work.
	var/obj/item/weapon/storage/internal/pockets

/obj/item/clothing/under/storage/New()
	..()
	pockets = new/obj/item/weapon/storage/internal(src)
	pockets.max_w_class = ITEMSIZE_LARGE		//fit only pocket sized items
	pockets.max_storage_space = ITEMSIZE_COST_SMALL * 2

/obj/item/clothing/under/storage/Destroy()
	qdel_null(pockets)
	return ..()

/obj/item/clothing/under/storage/attack_hand(mob/user as mob)
	user.visible_message("\The [user] rummage in [src] chest pocket.1", "You rummage in [src] chest pocket.")
	if (pockets.handle_attack_hand(user))
		..(user)

/obj/item/clothing/under/storage/MouseDrop(obj/over_object as obj, mob/user as mob)
	if (pockets.handle_mousedrop(user, over_object))
		..(over_object)


/obj/item/clothing/under/storage/attackby(obj/item/W as obj, mob/user as mob)
	..()
	pockets.attackby(W, user)
	user.visible_message("\The [user] stuff something in [src] chest pocket.4", "You stuff [W] in [src] chest pocket.")

/obj/item/clothing/under/storage/emp_act(severity)
	pockets.emp_act(severity)
	..()


/obj/item/clothing/storage/proc/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
//	on_enter_storage
	if(usr)
		for(var/mob/M in viewers(usr, null))
			if (M == usr)
				to_chat(usr, "<span class='notice'>You put \the [W] into [src].</span>")
			else if (M in range(1)) //If someone is standing close enough, they can tell what it is...
				M.show_message("<span class='notice'>\The [usr] puts [W] into [src].</span>")
			else if (W && W.w_class >= 3) //Otherwise they can only see large or normal items from a distance...
				M.show_message("<span class='notice'>\The [usr] puts [W] into [src].</span>")


/obj/item/clothing/under/storage/hammerspace_schoolgirl
	name = "protagonist schoolgirl uniform"
	desc = "It's just like one of my Japanese animes! It looks like there is an awful amount of space in the chest area."
	icon_state = "schoolgirl"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/*
/obj/structure/flora/tree/sif/attack_hand(mob/user as mob)
	if(tap == 1)
		user.put_in_hands(t_t)
		t_t = null
		user << "<span class='notice'>You remove the tap from [src].</span>"
		tap = 0
		return


	hitby
	visible_message("<span class='warning'>[src] is triggered by [A].</span>")
*/