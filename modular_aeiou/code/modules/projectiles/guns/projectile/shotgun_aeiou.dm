/obj/item/weapon/gun/projectile/shotgun/pump/air_rifle
	name = "air rifle"
	desc = "You'll shoot your eye out, kid..."
	icon = 'modular_aeiou/icons/obj/gun_aeiou.dmi'
	icon_state = "ryder"
	fire_sound = 'sound/weapons/gunshot_air_rifle.ogg'
//	item_state = ""		//we'll use shotgun item states for now so you can sling one across your back
	force = 5
	max_shells = 60	//60 round capacity
	caliber = "177pellet"		//.177 pellet
	ammo_type = /obj/item/ammo_casing/caseless/a177bb
	projectile_type = /obj/item/projectile/bullet/reusable/air_rifle_bb
	action_sound = 'sound/weapons/autoguninsert.ogg'		//reasonably close to the sound the real one makes
	

/obj/item/weapon/gun/projectile/shotgun/pump/air_rifle/pump(mob/M as mob)
	playsound(M, action_sound, 60, 1)

	if(chambered)		//there's one in the chamber
		if(chambered.BB)		//it's a live "casing" so eject the chambered one
			M.visible_message(
						"<span class='danger'>\The [chambered] rolls harmlessly out the barrel of [usr]'s [src].</span>",
						"<span class='danger'>\The [chambered] rolls harmlessly out of \the [src]'s barrel.</span>"
						)
			chambered.loc = get_turf(src)//Eject casing
			chambered = null
			
		else
			qdel(chambered)		//it's a used "casing", so destroy it.
			chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	update_icon()


/obj/item/weapon/gun/projectile/shotgun/pump/air_rifle/le		//limited edition
	name = "\improper Cuban Pete limited-edition air rifle"
	desc = "A Cuban Pete carbine-action, sixty-shot Range Master air-rifle with a fake compass on the stock and a carving of this thing which tells time."
	icon_state = "ryder-le"
	var/nice_direction = "null"		//this is intended to be a string that says null

/obj/item/weapon/gun/projectile/shotgun/pump/air_rifle/le/examine(mob/user)
	. = ..()
	
	nice_direction = "unset"		//debugging and sanity checks
	//compass check
	if(isCardinal(user.dir))
		nice_direction = "unset_cardinal"		//debugging and sanity checks
		switch(user.dir)
			if(NORTH)
				nice_direction = "north"
			if(EAST)
				nice_direction = "east"
			if(SOUTH)
				nice_direction = "south"
			if(WEST)
				nice_direction = "west"
	
	if(user.item_is_in_hands(src))
		to_chat(user, "The compass says you are facing [nice_direction].")
		else		//not on a cardinal direction
			to_chat(user, "The compass needle isn't pointing to a single direction.")
	else	//rifle not in hands
		to_chat(user, "The compass is too small to read at this angle.")

	//clock check
	if(user.item_is_in_hands(src) || in_range(src, user))
		to_chat(user, "The thing which tells time says it is currently [stationtime2text()].")
	else
		to_chat(user, "The digits on the thing which tells time are too small to read from here. You'll have to get closer if you want to read it.")

