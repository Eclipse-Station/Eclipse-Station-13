
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/synthd //This is a special synthetic gun for pixel. 
	desc = "A reproduction of an almost ancient weapon design from the early 20th century, fitted and modified for today's use with better ergonomics and a synthetic stock. It remains popular with hunters and marksmen across the universe. Uses 7.62mm rounds."
	icon = 'modular_aeiou/icons/obj/gun_aeiou.dmi'
	item_state = "sboltaction"
	icon_state = "sboltaction"

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/lever/synthd //This is a special synthetic gun for pixel. 
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

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/pocketrifle/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-empty"

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/pocketrifle/black
	item_state = "pocketrifleb"
	icon_state = "pocketrifleb"

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

////////////////////////////////

/obj/item/weapon/gun/projectile/shotgun/rifle/niim
	name = "Niim rifle"
	desc = "A special lever action rifle."
	caliber = "7.62mm"
	max_shells = 5
	icon = 'modular_aeiou/icons/obj/gun_aeiou.dmi'
	item_state = "levercarabine"
	icon_state = "levercarabine"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	load_method = SINGLE_CASING|SPEEDLOADER
	ammo_type = /obj/item/ammo_casing/a762
	projectile_type = /obj/item/projectile/bullet/shotgun
	handle_casings = HOLD_CASINGS
	var/recentpump = 0 // to prevent spammage
	var/action_sound = 'sound/weapons/shotgunpump.ogg'


/obj/item/weapon/gun/projectile/shotgun/rifle/niim/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/weapon/gun/projectile/shotgun/rifle/niim/attack_self(mob/living/user as mob)
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/weapon/gun/projectile/shotgun/rifle/niim/proc/pump(mob/M as mob)
	..()
	playsound(M, action_sound, 60, 1)
//	icon_state = "levercarabine-animated"
//	sleep(8)

	if(chambered)//We have a shell in the chamber
		chambered.loc = get_turf(src)//Eject casing
		chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	icon_state = "levercarabine-animated"
	sleep(8)
	update_icon()

/obj/item/weapon/gun/projectile/shotgun/rifle/niim/update_icon()
	..()
	if((loaded.len) || (chambered))
		icon_state = "levercarabine"
	else
		icon_state = "levercarabine-empty"