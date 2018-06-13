/obj/item/ammo_casing/caseless
	desc = "A caseless bullet casing. You probably shouldn't be seeing this..."
	
/obj/item/ammo_casing/caseless/expend()
	if (..())
		loc = null
		return 1
	else
		return 0

/obj/item/ammo_casing/caseless/update_icon()
	..()
	icon_state = "[initial(icon_state)]"
	
/obj/item/ammo_casing/caseless/a177bb		//.177/4.5mm air rifle
	name = "\improper BB"
	desc = "A zinc-coated, steel .177-calibre (4.5mm) BB. Perfect for shooting someone's eye out."
	caliber = "177pellet"
	icon = 'modular_aeiou/icons/obj/projectile_aeiou.dmi'
	icon_state = "bb-steel"
	projectile_type = /obj/item/projectile/bullet/reusable/air_rifle_bb