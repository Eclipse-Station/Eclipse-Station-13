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
	if (pockets.handle_attack_hand(user))
		user.visible_message("\The [user] rummage in the [src] chest pocket.", "You rummage in the [src] chest pocket.")
		..(user)

/obj/item/clothing/under/storage/MouseDrop(obj/over_object as obj)
	if (pockets.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/under/storage/attackby(obj/item/W as obj, mob/user as mob)
	..()
	pockets.attackby(W, user)

/obj/item/clothing/under/storage/emp_act(severity)
	pockets.emp_act(severity)
	..()

/obj/item/clothing/under/storage/hammerspace_schoolgirl
	name = "protagonist schoolgirl uniform"
	desc = "It's just like one of my Japanese animes! It looks like there is an awful amount of space in the chest area."
	icon_state = "schoolgirl"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO