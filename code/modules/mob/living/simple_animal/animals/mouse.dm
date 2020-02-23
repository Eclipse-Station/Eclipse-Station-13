/mob/living/simple_animal/mouse
	name = "mouse"
	real_name = "mouse"
	desc = "It's a small rodent."
	tt_desc = "E Mus musculus"
	icon_state = "mouse_gray"
	item_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	intelligence_level = SA_ANIMAL

	maxHealth = 5
	health = 5

	turns_per_move = 5
	see_in_dark = 6
	universal_understand = 1

	mob_size = MOB_MINISCULE
	pass_flags = PASSTABLE
	can_pull_size = ITEMSIZE_TINY
	can_pull_mobs = MOB_PULL_NONE
	layer = MOB_LAYER
	density = 0

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"

	min_oxy = 16 //Require at least 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celsius
	maxbodytemp = 323	//Above 50 Degrees Celsius

	has_langs = list("Mouse")
	speak_chance = 1
	speak = list("Squeek!","SQUEEK!","Squeek?")
	speak_emote = list("squeeks","squeeks","squiks")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")

	holder_type = /obj/item/weapon/holder/mouse
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	var/body_color //brown, gray and white, leave blank for random
	
	var/mouse_specific_chew_probability = 1		//Eclipse edit.

/mob/living/simple_animal/mouse/Life()
	. = ..()
	if(!. || ai_inactive) return

	if(prob(speak_chance))
		for(var/mob/M in view())
			M << 'sound/effects/mouse_squeak.ogg'

	if(!resting && prob(0.5))
		lay_down()
		speak_chance = 0
		//snuffles

	else if(resting)
		if(prob(1))
			lay_down()
			speak_chance = initial(speak_chance)
		else if(prob(1))
			audible_emote("snuffles.")

/mob/living/simple_animal/mouse/New()
	..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	if(name == initial(name))
		name = "[name] ([rand(1, 1000)])"
	real_name = name

	if(!body_color)
		body_color = pick( list("brown","gray","white") )
	icon_state = "mouse_[body_color]"
	item_state = "mouse_[body_color]"
	icon_living = "mouse_[body_color]"
	icon_dead = "mouse_[body_color]_dead"
	icon_rest = "mouse_[body_color]_sleep"
	desc = "A small [body_color] rodent, often seen hiding in maintenance areas and making a nuisance of itself."

/mob/living/simple_animal/mouse/proc/splat()
	src.health = 0
	src.stat = DEAD
	src.icon_dead = "mouse_[body_color]_splat"
	src.icon_state = "mouse_[body_color]_splat"
	layer = MOB_LAYER
	if(client)
		client.time_died_as_mouse = world.time


/mob/living/simple_animal/mouse/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			M.visible_message("<font color='blue'>\icon[src] Squeek!</font>")
			M << 'sound/effects/mouse_squeak.ogg'
	..()

/mob/living/simple_animal/mouse/death()
	layer = MOB_LAYER
	playsound(src, 'sound/effects/mouse_squeak_loud.ogg', 35, 1)
	if(client)
		client.time_died_as_mouse = world.time
	..()

/*
 * Mouse types
 */

/mob/living/simple_animal/mouse/white
	body_color = "white"
	icon_state = "mouse_white"

/mob/living/simple_animal/mouse/gray
	body_color = "gray"
	icon_state = "mouse_gray"

/mob/living/simple_animal/mouse/brown
	body_color = "brown"
	icon_state = "mouse_brown"

//TOM IS ALIVE! SQUEEEEEEEE~K :)
/mob/living/simple_animal/mouse/brown/Tom
	name = "Tom"
	desc = "Jerry the cat is not amused."
	mouse_specific_chew_probability = 0		//Eclipse edit: Tom is smarter than that.

/mob/living/simple_animal/mouse/brown/Tom/New()
	..()
	// Change my name back, don't want to be named Tom (666)
	name = initial(name)

/mob/living/simple_animal/mouse/cannot_use_vents()
	return

