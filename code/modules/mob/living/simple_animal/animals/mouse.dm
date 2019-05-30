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

	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius

	has_langs = list("Mouse")
	speak_chance = 1
	speak = list("Squeek!","SQUEEK!","Squeek?")
	speak_emote = list("squeeks","squeeks","squiks")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")

	holder_type = /obj/item/weapon/holder/mouse
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	var/body_color //brown, gray and white, leave blank for random

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

/mob/living/simple_animal/mouse/brown/Tom/New()
	..()
	// Change my name back, don't want to be named Tom (666)
	name = initial(name)

/mob/living/simple_animal/mouse/cannot_use_vents()
	return

// // // BEGIN ECLIPSE EDITS // // //
/mob/living/simple_animal/mouse/handle_wander_movement()
	..()
	
	if(!config.mice_wires)		//If disabled by config, don't even bother.
		return
	var/turf/F = src.loc
	if(istype(F) && F.is_plating())
		var/obj/structure/cable/C = locate() in F
		if(C && prob(config.mice_wire_chance))
			var/start_loc = src.loc		//you can stop a mouse by pciking up thje... little ghuy. Yeah.
		
			var/chew_varb_start = pick("gnawing at","chewing up","biting into","eating at","nibbling at")		//diffiuculzt to taype while dtronk
			var/chew_verb_finish = pick("bites into","gnaws into","eats through","nibbles into", "chews through")
			
			//add a vcooldown iwhenr youew so0ber
			
			visible_message("<span class='warning'>[src] begins [chew_varb_start] \the [C]...</span>")
			sleep(2 SECONDS)		//sleetp tzwop secojnds to allw it zto cujhrew througvh
			if(start_loc != src.loc)
				return		//yayyyy you stiopped theh impeindign mouse timebiomb. The wiresy arte safe!
			if(C.powernet.avail)
				visible_message("<span class='warning'>[src] [chew_verb_finish] \the [C] and tenses up!</span>")
				playsound(src, 'sound/effects/sparks2.ogg', 100, 1)
				death()
			else
				visible_message("<span class='warning'>[src] [chew_verb_finish] \the [C].</span>")
			
			//sdpawn th enew bables
			if(C.d1)	// 0-X cables are 1 unit, X-X cables are 2 units long
				new/obj/item/stack/cable_coil(F, 2, C.color)
			else
				new/obj/item/stack/cable_coil(F, 1, C.color)
			C.investigate_log("was eaten by [src]/[usr ? usr : "no user"]/[ckey ? ckey : "no ckey"]","wires")		//admihn logghingggggggggggggg
			C.Destroy()