/obj/item/weapon/gun/projectile/automatic/ak47 //aeiou addition
	name = "\improper Kalachnikova"
	desc = "What could be more iconic than the Kalachnikov? An ancient but rugged and powerful rifle made by the billion. Uses 7,62 mm rounds."
	icon = 'modular_aeiou/icons/obj/gun_aeiou.dmi'
	icon_state = "oldAK"
	force = 15 //AK buttbash
	wielded_item_state = "arifle-wielded"
	w_class = ITEMSIZE_LARGE
	sound_override = 1
	load_method = MAGAZINE
	caliber = "7.62mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 5)
	magazine_type = /obj/item/ammo_magazine/m762AK
	allowed_magazines = list(/obj/item/ammo_magazine/m762AK)
	accuracy = 2

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, fire_sound='sound/weapons/OLDAKsingle.ogg'),
		list(mode_name="4-round bursts", burst=4, burst_delay=2, fire_delay=4, move_delay=4, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0,0.6, 1.0, 1.0), fire_sound='sound/weapons/OLDAKburst.ogg'),
		)

/obj/item/weapon/gun/projectile/automatic/ak47/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "oldAK"
	else
		icon_state = "oldAK-empty"


/obj/item/weapon/gun/projectile/automatic/protekt //WIP, it need an action button so you can switch the stock more easily. Maybe a timer.
	name = "Protekt-9" //aeiou addition
	desc = "For the discerning mercenary on a budget. The common ammunition and low maintenance have assured its place in back alleys and gambling dens across the sector. Uses .45 rounds."
	icon = 'modular_aeiou/icons/obj/gun_aeiou.dmi'
	item_state = "protekt"
	sound_override = 1
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	fire_sound = 'sound/weapons/45pistol_vr.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m45uzi
	allowed_magazines = list(/obj/item/ammo_magazine/m45uzi)
	projectile_type = /obj/item/projectile/bullet/pistol/medium
	unfolded_stock = 0
//	action_button_name = "Folding stock"



/obj/item/weapon/gun/projectile/automatic/protekt/verb/toggle_stock()
	set name = "Folding stock"
	set category = "Object"
	set desc = "Click to extend or retract the stock."

	var/mob/living/carbon/human/M = usr
	if(!M.mind)
		return 0

	to_chat(M, "<span class='notice'>You move the stock on \the [src].</span>")
	unfolded_stock = !unfolded_stock
	update_held_icon()
	update_icon()

	if(unfolded_stock == 1)
		accuracy = 15
		w_class = ITEMSIZE_NORMAL
	else
		w_class = ITEMSIZE_SMALL
		accuracy =-20
		dispersion = -5


/obj/item/weapon/gun/projectile/automatic/protekt/update_icon()
	..()
	if(ammo_magazine && unfolded_stock)
		icon_state = "protektclosed-loaded"
//		update_held_icon()
		return
	else if(unfolded_stock)
		icon_state = "protektopen-empty"
//		update_held_icon()
		return
	else if(ammo_magazine)
		icon_state = "protektfclosed-loaded"
//		update_held_icon()
		return
	else
		icon_state = "protektfopen-empty"
//		update_held_icon()
		return
//	update_held_icon()