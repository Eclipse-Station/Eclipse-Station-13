/obj/item/weapon/gun/projectile/shotgun/pump/air_rifle
	name = "air rifle"
	desc = "You'll shoot your eye out, kid..."
	icon = 'modular_aeiou/icons/obj/gun_aeiou.dmi'
	icon_state = "ryder"
	fire_sound = 'sound/weapons/gunshot_air_rifle.ogg'
//	item_state = ""		//we'll use shotgun item states for now so you can sling one across your back
	force = 5
	max_shells = 200		//200 round capacity
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
	desc = "A Cuban Pete carbine-action, two-hundred-shot Range Master air-rifle with a fake compass on the stock and a carving of this thing which tells time."
	icon_state = "ryder-le"

	var/fake_compass_reading = "null"			//i am aware this is a string that says null
	var/fake_time = "null"


/obj/item/weapon/gun/projectile/shotgun/pump/air_rifle/le/New()		//set the time that the carving of the clock shows
	. = ..()
	fake_compass_reading = pick("north","northeast","east","southeast","south","southwest","west","northwest")

	var/fake_hour = rand(1,12)
	var/fake_minute = rand(0,11)
	fake_minute *= 5		//turn the clock position into a minute value, round to five

	fake_time = "[fake_hour]:[fake_minute]"


/obj/item/weapon/gun/projectile/shotgun/pump/air_rifle/le/examine(mob/user)
	. = ..()
	//to_chat(user, "The fake compass says you are facing [fake_compass_reading].")
	to_chat(user, "The fake compass says you are facing north.")
	to_chat(user, "The carving of that thing which tells time says it is currently [fake_time].")
	//It says twice that the compass is fake and the clock is a carving, so if the end user trusts them, it's on the user.