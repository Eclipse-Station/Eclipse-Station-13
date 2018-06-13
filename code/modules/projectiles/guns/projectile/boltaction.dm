// For all intents and purposes, these work exactly the same as pump shotguns. It's unnecessary to make their own procs for them.

/obj/item/weapon/gun/projectile/shotgun/pump/rifle
	name = "bolt action rifle"
	desc = "A reproduction of an almost ancient weapon design from the early 20th century. It's still popular among hunters and collectors due to its reliability. Uses 7.62mm rounds."
	item_state = "boltaction"
	icon_state = "boltaction"
	fire_sound = 'sound/weapons/rifleshot.ogg'
	max_shells = 5
	caliber = "7.62mm"
	origin_tech = list(TECH_COMBAT = 1)// Old as shit rifle doesn't have very good tech.
	ammo_type = /obj/item/ammo_casing/a762
	load_method = SINGLE_CASING|SPEEDLOADER
	action_sound = 'sound/weapons/riflebolt.ogg'

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/practice // For target practice
	desc = "A bolt-action rifle with a lightweight synthetic wood stock, designed for competitive shooting. Comes shipped with practice rounds pre-loaded into the gun. Popular among professional marksmen. Uses 7.62mm rounds."
	ammo_type = /obj/item/ammo_casing/a762p

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/ceremonial
	name = "ceremonial bolt-action rifle"
	desc = "A bolt-action rifle with a heavy, high-quality wood stock that has a beautiful finish. Clearly not intended to be used in combat. Uses 7.62mm rounds."
	icon_state = "boltaction_c"
	item_state = "boltaction_c"
	ammo_type = /obj/item/ammo_casing/a762/blank

// Stole hacky terrible code from doublebarrel shotgun. -Spades
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/ceremonial/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/weapon/surgical/circular_saw) || istype(A, /obj/item/weapon/melee/energy) || istype(A, /obj/item/weapon/pickaxe/plasmacutter) && w_class != ITEMSIZE_NORMAL)
		user << "<span class='notice'>You begin to shorten the barrel and stock of \the [src].</span>"
		if(loaded.len)
			afterattack(user, user)	//will this work? //it will. we call it twice, for twice the FUN
			playsound(user, fire_sound, 50, 1)
			user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='danger'>The rifle goes off in your face!</span>")
			return
		if(do_after(user, 30))
			icon_state = "sawnrifle"
			w_class = ITEMSIZE_NORMAL
			recoil = 2 // Owch
			accuracy = -15 // You know damn well why.
			item_state = "gun"
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
			name = "sawn-off rifle"
			desc = "The firepower of a rifle, now the size of a pistol, with an effective combat range of about three feet. Uses 7.62mm rounds."
			to_chat(user, "<span class='warning'>You shorten the barrel and stock of \the [src]!</span>")
	else
		..()


//Lever actions are the same thing, but bigger.
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/lever
	name = "lever-action rifle"
	desc = "A reproduction of an almost ancient weapon design from the 19th century. This one uses a lever-action to move new rounds into the chamber. Uses 7.62mm rounds."
	item_state = "leveraction"
	icon_state = "leveraction"
	fire_sound = 'sound/weapons/rifleshot.ogg'
	max_shells = 5
	caliber = "7.62mm"
	origin_tech = list(TECH_COMBAT = 1)// Old as shit rifle doesn't have very good tech.
	ammo_type = /obj/item/ammo_casing/a762
	load_method = SINGLE_CASING|SPEEDLOADER
	action_sound = 'sound/weapons/riflebolt.ogg'

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/pocketrifle //aeiou addition
	name = "pocket rifle"
	desc = "What the hell is this? It look like someone sawn a bolt action into 4 parts! Looks more usefull as a club than anything.. Uses 7.62mm rounds."
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

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/pocketrifle/black
	desc = "It look like someone sawn off the rest of the rifle and painted it black. Uses 7.62mm rounds."


/obj/item/weapon/gun/projectile/shotgun/pump/rifle/pockrifle/black/update_icon()
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

