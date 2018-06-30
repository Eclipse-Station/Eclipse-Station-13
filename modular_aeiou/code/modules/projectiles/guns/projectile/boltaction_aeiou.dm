
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/synthd
	desc = "A reproduction of an almost ancient weapon design from the early 20th century, fitted and modified for today's use with better ergonomics and a synthetic stock. It remains popular with hunters and marksmen across the universe. Uses 7.62mm rounds."
	icon = 'modular_aeiou/icons/obj/gun_aeiou.dmi'
	item_state = "sboltaction"
	icon_state = "sboltaction"

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/lever/synthd
	desc = "A reproduction of an almost ancient weapon design from the 19th century, fitted and modified for today's use with better ergonomics and a synthetic stock. This one uses a lever-action to move new rounds in the chamber. Uses 7.62mm rounds"
	icon = 'modular_aeiou/icons/obj/gun_aeiou.dmi'
	icon_state = "sleveraction"
	item_state = "sleveraction"

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/pocketrifle //aeiou addition
	name = "pocket rifle"
	desc = "What the hell is this? It look like someone sawn a bolt action into 4 parts! Looks more usefull as a club than anything.. Uses 7.62mm rounds."
	icon = 'modular_aeiou/icons/obj/gun_aeiou.dmi'
	item_state = "pocketrifle"
	icon_state = "pocketrifle"
	fire_sound = 'sound/weapons/rifleshot.ogg'
	w_class = ITEMSIZE_NORMAL
	max_shells = 3
	force = 10
	caliber = "7.62mm"
	accuracy = -20
	dispersion = 30 //TEST
	origin_tech = list(TECH_COMBAT = 2)
	ammo_type = /obj/item/ammo_casing/a762
	load_method = SINGLE_CASING
	action_sound = 'sound/weapons/riflebolt.ogg'

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/pockrifle/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "pocketrifle"
	else
		icon_state = "pocketrifle-empty"

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/pocketrifleblack
	item_state = "pocketrifle_b"
	icon_state = "pocketrifle_b"

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/pocketrifleblack/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "pocketrifle_b"
	else
		icon_state = "pocketrifle_b-empty"

//Perfect for your slavic snipers.
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/scoped//aeiou addition
	name = "scoped bolt action rifle"
	desc = "A reproduction of an almost ancient weapon design from the early 20th century. It's still popular among hunters and collectors due to its reliability. This one has a decent scope fitted on. Uses 7.62mm rounds."
	icon = 'modular_aeiou/icons/obj/gun_aeiou.dmi'
	item_state = "boltaction-scoped"
	icon_state = "boltaction-scoped"
	fire_sound = 'sound/weapons/rifleshot.ogg'
	max_shells = 5
	caliber = "7.62mm"
	accuracy = -15
	scoped_accuracy = 15
	origin_tech = list(TECH_COMBAT = 1)// Old as shit rifle doesn't have very good tech.
	ammo_type = /obj/item/ammo_casing/a762
	load_method = SINGLE_CASING|SPEEDLOADER
	action_sound = 'sound/weapons/riflebolt.ogg'

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/scoped/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)