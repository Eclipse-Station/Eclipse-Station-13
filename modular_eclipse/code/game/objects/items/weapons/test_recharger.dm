
/obj/item/weapon/handheld_recharger//To be rewrote.
	name = "Hand Recharger"
	desc = "A hand held cell recharger. It looks pretty makeshift."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "phaser"
	item_state = "phaser"
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_guns_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_guns_vr.dmi', "slot_belt" = 'icons/mob/belt_vr.dmi')
	item_state_slots = list(slot_r_hand_str = "phaser", slot_l_hand_str = "phaser", "slot_belt" = "phaser")
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_POWER = 4)
	var/obj/item/weapon/cell/bcell = null
	var/pump_power = 200
	var/recharging = 0


/obj/item/weapon/handheld_recharger/proc/squeeze_handle(var/mob/user)
	if(recharging)
		return
	recharging = 1
//	update_icon()
	user.visible_message("<span class='notice'>[user] opens \the [src] and starts pumping the handle.</span>", \
						"<span class='notice'>You open \the [src] and start pumping the handle.</span>")
	while(recharging)
		if(!do_after(user, 10, src))
			break
		playsound(get_turf(src),'sound/items/change_drill.ogg',25,1)
		if(bcell.give(60) < 60)
			break
	recharging = 0
//	update_icon()

/obj/item/weapon/handheld_recharger/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/cell))
		if(!bcell)
			user.drop_item()
			W.loc = src
			bcell = W
			user << "<span class='notice'>You install a cell in [src].</span>"
//			update_icon()
		else
			user << "<span class='notice'>[src] already has a cell.</span>"
	else
		user << "<span class='notice'>This cell is not fitted for [src].</span>"

/obj/item/weapon/handheld_recharger/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(bcell)
			bcell.update_icon()
			user.put_in_hands(bcell)
			bcell = null
			user << "<span class='notice'>You remove the cell from the [src].</span>"
			recharging = 0
//			update_icon()
			return
		..()
	else
		return ..()


/obj/item/weapon/handheld_recharger/attack_self(mob/user)
	if(bcell)
		user << "You begin pumping the [src] handle."
		playsound(loc, "sparks", 75, 1, -1)
//		update_icon()
	else
		user << "<span class='warning'>[src] does not have a cell!</span>"
	add_fingerprint(user)

/*
/obj/item/weapon/handheld_recharger/update_icon()
	if(recharging)
		icon_state = "[initial(icon_state)]_pump"
		update_held_icon()
		return
	..()
*/