// // // BEGIN ECLIPSE EDIT // // //
//Rationale: Mice can chew wires if enabled in config.
/mob/living/simple_animal/mouse/handle_wander_movement()
	..()
	
	//check for engineers.
	var/active_engineers
	for(var/mob/living/M in player_list)
		if(!M)
			return		//Nobody's home. Go back to sleep.
		if(!M.mind)
			continue
		if(M.mind.assigned_role in engineering_positions)
			active_engineers++
	
	if(!config.mice_wires)		//If disabled by config, don't even bother.
		return
	if(ai_inactive)		//AI inactive, so no wire chewing.
		return
	if(config.mice_wire_eng_req && !active_engineers)
		return
	var/turf/F = src.loc
	if(prob(mouse_specific_chew_probability))
		if(istype(F) && F.is_plating())
			var/obj/structure/cable/C = locate() in F
			if(C && prob(config.mice_wire_chance))
				var/start_loc = src.loc		//You can stop a mouse chewing through a wire by picking him up before he's done.
			
				//RANDOM WORDS! YAAAY.
				var/chew_verb_start = pick("gnawing at","chewing up","biting into","eating at","nibbling at")
				var/chew_verb_finish = pick("bites into","gnaws into","eats through","nibbles into", "chews through")
				
				if((config.mice_wire_cooldown_rs || last_mouse_wire) && (world.time <= last_mouse_wire + config.mice_wire_cooldown))		//If we're in cooldown, nope the fuck outta there.
					return
				visible_message("<span class='warning'>[src] begins [chew_verb_start] \the [C]...</span>")
				sleep(5 SECONDS)		//sleep 2 seconds to allow it to chew through, and let players pick it up to disarm the impeding wire timebomb.
				if(start_loc != src.loc)
					return		//yayyyy you stiopped theh impeindign mouse timebiomb. The wiresy arte safe!		//I'm keeping this drunken comment. ^Spitzer
				
				//HOLD ON THERE COWBOY! Before you hit copper, better make sure another mouse hasn't triggered the cooldown!
				if((config.mice_wire_cooldown_rs || last_mouse_wire) && (world.time <= last_mouse_wire + config.mice_wire_cooldown))		//If cooldown was triggered after the checks start, abort.
					visible_message("<span class='warning'>[src] stops [chew_verb_start] \the [C] and looks around, as if some inkling of self-preservation suddenly kicked in.</span>")
					return
				
				//Alright. Carry on then.
				last_mouse_wire = world.time	//set cooldown
				if(C.powernet.avail)
					visible_message("<span class='warning'>[src] [chew_verb_finish] \the [C] and tenses up!</span>")
					playsound(src, 'sound/effects/sparks2.ogg', 100, 1)
					death()
				else
					visible_message("<span class='warning'>[src] [chew_verb_finish] \the [C].</span>")
				
				//spawn the cable where the mouse chewed through the other.
				if(C.d1)	// 0-X cables are 1 unit, X-X cables are 2 units long
					new/obj/item/stack/cable_coil(F, 2, C.color)
				else
					new/obj/item/stack/cable_coil(F, 1, C.color)
				C.investigate_log("was eaten by [src]/[usr ? usr : "no user"]/[ckey ? ckey : "no ckey"]","wires")		//admin logging, theoretically
				C.Destroy()

/mob/living/simple_animal/mouse/proc/debug_wire()		//DEBUGGING!

	//check for engineers.
	var/active_engineers
	for(var/mob/living/M in player_list)
		if(!M.mind)
			continue
		if(M.mind.assigned_role in engineering_positions)
			active_engineers++

	to_chat(usr, "<span class='notice'>\
	*-------Mouse wire debugging-------*<br>\
	Name: [src]<br>\
	Ref: \ref[src]<br><br>\
	Wire chewing:</span>")
	if(!config.mice_wires)
		to_chat(usr, "<span class='warning'>Cannot chew wires: Disabled by configuration.<br></span>")
	else if(config.mice_wire_eng_req && !active_engineers)
		to_chat(usr, "<span class='warning'>Cannot chew wires: No engineering staff present.<br></span>")
	else if(ai_inactive)
		to_chat(usr, "<span class='warning'>Cannot chew wires: AI disabled.<br></span>")
	else if(stat == DEAD)
		to_chat(usr, "<span class='warning'>Cannot chew wires: Mob deceased.<br></span>")
	else if((config.mice_wire_cooldown_rs || last_mouse_wire) && (world.time <= last_mouse_wire + config.mice_wire_cooldown))
		to_chat(usr, "<span class='warning'>Cannot chew wires: Cooldown active.<br></span>")
	else
		to_chat(usr, "<span class='notice'><b>Can chew wires.</b><br></span>")
	to_chat(usr, "<span class='notice'>\
	*--Cooldown--*<br>\
	Last chewed wire: [last_mouse_wire]<br>\
	Current tick: [world.time]<br>\
	Cooldown duration (ticks): [config.mice_wire_cooldown]<br></span>")
	if((config.mice_wire_cooldown_rs || last_mouse_wire) && (world.time <= last_mouse_wire + config.mice_wire_cooldown))
		var/cooldown_left = ((last_mouse_wire + config.mice_wire_cooldown) - world.time)
		to_chat(usr, "<span class='warning'>Cooldown remaining: [cooldown_left] ticks ([cooldown_left / 10] sec.)</span>")
	to_chat(usr,"<span class='notice'>*-------End of debugging information.-------*<br><br></span>")

var/last_mouse_wire = 0			//this feels dirty.
// // // END ECLIPSE EDIT // // //