

//The ammo/gun is stored in a back slot item
/obj/item/minigunpack
	name = "backpack power source"
	desc = "The massive external power source for the laser gatling gun."
	icon = 'modular_aeiou/icons/obj/gun_aeiou.dmi'
	icon_state = "holstered"
	item_state = "backpack"
//	lefthand_file = 'modular_aeiou/icons/mob/items/guns_lefthand.dmi'
//	righthand_file = 'modular_aeiou/icons/mob/items/guns_righthand.dmi'
	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_HUGE
	var/obj/item/weapon/gun/energy/laser/minigun/linkedgun = null
	var/gun_wielded = 0 //whether the gun is attached, 0 is attached, 1 is the gun is wielded.
	var/overheat = 0
	var/overheat_max = 40
	var/heat_diffusion = 1

/obj/item/minigunpack/New()
	. = ..()
	linkedgun = new/obj/item/weapon/gun/energy/laser/minigun(src)
	gun_wielded = 0
	process()

/obj/item/minigunpack/Destroy()
	qdel(linkedgun)
	linkedgun = null
	return ..()

/obj/item/minigunpack/process()
	overheat = max(0, overheat - heat_diffusion)

/obj/item/minigunpack/proc/get_gun(var/mob/living/user)
	if(!ishuman(user))
		return 0

	var/mob/living/carbon/human/H = user

	if(H.hands_are_full()) //Make sure our hands aren't full.
		to_chat(H, "<span class='warning'>Your hands are full.  Drop something first.</span>")
		return 0

	var/obj/item/weapon/F = linkedgun
	H.put_in_hands(F)
	gun_wielded = 0
	to_chat(H, "<span class='warning'>You take the gun.</span>")

	return 1



/obj/item/minigunpack/attack_hand(mob/user as mob)
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/wearer = user
		if(wearer.back == src)
			if(linkedgun && !gun_wielded)
				if(!wearer.incapacitated())
					get_gun(user)
			else
				to_chat(user,"<span class='notice'>\The [src] does not have a nozzle attached!</span>")
		else
			..()
	else
		..()


/*
/obj/item/minigunpack/attack_hand(mob/user as mob)
	if(src.loc == user)
		if(!gun_wielded)
			if(user.get_item_by_slot(slot_back) == src)
				gun_wielded = 1
				if(!user.put_in_hands(linkedgun))
					gun_wielded = 0
					to_chat(user, "<span class='warning'>You need a free hand to hold the gun!</span>")
					return
				update_icon()
				linkedgun.forceMove(user)
				user.update_inv_back()
		else
			to_chat(user, "<span class='warning'>You are already holding the gun!</span>")
	else
		..()
*/

/obj/item/minigunpack/attackby(obj/item/W, mob/user, params)
	if(W == linkedgun) //Don't need gun_wielded check, because if you have the gun assume its gun_wielded.
		user.drop_item(linkedgun, TRUE)
	else
		..()

/obj/item/minigunpack/dropped(mob/user)
	..()
	if(gun_wielded)
		user.remove_from_mob(linkedgun)
		return_gun()
		to_chat(user, "<span class='notice'>\The [linkedgun] retracts to the [src].</span>")

/obj/item/minigunpack/proc/return_gun(var/mob/living/user)
	linkedgun.forceMove(src)
	gun_wielded = 0


/obj/item/minigunpack/MouseDrop(atom/over_object)
	if(gun_wielded)
		return
	if(iscarbon(usr))
		var/mob/M = usr

		if(!over_object)
			return

		if(!M.incapacitated())

			if(istype(over_object, /obj/screen/inventory/hand))
//				var/obj/screen/inventory/hand/H = over_object
				M.put_in_any_hand_if_possible(src)


/obj/item/minigunpack/update_icon()
	if(gun_wielded)
		icon_state = "notholstered"
	else
		icon_state = "holstered"

