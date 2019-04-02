/*
 * Warning: BYOND-induced spaghetti code ahead.
 *
 * In order to get the time-of-day to a number, I have to use text2numlist to
 * convert it to a list of 1 number, then call that by index in the variable
 * to set it as today's date. It's bad, it sucks, but I have to do it because
 * I can't call text2num() because apparently it's not a global proc or a macro
 * define I can just pick up and use.
 * 
 * If you are here in the weeks, months, or years later debugging the piece of
 * code relevant to the date pull, I truly am sorry.
 *
 * -Spitzer
 */

//Debug mode override.
#define OVERRIDE_DATE_CHECK 0

// .../code/modules/mob/living/simple_animal/animals/crab.dm
// Some Discord jokes just go too far. This is one of them.

/mob/living/simple_animal/crab/reginald
	name = "\proper Reginald"
	icon_state = "sif_crab"
	desc = ""
	description_fluff = "He's just visiting from Elsewhere."

/mob/living/simple_animal/crab/reginald/New()
	. = ..()
	
	if(OVERRIDE_DATE_CHECK)
		desc = "It's Reginald. Yell at a coder that his date check is overridden."
	else
		if(time2text(world.timeofday, "Day") == "Tuesday")
			desc = "Everybody say 'Hi, Reginald'. But remember, he's only here on alternating Tuesdays."
		else
			desc = "Weird, he's usually only here on Tuesdays."		//Admin tomfoolery.

// The spawner, so we can spawn it in-game, but have admins able to spawn it
// in-server separately.
/obj/effect/landmark/reginald_spawner
	name = "reginald spawner"
	icon = 'icons/mob/animal.dmi'
	icon_state = "sif_crab"
	desc = "Alternating Tuesdays."

/obj/effect/landmark/reginald_spawner/New()
//If the debug override above is true, we want to spawn it. No ifs, ands, or buts.
	if(OVERRIDE_DATE_CHECK)
		new /mob/living/simple_animal/crab/reginald(src.loc)
		log_debug("Reginald force-spawned.")
		log_to_dd("Reginald force-spawned: Debug define set at compile time.")
		message_admins("Reginald was force-spawned at ([src.loc.x], [src.loc.y], [src.loc.z]): Debug define set at compile time.")
		delete_me = TRUE
		return		//Implied 'else'.

// Begin BYOND-induced spaghetti code.
	var/list/DD = text2numlist(time2text(world.timeofday, "DD"))	//get today's date
	var/todaysdate = DD[1]
// End of BYOND-induced spaghetti code.

	switch(todaysdate)
		if(1 to 7)	//Week 1
			if(time2text(world.timeofday, "Day") == "Tuesday")
				new /mob/living/simple_animal/crab/reginald(src.loc)
				log_debug("Spawning Reginald...")
			else
				log_debug("Week 1, but not a Tuesday. Reginald not spawning.")
		// Week 3.
		if(15 to 21)
			if(time2text(world.timeofday, "Day") == "Tuesday")
				new /mob/living/simple_animal/crab/reginald(src.loc)
				log_debug("Spawning Reginald...")
			else
				log_debug("Week 3, but not a Tuesday. Reginald not spawning.")
//There are up to 5 Tuesdays in a month. To ensure maximum alternation, Reginald
//does not appear the last week of the month.
		else
			log_debug("Not first or third week. Reginald not spawning.")
		
	delete_me = TRUE
	return

#if OVERRIDE_DATE_CHECK
	#warning Overriding date check on Reginald for testing. This should not be compiled for production with this enabled...
#endif