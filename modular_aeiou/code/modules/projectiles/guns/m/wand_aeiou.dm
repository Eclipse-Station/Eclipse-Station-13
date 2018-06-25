/obj/item/weapon/gun/magic/wand
	name = "wand of nothing"
	desc = "It's not just a stick, it's a MAGIC stick!"
	icon = 'modular_aeiou/icons/obj/magic_aeiou.dmi'
	icon_state = "nothingwand"
	item_state = "wand"
	w_class = ITEMSIZE_SMALL
	ammo_type = /obj/item/ammo_casing/magic
	//can_charge = 0
	//max_charges = 100 //100, 50, 50, 34 (max charge distribution by 25%ths)
	var/variable_charges = 1

/obj/item/weapon/gun/magic/wand/New()
	if(prob(75) && variable_charges) //25% chance of listed max charges, 50% chance of 1/2 max charges, 25% chance of 1/3 max charges
		if(prob(33))
			max_charges = CEILING(max_charges / 3, 1)
		else
			max_charges = CEILING(max_charges / 2, 1)
	return ..()

/obj/item/weapon/gun/magic/wand/examine(mob/user)
	..()
	to_chat(user, "Has [charges] charge\s remaining.")

/obj/item/weapon/gun/magic/wand/update_icon()
	icon_state = "[initial(icon_state)][charges ? "" : "-drained"]"

/obj/item/weapon/gun/magic/wand/attack(atom/target, mob/living/user)
	if(target == user)
		return
	..()

/obj/item/weapon/gun/magic/wand/afterattack(atom/target, mob/living/user)
	if(!charges)
		shoot_with_empty_chamber(user)
		return
	if(target == user)
		if(no_den_usage)
			var/area/A = get_area(user)
			if(istype(A, /area/wizard_station))
				to_chat(user, "<span class='warning'>You know better than to violate the security of The Den, best wait until you leave to use [src].</span>")
				return
			else
				no_den_usage = 0
		zap_self(user)
	else
		..()
	update_icon()


/obj/item/weapon/gun/magic/wand/proc/zap_self(mob/living/user)
	user.visible_message("<span class='danger'>[user] zaps [user.p_them()]self with [src].</span>")
	playsound(user, fire_sound, 50, 1)
	user.log_message("zapped [user.p_them()]self with a <b>[src]</b>", INDIVIDUAL_ATTACK_LOG)