/obj/item/minigunpack/proc/attach_gun(var/mob/user)
	if(!linkedgun)
		linkedgun = new(src)
	linkedgun.forceMove(src)
	gun_wielded = 0
	if(user)
		to_chat(user, "<span class='notice'>You attach the [linkedgun.name] to the [name].</span>")
	else
		src.visible_message("<span class='warning'>The [linkedgun.name] snaps back onto the [name]!</span>")
	update_icon()
	user.update_inv_back()



/obj/item/weapon/gun/energy/laser/minigun
	name = "laser gatling gun"
	desc = "An advanced laser cannon with an incredible rate of fire. Requires a bulky backpack power source to use."
	icon = 'modular_aeiou/icons/obj/gun_aeiou.dmi'
	icon_state = "minigun_spin"
	item_state = "minigun"
	item_icons = list(
        slot_l_hand_str = 'modular_aeiou/icons/mob/items/guns_lefthand_aeiou.dmi',
        slot_r_hand_str = 'modular_aeiou/icons/mob/items/guns_righthand_aeiou.dmi'
        )

	firemodes = list(
		list(mode_name="lethal", burst=1, projectile_type=/obj/item/projectile/beam/burstlaser, modifystate="fm-2tkill", charge_cost = 200),
		list(mode_name="lethal burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/burstlaser, modifystate="fm-2tkill"),
		)


//	lefthand_file = 'modular_aeiou/icons/mob/items/guns_lefthand.dmi'
//	righthand_file = 'modular_aeiou/icons/mob/items/guns_righthand.dmi'
//	flags_1 = CONDUCT_1
	slowdown = 1
	battery_lock = 1
	slot_flags = null
	w_class = ITEMSIZE_HUGE
//	materials = list()
//	matter = list(DEFAULT_WALL_MATERIAL = 10000)
	automatic = 1
	fire_delay = 1
	fire_sound = 'sound/weapons/laser.ogg'
	charge_cost = 200
	projectile_type = /obj/item/projectile/beam/burstlaser
//	magazine_type = modular_aeiou/obj/item/ammo_magazine/internal/minigun
//	casing_ejector = FALSE
//	flags_2 = SLOWS_WHILE_IN_HAND_2
	var/obj/item/minigunpack/ammo_pack = null

/obj/item/weapon/gun/energy/laser/minigun/New()
	if(istype(loc, /obj/item/minigunpack)) //We should spawn inside an ammo pack so let's use that one.
		ammo_pack = loc
	else
		return INITIALIZE_HINT_QDEL //No pack, no gun

	return ..()

/obj/item/weapon/gun/energy/laser/minigun/attack_self(mob/living/user)
	return

/obj/item/weapon/gun/energy/laser/minigun/dropped(mob/user)
	if(ammo_pack)
		ammo_pack.attach_gun(user)
		to_chat(user, "<span class='notice'>\The [src] retracts to its pack.</span>")
	else
		qdel(src)


/obj/item/weapon/gun/energy/laser/minigun/proc/process_ammo(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(ammo_pack)
		var/mob/living/carbon/human/H = ammo_pack.loc
		if(H.back != ammo_pack)
			ammo_pack.return_gun()
		if(ammo_pack.overheat < ammo_pack.overheat_max)
			ammo_pack.overheat += 3 //Normally there would be a burst size reference but our guns don't work like that. I've remplaced it with a 3 instead.
			..()
		else
			to_chat(usr, "The gun's heat sensor locked the trigger to prevent lens damage.")


/obj/item/weapon/gun/energy/laser/minigun/afterattack(atom/target, mob/living/user, flag, params)
	if(!ammo_pack || ammo_pack.loc != user)
		to_chat(user, "You need the backpack power source to fire the gun!")
	process_ammo()
	..()

/obj/item/weapon/gun/energy/laser/minigun/dropped(mob/living/user)
	ammo_pack.attach_gun(user)

/obj/item/weapon/gun/energy/laser/minigun/update_icon(var/ignore_inhands)
	..()
	icon_state = "minigun_spin"
	if(!ignore_inhands) update_held_icon()
//	update_held_icon()


