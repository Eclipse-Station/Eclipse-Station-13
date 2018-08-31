
/obj/item/weapon/gun/projectile/usp
	name = "\improper P12 Compact"
	desc = "Renowned on Earth for its legendary reliability, this .45 handgun is still in use in some militaries throughout the galaxy. Has a threaded barrel to mount a suppressor. Has an accessory rail to mount a flashlight. Rated for +P ammunition."
	origin_tech = "combat=4;materials=2;engineering=4"
	icon = 'modular_aeiou/icons/obj/gun_aeiou.dmi'
	icon_state = "usp"
	item_state = "usp"
	caliber = ".45"
	load_method = MAGAZINE
	projectile_type = /obj/item/projectile/bullet/pistol/medium
	magazine_type = /obj/item/ammo_magazine/m45usp/p12
	allowed_magazines = list(/obj/item/ammo_magazine/m45usp/p12)
	can_flashlight = 1 //This allow the flashlight, IRC
	flight_x_offset = 16 //Flight is Flash-light
	flight_y_offset = 12
	recoil = 0 //no screenshake
	w_class = 2 //Small
	sound_override = 1 //This variable allows for sounds independant of the round.
	fire_sound = 'sound/weapons/pistol_glock17_1.ogg'
//	magazine_type = /obj/item/ammo_magazine/m45
//	allowed_magazines = list(/obj/item/ammo_magazine/m45)
//	spread = 5
//	canmagnum = 1 unused code due to fork and stuff.



/obj/item/weapon/gun/projectile/usp/update_icon() //Credit to Lohikar#1882 for the cut_overlays() idea.
	cut_overlays()
	if(ammo_magazine)
		if(ammo_magazine.stored_ammo.len)
			icon_state = "usp[silenced ? "-can" : ""]"
		else
			icon_state = "usp[silenced ? "-can" : ""]-locked"
	else
		icon_state = "usp[silenced ? "-can" : ""]-locked-nomag"
//	icon_state = "usp[silenced ? "-can" : ""][chambered ? "" : "-locked"][magazine_ammo ? "" : "-nomag"]"	//Don't uncomment. Won't work due to lack of a 'chambered' mechanic.
	if(flght && can_flashlight)
		cut_overlays()
		var/iconF = "flight"
		if(flght.on)
			iconF = "flight_on"
		add_overlay(image(icon = icon, icon_state = iconF, pixel_x = flight_x_offset, pixel_y = flight_y_offset))
	return


/obj/item/weapon/gun/projectile/usp/suppressed
	silenced = TRUE