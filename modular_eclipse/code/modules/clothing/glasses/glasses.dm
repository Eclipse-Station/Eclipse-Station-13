/*
//	Eclipse's eyewear goes here!
*/

/obj/item/clothing/glasses/fake
	name = "dark goggles"
	desc = "Protects the eyes from nothing in particular, condemned by the mad scientist association."
	action_button_name = "Flip Dark Goggles"
	item_state_slots = list(slot_r_hand_str = "welding-g", slot_l_hand_str = "welding-g")
	icon_state = "welding-g"
	matter = list(DEFAULT_WALL_MATERIAL = 1500, "glass" = 1000)
	item_flags = AIRTIGHT
	var/up = 0
	tint = TINT_NONE
	flash_protection = FLASH_PROTECTION_NONE

/obj/item/clothing/glasses/fake/attack_self()
	toggle()

/obj/item/clothing/glasses/fake/verb/toggle()
	set category = "Object"
	set name = "Adjust Dark goggles"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(src.up)
			src.up = !src.up
			flags_inv |= HIDEEYES
			body_parts_covered |= EYES
			icon_state = initial(icon_state)
			to_chat(usr, "You flip \the [src] down to protect your eyes.")
		else
			src.up = !src.up
			flags_inv &= ~HIDEEYES
			body_parts_covered &= ~EYES
			icon_state = "[initial(icon_state)]up"
			to_chat(usr, "You push \the [src] up out of your face.")
		update_clothing_icon()
		usr.update_action_buttons()